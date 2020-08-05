IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetNumberOfEntriesByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetNumberOfEntriesByNOC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_WL_GetNumberOfEntriesByNOC]
--描    述：得到Discipline下得NumberOfEntriesByNOC列表
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2010年10月22日


CREATE PROCEDURE [dbo].[Proc_Report_WL_GetNumberOfEntriesByNOC](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 


	DECLARE @EventID				INT
	DECLARE @SexCode				INT
	DECLARE @EventCode				NVARCHAR(30)
	DECLARE @DelegationID			INT
	DECLARE @NOC					NVARCHAR(20)

	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	DECLARE @GroupType				INT
	DECLARE @GroupTypeField			NVARCHAR(50)
	DECLARE @GroupTypeFieldValue	NVARCHAR(20)
	DECLARE @M56		            INT
	DECLARE @M62		            INT
	DECLARE @M69		            INT
	DECLARE @M77		            INT
	DECLARE @M85		            INT
	DECLARE @M94		            INT
	DECLARE @M105		            INT
	DECLARE @MM105		            INT	
	DECLARE @MT		                INT
	DECLARE @W48		            INT
	DECLARE @W53		            INT
	DECLARE @W58		            INT
	DECLARE @W63		            INT	
	DECLARE @W69		            INT	
	DECLARE @W75		            INT	
	DECLARE @WM75		            INT	
	DECLARE @WT		                INT
	DECLARE @Total		            INT
	
	DECLARE @SQL					NVARCHAR(max)

	CREATE TABLE #Tmp_Register( [F_RegisterID] INT)

	CREATE TABLE #Tmp_Table(
    [F_DelegationID] INT,
 	[F_NOC]			 NVARCHAR(20) collate database_default,
	[NOC]            NVARCHAR(100),
	[M56]		     NVARCHAR(10),
	[M62]		     NVARCHAR(10),
	[M69]		     NVARCHAR(10),
	[M77]		     NVARCHAR(10),
	[M85]		     NVARCHAR(10),
	[M94]		     NVARCHAR(10),
	[M105]		     NVARCHAR(10),
	[MM105]		     NVARCHAR(10),	
	[MT]		     NVARCHAR(10),
	[W48]		     NVARCHAR(10),
	[W53]		     NVARCHAR(10),
	[W58]		     NVARCHAR(10),
	[W63]		     NVARCHAR(10),	
	[W69]		     NVARCHAR(10),	
	[W75]		     NVARCHAR(10),	
	[WM75]		     NVARCHAR(10),	
	[WT]		     NVARCHAR(10),
	[Total]		     NVARCHAR(10)
							)
							
	-- 获取 GroupType: 目前只考虑 2 - NOC 和 4 - Delegation 这两种情况, 优先考虑 4 - Delegation.
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
	
	-- 添加 #Tmp_Table 基本信息, @GroupType 确定 NOC 来源
	IF @GroupType = 4
	BEGIN
		INSERT #Tmp_Table
		([F_DelegationID], [F_NOC], [NOC])
		(
			SELECT A.F_DelegationID
                , B.F_DelegationCode
				, B.F_DelegationCode + ' - ' + C.F_DelegationShortName
			FROM TS_ActiveDelegation AS A
			LEFT JOIN TC_Delegation AS B
				ON A.F_DelegationID = B.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS C
				ON A.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode
			WHERE A.F_DisciplineID = @DisciplineID
				AND B.F_DelegationType = N'N'
		)

		SET @GroupTypeField = N'F_DelegationID'
	END
	ELSE
	BEGIN
		INSERT #Tmp_Table
		([F_NOC], [NOC])
		(
			SELECT A.F_NOC, A.F_NOC + ' - ' + B.F_CountryLongName
			FROM TS_ActiveNOC AS A
			LEFT JOIN TC_Country_Des AS B
				ON A.F_NOC = B.F_NOC AND B.F_LanguageCode = @LanguageCode
			WHERE A.F_DisciplineID = @DisciplineID
		)

		SET @GroupTypeField = N'F_NOC'
	END
	
	
	DECLARE NOCCursor CURSOR			-- 声明游标 NOCCursor, 用于遍历每个 NOC
	FOR SELECT F_DelegationID, F_NOC FROM #Tmp_Table
	OPEN NOCCursor
		
	-- 遍历 NOC
	WHILE 1 = 1
	BEGIN
	FETCH NEXT FROM NOCCursor INTO @DelegationID, @NOC
	IF @@FETCH_STATUS <> 0 BREAK
		-- 获取该小项的 NOC 报名人数
		IF @GroupType = 4
			BEGIN
				SELECT @M56 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '001' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M62 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '002' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M69 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '003' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M77 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '004' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M85 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '005' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M94 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '006' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M105 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '007' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @MM105 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '008' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @W48 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '101' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W53 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '102' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W58 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '103' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W63 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '104' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W69 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '105' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W75 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '106' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @WM75 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventCode = '107' AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 2
			
				SET @GroupTypeFieldValue = CAST(@DelegationID AS NVARCHAR(20))
			END
		ELSE
			BEGIN
				SELECT @M56 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '001' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M62 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '002' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M69 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '003' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M77 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '004' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M85 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '005' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M94 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '006' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @M105 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '007' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @MM105 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '008' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1

				SELECT @W48 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '101' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W53 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '102' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W58 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '103' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W63 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '104' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W69 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '105' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @W75 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '106' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SELECT @WM75 = COUNT(R.F_RegisterID) FROM TS_Event AS E 
				LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
				LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
				WHERE E.F_EventCode = '107' AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 2

				SET @GroupTypeFieldValue = @NOC
			END

		SET @MT = @M56+@M62+@M69+@M77+@M85+@M94+@M105+@MM105	
		SET @WT = @W48+@W53+@W58+@W63+@W69+@W75+@WM75	
		SET @Total = @MT + @WT

		-- 更新该小项的 NOC 报名人数

		SET @SQL = '
		UPDATE #Tmp_Table SET ' + 
		'[M56] = ' + CAST(@M56 AS NVARCHAR(10)) + ',' + 
		'[M62] = ' + CAST(@M62 AS NVARCHAR(10)) + ',' + 
		'[M69] = ' + CAST(@M69 AS NVARCHAR(10)) + ',' + 
		'[M77] = ' + CAST(@M77 AS NVARCHAR(10)) + ',' + 
		'[M85] = ' + CAST(@M85 AS NVARCHAR(10)) + ',' + 
		'[M94] = ' + CAST(@M94 AS NVARCHAR(10)) + ',' + 
		'[M105] = ' + CAST(@M105 AS NVARCHAR(10)) + ',' + 
		'[MM105] = ' + CAST(@MM105 AS NVARCHAR(10)) + ',' + 
		'[MT] = ' + CAST(@MT AS NVARCHAR(10)) + ',' + 
		'[W48] = ' + CAST(@W48 AS NVARCHAR(10)) + ',' + 
		'[W53] = ' + CAST(@W53 AS NVARCHAR(10)) + ',' + 
		'[W58] = ' + CAST(@W58 AS NVARCHAR(10)) + ',' + 
		'[W63] = ' + CAST(@W63 AS NVARCHAR(10)) + ',' + 
		'[W69] = ' + CAST(@W69 AS NVARCHAR(10)) + ',' + 
		'[W75] = ' + CAST(@W75 AS NVARCHAR(10)) + ',' + 
		'[WM75] = ' + CAST(@WM75 AS NVARCHAR(10)) + ',' + 
		'[WT] = ' + CAST(@WT AS NVARCHAR(10)) + ',' + 
		'[Total] = ' + CAST(@Total AS NVARCHAR(10)) +  
		'
		WHERE ' + @GroupTypeField + ' = ''' + @GroupTypeFieldValue + '''
				'	
		EXEC (@SQL)
	END		-- 遍历 NOC 结束
		
	CLOSE NOCCursor
	DEALLOCATE NOCCursor


	SELECT * FROM #Tmp_Table WHERE [Total] != 0


Set NOCOUNT OFF
End	
GO
	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetNumberOfEntriesByNOC] 1, 'eng'
*/

