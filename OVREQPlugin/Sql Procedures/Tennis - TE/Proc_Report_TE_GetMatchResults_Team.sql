IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchResults_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchResults_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_TE_GetMatchResults_Team]
----功		  能：得到一场比赛的详细成绩信息,网球项目
----作		  者：郑金勇 
----日		  期: 2009-08-12
----修 改 记  录：
/*
                  李燕     2011-2-18     增加IRM表示
*/

CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMatchResults_Team] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3),
	@Position					INT = 0
)	
AS
BEGIN
SET NOCOUNT ON

--select * from TS_Match_Result

	SELECT A.F_MatchID, G.F_MatchSplitID, A.F_CompetitionPosition, B.F_PrintLongName AS CompetitorLongName, B.F_PrintShortName AS CompetitiorShortName,
	      D.F_DelegationCode AS NOC, A.F_Rank, A.F_Points AS [Sets]
		, NULL AS Srv, CAST(NULL AS NVARCHAR(10)) AS Set1 , CAST(NULL AS NVARCHAR(10)) AS Set2, CAST(NULL AS NVARCHAR(10)) AS Set3, CAST(NULL AS NVARCHAR(10)) AS Set4, CAST(NULL AS NVARCHAR(10)) AS Set5, A.F_Points AS Score, E.F_IRMCode AS IRM
		INTO #Temp_Results 
		FROM TS_Match_Split_Result AS A 
		LEFT JOIN TS_Match_Result AS F ON A.F_MatchID = F.F_MatchID AND A.F_CompetitionPosition = F.F_CompetitionPosition
		LEFT JOIN TS_Match_Split_Info AS G ON A.F_MatchID = G.F_MatchID AND A.F_MatchSplitID = G.F_MatchSplitID
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_IRM AS E ON A.F_IRMID = E.F_IRMID
			WHERE A.F_MatchID = @MatchID AND G.F_FatherMatchSplitID = 0  ORDER BY G.F_Order, F.F_CompetitionPositionDes1, F.F_CompetitionPositionDes2, F.F_CompetitionPosition
	
	--select * from #Temp_Results
	

	--Set比分
	UPDATE A SET A.Set1 = B.Set1, A.Set2 = B.Set2, A.Set3 = B.Set3, A.Set4 = B.Set4, A.Set5 = B.Set5 FROM #Temp_Results AS A LEFT JOIN
		(
		SELECT F_MatchID, F_FatherMatchSplitID, F_CompetitionPosition, Set1, Set2, Set3, Set4, Set5 FROM
			(SELECT A.F_MatchID, A.F_FatherMatchSplitID, 'Set' + CAST(A.F_MatchSplitCode AS NVARCHAR(10)) AS F_SetPoints, B.F_CompetitionPosition, CAST( B.F_Points AS NVARCHAR(10)) AS F_Points
			    FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID IN 
					(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0)
				) AS A
			PIVOT (MIN(F_Points) FOR F_SetPoints IN (Set1, Set2, Set3, Set4, Set5)) AS B
		) AS B
		ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_FatherMatchSplitID AND A.F_CompetitionPosition = B.F_CompetitionPosition
	
	--抢七比分
	SELECT F_MatchID, F_FatherMatchSplitID, F_CompetitionPosition, Set1, Set2, Set3, Set4, Set5 INTO #Temp_Results_1 FROM
			(SELECT A.F_MatchID, A.F_FatherMatchSplitID, 'Set' + CAST(A.F_MatchSplitCode AS NVARCHAR(10)) AS F_SetPoints, B.F_CompetitionPosition, CAST( B.F_SplitPoints AS NVARCHAR(10)) AS F_SplitPoints
				FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE  A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID IN 
						(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0)
						AND B.F_Rank = 2 
			) AS A 
			PIVOT (MIN(F_SplitPoints) FOR F_SetPoints IN (Set1, Set2, Set3, Set4, Set5)) AS B
			
	--select * from #Temp_Results_1
	--select * from #Temp_Results
	--select * from TS_Match_Split_Result
	
    UPDATE A SET A.Set1 = A.Set1 + (CASE WHEN B.Set1 IS NULL THEN '' ELSE '('+ B.Set1 + ')' END), 
             A.Set2 = A.Set2 + (CASE WHEN B.Set2 IS NULL THEN '' ELSE '('+ B.Set2 + ')' END),  
             A.Set3 = A.Set3 + (CASE WHEN B.Set3 IS NULL THEN '' ELSE '('+ B.Set3 + ')' END),
             A.Set4 = A.Set4 + (CASE WHEN B.Set4 IS NULL THEN '' ELSE '('+ B.Set4 + ')' END),
             A.Set5 = A.Set5 + (CASE WHEN B.Set5 IS NULL THEN '' ELSE '('+ B.Set5 + ')' END)
        FROM #Temp_Results AS A LEFT JOIN  #Temp_Results_1 AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_FatherMatchSplitID AND A.F_CompetitionPosition = B.F_CompetitionPosition


	DECLARE @Sql AS NVARCHAR(MAX)
	SET @Sql = ''
	SELECT @Sql = @Sql +' UPDATE #Temp_Results SET Set' + F_MatchSplitCode + '= NULL' FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_MatchSplitStatusID = 0
	EXEC (@Sql)
	

	IF @Position = 0 
	BEGIN
		SELECT (CASE F_Rank WHEN 1 THEN 'W' ELSE '' END) AS Result, NOC, CompetitorLongName,CompetitiorShortName
		, Srv, [Sets], Set1, Set2, Set3, Set4, Set5, Score, IRM, F_MatchID, F_MatchSplitID, F_CompetitionPosition
		 FROM #Temp_Results
	END
	ELSE
	BEGIN
		SELECT (CASE F_Rank WHEN 1 THEN 'W' ELSE '' END) AS Result, NOC, CompetitorLongName,CompetitiorShortName
		, Srv, [Sets], Set1, Set2, Set3, Set4, Set5, Score , IRM, F_MatchID, F_MatchSplitID, F_CompetitionPosition
		 FROM #Temp_Results WHERE F_CompetitionPosition = @Position
	END
	
SET NOCOUNT OFF
END








GO


--EXEC Proc_Report_TE_GetMatchResults_Team 284, 'CHN', 0