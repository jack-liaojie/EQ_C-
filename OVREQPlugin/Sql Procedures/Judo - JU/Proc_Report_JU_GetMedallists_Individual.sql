IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetMedallists_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetMedallists_Individual]
--描    述: 柔道项目报表获取单人项目奖牌获得者详细信息  
--创 建 人: 邓年彩
--日    期: 2010年10月28日 星期四
--修改记录：
/*			
	时间					修改人		修改内容	
	2011年1月4日 星期二		邓年彩		将 TS_Event_Result 中字段 F_EventDiplayPosition 改为 F_EventDisplayPosition.
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_Individual]
	@EventID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventRank AS [Rank]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, RD.F_PrintLongName AS [Name]
		, D.F_DelegationCode AS [NOCCode]
		, DD.F_DelegationLongName AS [NOCLongName]
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD 
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON ER.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	WHERE ER.F_MedalID IS NOT NULL
		AND ER.F_EventID = @EventID
		AND E.F_PlayerRegTypeID=1
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetMedallists_Individual] 109, 'ENG'

*/