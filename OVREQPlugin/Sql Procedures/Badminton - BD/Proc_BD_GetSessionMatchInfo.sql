IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetSessionMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetSessionMatchInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BD_GetSessionMatchInfo]
--描    述：获取session下的一场比赛信息
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年06月07日

CREATE PROCEDURE [dbo].[Proc_BD_GetSessionMatchInfo](
												@SessionID INT,
												@CourtNo   INT,
												@OrderInCourt INT
)
As
Begin
SET NOCOUNT ON 

	DECLARE @CourtID INT
	DECLARE @MatchID INT
	SELECT @CourtID = F_CourtID FROM TC_Court WHERE CONVERT(INT, F_CourtCode) = @CourtNo
	IF @CourtID IS NULL
		RETURN
		
	SELECT @MatchID = F_MatchID FROM TS_Match AS A
	WHERE A.F_SessionID = @SessionID AND A.F_CourtID = @CourtID 
			AND A.F_MatchComment1 = CONVERT(NVARCHAR(10), @OrderInCourt)	
	IF @MatchID IS NULL
		RETURN
			
	DECLARE @Lang NVARCHAR(10)
	SELECT @Lang = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	
	DECLARE @EventType INT
	DECLARE @EventCode NVARCHAR(10)
	SELECT @EventType = C.F_PlayerRegTypeID,@EventCode = D.F_EventComment
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = @Lang
	WHERE A.F_MatchID = @MatchID
	
	IF @EventType IN (1,3)
	BEGIN
		SELECT @EventCode + A.F_RaceNum AS MatchCode,LEFT( CONVERT(NVARCHAR(20), A.F_StartTime,108),5) AS TimeString,
		dbo.Fun_BD_GetPlayerDrawPos(@MatchID, 1) AS PosA, dbo.Fun_BD_GetPlayerDrawPos(@MatchID, 2) AS PosB,
		C1.F_LongName AS NameA1, '' AS NameA2, C2.F_LongName AS NameB1, '' AS NameB2,
		dbo.Fun_BDTT_GetPlayerNOCName(B1.F_RegisterID) AS NOCA, dbo.Fun_BDTT_GetPlayerNOCName(B2.F_RegisterID) AS NOCB
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = @Lang
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = @Lang
		WHERE A.F_SessionID = @SessionID AND A.F_CourtID = @CourtID 
			AND A.F_MatchComment1 = CONVERT(NVARCHAR(10), @OrderInCourt)
	END
	ELSE
	BEGIN
		SELECT @EventCode + A.F_RaceNum AS MatchCode,LEFT( CONVERT(NVARCHAR(20), A.F_StartTime,108),5) AS TimeString,
		dbo.Fun_BD_GetPlayerDrawPos(@MatchID, 1) AS PosA, dbo.Fun_BD_GetPlayerDrawPos(@MatchID, 2) AS PosB,
		dbo.Fun_BDTT_GetRegisterName(D11.F_MemberRegisterID, 41, @Lang, 0) AS NameA1,
		dbo.Fun_BDTT_GetRegisterName(D12.F_MemberRegisterID, 41, @Lang, 0) AS NameA2,
		dbo.Fun_BDTT_GetRegisterName(D21.F_MemberRegisterID, 41, @Lang, 0) AS NameB1,
		dbo.Fun_BDTT_GetRegisterName(D22.F_MemberRegisterID, 41, @Lang, 0) AS NameB2,
		dbo.Fun_BDTT_GetPlayerNOCName(B1.F_RegisterID) AS NOCA, dbo.Fun_BDTT_GetPlayerNOCName(B2.F_RegisterID) AS NOCB
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Member AS D11 ON D11.F_RegisterID = B1.F_RegisterID AND D11.F_Order = 1
		LEFT JOIN TR_Register_Member AS D12 ON D12.F_RegisterID = B1.F_RegisterID AND D12.F_Order = 2
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Member AS D21 ON D21.F_RegisterID = B2.F_RegisterID AND D21.F_Order = 1
		LEFT JOIN TR_Register_Member AS D22 ON D22.F_RegisterID = B2.F_RegisterID AND D22.F_Order = 2
		WHERE A.F_SessionID = @SessionID AND A.F_CourtID = @CourtID 
			AND A.F_MatchComment1 = CONVERT(NVARCHAR(10), @OrderInCourt)
	END
	

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

