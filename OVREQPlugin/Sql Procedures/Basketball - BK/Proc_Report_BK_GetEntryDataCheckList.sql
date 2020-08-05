IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEntryDataCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetEntryDataCheckList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Report_BK_GetEntryDataCheckList]
--��    ��: ���� C38 (Entry Data Checklist), ��ȡ��Ҫ��Ϣ.
--����˵��: 
--˵    ��: 
--�� �� ��: 
--��    ��: 
--�޸ļ�¼��
--�޸ļ�¼�� 
/*			
			ʱ��				�޸���		�޸�����	
			2012��9��20��       �ⶨ�P      Ϊ��������˶���ı���Ҫ�󣬼���һЩ����б��ֶΡ�
*/



CREATE PROCEDURE [dbo].[Proc_Report_BK_GetEntryDataCheckList]
	@DisciplineID				INT,
	@DelegationID				INT,
	@NOCID						CHAR(3),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL	NVARCHAR(4000)
	DECLARE @GroupType			INT
	
	-- ȷ�� @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- Ŀǰֻ���� 2 - NOC �� 4 - Delegation ���������, ���ȿ��� 4 - Delegation.
	IF @DelegationID > 0
	BEGIN
		SET @GroupType = 4
	END
	ELSE IF @NOCID <> '-1 ' AND @NOCID <> '   '
	BEGIN
		SET @GroupType = 2
	END
	-- �� @DelegationID �� @NOCID ��Чʱ, ��Ĭ�������л�ȡ GroupType
	ELSE
	BEGIN
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
	END
	
	CREATE TABLE #Tmp_Table(
    [NOC]          NVARCHAR(10),
    [NOCOrder]     INT,
    [NOCLongName]  NVARCHAR(100),
    [Reference]    NVARCHAR(50),
    [Function]     NVARCHAR(50),
    [FamilyName]   NVARCHAR(50),
    [GivenName]    NVARCHAR(50),
    [Gender]       NVARCHAR(10),
    [BirthDate]    NVARCHAR(50),
    [Height]       NVARCHAR(50),
    [Weight]      NVARCHAR(50),
    [Accredition]      NVARCHAR(50),
    [ICFNumber]      NVARCHAR(50),
    [F_PrintLongName]      NVARCHAR(100),
    [F_PrintShortName]      NVARCHAR(100),
    [F_TvLongName]      NVARCHAR(50),
    [F_TvShortName]      NVARCHAR(50),
    [F_SBLongName]      NVARCHAR(50),
    [F_SBShortName]      NVARCHAR(50),
    [WNPAFamilyName]      NVARCHAR(50),
    [WNPAFirstName]      NVARCHAR(50),
    [F_RegTypeID]      NVARCHAR(50)
	)
	
    --���������Ϣ
	SET @SQL = 'INSERT INTO #Tmp_Table([NOC],[NOCOrder],[NOCLongName],[Reference],[Function],
	[FamilyName],[GivenName],[Gender],[BirthDate],[Height],[Weight],[Accredition],[ICFNumber],
	[F_PrintLongName],[F_PrintShortName],[F_TvLongName],[F_TvShortName],[F_SBLongName],[F_SBShortName],
	[WNPAFamilyName],[WNPAFirstName],[F_RegTypeID])
	           ('

	-- NOC ��Դ�� Delegation
	IF @GroupType = 4
	BEGIN
	    SET @SQL = @SQL + '
			SELECT LTRIM(RTRIM(D.F_DelegationCode)) AS [NOC]
			    , NULL AS [NOCOrder]
				, DD.F_DelegationLongName AS [NOCLongName]
			'
	END
	-- NOC ��Դ�� Country
	ELSE
	BEGIN
		SET @SQL = @SQL + '
			SELECT R.F_NOC AS [NOC]
			    , NULL AS [NOCOrder]
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
			, CONVERT(NVARCHAR(20), R.F_Birth_Date, 106) AS [BirthDate]
		    , LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + '' / '' 
			  + CONVERT(NVARCHAR(2), CONVERT(INT, R.F_Height * 100 / 3048)) + ''''''''
			  + CONVERT(NVARCHAR(2), CONVERT(INT, R.F_Height * 100 / 254) % 12) + ''"'' AS [Height]
		    , CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + '' / '' 
			  + CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight * 22 / 10, 0))) AS [Weight]
			, R.F_RegisterCode AS [Accredition]
			, R.F_RegisterNum AS [ICFNumber]
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
		WHERE R.F_RegTypeID IN (1, 5)
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

	-- �� @DelegationID ��Чʱ, ��� @DelegationID �������
	IF @DelegationID > 0
	BEGIN
		SET @SQL = @SQL + '
			AND R.F_DelegationID = ' + CAST(@DelegationID AS NVARCHAR(10)) + '
		'
	END
	-- �� @NOCID ��Чʱ, ��� @NOCID �������
	ELSE IF @NOCID <> '-1 ' AND @NOCID <> '   '
	BEGIN
		SET @SQL = @SQL + '
			AND R.F_NOC = ''' + @NOCID + '''
		'
	END
	SET @SQL = @SQL + ')'

	EXEC (@SQL)

    SELECT * FROM #Tmp_Table Order By NOCOrder

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

EXEC [Proc_Report_BK_GetEntryDataCheckList] 67, -1, '-1', 'ENG'
EXEC [Proc_Report_BK_GetEntryDataCheckList] 67, -1, 'CHN', 'ENG'

*/