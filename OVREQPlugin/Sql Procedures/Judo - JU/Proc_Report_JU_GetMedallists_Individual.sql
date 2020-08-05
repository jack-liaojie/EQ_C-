IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetMedallists_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_JU_GetMedallists_Individual]
--��    ��: �����Ŀ�����ȡ������Ŀ���ƻ������ϸ��Ϣ  
--�� �� ��: �����
--��    ��: 2010��10��28�� ������
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����	
	2011��1��4�� ���ڶ�		�����		�� TS_Event_Result ���ֶ� F_EventDiplayPosition ��Ϊ F_EventDisplayPosition.
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_Individual]
	@EventID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventRank AS [Rank]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, RD.F_PrintLongName AS [Name]
		, D.F_DelegationCode AS [NOCCode]
		, DD.F_DelegationLongName AS [NOCLongName]
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD 
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON ER.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	WHERE ER.F_MedalID IS NOT NULL
		AND ER.F_EventID = @EventID
		AND E.F_PlayerRegTypeID=1
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetMedallists_Individual] 109, 'ENG'

*/