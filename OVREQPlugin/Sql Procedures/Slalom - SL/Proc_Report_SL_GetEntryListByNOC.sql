IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetEntryListByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetEntryListByNOC]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Report_SL_GetEntryListByNOC]
--��    ��: ��ȡ Entry List By NOC ����Ҫ��Ϣ��Ϣ, ��Ҫ���ڱ���
--����˵��: 
--˵    ��: 
--�� �� ��: �ⶨ�P
--��    ��: 2010��01��22��
--�޸ļ�¼��




CREATE PROCEDURE [dbo].[Proc_Report_SL_GetEntryListByNOC]
	@DisciplineID				INT,
	@DelegationID				INT,
	@NOCID					CHAR(3),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL				NVARCHAR(4000)		-- ȫ�� SQL
	DECLARE @IndSQL				NVARCHAR(1000)		-- ��������Ŀ���˶�Ա
	DECLARE @TeamSQL			NVARCHAR(1000)		-- ��������Ŀ���˶�Ա
	DECLARE @IndRegIDSQL		NVARCHAR(1000)		-- ��ȡ���б�������Ŀ���˶�Ա�� RegisterID
	DECLARE @TeamRegIDSQL		NVARCHAR(1000)		-- ��ȡ���б�������Ŀ���˶�Ա�� RegisterID 
	DECLARE @NoSQL				NVARCHAR(2000)		-- û�б�����˶�Ա

	DECLARE @GroupType			INT
	DECLARE @DisciplineID_Str	NVARCHAR(10)
	DECLARE @DelegationID_Str	NVARCHAR(10)

	SET @DisciplineID_Str = CAST(@DisciplineID AS NVARCHAR(10))
	SET @DelegationID_Str = CAST(@DelegationID AS NVARCHAR(10))

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
		SELECT @GroupType = A.F_ConfigValue
		FROM TS_Sport_Config AS A
		LEFT JOIN TS_Discipline AS B
			ON A.F_SportID = B.F_SportID
		WHERE B.F_DisciplineID = @DisciplineID
			AND A.F_ConfigType = 1 AND A.F_ConfigName = N'GroupType'

		IF @GroupType <> 2
		BEGIN
			SET @GroupType = 4
		END
	END

	-- ��������Ŀ���˶�Ա
	SET @IndSQL = '
		SELECT R.F_RegisterID
			, E.F_EventID
			, 1 AS Inscription
		FROM TR_Inscription AS I
		LEFT JOIN TR_Register AS R
			ON I.F_RegisterID = R.F_RegisterID
		LEFT JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		WHERE E.F_PlayerRegTypeID = 1 
			AND E.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_RegTypeID = 1
	'

	-- ��˫�˻�������Ŀ���˶�Ա
	SET @TeamSQL = '
		SELECT  R.F_RegisterID
			, E.F_EventID
			, 1 AS Inscription
		FROM TR_Register_Member RM
		LEFT JOIN TR_Inscription I
			ON RM.F_RegisterID = I.F_RegisterID
		LEFT JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		LEFT JOIN TR_Register AS R
			ON RM.F_MemberRegisterID = R.F_RegisterID
		WHERE E.F_PlayerRegTypeID = 2 or E.F_PlayerRegTypeID = 3
			AND E.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_RegTypeID = 1
	'

	-- ���б�������Ŀ���˶�Ա�� RegisterID
	SET @IndRegIDSQL = '
		SELECT R.F_RegisterID
		FROM TR_Inscription AS I
		LEFT JOIN TR_Register AS R
			ON I.F_RegisterID = R.F_RegisterID
		LEFT JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		WHERE E.F_PlayerRegTypeID = 1 
			AND E.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_RegTypeID = 1
	'

	-- ���б�������Ŀ���˶�Ա�� RegisterID
	SET @TeamRegIDSQL = '
		SELECT R.F_RegisterID
		FROM TR_Register_Member RM
		LEFT JOIN TR_Inscription I
			ON RM.F_RegisterID = I.F_RegisterID
		LEFT JOIN TS_Event E
			ON I.F_EventID = E.F_EventID
		LEFT JOIN TR_Register AS R
			ON RM.F_MemberRegisterID = R.F_RegisterID
		WHERE E.F_PlayerRegTypeID = 3
			AND E.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_RegTypeID = 1
	'

	-- �� @DelegationID ��Чʱ, ��� @DelegationID �������
	IF @DelegationID > 0
	BEGIN
		SET @IndSQL = @IndSQL + ' AND R.F_DelegationID = ''' + @DelegationID_Str + '''' 
		SET @TeamSQL = @TeamSQL + ' AND R.F_DelegationID = ''' + @DelegationID_Str  + ''''
		SET @IndRegIDSQL = @IndRegIDSQL + ' AND R.F_DelegationID = ''' + @DelegationID_Str + ''''
		SET @TeamRegIDSQL = @TeamRegIDSQL + ' AND R.F_DelegationID = ''' + @DelegationID_Str + ''''
	END
	-- �� @NOCID ��Чʱ, ��� @NOCID �������
	ELSE IF @NOCID <> '-1 ' AND @NOCID <> '   '
	BEGIN
		SET @IndSQL = @IndSQL + ' AND R.F_NOC = ''' + @NOCID + '''' 
		SET @TeamSQL = @TeamSQL + ' AND R.F_NOC = ''' + @NOCID  + ''''
		SET @IndRegIDSQL = @IndRegIDSQL + ' AND R.F_NOC = ''' + @NOCID + ''''
		SET @TeamRegIDSQL = @TeamRegIDSQL + ' AND R.F_NOC = ''' + @NOCID + ''''
	END

	-- û�б�����˶�Ա
	SET @NoSQL = '
		SELECT R.F_RegisterID
			, -1 AS F_EventID
			, 0 AS Inscription
		FROM TR_Register AS R
		WHERE R.F_RegTypeID = 1
			AND R.F_DisciplineID = ' + @DisciplineID_Str + '
			AND R.F_RegisterID NOT IN
				(
		' + @IndRegIDSQL + '
					UNION
		' + @TeamRegIDSQL + '
				)
	'

	IF @DelegationID > 0
	BEGIN
		SET @NoSQL = @NoSQL + '
			AND R.F_DelegationID = ''' + @DelegationID_Str + '''
		'
	END
	ELSE IF @NOCID <> '-1 ' AND @NOCID <> '   '
	BEGIN
		SET @NoSQL = @NoSQL + '
			AND R.F_NOC = ''' + @NOCID + '''
		'
	END
    
	CREATE TABLE #Tmp_Table(
	[Inscription]  NVARCHAR(50),
    [Gender]       NVARCHAR(10),
    [NOC]          NVARCHAR(10),
    [NOCOrder]     INT,
    [NOCLongName]  NVARCHAR(50),
    [Name]         NVARCHAR(100),
    [Bib]          NVARCHAR(10),
    [GenderCode]   NVARCHAR(10),
    [EventCode]    NVARCHAR(10),
    [EventName]    NVARCHAR(50),
    [ICFNumber]    NVARCHAR(50),
    [BirthDate]    NVARCHAR(50),
    [Height]       NVARCHAR(50),
    [Weight]      NVARCHAR(50)
	)
    

    --���������Ϣ
	SET @SQL = ' INSERT INTO #Tmp_Table([Inscription],[Gender],[NOC],[NOCOrder],[NOCLongName],
	[Name],[Bib],[GenderCode],[EventCode],[EventName],[ICFNumber],[BirthDate],[Height],[Weight])
		(SELECT UT.Inscription
			, UPPER(SD.F_SexLongName) AS [Gender]
		'
	
	-- NOC ��Դ�� Delegation
	IF @GroupType = 4
	BEGIN
		SET @SQL = @SQL + '
				, D.F_DelegationCode AS [NOC]
				, D.F_Order AS [NOCOrder]
				, DD.F_DelegationLongName AS [NOCLongName]
			'
	END
	-- NOC ��Դ�� Country
	ELSE
	BEGIN
		SET @SQL = @SQL + '
				, R.F_NOC AS [NOC]
				, NULL AS [NOCOrder]
				, CD.F_CountryLongName AS [NOCLongName]
			'
	END

	SET @SQL = @SQL + '
			, RD.F_PrintLongName AS [Name]
			, cast((case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '''' then I.F_InscriptionNum else R.F_Bib end) as int) AS [Bib]
			, S.F_GenderCode AS [GenderCode]
			, E.F_EventCode AS [EventCode]
			, ED.F_EventComment AS [EventName]
            , R.F_RegisterNum AS [ICFNumber]
			, UPPER(LEFT(CONVERT (NVARCHAR(100), R.F_Birth_Date, 113), 11)) AS [BirthDate]
		    , LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + '' / '' 
			  + CONVERT(NVARCHAR(2), CONVERT(INT, R.F_Height * 100 / 3048)) + ''''''''
			  + CONVERT(NVARCHAR(2), CONVERT(INT, R.F_Height * 100 / 254) % 12) + ''"'' AS [Height]
		    , CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + '' / '' 
			  + CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight * 22 / 10, 0))) AS [Weight]
		FROM
		(
		' + @IndSQL + '
			UNION 
		' + @TeamSQL + '
			UNION
		' + @NoSQL + '
		) AS UT
		LEFT JOIN TR_Register AS R
			ON UT.F_RegisterID = R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON UT.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Event AS E
			ON UT.F_EventID = E.F_EventID
		LEFT JOIN TS_Event_Des AS ED
			ON UT.F_EventID = ED.F_EventID AND ED.F_LanguageCode = ''eng''
		LEFT JOIN TC_Country_Des AS CD
			ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Sex AS S
			ON R.F_SexCode = S.F_SexCode
		LEFT JOIN TC_Sex_Des AS SD
			ON R.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = ''' + @LanguageCode + '''
        LEFT JOIN TR_Inscription AS I 
            ON UT.F_RegisterID = I.F_RegisterID AND UT.F_EventID = I.F_EventID 			
		WHERE E.F_EventCode IS NOT NULL AND E.F_EventCode <> ''000'')
	'
	
	EXEC (@SQL)

    SELECT * FROM #Tmp_Table Order by NOCOrder
    
SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

EXEC [Proc_Report_SL_GetEntryListByNOC] 67, -1, -1, 'ENG'
EXEC [Proc_Report_SL_GetEntryListByNOC] 67, -1, 'CHN', 'ENG'

*/