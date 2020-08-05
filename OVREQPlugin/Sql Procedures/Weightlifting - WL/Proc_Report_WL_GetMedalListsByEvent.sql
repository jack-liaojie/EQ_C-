IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetMedalListsByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetMedalListsByEvent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_WL_GetMedalListsByEvent]
--描    述: 项目报表获取所有项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月12日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetMedalListsByEvent]
	@DisciplineID						INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
     SET Language English
	SELECT E.F_Order AS [EventOrder]
		, F.F_EventLongName AS [EventName]
		, dbo.Fun_WL_GetDateTime( A.F_ResultCreateDate, 1, @LanguageCode)  AS [Date]
		, A.F_EventRank AS [Rank]
		, B.F_MedalLongName AS [Medal]
		, 0 AS [MemberOrder]
	    ,(SELECT REPLACE(D.F_PrintLongName,'/',nchar(10))) AS [MemberName]
		, GD.F_DelegationLongName AS [NOC]
		, A.F_RegisterID
	FROM TS_Event_Result AS A
	LEFT JOIN TC_Medal_Des AS B 
		ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
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
	LEFT JOIN TC_Delegation_des AS GD
		ON C.F_DelegationID = GD.F_DelegationID AND GD.F_LanguageCode = @LanguageCode
	WHERE A.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID > 100

SET NOCOUNT OFF
END

GO

/*
exec Proc_Report_WL_GetMedalListsByEvent 1, 'eng'
*/
