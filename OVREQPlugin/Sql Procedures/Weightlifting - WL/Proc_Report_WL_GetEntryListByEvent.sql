IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetEntryListByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetEntryListByEvent]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Report_WL_GetEntryListByEvent]
--描    述: 获取 Entry List By Event 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月22日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetEntryListByEvent]
	@DisciplineID				INT,
	@EventID					INT,		-- EventID <= 0 时打印所有小项
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


    --最终输出信息
	SET @AllSQL = '
		SET LANGUAGE N''English''
		SELECT DISTINCT UT.F_RegisterID
		,UT.F_EventID AS [EventID]
		,ED.F_EventLongName AS [Event]
		,E.F_Order AS [EventOrder]
	'

	-- NOC 来源于 Delegation
	IF @GroupType = 4
	BEGIN
		SET @AllSQL = @AllSQL + '
				, D.F_DelegationCode AS [NOC]
				, DD.F_DelegationLongName AS [NOCLongName]
	            , (row_number() over (PARTITION BY UT.F_EventID order by  RIGHT(''000''+ CONVERT(NVARCHAR(10),ISNULL(I.F_InscriptionResult,''999'')),3) desc, I.F_Seed)) AS [No]
			'
	END
	-- NOC 来源于 Country
	ELSE
	BEGIN
		SET @AllSQL = @AllSQL + '
				, R.F_NOC AS [NOC]
				, CD.F_CountryLongName AS [NOCLongName]
	            , (row_number() over (PARTITION BY UT.F_EventID order by RIGHT(''000''+ CONVERT(NVARCHAR(10),ISNULL(I.F_InscriptionResult,''999'')),3) desc, I.F_Seed)) AS [No]
		'
	END

	SET @AllSQL = @AllSQL + '
			, MRD.F_PrintLongName AS [Name]
			, dbo.Fun_WL_GetDateTime(MR.F_Birth_Date,1, ''ENG'' ) AS [BirthDate]
            , I.F_InscriptionResult AS [EntryTotal]
            , I.F_Seed AS [LotNumber]
            , RIGHT(''000''+ CONVERT(NVARCHAR(10),ISNULL(I.F_InscriptionResult,''999'')),3)
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
            ON UT.F_RegisterID = I.F_RegisterID AND UT.F_EventID = I.F_EventID
        LEFT JOIN TS_Event_Des AS ED 
            ON UT.F_EventID = ED.F_EventID  AND ED.F_LanguageCode = ''' + @LanguageCode + '''
        LEFT JOIN TS_Event AS E 
            ON UT.F_EventID = E.F_EventID 
            
        ORDER BY  RIGHT(''000''+ CONVERT(NVARCHAR(10),ISNULL(I.F_InscriptionResult,''999'')),3) DESC, I.F_Seed
	'
	
	EXEC (@ALLSQL) 

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

EXEC [Proc_Report_WL_GetEntryListByEvent] 59, 109, 'CHN'
EXEC [Proc_Report_WL_GetEntryListByEvent] 59, 109, 'ENG'
EXEC [Proc_Report_WL_GetEntryListByEvent] 67, 1, 'ENG'
EXEC [Proc_Report_WL_GetEntryListByEvent] 59, -1, 'CHN'
EXEC [Proc_Report_WL_GetEntryListByEvent] 1, 1, 'ENG'

*/