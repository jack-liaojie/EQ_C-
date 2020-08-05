IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_GetMedallists_Event]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_GetMedallists_Event]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_TVG_WR_GetMedallists_Event]
--描    述: 柔道项目TVG单项奖牌 
--创 建 人: 宁顺泽2011年05月28日 星期1
--修改记录：
/*			
	时间					修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_GetMedallists_Event]
	@EventID						INT,
	@LanguageCode					CHAR(3) = N'ENG'
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		MD.F_MedalLongName+N' Medal - '+ED.F_EventLongName AS [EventName]
		, N'[Image]'+D.F_DelegationCode AS [Flag]
		, RD.F_TvLongName AS [Name]		
		, N'[Image]'+UPPER(MD.F_MedalLongName) AS [Medal]
		,RD.F_TvShortName AS [Name_Short]
		,Ed.F_EventLongName AS EventName2
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event_Des AS ED
		ON ER.F_EventID=ED.F_EventID AND ED.F_LanguageCode=@LanguageCode
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
	WHERE ER.F_MedalID IS NOT NULL
		AND ER.F_EventID = @EventID
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_TVG_JU_GetMedallists_Event] 7, 'ENG'

*/