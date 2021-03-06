IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_GetMatchResult]
--描    述：得到比赛结果
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月07日


CREATE PROCEDURE [dbo].[Proc_BD_GetMatchResult](
												@MatchID		    INT,
                                                @MatchSplitID       INT,
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
                                F_NOC                   NVARCHAR(30),
                                F_LongName              NVARCHAR(100),
                                F_MatchResult           NVARCHAR(100),
                                F_IRM                   NVARCHAR(3),
                                F_CompetitionPosition   INT,
                                F_Match                 INT,
                                F_Point                 INT
							)

    DECLARE @DisciplineID INT
    DECLARE @MatchType INT
    DECLARE @FatherMatchSplitID INT
    SELECT @DisciplineID = C.F_DisciplineID, @MatchType = A.F_MatchTypeID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID
    SELECT @FatherMatchSplitID = F_FatherMatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND @MatchSplitID <> -1

    IF (@MatchSplitID = -1)
    BEGIN
      INSERT INTO #Tmp_Table (F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition, F_Match)
        SELECT F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPositionDes1, F_Points
        FROM TS_Match_Result AS A
        WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition
    END
    ELSE IF (@MatchType = 1 AND @MatchSplitID <> -1)
    BEGIN
      INSERT INTO #Tmp_Table (F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition, F_Point)
        SELECT MSR.F_RegisterID, MSR.F_ResultID, MSR.F_IRMID, MSR.F_CompetitionPosition, MSR.F_Points
        FROM TS_Match_Split_Result AS MSR
        LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPositionDes1
        WHERE MSR.F_MatchID = @MatchID AND MSR.F_MatchSplitID = @MatchSplitID ORDER BY MR.F_CompetitionPositionDes1, MR.F_CompetitionPosition
    END
    ELSE IF (@MatchType = 3 AND @MatchSplitID <> -1 AND @FatherMatchSplitID = 0)
    BEGIN
      INSERT INTO #Tmp_Table (F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition, F_Match)
        SELECT MSR.F_RegisterID, MSR.F_ResultID, MSR.F_IRMID, MSR.F_CompetitionPosition, MSR.F_Points
        FROM TS_Match_Split_Result AS MSR
        LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPositionDes1
        WHERE MSR.F_MatchID = @MatchID AND MSR.F_MatchSplitID = @MatchSplitID ORDER BY MR.F_CompetitionPositionDes1, MR.F_CompetitionPosition
    END
    ELSE IF (@MatchType = 3 AND @MatchSplitID <> -1 AND @FatherMatchSplitID <> 0)
    BEGIN
      INSERT INTO #Tmp_Table (F_RegisterID, F_ResultID, F_IRMID, F_CompetitionPosition, F_Point)
        SELECT MSR.F_RegisterID, MSR.F_ResultID, MSR.F_IRMID, MSR.F_CompetitionPosition, MSR.F_Points
        FROM TS_Match_Split_Result AS MSR
        LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPositionDes1
        WHERE MSR.F_MatchID = @MatchID AND MSR.F_MatchSplitID = @MatchSplitID ORDER BY MR.F_CompetitionPositionDes1, MR.F_CompetitionPosition
    END

    UPDATE #Tmp_Table SET F_NOC = C.F_DelegationCode FROM #Tmp_Table AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
    UPDATE #Tmp_Table SET F_LongName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_MatchResult = B.F_ResultLongName FROM #Tmp_Table AS A LEFT JOIN TC_Result_Des AS B ON A.F_ResultID = B.F_ResultID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_IRM = B.F_IRMCODE FROM #Tmp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID AND B.F_DisciplineID = @DisciplineID

    IF (@MatchSplitID = -1 OR (@MatchType = 3 AND @FatherMatchSplitID = 0))
    BEGIN
        SELECT F_NOC AS NOC, F_LongName AS LongName, F_MatchResult AS MatchResult, F_IRM AS IRM, F_CompetitionPosition, F_Match AS MatchPoint FROM #Tmp_Table
    END
    ELSE
    BEGIN
	  SELECT F_NOC AS NOC, F_LongName AS LongName, F_MatchResult AS MatchResult, F_IRM AS IRM, F_CompetitionPosition, F_Point AS GamePoint FROM #Tmp_Table
    END
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

