IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetTeamMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetTeamMember]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetTeamMember]
----功		  能：获取TVG需要的小组成员
----作		  者：王强
----日		  期: 2011-04-25

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetTeamMember]
		@EventID INT,
		@PhaseCode NVARCHAR(6)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = @PhaseCode
	IF @PhaseID IS NULL
		RETURN
		
	CREATE TABLE #TMP_MEMBER
	(
		RegisterID INT,
		NOC NVARCHAR(20),
		TeamName_ENG NVARCHAR(200),
		TeamName_CHN NVARCHAR(200),
		WonNum INT,
		LoseNum INT,
		Points INT,
		[Rank] INT,
		TeamName NVARCHAR(30)
	)
	
	INSERT INTO #TMP_MEMBER (RegisterID)
	(
		SELECT DISTINCT(A.F_RegisterID) FROM TS_Match_Result AS A
		LEFT JOIN TS_Match AS B ON B.F_MatchID = A.F_MatchID
		LEFT JOIN TS_Phase AS C ON C.F_PhaseID = B.F_PhaseID
		WHERE C.F_PhaseID = @PhaseID AND A.F_RegisterID IS NOT NULL
	)
	
	UPDATE #TMP_MEMBER SET NOC = D.F_DelegationCode, TeamName_ENG = B1.F_TvShortName, TeamName_CHN = B2.F_TvShortName
			,WonNum = [dbo].[Fun_BD_GetMatchWonLost](@PhaseID, A.RegisterID, 1, 1)
			,LoseNum = [dbo].[Fun_BD_GetMatchWonLost](@PhaseID, A.RegisterID, 1, 2)
			,Points = [dbo].[Fun_BD_GetMatchWonLost](@PhaseID, A.RegisterID, 1, 1)
			,[Rank] = E.F_PhaseRank,TeamName = G.F_PhaseShortName
	FROM #TMP_MEMBER AS A
	LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.RegisterID AND B1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.RegisterID AND B2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS C ON C.F_RegisterID = A.RegisterID
	LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = C.F_DelegationID
	LEFT JOIN TS_Phase_Result AS E ON E.F_PhaseID = @PhaseID AND E.F_RegisterID = A.RegisterID
	LEFT JOIN TS_Phase AS F ON F.F_EventID = @EventID AND F.F_PhaseCode = @PhaseCode
	LEFT JOIN dbo.TS_Phase_Des AS G ON G.F_PhaseID = F.F_PhaseID AND G.F_LanguageCode = 'ENG'
	UPDATE #TMP_MEMBER SET NOC = '[Image]' + NOC
	
	
	SELECT NOC, TeamName_ENG, TeamName_CHN, WonNum, LoseNum, Points, [Rank], TeamName AS PhaseName FROM #TMP_MEMBER ORDER BY [Rank], NOC
	
SET NOCOUNT OFF
END


GO


