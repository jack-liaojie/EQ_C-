IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetNumberOfEntries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetNumberOfEntries]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetNumberOfEntries]
--描    述: 摔跤项目报表 C30 (Number of Entries by NOC) 获取详细信息
--创 建 人: 宁顺泽
--日    期: 2011年10月17日 星期1
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetNumberOfEntries]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @EventID				INT
	DECLARE @EventCode				NVARCHAR(30)
	DECLARE @RegTypeID				INT
	DECLARE @DelegationID			INT

	DECLARE @NumberOfEntries		INT
	
	DECLARE @SQL					NVARCHAR(1000)

	-- 临时表: 存储 NOC 报名人数
	CREATE TABLE #NumberOfEntries
	(
		F_DelegationID		INT,
		F_NOC				NVARCHAR(20) collate database_default,
		F_NOCLongName		NVARCHAR(200),
		MenTotal			INT,
		WomenTotal			INT,
		Total				INT
	)
	
	INSERT #NumberOfEntries
	(F_DelegationID, F_NOC, F_NOCLongName, MenTotal, WomenTotal)
	SELECT AD.F_DelegationID
		, D.F_DelegationCode
		, DD.F_DelegationLongName
		, (
			SELECT COUNT(DISTINCT F_RegisterID)
			FROM
			(
				SELECT R.F_RegisterID
				FROM TR_Register AS R
				INNER JOIN TR_Inscription AS I
					ON R.F_RegisterID = I.F_RegisterID
				WHERE R.F_DelegationID = AD.F_DelegationID
					AND R.F_RegTypeID = 1
					AND R.F_SexCode = 1
				UNION
				SELECT R.F_RegisterID
				FROM TR_Register_Member AS RM
				INNER JOIN TR_Register AS R
					ON RM.F_MemberRegisterID = R.F_RegisterID
				INNER JOIN TR_Inscription AS I
					ON RM.F_RegisterID = I.F_RegisterID
				WHERE R.F_DelegationID = AD.F_DelegationID
					AND R.F_SexCode = 1
			) AS X
		)
		, (
			SELECT COUNT(DISTINCT F_RegisterID)
			FROM
			(
				SELECT R.F_RegisterID
				FROM TR_Register AS R
				INNER JOIN TR_Inscription AS I
					ON R.F_RegisterID = I.F_RegisterID
				WHERE R.F_DelegationID = AD.F_DelegationID
					AND R.F_RegTypeID = 1
					AND R.F_SexCode = 2
				UNION
				SELECT R.F_RegisterID
				FROM TR_Register_Member AS RM
				INNER JOIN TR_Register AS R
					ON RM.F_MemberRegisterID = R.F_RegisterID
				INNER JOIN TR_Inscription AS I
					ON RM.F_RegisterID = I.F_RegisterID
				WHERE R.F_DelegationID = AD.F_DelegationID
					AND R.F_SexCode = 2
			) AS X
		)
	FROM TS_ActiveDelegation AS AD
	INNER JOIN TC_Delegation AS D
		ON AD.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON AD.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE AD.F_DisciplineID = @DisciplineID
		AND D.F_DelegationType = N'N'
	
	-- 声明游标 EventCursor, 用于遍历每个小项
	DECLARE EventCursor CURSOR				
	FOR 
	( 
		SELECT E.F_EventID, S.F_GenderCode + E.F_EventCode AS [EventCode]
			, E.F_PlayerRegTypeID AS RegTypeID
		FROM TS_Event AS E
		LEFT JOIN TC_Sex AS S
			ON E.F_SexCode = S.F_SexCode
		WHERE E.F_DisciplineID = @DisciplineID
	)
	
	OPEN EventCursor
	
	-- 遍历小项
	WHILE 1 = 1
	BEGIN
		FETCH NEXT FROM EventCursor INTO @EventID, @EventCode, @RegTypeID
		IF @@FETCH_STATUS <> 0 BREAK
		
		-- 添加一个字段 @@EventCode, 存该小项的 NOC 报名人数
		SET @SQL = ' ALTER TABLE #NumberOfEntries ADD [' + @EventCode +	'] INT ' 
		EXEC (@SQL)
		
		-- 声明游标 NOCCursor, 用于遍历每个 NOC
		DECLARE NOCCursor CURSOR 
		FOR SELECT F_DelegationID FROM #NumberOfEntries
		
		OPEN NOCCursor
		
		-- 遍历 NOC
		WHILE 1 = 1
		BEGIN
			FETCH NEXT FROM NOCCursor INTO @DelegationID
			IF @@FETCH_STATUS <> 0 BREAK
			
			IF @RegTypeID = 1
			BEGIN
				SELECT @NumberOfEntries = COUNT(R.F_RegisterID)
				FROM TS_Event AS E
				INNER JOIN TR_Inscription AS I
					ON E.F_EventID = I.F_EventID
				INNER JOIN TR_Register AS R
					ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventID = @EventID
					AND R.F_DelegationID = @DelegationID
			END
			ELSE
			BEGIN
				SELECT @NumberOfEntries = COUNT(RM.F_MemberRegisterID)
				FROM TS_Event AS E
				INNER JOIN TR_Inscription AS I
					ON E.F_EventID = I.F_EventID
				INNER JOIN TR_Register AS R
					ON I.F_RegisterID = R.F_RegisterID
				INNER JOIN TR_Register_Member AS RM
					ON R.F_RegisterID = RM.F_RegisterID
				WHERE E.F_EventID = @EventID
					AND R.F_DelegationID = @DelegationID
			END
			
			-- 更新该小项的 NOC 报名人数
			SET @SQL = '
				UPDATE #NumberOfEntries
				SET [' + @EventCode + '] = ' + CAST(@NumberOfEntries AS NVARCHAR(10)) + '
				WHERE F_DelegationID = ' + CONVERT(NVARCHAR(10), @DelegationID) + '
			'	
			EXEC (@SQL)
		END		-- 遍历 NOC 结束
		
		CLOSE NOCCursor
		DEALLOCATE NOCCursor
		
	END		-- 遍历小项结束
	
    CLOSE EventCursor
    DEALLOCATE EventCursor
    
    -- 计算 Total
    UPDATE #NumberOfEntries SET Total = MenTotal + WomenTotal

	-- 删除 DelegationID 字段
	ALTER TABLE #NumberOfEntries DROP COLUMN F_DelegationID

	SELECT * FROM #NumberOfEntries

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetNumberOfEntries] 62
EXEC [Proc_Report_JU_GetNumberOfEntries] 52

*/