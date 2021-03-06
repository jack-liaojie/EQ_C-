IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEntryListByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetEntryListByEvent]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Report_BK_GetEntryListByEvent]
--描    述: 获取 Entry List By Event 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月22日
--修改记录： 
/*			
			时间				修改人		修改内容	
			2012年9月20日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_BK_GetEntryListByEvent]
	@DisciplineID				INT,
	@EventID				INT,		-- EventID <= 0 时打印所有小项
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE	@IndSQL		NVARCHAR(1000)			-- 单人项目的 SQL
	DECLARE @DouSQL	    NVARCHAR(1000)			-- 双人项目的 SQL
	DECLARE @AllSQL		NVARCHAR(4000)			-- 所有项目的 SQL

	DECLARE @GroupType			INT

	-- 单人项目
	SET @IndSQL = '
		SELECT I.F_EventID
			, I.F_RegisterID
			, I.F_RegisterID AS F_MemberRegisterID
		FROM TR_Inscription AS I
		LEFT JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		LEFT JOIN TR_Register AS R
			ON I.F_RegisterID = R.F_RegisterID
		WHERE E.F_PlayerRegTypeID = 1 
			AND E.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10)) + '
			AND R.F_RegTypeID = 1
	'

	-- 双人项目
	SET @DouSQL = '
		SELECT I.F_EventID
			, I.F_RegisterID
			, RM.F_MemberRegisterID
		FROM TR_Inscription AS I
		LEFT JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		LEFT JOIN TR_Register_Member AS RM
			ON I.F_RegisterID = RM.F_RegisterID
		LEFT JOIN TR_Register AS R
			ON RM.F_MemberRegisterID = R.F_RegisterID
		WHERE E.F_PlayerRegTypeID = 2 
			AND E.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10)) + '
			AND R.F_RegTypeID = 1
	'

	IF @EventID >= 0
	BEGIN
		SET @IndSQL = @IndSQL + ' AND I.F_EventID = ' + CAST(@EventID AS NVARCHAR(10)) + ' '
		SET @DouSQL = @DouSQL + ' AND I.F_EventID = ' + CAST(@EventID AS NVARCHAR(10)) + ' '
	END

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

	CREATE TABLE #Tmp_Table(
	[EventID]      INT,
	[F_RegisterID] INT,
    [NOC]          NVARCHAR(10),
    [NOCOrder]     INT,
    [NOCLongName]  NVARCHAR(100),
    [Bib]          NVARCHAR(50),
    [Name]         NVARCHAR(100),
    [WorldRank]    NVARCHAR(50),
    [BirthDate]    NVARCHAR(50),
    [Height]       NVARCHAR(50),
    [Weight]      NVARCHAR(50)
	)

    --输出所有信息

	SET @AllSQL = ' INSERT INTO #Tmp_Table([EventID],[F_RegisterID],[NOC],[NOCOrder],[NOCLongName],
	[Bib],[Name],[WorldRank],[BirthDate],[Height],[Weight])
		(SELECT UT.F_EventID AS [EventID]
		, UT.F_RegisterID
	'

	-- NOC 来源于 Delegation
	IF @GroupType = 4
	BEGIN
		SET @AllSQL = @AllSQL + '
				, D.F_DelegationCode AS [NOC]
				, NULL AS [NOCOrder]
				, DD.F_DelegationLongName AS [NOCLongName]
			'
	END
	-- NOC 来源于 Country
	ELSE
	BEGIN
		SET @AllSQL = @AllSQL + '
				, R.F_NOC AS [NOC]
				, NULL AS [NOCOrder]
				, CD.F_CountryLongName AS [NOCLongName]
		'
	END

	SET @AllSQL = @AllSQL + '
			, cast((case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '''' then I.F_InscriptionNum else R.F_Bib end) as int) AS [Bib]
			, MRD.F_PrintLongName AS [Name]
            , I.F_InscriptionRank AS [WorldRank]
			, UPPER(LEFT(CONVERT (NVARCHAR(100), MR.F_Birth_Date, 113), 11)) AS [BirthDate]
		    , LEFT(CONVERT(INT, ROUND(MR.F_Height, 0)) / 100.0, 4) + '' / '' 
			  + CONVERT(NVARCHAR(2), CONVERT(INT, MR.F_Height * 100 / 3048)) + ''''''''
			  + CONVERT(NVARCHAR(2), CONVERT(INT, MR.F_Height * 100 / 254) % 12) + ''"'' AS [Height]
		    , CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(MR.F_Weight, 0))) + '' / '' 
			  + CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(MR.F_Weight * 22 / 10, 0))) AS [Weight]
		FROM 
		(
		' + @IndSQL + '
			UNION
		' + @DouSQL + '
		) AS UT
		LEFT JOIN TR_Register AS R
			ON UT.F_RegisterID = R.F_RegisterID
		LEFT JOIN TC_Country_Des AS CD
			ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TR_Register AS MR	
			ON UT.F_MemberRegisterID = MR.F_RegisterID
		LEFT JOIN TR_Register_Des AS MRD
			ON UT.F_MemberRegisterID = MRD.F_RegisterID AND MRD.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = ''' + @LanguageCode + '''
        LEFT JOIN TR_Inscription AS I 
            ON UT.F_RegisterID = I.F_RegisterID AND UT.F_EventID = I.F_EventID)
	'
	
	EXEC (@ALLSQL)

    SELECT * FROM #Tmp_Table Order By NOCOrder
    
SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

EXEC [Proc_Report_BK_GetEntryListByEvent] 59, 109, 'CHN'
EXEC [Proc_Report_BK_GetEntryListByEvent] 59, 109, 'ENG'
EXEC [Proc_Report_BK_GetEntryListByEvent] 59, 115, 'ENG'
EXEC [Proc_Report_BK_GetEntryListByEvent] 67, -1, 'CHN'
EXEC [Proc_Report_BK_GetEntryListByEvent] 67, -1, 'ENG'

*/