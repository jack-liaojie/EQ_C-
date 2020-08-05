IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_TE_GetMatchResult]
--描    述：得到比赛结果
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年01月12日


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchResult](
												@MatchID		    INT,
												@MatchSplitID       INT,    ---- -1:对于整场比赛
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID            INT,
                                F_ResultID              INT,
                                F_IRMID                 INT,
                                F_LongName              NVARCHAR(100),
                                F_MatchResult           NVARCHAR(100),
                                F_IRM                   NVARCHAR(3),
                                F_CompetitionPosition   INT
							)

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID

    IF(@MatchSplitID = -1)
    BEGIN
		INSERT INTO #Tmp_Table (F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition)
		  SELECT F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition
    END
    ELSE
    BEGIN
    	INSERT INTO #Tmp_Table (F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition)
		  SELECT F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition FROM TS_Match_Split_Result 
		        WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID ORDER BY  F_CompetitionPosition
    END


    UPDATE #Tmp_Table SET F_LongName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_MatchResult = B.F_ResultLongName FROM #Tmp_Table AS A LEFT JOIN TC_Result_Des AS B ON A.F_ResultID = B.F_ResultID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_IRM = B.F_IRMCODE FROM #Tmp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID AND B.F_DisciplineID = @DisciplineID

	SELECT F_LongName AS LongName, F_MatchResult AS MatchResult, F_IRM AS IRM, F_CompetitionPosition FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

