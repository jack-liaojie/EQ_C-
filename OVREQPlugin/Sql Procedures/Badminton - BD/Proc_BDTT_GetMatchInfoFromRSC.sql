IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BDTT_GetMatchInfoFromRSC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BDTT_GetMatchInfoFromRSC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_BDTT_GetMatchInfoFromRSC]
----功		  能: 从MatchCode获取到
----作		  者：王强
----日		  期: 2011-5-17

CREATE PROCEDURE [dbo].[Proc_BDTT_GetMatchInfoFromRSC]
	@AllMatchRsc     NVARCHAR(MAX)
	
AS
BEGIN
	
SET NOCOUNT ON
	
	CREATE TABLE #TMP_ACTION_LIST
	(
		MatchCode NVARCHAR(20),
		MatchID INT,
		Court INT,
		TimeDes NVARCHAR(20),
		MatchDes NVARCHAR(200)
	)
	
	DECLARE @iDoc           AS INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @AllMatchRsc
	
	INSERT INTO #TMP_ACTION_LIST (MatchCode)
	SELECT *
	FROM OPENXML (@iDoc, '/AllCode/Match',1)
	WITH
	(
		MatchCode NVARCHAR(20)
	)
	
	EXEC sp_xml_removedocument @iDoc
	
	UPDATE #TMP_ACTION_LIST SET MatchID = dbo.Fun_BDTT_GetMatchIDFromRsc(MatchCode)
	
	UPDATE #TMP_ACTION_LIST SET Court = B.F_CourtID, TimeDes = LEFT( CONVERT(NVARCHAR(20), B.F_StartTime, 108), 5 ),
			MatchDes= D.F_EventShortName + ' ' + E.F_PhaseShortName + ' ' + F.F_MatchShortName
	FROM #TMP_ACTION_LIST AS A
	LEFT JOIN TS_Match AS B ON B.F_MatchID = A.MatchID
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Des AS F ON F.F_MatchID = B.F_MatchID AND F.F_LanguageCode = 'ENG'
	
	SELECT * FROM #TMP_ACTION_LIST

SET NOCOUNT OFF
END


GO

