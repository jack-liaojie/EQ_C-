IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_AllTeamRankList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_AllTeamRankList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_BD_AllTeamRankList]
----功		  能：获取小组赛全排名
----作		  者：王强
----日		  期: 2012-07-16
----修 改 记  录：


CREATE PROCEDURE [dbo].[Proc_Report_BD_AllTeamRankList] 
                   (	
					@EventID      INT
                   )	
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @TypeID INT
	SELECT @TypeID = F_PlayerRegTypeID
	FROM TS_Event WHERE F_EventID = @EventID

	IF @TypeID != 3
	BEGIN
		SELECT RANK() OVER(ORDER BY B.F_PhaseRank, 
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 2) DESC,
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 2) DESC,
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 2) DESC
					) AS TotalRank, B.F_RegisterID,
		'' AS TotalTie, '' AS WonTie, ''  AS LostTie, '' AS WTie,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 0) AS TotalMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 1) AS WonMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 2) AS LostMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 2) AS WMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 1) AS WonGames,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 2) AS LostGames,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 2) AS WGame,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 1) AS WonPoints,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 2) AS LostPoints,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 2) AS WPoints,
		C.F_LongName,
		D.F_PhaseLongName,
		B.F_PhaseRank
		FROM TS_Phase AS A 
		LEFT JOIN TS_Phase_Result AS B ON B.F_PhaseID = A.F_PhaseID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'CHN'
		LEFT JOIN TS_Phase_Des AS D ON D.F_PhaseID = A.F_PhaseID AND D.F_LanguageCode = 'CHN'
		WHERE A.F_EventID = @EventID AND A.F_PhaseIsPool = 1 AND A.F_PhaseHasPools = 0 AND A.F_PhaseStatusID = 110
	END
	ELSE
	BEGIN
		SELECT RANK() OVER(ORDER BY B.F_PhaseRank,
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 2) DESC,
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 2) DESC,
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 2) DESC,
					dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 4, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 4, 2) DESC
		) AS TotalRank, B.F_RegisterID,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 0) AS TotalTie, 
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 1) AS WonTie, 
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 2) AS LostTie, 
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 1, 2) AS WTie,
		'' AS TotalMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 1) AS WonMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 2) AS LostMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 2, 2) AS WMatch,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 1) AS WonGames,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 2) AS LostGames,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 3, 2) AS WGame,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 4, 1) AS WonPoints,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 4, 2) AS LostPoints,
		dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 4, 1) - dbo.Fun_BD_GetMatchWonLost(A.F_PhaseID, B.F_RegisterID, 4, 2) AS WPoints,
		C.F_LongName,
		D.F_PhaseLongName,
		B.F_PhaseRank
		FROM TS_Phase AS A 
		LEFT JOIN TS_Phase_Result AS B ON B.F_PhaseID = A.F_PhaseID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'CHN'
		LEFT JOIN TS_Phase_Des AS D ON D.F_PhaseID = A.F_PhaseID AND D.F_LanguageCode = 'CHN'
		WHERE A.F_EventID = @EventID AND A.F_PhaseIsPool = 1 AND A.F_PhaseHasPools = 0 AND A.F_PhaseStatusID = 110
	END
        
SET NOCOUNT OFF
END



GO


