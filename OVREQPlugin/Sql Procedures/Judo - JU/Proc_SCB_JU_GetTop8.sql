IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_GetTop8]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_GetTop8]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_SCB_JU_GetTop8]
--��    ��: ��ȡ��Ļ��ʾ����.
--�� �� ��: ��˳��
--��    ��: 2011��3��2�� ������
--�޸ļ�¼��
/*			
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_GetTop8]
	@EventID						INT
AS
BEGIN
SET NOCOUNT ON
	
	SELECT
		ED1.F_EventLongName AS [Event_Name] 
		,ER.F_EventRank AS [Rank]
		, RD.F_LongName AS [Name]
		, D.F_DelegationCode AS [NOCCode]
		, [Medal] = CASE ER.F_EventRank WHEN 1 THEN N'GOLD' WHEN 2 THEN N'SILVER' WHEN 3 THEN N'BRONZE' END
		,N'[Image]'+D.F_DelegationCode AS [Image_Noccode]
		,ED2.F_EventLongName AS [Event_Name_CHN]
		,ED1.F_EventLongName+N'��'+ED2.F_EventLongName+N'��' AS EventName_ENG_CHN
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event_Des AS ED1
		ON ER.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED2
		ON ER.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	WHERE ER.F_EventID = @EventID
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END