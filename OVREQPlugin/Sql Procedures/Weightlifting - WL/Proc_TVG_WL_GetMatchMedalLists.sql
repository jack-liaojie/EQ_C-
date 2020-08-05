IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WL_GetMatchMedalLists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WL_GetMatchMedalLists]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_TVG_WL_GetMatchMedalLists]
--描    述: 奖牌信息 屏幕数据集  
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年2月28日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WL_GetMatchMedalLists]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON
 
	SELECT DISTINCT  
		  EDE.F_EventLongName AS Event_ENG
		, EDC.F_EventLongName AS Event_CHN
		, ISNULL(MR.F_Rank,999) AS [Rank]
		, UPPER(MDE.F_MedalLongName) AS [Medal_ENG]
		, MDC.F_MedalLongName AS [Medal_CHN]
		, (SELECT REPLACE(RDE.F_LongName,'/',nchar(10))) AS [Name_ENG]
		, (SELECT REPLACE(RDC.F_LongName,'/',nchar(10))) AS [Name_CHN]
		, '[image]' +D.F_DelegationCode AS [Flag]
		, D.F_DelegationCode AS [NOC]
		, DDE.F_DelegationLongName AS [NOCLongName_ENG]
		, DDC.F_DelegationLongName AS [NOCLongName_CHN]
		, DDE.F_DelegationLongName AS [DelegationName_ENG]
		, DDC.F_DelegationLongName AS [DelegationName_CHN]
		, FDE.F_FederationLongName AS [FederationName_ENG]
		, FDC.F_FederationLongName AS [FederationName_CHN]
		, MDE.F_MedalLongName + N' Medal - ' + EDE.F_EventLongName AS [FederationName_CHN]
		, N'[Image]' + MDE.F_MedalLongName  AS [Medal]
	FROM TS_Match_Result AS MR
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDE ON MR.F_RegisterID = RDE.F_RegisterID AND RDE.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS RDC ON MR.F_RegisterID = RDC.F_RegisterID AND RDC.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID	
	LEFT JOIN TC_Delegation_Des AS DDE ON R.F_DelegationID = DDE.F_DelegationID AND DDE.F_LanguageCode = 'ENG'	
	LEFT JOIN TC_Delegation_Des AS DDC ON R.F_DelegationID = DDC.F_DelegationID AND DDC.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Federation_Des AS FDE ON R.F_FederationID = FDE.F_FederationID AND FDE.F_LanguageCode = 'ENG'	
	LEFT JOIN TC_Federation_Des AS FDC ON R.F_FederationID = FDC.F_FederationID AND FDC.F_LanguageCode = 'CHN'
		
	LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID
	LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID 
	LEFT JOIN TS_Event_Result AS ER ON ER.F_EventID = E.F_EventID AND ER.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TC_Medal_Des AS MDE ON ER.F_MedalID = MDE.F_MedalID AND MDE.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Medal_Des AS MDC ON ER.F_MedalID = MDC.F_MedalID AND MDC.F_LanguageCode = 'CHN'	
	LEFT JOIN TS_Event_Des AS EDE ON EDE.F_EventID = ER.F_EventID AND EDE.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS EDC ON EDC.F_EventID = ER.F_EventID AND EDC.F_LanguageCode = 'CHN'	
	WHERE MR.F_Rank IS NOT NULL
		AND MR.F_MatchID = @MatchID
	ORDER BY [Rank]
	
SET NOCOUNT OFF
END

GO


