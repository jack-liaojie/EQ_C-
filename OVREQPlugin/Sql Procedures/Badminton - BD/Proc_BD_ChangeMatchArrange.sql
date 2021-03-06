IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_ChangeMatchArrange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_ChangeMatchArrange]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BD_ChangeMatchArrange]
--描    述：编排@MatchCode
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年06月08日

CREATE PROCEDURE [dbo].[Proc_BD_ChangeMatchArrange](
								@MatchCode NVARCHAR(10),--要改变为的MatchCode
								@SessionID INT,--当前SessionID
								@CourtNo INT,--当前的比赛场地
								@OrderInCourt INT,--当前场地的比赛顺序
								@Result INT OUTPUT--
								/*
								1 为设置成功，并返回设置成功后的比赛信息
								-1为找不到场地，检查场地的Code
								-2MatchCode不合法
								-3从MatchCode获取EventID失败
								-4MatchCode已经被安排了或无法找到
								*/
)
As
Begin
SET NOCOUNT ON 
	
	SET @Result = 1
	--首先判断当前场地和顺序上是否有比赛
	DECLARE @OldMatchID INT
	DECLARE @CourtID INT
	DECLARE @SessionDate DATETIME
	SELECT @SessionDate = F_SessionDate FROM TS_Session WHERE F_SessionID = @SessionID
	SELECT @CourtID = F_CourtID FROM TC_Court WHERE CONVERT(INT,F_CourtCode) = @CourtNo
	IF @CourtID IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	--获取原有场地上的ID	
	SELECT @OldMatchID = F_MatchID FROM TS_Match WHERE F_SessionID = @SessionID AND F_CourtID = @CourtID AND
			F_MatchComment1 = CAST(@OrderInCourt AS NVARCHAR(10))
	
	--如果原有场地有比赛，则先清空它
	IF @OldMatchID IS NOT NULL
	BEGIN
		UPDATE TS_Match SET F_CourtID = NULL, F_MatchComment1 = NULL WHERE F_MatchID = @OldMatchID
	END
	
	--获取要设置为的比赛ID
	IF LEN(@MatchCode) < 3
	BEGIN
		SET @Result = -2
		RETURN
	END
		
	DECLARE @EventComment NVARCHAR(10)
	DECLARE @MatchID INT
	DECLARE @EventID INT
	SET @EventComment = LEFT(@MatchCode,2)
	
	SELECT @EventID = F_EventID FROM TS_Event_Des WHERE F_EventComment = @EventComment
	IF @EventID IS NULL
	BEGIN
		SET @Result = -3
		RETURN
	END
		
	SELECT @MatchID = F_MatchID FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	WHERE B.F_EventID = @EventID AND A.F_RaceNum = SUBSTRING(@MatchCode, 3, 10)
		AND (A.F_MatchComment1 IS NULL OR A.F_CourtID IS NULL )
	IF @MatchID IS NULL
	BEGIN
		SET @Result = -4
		RETURN
	END
	
	--为新比赛设置场地和顺序
	UPDATE TS_Match SET F_CourtID = @CourtID, F_SessionID = @SessionID, F_MatchDate = @SessionDate, F_MatchComment1 = CAST(@OrderInCourt AS NVARCHAR(10))
	WHERE F_MatchID = @MatchID
	
	--获取当前语言		
	DECLARE @Lang NVARCHAR(10)
	SELECT @Lang = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	
	--获取Event信息
	DECLARE @EventType INT
	DECLARE @EventCode NVARCHAR(10)
	SELECT @EventType = C.F_PlayerRegTypeID,@EventCode = D.F_EventComment
	FROM TS_Event AS C
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = @Lang
	WHERE C.F_EventID = @EventID
	
	--返回新设置的比赛信息
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
		WHERE A.F_MatchID = @MatchID
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
		WHERE A.F_MatchID = @MatchID
	END
	
	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

