IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchResultInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchResultInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchResultInfo]
----功		  能：得到一场比赛的初始信息
----作		  者：李燕
----日		  期: 2011-01-19
----修  改 记 录：
/*
                  2011-6-27   李燕  为了城运会，增加SubMatchCode参数
*/
CREATE PROCEDURE [dbo].[Proc_TE_GetMatchResultInfo] (	
	@MatchID					INT,
	@SubMatchCode               INT,  --- -1：个人赛
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

--select * from TS_Match_Result

   CREATE TABLE #Temp_Results (
                                F_MatchID                   INT,
                                F_CompetitionPosition       INT,
                                Competitor                  NVARCHAR(150),
                                NOC                         NVARCHAR(50),
                                [Sets]                      INT,
                                Srv                         INT,
                                Set1                        INT,
                                Set2                        INT,
                                Set3                        INT,
                                Set4                        INT,
                                Set5                        INT,
                                Score                       INT
                            )
   IF(@SubMatchCode = -1)
   BEGIN
      
       INSERT INTO #Temp_Results(F_MatchID, F_CompetitionPosition, Competitor, NOC, [Sets]
       			                  ,Srv, Set1, Set2, Set3, Set4, Set5,Score)
	   SELECT A.F_MatchID, A.F_CompetitionPosition, B.F_LongName AS Competitor, D.F_DelegationCode AS NOC, NULL AS [Sets]
			, NULL AS Srv, NULL AS Set1, NULL AS Set2, NULL AS Set3, NULL AS Set4, NULL AS Set5, NULL AS Score
			FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
				WHERE A.F_MatchID = @MatchID ORDER BY A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes2, A.F_CompetitionPosition
		
   END  
   ELSE
   BEGIN
   
		INSERT INTO #Temp_Results(F_MatchID, F_CompetitionPosition, Competitor, NOC, [Sets]
								  ,Srv, Set1, Set2, Set3, Set4, Set5,Score)
		SELECT A.F_MatchID, A.F_CompetitionPosition, B.F_LongName AS Competitor, D.F_DelegationCode AS NOC, NULL AS [Sets]
			, NULL AS Srv, NULL AS Set1, NULL AS Set2, NULL AS Set3, NULL AS Set4, NULL AS Set5, NULL AS Score
			FROM TS_Match_Split_Result AS A 
			LEFT JOIN TS_Match_Split_Info AS E ON A.F_MatchID = E.F_MatchID AND A.F_MatchSplitID = E.F_MatchSplitID
			LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID 
			LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
				WHERE A.F_MatchID = @MatchID AND E.F_MatchSplitCode = @SubMatchCode AND E.F_FatherMatchSplitID = 0
				  ORDER BY A.F_CompetitionPosition
		
		IF NOT EXISTS (SELECT F_MatchID FROM #Temp_Results)
		BEGIN
			INSERT INTO #Temp_Results(F_MatchID, F_CompetitionPosition) VALUES (@MatchID, 1)
			INSERT INTO #Temp_Results(F_MatchID, F_CompetitionPosition) VALUES (@MatchID, 2)
		END
   END 
	

	SELECT NOC, Competitor, Srv, [Sets], Set1, Set2, Set3, Set4, Set5, Score FROM #Temp_Results
	
SET NOCOUNT OFF
END






GO

 --EXEC [Proc_TE_GetMatchResultInfo] 1,'ENG'
