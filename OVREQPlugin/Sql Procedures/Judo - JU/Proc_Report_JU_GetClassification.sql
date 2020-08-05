IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetClassification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetClassification]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_JU_GetClassification]
--��    ��: ��ȡһ����Ŀ����������.
--�� �� ��: �����
--��    ��: 2010��10��25�� ����һ
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
	2011��1��4�� ���ڶ�		�����		�� TS_Event_Result ���ֶ� F_EventDiplayPosition ��Ϊ F_EventDisplayPosition.
	2011��3��30��			��˳��		��F_MedalID�ֶλ�ȡ����
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetClassification]
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	-- �� @MatchID ��Чʱ, �� @MatchID Ϊ׼
	IF @MatchID > 0
	BEGIN
		SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	END
	
	-- �� @PhaseID ��Чʱ, �� @PhaseID Ϊ׼
	IF @PhaseID > 0
	BEGIN
		SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	END
	
	SELECT ER.F_EventRank AS [Rank]
		, RD.F_PrintLongName AS [Name]
		, DD.F_DelegationLongName AS [NOCCode]
		, [Medal] = CASE ER.F_MedalID WHEN 1 THEN N'GOLD' WHEN 2 THEN N'SILVER' WHEN 3 THEN N'BRONZE' END
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD
		ON D.F_DelegationID=DD.F_DelegationID and DD.F_LanguageCode=@LanguageCode
	WHERE ER.F_EventID = @EventID
	ORDER BY ER.F_EventDisplayPosition

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetClassification] 15, -1, -1, 'ENG'

*/