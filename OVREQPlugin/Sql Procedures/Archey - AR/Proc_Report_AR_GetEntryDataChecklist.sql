IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetEntryDataChecklist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetEntryDataChecklist]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_Report_AR_GetEntryDataChecklist]
--描    述: 
--参数说明: 
--说    明: 射箭的运动员需要有备注信息
--创 建 人: 崔凯	
--日    期: 2011年10月18日
--修改记录：
/*			

*/



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetEntryDataChecklist]
	@DisciplineID				INT,
	@DelegationID				INT,
	@NOCID						CHAR(3),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

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
	
	SELECT R.F_RegisterID, [NOC] = CASE @GroupType WHEN 2 THEN R.F_NOC ELSE D.F_DelegationCode END
		, [NOCLongName] = CASE @GroupType WHEN 2 THEN CD.F_CountryLongName ELSE DD.F_DelegationLongName END
		, R.F_RegisterID AS [Reference]
		, CASE WHEN R.F_RegTypeID=1 AND @LanguageCode='ENG' THEN 'Athlete'
			WHEN R.F_RegTypeID=1 AND @LanguageCode='CHN' THEN '运动员'
			ELSE FD.F_FunctionLongName
		END [Function]
		, RD.F_LastName AS [FamilyName]
		, RD.F_FirstName AS [GivenName]
		, SD.F_SexLongName AS [Gender]
		, dbo.Fun_AR_GetDateTime(R.F_Birth_Date, 1, @LanguageCode) AS [BirthDate]
		, LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + ' / ' 
			+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 3048) + ''''
			+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 254) % 12) + '"' AS [Height]
			, CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + ' / ' 
			+ CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight, 0)) * 22 / 10) AS [Weight]
		, R.F_RegisterCode AS [Accredition]
		, R.F_RegisterNum AS [WKFNumber]
		, RD.F_PrintLongName
		, RD.F_PrintShortName
		, RD.F_TvLongName
		, RD.F_TvShortName
		, RD.F_SBLongName
		, RD.F_SBShortName
		, RD.F_WNPA_LastName AS [WNPAFamilyName]
		, RD.F_WNPA_FirstName AS [WNPAFirstName]
		, R.F_RegTypeID

	INTO #Temp_Entry FROM TR_Register AS R
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex AS S
		ON R.F_SexCode = S.F_SexCode
	LEFT JOIN TC_Sex_Des AS SD
		ON R.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function_Des AS FD
		ON R.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Country_Des AS CD
		ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE R.F_RegTypeID IN (1, 5)
		AND R.F_DisciplineID = @DisciplineID
		AND (
				(@GroupType = 4 AND R.F_DelegationID IS NOT NULL
					AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID))
				OR
				(@GroupType = 2 AND R.F_NOC IS NOT NULL
					AND (@NOCID = '-1 ' OR @NOCID = '   ' OR R.F_NOC = @NOCID))
			)

	ALTER TABLE #Temp_Entry ADD DoubleRegisterID		INT NULL
	ALTER TABLE #Temp_Entry ADD PartnerRegisterID		INT NULL
	ALTER TABLE #Temp_Entry ADD DoublePartner			NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Handedness				NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Event_Single			NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Event_Double			NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Event_MixedDouble		NVARCHAR(100) NULL


	UPDATE A SET A.DoubleRegisterID = B.F_RegisterID FROM #Temp_Entry AS A LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_MemberRegisterID 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TR_Register AS D ON B.F_RegisterID = D.F_RegisterID WHERE C.F_SexCode = D.F_SexCode AND D.F_RegTypeID = 2
	
	UPDATE A SET A.PartnerRegisterID = B.F_MemberRegisterID FROM #Temp_Entry AS A LEFT JOIN TR_Register_Member AS B ON A.DoubleRegisterID = B.F_RegisterID AND A.F_RegisterID != B.F_MemberRegisterID 
	
	UPDATE A SET A.DoublePartner = B.F_PrintLongName FROM #Temp_Entry AS A LEFT JOIN TR_Register_Des AS B ON A.PartnerRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	
	UPDATE A SET A.Event_Single = (CASE C.F_EventCode WHEN '001' THEN 'S' WHEN '101' THEN 'S' ELSE '' END ) FROM #Temp_Entry AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
	
	UPDATE A SET A.Event_Double = (CASE C.F_EventCode WHEN '002' THEN 'D' WHEN '102' THEN 'D' ELSE '' END ) FROM #Temp_Entry AS A LEFT JOIN TR_Inscription AS B ON A.DoubleRegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
	
	UPDATE A SET A.Event_MixedDouble = (CASE C.F_EventCode WHEN '201' THEN 'XD' ELSE '' END ) FROM #Temp_Entry AS A LEFT JOIN TR_Inscription AS B ON A.DoubleRegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID

	UPDATE A SET A.Handedness = B.F_Comment FROM #Temp_Entry AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_Title = 'Handedness'
	
	SELECT * FROM #Temp_Entry

SET NOCOUNT OFF
END


GO


