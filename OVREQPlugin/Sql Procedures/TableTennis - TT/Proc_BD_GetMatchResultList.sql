IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetMatchResultList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetMatchResultList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_GetMatchResultList]
--描    述：得到可选比赛结果
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月07日


CREATE PROCEDURE [dbo].[Proc_BD_GetMatchResultList](
												@MatchID		    INT,
                                                @MatchSplitID		INT,
                                                @Position           INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_ResultLongName        NVARCHAR(100),
                                F_ResultID              INT
							)

	IF @MatchSplitID = -1
    BEGIN
	  INSERT INTO #Tmp_Table (F_ResultLongName, F_ResultID)
      SELECT B.F_ResultLongName, A.F_ResultID FROM TC_Result AS A LEFT JOIN TC_Result_Des AS B ON A.F_ResultID = B.F_ResultID WHERE B.F_LanguageCode = @LanguageCode
      AND A.F_ResultID NOT IN (SELECT F_ResultID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 <> @Position AND F_ResultID IN (1,2))
    END
    ELSE
    BEGIN
      INSERT INTO #Tmp_Table (F_ResultLongName, F_ResultID)
      SELECT B.F_ResultLongName, A.F_ResultID FROM TC_Result AS A LEFT JOIN TC_Result_Des AS B ON A.F_ResultID = B.F_ResultID WHERE B.F_LanguageCode = @LanguageCode
      AND A.F_ResultID NOT IN (SELECT F_ResultID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition <> @Position AND F_ResultID IN (1,2))
    END

    INSERT INTO #Tmp_Table (F_ResultLongName, F_ResultID)
    VALUES ('NONE', -1)

	SELECT F_ResultLongName, F_ResultID AS MatchResult FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

