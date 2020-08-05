IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetEntryListByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetEntryListByEvent]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetEntryListByEvent]
--描    述: 获取 Entry By Event 的主要内容, 用于 Judo 的 Entry By Event 的报表
--创 建 人: 邓年彩
--日    期: 2010年10月6日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetEntryListByEvent]
	@DisciplineID				INT,
	@EventID					INT,		-- EventID <= 0 时打印所有小项
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

	DECLARE @GroupType			INT
	
	-- 确定 @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- 目前只考虑 2 - NOC 和 4 - Delegation 这两种情况, 优先考虑 4 - Delegation.
	SELECT @GroupType = SC.F_ConfigValue
	FROM TS_Sport_Config AS SC
	INNER JOIN TS_Discipline AS D
		ON SC.F_SportID = D.F_SportID
	WHERE D.F_DisciplineID = @DisciplineID
		AND SC.F_ConfigType = 1 AND SC.F_ConfigName = N'GroupType'
	
	SELECT X.F_EventID AS [EventID]
			, [NOC] = CASE @GroupType WHEN 2 THEN R.F_NOC ELSE D.F_DelegationCode END
			, [NOCLongName] = CASE @GroupType WHEN 2 THEN CD.F_CountryLongName ELSE DD.F_DelegationLongName END
			, RD.F_LongName AS [Name]
			, dbo.[Func_Report_JU_GetDateTime](MR.F_Birth_Date, 1, 'ENG') AS [BirthDate]
			, LEFT(CONVERT(INT, ROUND(MR.F_Height, 0)) / 100.0, 4) + ' / ' 
				+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(MR.F_Height, 0)) * 100 / 3048) + '''' 
				+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(MR.F_Height, 0)) * 100 / 254) % 12) + '"' AS [Height]
			, CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + ' / ' 
				+ CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight, 0)) * 22 / 10) AS [Weight]
		FROM 
		(
			-- 单人项目
			SELECT I.F_EventID
				, I.F_RegisterID
				, I.F_RegisterID AS F_MemberRegisterID
			FROM TR_Inscription AS I
			LEFT JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			LEFT JOIN TR_Register AS R
				ON I.F_RegisterID = R.F_RegisterID
			WHERE E.F_PlayerRegTypeID = 1 
				AND E.F_DisciplineID = @DisciplineID
				AND R.F_RegTypeID = 1
				AND (@EventID = -1 OR I.F_EventID = @EventID)
				
			UNION
			
			-- 多人项目
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
			WHERE E.F_PlayerRegTypeID IN (2, 3) 
				AND E.F_DisciplineID = @DisciplineID
				AND R.F_RegTypeID = 1
				AND (@EventID = -1 OR I.F_EventID = @EventID)
		) AS X
		LEFT JOIN TR_Register AS R
			ON X.F_RegisterID = R.F_RegisterID
		LEFT JOIN TC_Country_Des AS CD
			ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS MR	
			ON X.F_MemberRegisterID = MR.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON X.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetEntryListByEvent] 

*/