IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetEntryDataChecklist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetEntryDataChecklist]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetEntryDataChecklist]
--描    述: 空手道报表 C38 (Entry Data Checklist), 获取主要信息.
--创 建 人: 邓年彩
--日    期: 2010年10月6日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetEntryDataChecklist]
	@DisciplineID				INT,
	@DelegationID				INT,
	@NOCID						CHAR(3),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

	DECLARE @GroupType			INT

	-- 确定 @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- 目前只考虑 2 - NOC 和 4 - Delegation 这两种情况, 优先考虑 4 - Delegation.
	IF @DelegationID > 0
	BEGIN
		SET @GroupType = 4
	END
	ELSE IF @NOCID <> '-1 ' AND @NOCID <> '   '
	BEGIN
		SET @GroupType = 2
	END
	-- 当 @DelegationID 与 @NOCID 无效时, 从默认配置中获取 GroupType
	ELSE
	BEGIN
		SELECT @GroupType = SC.F_ConfigValue
		FROM TS_Sport_Config AS SC
		LEFT JOIN TS_Discipline AS D
			ON SC.F_SportID = D.F_SportID
		WHERE D.F_DisciplineID = @DisciplineID
			AND SC.F_ConfigType = 1 AND SC.F_ConfigName = N'GroupType'
			
		IF @GroupType <> 2
			SET @GroupType = 4
	END
	
	SELECT [NOC] = CASE @GroupType WHEN 2 THEN R.F_NOC ELSE D.F_DelegationCode END
		, [NOCLongName] = CASE @GroupType WHEN 2 THEN CD.F_CountryLongName ELSE DD.F_DelegationLongName END
		, R.F_RegisterID AS [Reference]
		, CASE R.F_RegTypeID
			WHEN 1 THEN 'Athlete'
			ELSE FD.F_FunctionLongName
		END [Function]
		, RD.F_LastName AS [FamilyName]
		, RD.F_FirstName AS [GivenName]
		, S.F_GenderCode AS [Gender]
		, dbo.[Func_Report_JU_GetDateTime](R.F_Birth_Date, 1, 'ENG') AS [BirthDate]
		, LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + ' / ' 
			+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 3048) + ''''
			+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 254) % 12) + '"' AS [Height]
		, CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + ' / ' 
			+ CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight, 0)) * 22 / 10) AS [Weight]
		, R.F_RegisterCode AS [Accredition]
		, R.F_RegisterNum AS [IFNumber]
		, RD.F_PrintLongName
		, RD.F_PrintShortName
		, RD.F_TvLongName
		, RD.F_TvShortName
		, RD.F_SBLongName
		, RD.F_SBShortName
		, RD.F_WNPA_LastName AS [WNPAFamilyName]
		, RD.F_WNPA_FirstName AS [WNPAFirstName]
		, R.F_RegTypeID
	FROM TR_Register AS R
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex AS S
		ON R.F_SexCode = S.F_SexCode
	LEFT JOIN TD_Function_Des AS FD
		ON R.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Country_Des AS CD
		ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE R.F_RegTypeID IN (1)
		AND R.F_DisciplineID = @DisciplineID
		AND (
				(@GroupType = 4 AND R.F_DelegationID IS NOT NULL AND D.F_DelegationType = N'N'
					AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID))
				OR
				(@GroupType = 2 AND R.F_NOC IS NOT NULL
					AND (@NOCID = '-1 ' OR @NOCID = '   ' OR R.F_NOC = @NOCID))
			)	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetEntryDataChecklist] -1, -1, '-1', 'ENG'
EXEC [Proc_Report_JU_GetEntryDataChecklist] -1, -1, 'AFG', 'ENG'

*/