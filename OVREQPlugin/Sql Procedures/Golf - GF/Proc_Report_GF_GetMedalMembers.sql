IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetMedalMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetMedalMembers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_Report_GF_GetMedalMembers]
--��    ��: SQ��Ŀ��ȡ ���ƻ����(����Ŀ����)��Ա��Ϣ, ���� C93 - Medallists by Event ����
--����˵��: 
--˵    ��: 
--�� �� ��: �Ŵ�ϼ
--��    ��: 2010��9��15��



CREATE PROCEDURE [dbo].[Proc_Report_GF_GetMedalMembers]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

    CREATE TABLE #Table_Tmp(
                            F_EventID         INT,
                            F_RegisterID      INT,
                            [Name]            NVARCHAR(150)
                            )
                            
    INSERT INTO #Table_Tmp(F_EventID, F_RegisterID, [Name])
	SELECT ER.F_EventID
		, ER.F_RegisterID
		, RD.F_PrintLongName
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	WHERE ER.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_PlayerRegTypeID = 1
		AND R.F_RegTypeID = 1
	
	INSERT INTO #Table_Tmp(F_EventID, F_RegisterID, [Name])
	SELECT ER.F_EventID
		, RM.F_RegisterID
		, RD.F_PrintLongName
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register_Member AS RM
	    ON ER.F_RegisterID = RM.F_RegisterID
	LEFT JOIN TR_Register AS R
		ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON RM.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	WHERE ER.F_MedalID IS NOT NULL		
		AND E.F_PlayerRegTypeID = 3 AND E.F_DisciplineID = @DisciplineID
		AND R.F_RegTypeID = 1	
		
	SELECT * FROM #Table_Tmp

SET NOCOUNT OFF
END




GO


