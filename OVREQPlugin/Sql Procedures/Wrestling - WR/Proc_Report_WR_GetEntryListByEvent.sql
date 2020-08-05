IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetEntryListByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetEntryListByEvent]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_WR_GetEntryListByEvent]
--��    ��: ��ȡ Entry By Event ����Ҫ����, ���� Judo �� Entry By Event �ı���
--�� �� ��: ��˳��
--��    ��: 2011��10��17�� ����1
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetEntryListByEvent]
	@DisciplineID				INT,
	@EventID					INT,		-- EventID <= 0 ʱ��ӡ����С��
	@LanguageCode				CHAR(3)=N'ENG'
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

	DECLARE @GroupType			INT
	
	-- ȷ�� @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- Ŀǰֻ���� 2 - NOC �� 4 - Delegation ���������, ���ȿ��� 4 - Delegation.
	SELECT @GroupType = SC.F_ConfigValue
	FROM TS_Sport_Config AS SC
	INNER JOIN TS_Discipline AS D
		ON SC.F_SportID = D.F_SportID
	WHERE D.F_DisciplineID = @DisciplineID
		AND SC.F_ConfigType = 1 AND SC.F_ConfigName = N'GroupType'
	
	SELECT X.F_EventID AS [EventID]
			, [NOC] = D.F_DelegationCode
			, [NOCLongName] =  DD.F_DelegationLongName 
			, RD.F_PrintLongName AS [Name]
			, dbo.[Func_Report_WR_GetDateTime](R.F_Birth_Date, 1, 'ENG') AS [BirthDate]
			, LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + ' / ' 
				+ LEFT(CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 3048), 4) + ''''
				+ LEFT(CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 254) % 12), 4) + '"' AS [Height]
		FROM 
		(
			SELECT I.F_EventID
				, I.F_RegisterID									
			FROM TR_Inscription AS I
			LEFT JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			WHERE  E.F_DisciplineID=@DisciplineID
			and (@EventID=-1 or E.F_EventID=@EventID)
		) AS X
		LEFT JOIN TR_Register AS R
			ON X.F_RegisterID = R.F_RegisterID
		LEFT JOIN TC_Country_Des AS CD
			ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = N'ENG'
		LEFT JOIN TR_Register_Des AS RD
			ON X.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = N'ENG'
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = N'ENG'	
		ORDER BY NOC

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetEntryListByEvent] 

*/