IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_GetMatchResultList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_GetMatchResultList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_BK_GetMatchResultList]
--描    述：得到可选比赛结果
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月18日


CREATE PROCEDURE [dbo].[Proc_BK_GetMatchResultList](
												@MatchID		    INT,
                                                @Position           INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Table(
                                F_ResultLongName        NVARCHAR(100),
                                F_ResultID              INT
							)

  
	  INSERT INTO #Tmp_Table (F_ResultLongName, F_ResultID)
      SELECT B.F_ResultLongName, A.F_ResultID FROM TC_Result AS A LEFT JOIN TC_Result_Des AS B ON A.F_ResultID = B.F_ResultID 
            WHERE B.F_LanguageCode = @LanguageCode  AND A.F_ResultID NOT IN(SELECT F_ResultID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition <> @Position AND F_ResultID IN (1,2))
              
	INSERT INTO #Tmp_Table (F_ResultLongName, F_ResultID)
	VALUES ('NONE', -1)

	SELECT F_ResultLongName, F_ResultID AS MatchResult FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

