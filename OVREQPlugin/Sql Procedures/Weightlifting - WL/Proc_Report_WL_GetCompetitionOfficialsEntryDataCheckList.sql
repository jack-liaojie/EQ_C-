IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetCompetitionOfficialsEntryDataCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetCompetitionOfficialsEntryDataCheckList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Report_WL_GetCompetitionOfficialsEntryDataCheckList]
--��    ��: ���� C39 (Entry Data Checklist), ��ȡ��Ҫ��Ϣ.
--����˵��: 
--˵    ��: 
--�� �� ��: �ⶨ�P
--��    ��: 2010��11��28��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetCompetitionOfficialsEntryDataCheckList]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SET LANGUAGE ENGLISH
	DECLARE @SQL	NVARCHAR(4000)
	DECLARE @GroupType			INT
	
	-- ȷ�� @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- Ŀǰֻ���� 2 - NOC �� 4 - Delegation ���������, ���ȿ��� 4 - Delegation.
	-- �� @DelegationID �� @NOCID ��Чʱ, ��Ĭ�������л�ȡ GroupType
	SELECT @GroupType = SC.F_ConfigValue
	FROM TS_Sport_Config AS SC
	LEFT JOIN TS_Discipline AS D
		ON SC.F_SportID = D.F_SportID
	WHERE D.F_DisciplineID = @DisciplineID
		AND SC.F_ConfigType = 1 AND SC.F_ConfigName = N'GroupType'

	IF @GroupType <> 2
	BEGIN
		SET @GroupType = 4
	END

	-- NOC ��Դ�� Delegation
	IF @GroupType = 4
	BEGIN
		SET @SQL = '
			SELECT LTRIM(RTRIM(D.F_DelegationCode)) AS [NOC]
				, DD.F_DelegationLongName AS [NOCLongName]
			'
	END
	-- NOC ��Դ�� Country
	ELSE
	BEGIN
		SET @SQL = '
			SELECT R.F_NOC AS [NOC]
				, CD.F_CountryLongName AS [NOCLongName]
			'
	END

	SET @SQL = @SQL + '
			, R.F_RegisterID AS [Reference]
			, CASE R.F_RegTypeID
				WHEN 1 THEN case when ''' + @LanguageCode + ''' = ''CHN'' then ''�˶�Ա'' else ''Athlete'' end
				ELSE FD.F_FunctionLongName
			END [Function]
			, RD.F_LastName AS [FamilyName]
			, RD.F_FirstName AS [GivenName]
			, S.F_GenderCode AS [Gender]
			, dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1, ''ENG'' ) AS [BirthDate]
			, LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + '' / '' 
			  + CONVERT(NVARCHAR(20), CONVERT(INT, R.F_Height * 100 / 3048)) + ''''''''
			  + CONVERT(NVARCHAR(20), CONVERT(INT, R.F_Height * 100 / 254) % 12) + ''"'' AS [Height]
		    , CONVERT(NVARCHAR(30), CONVERT(INT, ROUND(R.F_Weight, 0))) + '' / '' 
			  + CONVERT(NVARCHAR(50), CONVERT(INT, ROUND(R.F_Weight * 22 / 10, 0))) AS [Weight]
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
		FROM TR_Register AS R
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Sex AS S
			ON R.F_SexCode = S.F_SexCode
		LEFT JOIN TD_Function_Des AS FD
			ON R.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Country_Des AS CD
			ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = ''' + @LanguageCode + '''
		WHERE R.F_RegTypeID = 4
			AND R.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10)) + '
	'

	-- NOC ��Դ�� Delegation
	IF @GroupType = 4
	BEGIN
		SET @SQL = @SQL + '
			AND R.F_DelegationID IS NOT NULL
		'
	END
	-- NOC ��Դ�� Country
	ELSE
	BEGIN
		SET @SQL = @SQL + '
			AND R.F_NOC IS NOT NULL
		'
	END

	--SELECT @SQL

	EXEC (@SQL)

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

EXEC [Proc_Report_WL_GetCompetitionOfficialsEntryDataCheckList] 61, 'ENG'
EXEC [Proc_Report_WL_GetCompetitionOfficialsEntryDataCheckList] 61, -1, 'AUS', 'ENG'

*/