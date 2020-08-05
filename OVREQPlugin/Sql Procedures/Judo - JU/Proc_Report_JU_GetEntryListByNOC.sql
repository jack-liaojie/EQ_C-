IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetEntryListByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetEntryListByNOC]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetEntryListByNOC]
--描    述: 柔道项目获取报表 Entry List by NOC 的主要数据.
--创 建 人: 邓年彩
--日    期: 2010年9月25日 星期六
--修改记录：
/*			
	日期					修改人		修改内容
	2010年10月25日 星期一	邓年彩		添加字段 Inscipt, 表示运动员是否报项.
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetEntryListByNOC]
	@DisciplineID						INT,
	@DelegationID						INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
		
		
	SELECT D.F_DelegationCode AS [NOCCode]
		, DD.F_DelegationLongName AS [NOC]
		, RD.F_PrintLongName AS [Name]
		, S.F_GenderCode AS [Gender]
		, ED.F_EventLongName AS [Event]
		, X.F_EventCode
		, dbo.Func_Report_JU_GetDateTime(R.F_Birth_Date, 1, 'ENG') AS [DateOfBirth]
		, LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + ' / ' 
				+ LEFT(CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 3048), 4) + ''''
				+ LEFT(CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 254) % 12), 4) + '"' AS [Height]
		, [Inscipt] = CASE WHEN X.F_EventID IS NOT NULL THEN 1 ELSE 0 END
		,Right(R.F_RegisterCode,7) AS Reg_No
	FROM TR_Register AS R
	LEFT JOIN
		(
			SELECT I.F_EventID
				, R.F_RegisterID
				, E.F_EventCode
			FROM TR_Inscription AS I
			INNER JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			INNER JOIN TR_Register AS R
				ON I.F_RegisterID = R.F_RegisterID
			WHERE R.F_DisciplineID = @DisciplineID
				AND E.F_PlayerRegTypeID = 1
				AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID)
			UNION
			SELECT I.F_EventID
				, R.F_RegisterID
				, E.F_EventCode
			FROM TR_Inscription AS I
			INNER JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			INNER JOIN TR_Register_Member AS RM
				ON I.F_RegisterID = RM.F_RegisterID
			LEFT JOIN TR_Register AS R
				ON R.F_RegisterID = RM.F_MemberRegisterID
			WHERE R.F_DisciplineID = @DisciplineID
				AND E.F_PlayerRegTypeID IN (2, 3)
				AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID)
		) AS X
		ON R.F_RegisterID = X.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	INNER JOIN TC_Sex AS S
		ON R.F_SexCode = S.F_SexCode
	INNER JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event_Des AS ED
		ON X.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode 
	WHERE R.F_DisciplineID = @DisciplineID
		AND R.F_RegTypeID = 1
		AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID)
	ORDER BY D.F_DelegationCode, S.F_SexCode, ISNULL(X.F_EventCode, '999'), RD.F_PrintLongName
		
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetEntryListByNOC] -1, -1, 'ENG'
EXEC [Proc_Report_JU_GetEntryListByNOC] -1, -1, 'CHN'

*/