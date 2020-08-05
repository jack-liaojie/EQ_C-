IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetMedallists_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_JU_GetMedallists_Team]
--��    ��: �����Ŀ�����ȡTeam��Ŀ���ƻ������ϸ��Ϣ  
--�� �� ��: ��˳��
--��    ��: 2011��6��3�� ����5
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����	
	
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetMedallists_Team]
	@EventID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_MedalID AS [EventOrder]
		, ED.F_EventLongName AS [EventName]
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, RD.F_PrintLongName AS [MemberName]
		, D.F_DelegationCode +N' - '+DD.F_DelegationLongName AS [NOC]		
	FROM TS_Event_Result AS ER
	LEFT JOIN TC_Medal_Des AS MD 
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Member AS RM
		ON ER.F_RegisterID = RM.F_RegisterID
	LEFT JOIN TR_Register AS MR
		ON RM.F_MemberRegisterID = MR.F_RegisterID 
	LEFT JOIN TC_Delegation_Des AS DD
		ON DD.F_DelegationID=MR.F_DelegationID AND DD.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des AS RD
		ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON ER.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	WHERE ER.F_MedalID IS NOT NULL
		AND E.F_EventID = @EventID
		AND E.F_EventStatusID = 110							-- ����ʾ�����˵���Ŀ
		AND E.F_PlayerRegTypeID >1
		AND MR.F_RegTypeID = 1
	ORDER BY ER.F_MedalID
		
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetMedallists_Team] 17, 'ENG'

*/