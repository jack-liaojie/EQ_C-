IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_GetMedallists_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_GetMedallists_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_GetMedallists_Team]
--描    述: 柔道项目报表获取Team项目奖牌获得者详细信息  
--创 建 人: 宁顺泽
--日    期: 2011年6月23日 星期4
--修改记录：
/*			
	时间					修改人		修改内容	
	
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_GetMedallists_Team]
	@EventID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT ER.F_MedalID AS [EventOrder]
		, ED.F_EventLongName AS [EventName]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		,N'[Image]'+UPPER(MD.F_MedalLongName) AS [ImageMedal]
		, RD.F_PrintLongName AS [MemberName1]
		,Rd2.F_PrintLongName AS [MemberName2]
		,Rd3.F_PrintLongName AS [MemberName3]
		,Rd4.F_PrintLongName AS [MemberName4]
		,Rd5.F_PrintLongName AS [MemberName5]
		,N'[Image]'+D.F_DelegationCode AS [Image_Noc] 
		,DD.F_DelegationLongName AS Team_Name
		,ED_CHN.F_EventLongName AS [EventName_CHN]
		,ED.F_EventLongName+N'（'+ED_CHN.F_EventLongName+N'）' AS EventName_CHN_ENG		
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD 
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Member AS RM
		ON ER.F_RegisterID = RM.F_RegisterID AND RM.F_Order=1
	LEFT JOIN TR_Register AS MR
		ON RM.F_MemberRegisterID = MR.F_RegisterID AND MR.F_RegTypeID = 1
	
	LEFT JOIN TR_Register_Member AS RM2
		ON ER.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order=2
	LEFT JOIN TR_Register AS MR2
		ON RM2.F_MemberRegisterID = MR2.F_RegisterID AND MR.F_RegTypeID = 1	
	LEFT  JOIN TR_Register_Des AS Rd2
		ON MR2.F_RegisterID=Rd2.F_RegisterID AND Rd2.F_LanguageCode=N'ENG'
	
	LEFT JOIN TR_Register_Member AS RM3
		ON ER.F_RegisterID = RM3.F_RegisterID AND RM3.F_Order=3
	LEFT JOIN TR_Register AS MR3
		ON RM3.F_MemberRegisterID = MR3.F_RegisterID AND MR.F_RegTypeID = 1	
	LEFT  JOIN TR_Register_Des AS Rd3
		ON MR3.F_RegisterID=Rd3.F_RegisterID AND Rd3.F_LanguageCode=N'ENG'
	
	LEFT JOIN TR_Register_Member AS RM4
		ON ER.F_RegisterID = RM4.F_RegisterID AND RM4.F_Order=4
	LEFT JOIN TR_Register AS MR4
		ON RM4.F_MemberRegisterID = MR4.F_RegisterID AND MR.F_RegTypeID = 1
	LEFT  JOIN TR_Register_Des AS Rd4
		ON MR4.F_RegisterID=Rd4.F_RegisterID AND Rd4.F_LanguageCode=N'ENG'
		
	LEFT JOIN TR_Register_Member AS RM5
		ON ER.F_RegisterID = RM5.F_RegisterID AND RM5.F_Order=5
	LEFT JOIN TR_Register AS MR5
		ON RM5.F_MemberRegisterID = MR5.F_RegisterID AND MR.F_RegTypeID = 1
	LEFT  JOIN TR_Register_Des AS Rd5
		ON MR5.F_RegisterID=Rd5.F_RegisterID AND Rd5.F_LanguageCode=N'ENG'
	
	LEFT JOIN TC_Delegation_Des AS DD
		ON DD.F_DelegationID=MR.F_DelegationID AND DD.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des AS DD_CHN
		ON DD_CHN.F_DelegationID=MR.F_DelegationID AND DD_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TR_Register_Des AS RD
		ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON ER.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED_CHN
		ON ER.F_EventID = ED_CHN.F_EventID AND ED_CHN.F_LanguageCode = 'CHN' 
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	WHERE ER.F_MedalID IS NOT NULL
		AND E.F_EventID = @EventID
		AND E.F_EventStatusID = 110							-- 仅显示结束了的项目
		AND E.F_PlayerRegTypeID = 3
	ORDER BY ER.F_MedalID
	
SET NOCOUNT OFF
END

/*

-- Just for test


*/