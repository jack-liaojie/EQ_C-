IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchResults]
----功		  能：得到一场比赛的详细成绩信息,网球项目
----作		  者：郑金勇 
----日		  期: 2009-08-12

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchResults] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

--select * from TS_Match_Result

	SELECT A.F_MatchID, A.F_CompetitionPosition, B.F_LongName AS Competitor, D.F_DelegationCode AS NOC, A.F_Points AS [Sets]
		, NULL AS Srv, NULL AS Set1, NULL AS Set2, NULL AS Set3, NULL AS Set4, NULL AS Set5, NULL AS Score
		INTO #Temp_Results FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
			WHERE A.F_MatchID = @MatchID ORDER BY A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes2, A.F_CompetitionPosition
	
	UPDATE A SET A.Set1 = B.Set1, A.Set2 = B.Set2, A.Set3 = B.Set3, A.Set4 = B.Set4, A.Set5 = B.Set5 FROM #Temp_Results AS A LEFT JOIN
		(SELECT F_MatchID, F_CompetitionPosition, Set1, Set2, Set3, Set4, Set5 FROM
			(SELECT A.F_MatchID, 'Set' + CAST(A.F_MatchSplitID AS NVARCHAR(10)) AS F_SetPoints, B.F_CompetitionPosition, B.F_Points FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0) AS A
			PIVOT (MIN(F_Points) FOR F_SetPoints IN (Set1, Set2, Set3, Set4, Set5)) AS B ) AS B
		ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
	
	SELECT NOC, Competitor, Srv, [Sets], Set1, Set2, Set3, Set4, Set5, Score FROM #Temp_Results
	
SET NOCOUNT OFF
END






GO

 --EXEC [Proc_TE_GetMatchResults] 1,'ENG'
