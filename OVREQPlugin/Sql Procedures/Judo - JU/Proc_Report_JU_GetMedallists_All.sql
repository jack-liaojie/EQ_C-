IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetMedallists_All]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_All]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetMedallists_All]
--描    述: 柔道项目报表获取所有项目奖牌获得者详细信息  
--创 建 人: 邓年彩
--日    期: 2010年10月28日 星期四
--修改记录：
/*			
	时间					修改人		修改内容
	2011年1月4日 星期二		邓年彩		将 TS_Event_Result 中字段 F_EventDiplayPosition 改为 F_EventDisplayPosition.	
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_All]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID
		FROM TS_Discipline AS D
		WHERE D.F_Active = 1
	END

	-- 多人项目
	SELECT E.F_Order AS [EventOrder]
		, ED.F_EventLongName AS [EventName]
		, dbo.[Func_Report_JU_GetDateTime](E.F_CloseDate, 1, 'ENG') AS [Date]
		, ER.F_EventRank AS [Rank]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, RM.F_Order AS [MemberOrder]
		, RD.F_PrintLongName AS [MemberName]
		, D.F_DelegationCode  AS [NOC]
		, ER.F_RegisterID
		, ER.F_EventDisplayPosition AS [Dispos]
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD 
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Member AS RM
		ON ER.F_RegisterID = RM.F_RegisterID
	LEFT JOIN TR_Register AS MR
		ON RM.F_MemberRegisterID = MR.F_RegisterID AND MR.F_RegTypeID = 1
	LEFT JOIN TR_Register_Des AS RD
		ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON ER.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	WHERE ER.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID = 110							-- 仅显示结束了的项目
		AND E.F_PlayerRegTypeID = 3
		And ISNULL(RD.F_PrintLongName,N'')<>N''
	UNION

	-- 单人项目
	SELECT E.F_Order AS [EventOrder]
		, ED.F_EventLongName AS [EventName]
		, dbo.[Func_Report_JU_GetDateTime](E.F_CloseDate, 1, 'ENG') AS [Date]
		, ER.F_EventRank AS [Rank]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, 0 AS [MemberOrder]
		, RD.F_PrintLongName AS [MemberName]
		, D.F_DelegationCode AS [NOC]
		, ER.F_RegisterID
		, ER.F_EventDisplayPosition AS [Dispos]
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD 
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON ER.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON ER.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	WHERE ER.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID = 110							-- 仅显示结束了的项目
		AND E.F_PlayerRegTypeID = 1
		AND R.F_RegTypeID = 1
		And ISNULL(RD.F_PrintLongName,N'')<>N''
	ORDER BY [EventOrder], [Dispos], [MemberOrder]

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetMedallists_All] 74, 'ENG'

*/