IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetClassification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetClassification]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetClassification]
--描    述: 获取一个项目的所有名次.
--创 建 人: 邓年彩
--日    期: 2010年10月25日 星期一
--修改记录：
/*			
	日期					修改人		修改内容
	2011年1月4日 星期二		邓年彩		将 TS_Event_Result 中字段 F_EventDiplayPosition 改为 F_EventDisplayPosition.
	2011年3月30号			宁顺泽		从F_MedalID字段获取奖牌
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetClassification]
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	-- 当 @MatchID 有效时, 以 @MatchID 为准
	IF @MatchID > 0
	BEGIN
		SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	END
	
	-- 当 @PhaseID 有效时, 以 @PhaseID 为准
	IF @PhaseID > 0
	BEGIN
		SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	END
	
	SELECT ER.F_EventRank AS [Rank]
		, RD.F_PrintLongName AS [Name]
		, DD.F_DelegationLongName AS [NOCCode]
		, [Medal] = CASE ER.F_MedalID WHEN 1 THEN N'GOLD' WHEN 2 THEN N'SILVER' WHEN 3 THEN N'BRONZE' END
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD
		ON D.F_DelegationID=DD.F_DelegationID and DD.F_LanguageCode=@LanguageCode
	WHERE ER.F_EventID = @EventID
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetClassification] 15, -1, -1, 'ENG'

*/