IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetMedalLists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetMedalLists]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_Report_WL_GetMedalLists]
--描    述: 项目报表获取单人项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月20日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetMedalLists]
	@EventID						INT,
	@LanguageCode                   CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventRank AS [Rank]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [Name]
		, D.F_DelegationCode AS [NOCCode]
		, DD.F_DelegationLongName AS [NOCLongName]
		, DD.F_DelegationLongName AS [DelegationName]
		, FD.F_FederationLongName AS [FederationName]
		, ER.F_EventPointsCharDes4 AS [Result]
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON ER.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID	
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode	
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode		
	WHERE  ER.F_EventID = @EventID
		   --AND ER.F_MedalID IS NOT NULL
		   AND ER.F_EventRank<=8
	

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetMedalLists] 9,'CHN'

*/