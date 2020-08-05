IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetMedallists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetMedallists]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_AR_GetMedallists]
--描    述: 射箭项目报表获取所有项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 
--日    期: 2011年10月18日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetMedallists]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3) = 'CHN'
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID
		FROM TS_Discipline AS D
		WHERE D.F_Active = 1
	END

	-- 双打项目
	SELECT F.F_Order AS [EventOrder]
		, G.F_EventLongName AS [EventName]
		, dbo.[Func_Report_TE_GetDateTime](F.F_CloseDate, 1, @LanguageCode) AS [Date]
		, A.F_EventRank AS [Rank]
		, B.F_MedalLongName AS [Medal]
		, C.F_Order AS [MemberOrder]
		, E.F_PrintLongName AS [MemberName]
		, I.F_DelegationCode  AS [NOC]
		, A.F_RegisterID
		, DD.F_DelegationLongName
	FROM TS_Event_Result AS A
	LEFT JOIN TC_Medal_Des AS B 
		ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Member AS C
		ON A.F_RegisterID = C.F_RegisterID
	LEFT JOIN TR_Register AS D
		ON C.F_MemberRegisterID = D.F_RegisterID 
	LEFT JOIN TR_Register_Des AS E
		ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS F
		ON A.F_EventID = F.F_EventID
	LEFT JOIN TS_Event_Des AS G
		ON A.F_EventID = G.F_EventID AND G.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS H
		ON A.F_RegisterID = H.F_RegisterID
	LEFT JOIN TC_Delegation AS I
		ON D.F_DelegationID = I.F_DelegationID
	LEFT JOIN TC_Delegation_des AS DD
		ON DD.F_DelegationID = I.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE A.F_MedalID IS NOT NULL
		AND F.F_DisciplineID = @DisciplineID
		AND F.F_EventStatusID = 110							-- 仅显示结束了的项目
		AND F.F_PlayerRegTypeID = 2
		AND D.F_RegTypeID = 1

	UNION

	-- 单人项目
	SELECT E.F_Order AS [EventOrder]
		, F.F_EventLongName AS [EventName]
		, dbo.[Func_Report_TE_GetDateTime](E.F_CloseDate, 1, @LanguageCode) AS [Date]
		, A.F_EventRank AS [Rank]
		, B.F_MedalLongName AS [Medal]
		, 0 AS [MemberOrder]
		, D.F_PrintLongName AS [MemberName]
		, G.F_DelegationCode AS [NOC]
		, A.F_RegisterID
		, DD.F_DelegationLongName
	FROM TS_Event_Result AS A
	LEFT JOIN TC_Medal_Des AS B 
		ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_RegisterID
	LEFT JOIN TR_Register AS C
		ON A.F_RegisterID = C.F_RegisterID
	LEFT JOIN TR_Register_Des AS D
		ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON A.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS F
		ON A.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS G
		ON C.F_DelegationID = G.F_DelegationID
	LEFT JOIN TC_Delegation_des AS DD
		ON DD.F_DelegationID = G.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE A.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID = 110							-- 仅显示结束了的项目
		AND E.F_PlayerRegTypeID = 1
		AND C.F_RegTypeID = 1
		
	UNION
			
	-- 团体项目
	SELECT F.F_Order AS [EventOrder]
		, G.F_EventLongName AS [EventName]
		, dbo.[Func_Report_TE_GetDateTime](F.F_CloseDate, 1, @LanguageCode) AS [Date]
		, A.F_EventRank AS [Rank]
		, B.F_MedalLongName AS [Medal]
		, 0 AS [MemberOrder]
		, E.F_PrintLongName AS [MemberName]
		, I.F_DelegationCode  AS [NOC]
		, A.F_RegisterID
		, DD.F_DelegationLongName
	FROM TS_Event_Result AS A
	LEFT JOIN TC_Medal_Des AS B 
		ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS C
		ON A.F_RegisterID = C.F_RegisterID
	LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = C.F_RegisterID
	LEFT JOIN TR_Register AS D
		ON RM.F_MemberRegisterID = D.F_RegisterID AND RM.F_Order IN (1,2,3)
	LEFT JOIN TR_Register_Des AS E
		ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS F
		ON A.F_EventID = F.F_EventID
	LEFT JOIN TS_Event_Des AS G
		ON A.F_EventID = G.F_EventID AND G.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS H
		ON A.F_RegisterID = H.F_RegisterID
	LEFT JOIN TC_Delegation AS I
		ON D.F_DelegationID = I.F_DelegationID
	LEFT JOIN TC_Delegation_des AS DD
		ON DD.F_DelegationID = C.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE A.F_MedalID IS NOT NULL
		AND F.F_DisciplineID = @DisciplineID
		AND F.F_EventStatusID = 110							-- 仅显示结束了的项目
		AND F.F_PlayerRegTypeID = 3 
		AND D.F_RegTypeID = 1


SET NOCOUNT OFF
END



GO


