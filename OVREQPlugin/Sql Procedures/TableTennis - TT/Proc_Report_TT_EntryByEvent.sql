IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_EntryByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_EntryByEvent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--��    ��: [Proc_Report_TT_EntryByEvent]
--��    ��: ��ȡ Entry By Event ����Ҫ����, ���� Karate �� Entry By Event �ı���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��09��08��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��15��		�����		��� EventID ����, ��ӡ����ʱ���Դ�ӡ����С��򵥸�С��
			2009��11��10��		�����		����������ͬ���� SQL ���򻯴洢����
			2009��11��24��		�����		NOCCode ���� Delegation ��ȡ, �� Delegation ��ȡ, ȡ�� NOC �����Ͷ���
			2010��1��12��		�����		��Ӳ���@DisciplineID; NOC �� TC_Country ��ȡ; ����ֶ� Height; 
											��ϸ��Ϣͳһ���ȥ��, �����Ժ�ά����ѯ; ��������˶�Ա������.
			2010��1��13��		�����		���� Sport �� GroupType ��ѡ�� NOC ����Դ.
			2010��1��15��		�����		����ֶ� [DrawPosition].
			2010��1��28��		�����		����ȡ��д.
			2010��2��4��		�����		ȡ����ʹ��ͳһ�ĺ��� [Func_Report_KR_GetDateTime], ���ڲ��� 0 ��ͷ.
			2010��6��9��		�����		�������ھ�ȡӢ�ĵ�����.
			2010��9��27��		�����		��ʹ����� SQL; ���� TR_Register.F_Height �� INT ��Ϊ DECIMAL ��, ���޸�ת��.
			2011��3��9��        ����        ����F_InscriptionRank�ֶ�
*/


CREATE PROCEDURE [dbo].[Proc_Report_TT_EntryByEvent]
	@DisciplineID				INT,
	@EventID					INT,		-- EventID <= 0 ʱ��ӡ����С��
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

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
			, [NOC] = CASE @GroupType WHEN 2 THEN R.F_NOC ELSE D.F_DelegationCode END
			, [NOCLongName] = CASE @GroupType WHEN 2 THEN CD.F_CountryLongName ELSE DD.F_DelegationLongName END
			, MR.F_Bib AS [Bib]
			, RD.F_LongName AS [Name]
			, dbo.[Func_Report_TE_GetDateTime](MR.F_Birth_Date, 1, 'ENG') AS [BirthDate]
			, LEFT(CONVERT(INT, ROUND(MR.F_Height, 0)) / 100.0, 4) + ' / ' 
				+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(MR.F_Height, 0)) * 100 / 3048) + '''' 
				+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(MR.F_Height, 0)) * 100 / 254) % 12) + '"' AS [Height]
			, CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(MR.F_Weight, 0))) + ' / ' 
			  + CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(MR.F_Weight, 0)) * 22 / 10) AS [Weight]
			, X.F_InscriptionRank AS [TechOrder]
			, X.F_RegisterID AS [RegisterID]
			, S.F_GenderCode AS [Gender]
		FROM 
		(
			-- ������Ŀ
			SELECT I.F_EventID
				, I.F_RegisterID
				, I.F_RegisterID AS F_MemberRegisterID
				, I.F_InscriptionRank
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
			
			-- ������Ŀ
			SELECT I.F_EventID
				, I.F_RegisterID
				, RM.F_MemberRegisterID
				, TR1.F_InscriptionRank
			FROM TR_Inscription AS I
			LEFT JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			LEFT JOIN TR_Register_Member AS RM
				ON I.F_RegisterID = RM.F_RegisterID
			LEFT JOIN TR_Register AS R
				ON RM.F_MemberRegisterID = R.F_RegisterID
			LEFT JOIN TR_Inscription AS TR1 ON TR1.F_RegisterID = R.F_RegisterID
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
		LEFT JOIN TC_Sex AS S 
		    ON MR.F_SexCode = S.F_SexCode
		ORDER BY D.F_DelegationCode, X.F_InscriptionRank 

SET NOCOUNT OFF
END


GO


