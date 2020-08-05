IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetMedalMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetMedalMembers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_HO_GetMedalMembers]
--描    述: HO项目获取 奖牌获得者成员信息,
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2012年09月05日



CREATE PROCEDURE [dbo].[Proc_Report_HO_GetMedalMembers]
	@EventID						    INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

    CREATE TABLE #Table_Tmp(
                            F_EventID         INT,
                            F_RegisterID      INT,
                            [Name]            NVARCHAR(150),
                            F_FenjiDanwei     NVARCHAR(100)
                            )
                            
    INSERT INTO #Table_Tmp(F_EventID, F_RegisterID, [Name])
	SELECT ER.F_EventID
		, ER.F_RegisterID
		, RD.F_PrintLongName
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E ON ER.F_EventID = E.F_EventID
	WHERE ER.F_MedalID IS NOT NULL
		AND E.F_EventID = @EventID
		AND E.F_PlayerRegTypeID = 1
		AND R.F_RegTypeID = 1
	
	INSERT INTO #Table_Tmp(F_EventID, F_RegisterID, [Name])
	SELECT ER.F_EventID
		, RM.F_RegisterID
		, RD.F_PrintLongName
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register_Member AS RM ON ER.F_RegisterID = RM.F_RegisterID
	LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON RM.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Des AS RD1 ON RM.F_MemberRegisterID = RD1.F_RegisterID AND RD1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event AS E ON ER.F_EventID = E.F_EventID
	WHERE E.F_PlayerRegTypeID = 3 AND E.F_EventID = @EventID AND R.F_RegTypeID = 1
		ORDER BY ER.F_EventDisplayPosition, RM.F_RegisterID, RD1.F_LastName, RD1.F_FirstName
		
	SELECT * FROM #Table_Tmp

SET NOCOUNT OFF
END

GO

/*EXEC Proc_Report_HO_GetMedalMembers 16, 'CHN'*/


