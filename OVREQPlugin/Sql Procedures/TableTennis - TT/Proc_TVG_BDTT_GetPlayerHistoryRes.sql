IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetPlayerHistoryRes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetPlayerHistoryRes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetPlayerHistoryRes]
----功		  能：获取TVG需要的比赛双方的历史对阵和成绩
----作		  者：王强
----日		  期: 2011-04-25

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetPlayerHistoryRes]
		@MatchID INT,
		@Position INT --1为主队，2为客队
AS
BEGIN
	
	SET NOCOUNT ON
	
	IF @Position NOT IN (1,2)
		RETURN
	
	DECLARE @EventID INT
	SELECT @EventID = A.F_EventID FROM TS_Phase AS A
	LEFT JOIN TS_Match AS B ON B.F_PhaseID = A.F_PhaseID
	WHERE B.F_MatchID = @MatchID
	


	SELECT '[Image]' + D4.F_DelegationCode AS HomeNOC, REPLACE(D1.F_TvShortName,'/',' / ') AS HomeName_ENG, REPLACE(D2.F_TvShortName,'/',' / ') AS HomeName_CHN,
	       '[Image]' + E4.F_DelegationCode AS AWayNOC, REPLACE(E1.F_TvShortName,'/',' / ') AS AWayName_ENG, REPLACE(E2.F_TvShortName,'/',' / ') AS AwayName_CHN,
		[dbo].[Fun_TVG_BDTT_GetRegisterResultDes](B.F_MatchID, A.F_RegisterID) AS ResultDes
	FROM TS_Match_Result AS A
	LEFT JOIN TS_Match_Result AS B ON B.F_RegisterID = A.F_RegisterID
				AND B.F_MatchID IN
				(
						SELECT A.F_MatchID FROM TS_Match AS A
						LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
						LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
						WHERE C.F_EventID = @EventID
				)--根据RegisterID找到含有Register的MatchID
	--根据MatchID找对手ID，且要求对手不为空
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = B.F_MatchID AND B2.F_RegisterID != B.F_RegisterID AND (B2.F_RegisterID IS NOT NULL) 
			AND B2.F_RegisterID != -1
	LEFT JOIN TS_Match AS C ON C.F_MatchID = B.F_MatchID
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = A.F_RegisterID AND D1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = A.F_RegisterID AND D2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS D3 ON D3.F_RegisterID = A.F_RegisterID
	LEFT JOIN TC_Delegation AS D4 ON D4.F_DelegationID = D3.F_DelegationID

	LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = B2.F_RegisterID AND E1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = B2.F_RegisterID AND E2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS E3 ON E3.F_RegisterID = B2.F_RegisterID
	LEFT JOIN TC_Delegation AS E4 ON E4.F_DelegationID = E3.F_DelegationID
	WHERE A.F_MatchID = @MatchID AND C.F_MatchStatusID IN (100,110) AND A.F_CompetitionPositionDes1 = @Position
			AND B2.F_RegisterID IS NOT NULL AND B2.F_RegisterID != -1
	ORDER BY CAST(C.F_RaceNum AS INT)
	
SET NOCOUNT OFF
END


GO


