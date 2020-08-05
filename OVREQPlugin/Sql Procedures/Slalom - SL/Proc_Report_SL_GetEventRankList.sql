IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetEventRankList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetEventRankList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----名    称: [Proc_Report_SL_GetEventRankList]
----描    述: 激流回旋项目报表获取单人项目奖牌获得者详细信息  
----参数说明: 
----说    明: 
----创 建 人: 吴定昉
----日    期: 2010年01月25日
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年7月31日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetEventRankList]
	@EventID						INT,
	@LanguageCode                   CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventRank AS [Rank]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [Name]
		, RD.F_LongName AS [DefaultName]
		, RD.F_LongName AS [DoublePlayerCombName]
		, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [DoublePlayerWrapName]		
		, D.F_DelegationCode AS [NOCCode]
		, DD.F_DelegationLongName AS [NOCLongName]
		, DD.F_DelegationLongName AS [DelegationName]
		/*
		, (case when R.f_regtypeid = 1 then DD.F_DelegationLongName 
				when R.f_regtypeid = 2 then (DD1.F_DelegationLongName + nchar(10) + DD2.F_DelegationLongName) 
				end) AS [DelegationName]
		*/		
		--, DD.F_DelegationLongName AS [DelegationName]
		, (case when R.f_regtypeid = 1 then FD.F_FederationLongName 
				when R.f_regtypeid = 2 then (FD1.F_FederationLongName + nchar(10) + FD2.F_FederationLongName) 
				end) AS [FederationName]
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON ER.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID	
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode	
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Member AS RM1 ON R.F_RegisterID = RM1.F_RegisterID AND RM1.F_Order = 1
	LEFT JOIN TR_Register AS R1 ON RM1.F_MemberRegisterID = R1.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD1 ON R1.F_RegisterID = RD1.F_RegisterID AND RD1.F_LanguageCode = @LanguageCode 
	LEFT JOIN TC_Delegation_Des AS DD1 ON R1.F_DelegationID = DD1.F_DelegationID AND DD1.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Federation_Des AS FD1 ON R1.F_FederationID = FD1.F_FederationID AND FD1.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Member AS RM2 ON R.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order = 2
	LEFT JOIN TR_Register AS R2 ON RM2.F_MemberRegisterID = R2.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD2 ON R2.F_RegisterID = RD2.F_RegisterID AND RD2.F_LanguageCode = @LanguageCode 
	LEFT JOIN TC_Delegation_Des AS DD2 ON R2.F_DelegationID = DD2.F_DelegationID AND DD2.F_LanguageCode = @LanguageCode			
	LEFT JOIN TC_Federation_Des AS FD2 ON R2.F_FederationID = FD2.F_FederationID AND FD2.F_LanguageCode = @LanguageCode			
	WHERE ER.F_EventRank <= 8
		AND ER.F_EventID = @EventID

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetEventRankList] 1,'chn'

*/