IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_BD_RealTimeResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_BD_RealTimeResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Info_BD_RealTimeResult]
----功		  能：获取羽毛球Info需要的实时成绩
----作		  者：王强
----日		  期: 2012-09-13

CREATE PROCEDURE [dbo].[Proc_Info_BD_RealTimeResult]
								@MatchID INT
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @EventID INT
	DECLARE @PhaseType INT
	DECLARE @PlayerType INT
	DECLARE @MatchDate DATETIME
	DECLARE @Xml NVARCHAR(MAX)
	DECLARE @DayOrder INT
	SELECT @EventID = C.F_EventID, @PhaseType = B.F_PhaseType, @PlayerType = C.F_PlayerRegTypeID,@MatchDate = A.F_MatchDate,
			@DayOrder = D.F_DateOrder
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID  = B.F_EventID
	LEFT JOIN TS_DisciplineDate AS D ON DATEDIFF(dd,D.F_Date, A.F_MatchDate) = 0
	WHERE A.F_MatchID = @MatchID
	
	
	IF @PlayerType = 3
	BEGIN
		SET @Xml = 
		(
			SELECT 'CHI' AS [Language], dbo.Fun_Report_BD_GetDateTime(GETDATE(), 10 ) AS [Date],
				 dbo.Fun_Report_BD_GetDateTime(GETDATE(), 14 ) AS [Time],
			(
				SELECT ISNULL(C.F_MatchShortName,'') AS [Match], 
				'' AS GroupA, dbo.Fun_BDTT_GetRegisterName(D1.F_RegisterID, 21, 'CHN', 0) AS DelegationName_A,
				'' AS GroupB, dbo.Fun_BDTT_GetRegisterName(D2.F_RegisterID, 21, 'CHN', 0) AS DelegationName_B,
				'' AS DuringTime, dbo.Fun_Info_BDTT_New_GetMatchResultDes(A.F_MatchID, 0, 0) AS Result,
				CASE WHEN D1.F_Rank = 1 THEN dbo.Fun_BDTT_GetRegisterName(D1.F_RegisterID, 21, 'CHN', 0)
					 WHEN D2.F_Rank = 1 THEN dbo.Fun_BDTT_GetRegisterName(D2.F_RegisterID, 21, 'CHN', 0)
					 ELSE '' END AS Winner, E.F_StatusCode AS [Status],
					 (
						SELECT dbo.Func_BDTT_GetTeamMatchSplitTypeDes(H.F_MatchSplitType,'CHN') AS Item,
							dbo.Fun_BDTT_GetRegisterName(I1.F_RegisterID, 21, 'CHN', 0) AS AthleteNameA,
							dbo.Fun_BDTT_GetRegisterName(I2.F_RegisterID, 21, 'CHN', 0) AS AthleteNameB,
							'' AS DuringTime,
							dbo.Fun_Info_BDTT_New_GetMatchResultDes(H.F_MatchID, H.F_Order, 1) AS Result1,
							dbo.Fun_Info_BDTT_New_GetMatchResultDes(H.F_MatchID, H.F_Order, 2) AS Result2,
							dbo.Fun_Info_BDTT_New_GetMatchResultDes(H.F_MatchID, H.F_Order, 3) AS Result3,
							dbo.Fun_Info_BDTT_New_GetMatchResultDes(H.F_MatchID, H.F_Order, 0) AS Result
						FROM TS_Match_Split_Info AS H
						LEFT JOIN TS_Match_Split_Result AS I1 ON I1.F_MatchID = H.F_MatchID AND I1.F_MatchSplitID = H.F_MatchSplitID
																		AND I1.F_CompetitionPosition = 1
						LEFT JOIN TS_Match_Split_Result AS I2 ON I2.F_MatchID = H.F_MatchID AND I2.F_MatchSplitID = H.F_MatchSplitID
																		AND I2.F_CompetitionPosition = 2
						WHERE H.F_MatchID = A.F_MatchID AND H.F_FatherMatchSplitID = 0
						FOR XML RAW('Row1'),TYPE
					 )
				FROM TS_Match AS A
				LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
				LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = 'CHN'
				LEFT JOIN TS_Match_Result AS D1 ON D1.F_MatchID = A.F_MatchID AND D1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TS_Match_Result AS D2 ON D2.F_MatchID = A.F_MatchID AND D2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TC_Status AS E ON E.F_StatusID = A.F_MatchStatusID
				WHERE B.F_EventID = @EventID AND B.F_PhaseType = @PhaseType AND DATEDIFF(dd, A.F_MatchDate,@MatchDate ) = 0
					AND A.F_MatchStatusID BETWEEN 50 AND 110
				FOR XML RAW('Row'),TYPE
			) FOR XML RAW('Message')
		)
	END
	ELSE
	BEGIN
		SET @Xml = 
		(
			SELECT 	'CHI' AS [Language], dbo.Fun_Report_BD_GetDateTime(GETDATE(), 10 ) AS [Date],
				 dbo.Fun_Report_BD_GetDateTime(GETDATE(), 14 ) AS [Time],
			(
				SELECT ISNULL(C.F_MatchShortName,'') AS [Match], 
				dbo.Fun_BDTT_GetPlayerNOCName(D1.F_RegisterID) AS DelegationName_A,
				dbo.Fun_BDTT_GetRegisterName(D1.F_RegisterID, 21, 'CHN', 0) AS AthleteNameA,
				dbo.Fun_BDTT_GetPlayerNOCName(D2.F_RegisterID) AS DelegationName_B,
				dbo.Fun_BDTT_GetRegisterName(D2.F_RegisterID, 21, 'CHN', 0) AS AthleteNameB,
				dbo.Fun_Info_BDTT_New_GetMatchResultDes(A.F_MatchID, 0, 1) AS Result1,
				dbo.Fun_Info_BDTT_New_GetMatchResultDes(A.F_MatchID, 0, 2) AS Result2,
				dbo.Fun_Info_BDTT_New_GetMatchResultDes(A.F_MatchID, 0, 3) AS Result3,
				'' AS DuringTime, dbo.Fun_Info_BDTT_New_GetMatchResultDes(A.F_MatchID, 0, 0) AS Result,
				CASE WHEN D1.F_Rank = 1 THEN dbo.Fun_BDTT_GetRegisterName(D1.F_RegisterID, 21, 'CHN', 0)
					 WHEN D2.F_Rank = 1 THEN dbo.Fun_BDTT_GetRegisterName(D2.F_RegisterID, 21, 'CHN', 0)
					 ELSE '' END AS Winner, E.F_StatusCode AS [Status]
				FROM TS_Match AS A
				LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
				LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = 'CHN'
				LEFT JOIN TS_Match_Result AS D1 ON D1.F_MatchID = A.F_MatchID AND D1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TS_Match_Result AS D2 ON D2.F_MatchID = A.F_MatchID AND D2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TC_Status AS E ON E.F_StatusID = A.F_MatchStatusID
				WHERE B.F_EventID = @EventID AND B.F_PhaseType = @PhaseType AND DATEDIFF(dd, A.F_MatchDate,@MatchDate ) = 0
					AND A.F_MatchStatusID BETWEEN 50 AND 110
				FOR XML RAW('Row'),TYPE
			) FOR XML RAW('Message')
		)
	END
	
	
	SET @Xml = '<?xml version="1.0" encoding="UTF-8"?>' + @xml
	
	DECLARE @Type INT
	IF @PlayerType != 3
	BEGIN
		SET @Type = 0
	END
	ELSE
	BEGIN
		IF @PhaseType = 31
			SET @Type = 2
		ELSE
			SET @Type = 1
	END
	
	SELECT @xml,dbo.Fun_Info_BDTT_LN_GetScheduleRSC(@EventID, @Type, @DayOrder)
SET NOCOUNT OFF
END


GO
