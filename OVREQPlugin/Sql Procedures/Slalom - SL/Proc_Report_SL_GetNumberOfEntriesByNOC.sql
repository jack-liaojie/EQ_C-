IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetNumberOfEntriesByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetNumberOfEntriesByNOC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----��    �ƣ�[Proc_Report_SL_GetNumberOfEntriesByNOC]
----��    �����õ�Discipline�µ�NumberOfEntriesByNOC�б�
----����˵���� 
----˵    ����
----�� �� �ˣ��ⶨ�P
----��    �ڣ�2010��01��22��
/*			
			ʱ��				�޸���		�޸�����	
			2012��09��12��       �ⶨ�P      Ϊ��������˶���ı���Ҫ�����ݿ�ṹ�ֶη����仯����������
*/



CREATE PROCEDURE [dbo].[Proc_Report_SL_GetNumberOfEntriesByNOC](
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
	DECLARE @MBK1		            INT
	DECLARE @MBC1		            INT
	DECLARE @MBC2		            INT
	DECLARE @MCompetitors		    INT
	DECLARE @WBK1		            INT
	DECLARE @WCompetitors		    INT
	DECLARE @TB		                INT
	DECLARE @TCompetitors		    INT
	
	DECLARE @SQL					NVARCHAR(max)

	CREATE TABLE #Tmp_Register( [F_RegisterID] INT)

	CREATE TABLE #Tmp_Table(
    [F_DelegationID] INT,
 	[F_NOC]			 NVARCHAR(20) collate database_default,
	[NOC]            NVARCHAR(50),
    [MBK1]           NVARCHAR(50),
    [MBC1]           NVARCHAR(50),
    [MBC2]           NVARCHAR(50),
    [MCompetitors]   NVARCHAR(50),
    [WBK1]           NVARCHAR(50),
    [WCompetitors]   NVARCHAR(50),
    [TB]             NVARCHAR(50),
    [TCompetitors]   NVARCHAR(50),
							)
	-- ��ȡ GroupType: Ŀǰֻ���� 2 - NOC �� 4 - Delegation ���������, ���ȿ��� 4 - Delegation.
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
	
	-- ��� #Tmp_Table ������Ϣ, @GroupType ȷ�� NOC ��Դ
	IF @GroupType = 4
	BEGIN
		INSERT #Tmp_Table
		([F_DelegationID], [F_NOC], [NOC])
		(
			SELECT AD.F_DelegationID
                , D.F_DelegationCode
				, D.F_DelegationCode + ' - ' + DD.F_DelegationLongName
			FROM TS_ActiveDelegation AS AD
			LEFT JOIN TC_Delegation AS D
				ON AD.F_DelegationID = D.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS DD
				ON AD.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
			WHERE AD.F_DisciplineID = @DisciplineID
				AND D.F_DelegationType = N'N'
		)

		SET @GroupTypeField = N'F_DelegationID'
	END
	ELSE
	BEGIN
		INSERT #Tmp_Table
		([F_NOC], [NOC])
		(
			SELECT AN.F_NOC, AN.F_NOC + ' - ' + CD.F_CountryLongName
			FROM TS_ActiveNOC AS AN
			LEFT JOIN TC_Country_Des AS CD
				ON AN.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
			WHERE AN.F_DisciplineID = @DisciplineID
		)

		SET @GroupTypeField = N'F_NOC'
	END
	

	DECLARE NOCCursor CURSOR			-- �����α� NOCCursor, ���ڱ���ÿ�� NOC
	FOR SELECT F_DelegationID, F_NOC FROM #Tmp_Table
	OPEN NOCCursor
		
	-- ���� NOC
	WHILE 1 = 1
	BEGIN
	FETCH NEXT FROM NOCCursor INTO @DelegationID, @NOC
	IF @@FETCH_STATUS <> 0 BREAK
			
	-- ��ȡ��С��� NOC ��������
	IF @GroupType = 4
		BEGIN
			SELECT @MBK1 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			WHERE E.F_EventCode = 110
			AND R.F_DelegationID = @DelegationID
			AND R.F_RegTypeID = 1
			AND R.F_SexCode = 1

			SELECT @MBC1 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			WHERE E.F_EventCode = 210
			AND R.F_DelegationID = @DelegationID
			AND R.F_RegTypeID = 1
			AND R.F_SexCode = 1
	
			SELECT @MBC2 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			WHERE E.F_EventCode = 220
			AND R.F_DelegationID = @DelegationID
			AND R.F_RegTypeID = 2
			AND R.F_SexCode = 1
	
	        INSERT #Tmp_Register (F_RegisterID)(
			SELECT R.F_RegisterID FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			WHERE ( E.F_EventCode = 110 AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1 )
			OR (E.F_EventCode = 210 AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 1 AND R.F_SexCode = 1 ))
			
            INSERT #Tmp_Register (F_RegisterID)(
			SELECT RM.F_MemberRegisterID	FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Member AS RM ON R.F_RegisterID = RM.F_RegisterID
			WHERE E.F_EventCode = 220 AND R.F_DelegationID = @DelegationID AND R.F_RegTypeID = 2 AND R.F_SexCode = 1)
	
			SELECT @MCompetitors = COUNT(Distinct F_RegisterID) FROM #Tmp_Register
			DELETE #Tmp_Register
	
			SELECT @WBK1 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			WHERE E.F_EventCode = 110
			AND R.F_DelegationID = @DelegationID
			AND R.F_RegTypeID = 1
			AND R.F_SexCode = 2
		
			SET @GroupTypeFieldValue = CAST(@DelegationID AS NVARCHAR(20))
		END
	ELSE
		BEGIN
			SELECT @MBK1 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
			WHERE E.F_EventCode = 110
			AND R.F_NOC = @NOC
			AND R.F_RegTypeID = 1
			AND R.F_SexCode = 1

			SELECT @MBC1 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
			WHERE E.F_EventCode = 210
			AND R.F_NOC = @NOC
			AND R.F_RegTypeID = 1
			AND R.F_SexCode = 1

			SELECT @MBC2 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
			WHERE E.F_EventCode = 220
			AND R.F_NOC = @NOC
			AND R.F_RegTypeID = 2
			AND R.F_SexCode = 1

	        INSERT #Tmp_Register (F_RegisterID)(
	        SELECT R.F_RegisterID FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
			WHERE (E.F_EventCode = 110 AND R.F_NOC = @NOC AND R.F_RegTypeID = 1	AND R.F_SexCode = 1)
			OR (E.F_EventCode = 210	AND R.F_NOC = @NOC AND R.F_RegTypeID = 1 AND R.F_SexCode = 1))
	
            INSERT #Tmp_Register (F_RegisterID)(
			SELECT RM.F_MemberRegisterID	FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Member AS RM ON R.F_RegisterID = RM.F_RegisterID
			WHERE E.F_EventCode = 220 AND R.F_NOC = @NOC AND R.F_RegTypeID = 2 AND R.F_SexCode = 1)
			
			SELECT @MCompetitors = COUNT( Distinct F_RegisterID) FROM #Tmp_Register
			DELETE #Tmp_Register

			SELECT @WBK1 = COUNT(R.F_RegisterID)
			FROM TS_Event AS E 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID	
			LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID 
			WHERE E.F_EventCode = 110
			AND R.F_NOC = @NOC
			AND R.F_RegTypeID = 1
			AND R.F_SexCode = 2

			SET @GroupTypeFieldValue = @NOC
		END
	
    SET @WCompetitors = @WBK1
	SET @TB = @MBK1 + @MBC1 + @MBC2 + @WBK1
	SET @TCompetitors = @MCompetitors + @WCompetitors

	-- ���¸�С��� NOC ��������

	SET @SQL = '
	UPDATE #Tmp_Table SET ' + 
	'[MBK1] = ' + CAST(@MBK1 AS NVARCHAR(10)) + ',' + 
	'[MBC1] = ' + CAST(@MBC1 AS NVARCHAR(10)) + ',' + 
	'[MBC2] = ' + CAST(@MBC2 AS NVARCHAR(10)) + ',' + 
	'[MCompetitors] = ' + CAST(@MCompetitors AS NVARCHAR(10)) + ',' + 
	'[WBK1] = ' + CAST(@WBK1 AS NVARCHAR(10)) + ',' + 
	'[WCompetitors] = ' + CAST(@WCompetitors AS NVARCHAR(10)) + ',' + 
	'[TB] = ' + CAST(@TB AS NVARCHAR(10)) + ',' + 
	'[TCompetitors] = ' + CAST(@TCompetitors AS NVARCHAR(10)) +  
    '
	WHERE ' + @GroupTypeField + ' = ''' + @GroupTypeFieldValue + '''
			'	
	EXEC (@SQL)

	END		-- ���� NOC ����
		
	CLOSE NOCCursor
	DEALLOCATE NOCCursor


	SELECT * FROM #Tmp_Table Order by NOCOrder


Set NOCOUNT OFF
End	
GO
	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

EXEC [Proc_Report_SL_GetNumberOfEntriesByNOC] 67, 'ENG'
EXEC [Proc_Report_SL_GetNumberOfEntriesByNOC] 67, 'CHN'

*/

