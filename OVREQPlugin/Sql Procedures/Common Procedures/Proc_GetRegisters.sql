IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegisters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegisters]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--��    ��: [Proc_GetRegisters]
--��    ��: ���� EventID ��ȡ DisciplineID, Ȼ���ȡ��Discipline�µ����еĲ����ߣ����������˶�Ա��˫����Ϻ����ӣ��δ洢������Ҫ��EventRecord������ġ�
--����˵��: 
--˵    ��: 
--�� �� ��: ֣����
--��    ��: 2010��12��30��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_GetRegisters]
	@EventID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Event WHERE F_EventID = @EventID
	
	(SELECT A.F_RegisterCode, F.F_RegTypeLongDescription, D.F_DelegationCode, A.F_NOC, B.F_LongName, B.F_FirstName, B.F_LastName, E.F_DelegationLongName, C.F_CountryLongName, A.F_RegisterID
	FROM TR_Register AS A 
	LEFT JOIN TR_Register_Des AS B 
		ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Country_Des AS C ON A.F_NOC = C.F_NOC AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS E ON A.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RegType_Des AS F ON A.F_RegTypeID = F.F_RegTypeID AND F.F_LanguageCode = @LanguageCode
		WHERE A.F_DisciplineID = @DisciplineID AND A.F_IsRecord = 1
		--ORDER BY A.F_IsRecord DESC, A.F_DelegationID
	)	
	UNION
	(
	SELECT A.F_RegisterCode, F.F_RegTypeLongDescription, D.F_DelegationCode, A.F_NOC, B.F_LongName, B.F_FirstName, B.F_LastName, E.F_DelegationLongName, C.F_CountryLongName, A.F_RegisterID
	FROM TR_Inscription AS G LEFT JOIN TR_Register AS A ON G.F_RegisterID = A.F_RegisterID
	LEFT JOIN TR_Register_Des AS B 
		ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Country_Des AS C ON A.F_NOC = C.F_NOC AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS E ON A.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RegType_Des AS F ON A.F_RegTypeID = F.F_RegTypeID AND F.F_LanguageCode = @LanguageCode
		WHERE G.F_EventID = @EventID AND A.F_RegTypeID IN (1, 2, 3)
		--ORDER BY A.F_DelegationID
	)

SET NOCOUNT OFF
END


GO


