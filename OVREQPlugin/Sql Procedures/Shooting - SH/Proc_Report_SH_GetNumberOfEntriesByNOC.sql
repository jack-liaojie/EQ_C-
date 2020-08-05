IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetNumberOfEntriesByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetNumberOfEntriesByNOC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_SH_GetNumberOfEntriesByNOC]
--描    述：得到Discipline下得NumberOfEntriesByNOC列表


CREATE PROCEDURE [dbo].[Proc_Report_SH_GetNumberOfEntriesByNOC](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 


	DECLARE @EventID				INT
	DECLARE @SexCode				INT
	DECLARE @EventCode				NVARCHAR(100)
	DECLARE @DelegationID			INT
	DECLARE @NOC					NVARCHAR(100)

	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	DECLARE @GroupType				INT
	DECLARE @GroupTypeField			NVARCHAR(100)
	DECLARE @GroupTypeFieldValue	NVARCHAR(100)
	DECLARE @MP						INT
	DECLARE @MR						INT
	DECLARE @WP						INT
	DECLARE @WR						INT
	DECLARE @Total		            INT
	
	DECLARE @SQL					NVARCHAR(max)

	CREATE TABLE #Tmp_Register( [F_RegisterID] INT)

	CREATE TABLE #Tmp_Table(
    [F_DelegationID] INT,
 	[F_NOC]			 NVARCHAR(100) collate database_default,
	[NOC]            NVARCHAR(100),
    [MP]            NVARCHAR(100),
    [MR]            NVARCHAR(100),
    [WP]            NVARCHAR(100),
    [WR]            NVARCHAR(100),
    [Total]          NVARCHAR(100),
							)

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

	
	DECLARE NOCCursor CURSOR			-- 声明游标 NOCCursor, 用于遍历每个 NOC
	FOR SELECT F_DelegationID, F_NOC FROM #Tmp_Table
	OPEN NOCCursor
		
	FETCH NEXT FROM NOCCursor INTO @DelegationID, @NOC
	WHILE @@FETCH_STATUS = 0
			
	-- 获取该小项的 NOC 报名人数

	BEGIN
		SELECT @MP = COUNT(R.F_RegisterID)
		FROM TS_Event AS E 
		LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
		LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
		WHERE E.F_EventCode IN('001','005','007','009')
		AND R.F_DelegationID = @DelegationID
		AND R.F_RegTypeID = 1
		AND R.F_SexCode = 1

		SELECT @MR = COUNT(C.F_RegisterID)
		FROM TS_Event AS A 
		LEFT JOIN TR_Inscription AS B ON A.F_EventID = B.F_EventID
		LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
		WHERE A.F_EventCode IN('003','011','013')
		AND C.F_DelegationID = @DelegationID
		AND C.F_RegTypeID = 1
		AND C.F_SexCode = 1

		SELECT @WP = COUNT(C.F_RegisterID)
		FROM TS_Event AS A 
		LEFT JOIN TR_Inscription AS B ON A.F_EventID = B.F_EventID
		LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
		WHERE A.F_EventCode IN('101','105')
		AND C.F_DelegationID = @DelegationID
		AND C.F_RegTypeID = 1
		AND C.F_SexCode = 2


		SELECT @WR = COUNT(C.F_RegisterID)
		FROM TS_Event AS A 
		LEFT JOIN TR_Inscription AS B ON A.F_EventID = B.F_EventID
		LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
		WHERE A.F_EventCode IN('103','107','109')
		AND C.F_DelegationID = @DelegationID
		AND C.F_RegTypeID = 1
		AND C.F_SexCode = 2

		SET @GroupTypeField = '[F_DelegationID]'	
		SET @GroupTypeFieldValue = CAST(@DelegationID AS NVARCHAR(100))
		SET @Total = @MP + @MR + @WP + @WR 

		-- 更新该小项的 NOC 报名人数

		SET @SQL = '
		UPDATE #Tmp_Table SET ' + 
		'[MP] = ' + CAST(@MP AS NVARCHAR(50)) + ',' + 
		'[MR] = ' + CAST(@MR AS NVARCHAR(50)) + ',' + 
		'[WP] = ' + CAST(@WP AS NVARCHAR(50)) + ',' + 
		'[WR] = ' + CAST(@WR AS NVARCHAR(50)) + ',' + 	
		'[Total] = ' + CAST(@Total AS NVARCHAR(50)) +  
		'
		WHERE ' + @GroupTypeField + ' = ''' + @GroupTypeFieldValue + '''
				'	
		EXEC (@SQL)		
		
		FETCH NEXT FROM NOCCursor INTO @DelegationID, @NOC
	END
	
		
	CLOSE NOCCursor
	DEALLOCATE NOCCursor


	SELECT * FROM #Tmp_Table


Set NOCOUNT OFF
End	
GO
	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SH_GetNumberOfEntriesByNOC] 1, 'eng'

*/

