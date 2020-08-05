IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_Medallists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_Medallists]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [[Proc_SCB_JU_Medallists]]
--描    述: 获取 Medallists 屏幕数据集 
--创 建 人: 宁顺泽
--日    期: 2011年2月21日 星期一
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_Medallists]
	@EventID						INT
AS
BEGIN
SET NOCOUNT ON

	SELECT ED1.F_EventLongName AS [Event_ENG]
		, ED2.F_EventLongName AS [Event_CHN]
		, UPPER(MD1.F_MedalLongName) AS [Medal_ENG]
		, UPPER(MD2.F_MedalLongName) AS [Medal_CHN]
		, RD1.F_SBLongName AS [Name_ENG]
		, RD2.F_SBLongName AS [Name_CHN]
		, D.F_DelegationCode AS [NOC_ENG]
		, DD2.F_DelegationShortName AS [NOC_CHN]
		,N'[Image]'+UPPER(MD1.F_MedalLongName) AS [Image_Medal]
		,N'[Image]'+D.F_DelegationCode AS [Image_noc]
		,ED1.F_EventLongName+N'（'+ED2.F_EventLongName+N'）' AS EventName_CHN_ENG
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event_Des AS ED1
		ON ER.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED2
		ON ER.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Medal_Des AS MD1
		ON ER.F_MedalID = MD1.F_MedalID AND MD1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Medal_Des AS MD2
		ON ER.F_MedalID = MD2.F_MedalID AND MD2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD1
		ON R.F_RegisterID = RD1.F_RegisterID AND RD1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS RD2
		ON R.F_RegisterID = RD2.F_RegisterID AND RD2.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD2
		ON D.F_DelegationID = DD2.F_DelegationID AND DD2.F_LanguageCode = 'CHN'
	WHERE ER.F_MedalID IS NOT NULL
		AND ER.F_EventID = @EventID
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_JU_Medallists] 

*/