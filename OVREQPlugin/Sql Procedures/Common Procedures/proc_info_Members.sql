IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Members]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Members]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----�洢�������ƣ�[proc_info_Members]
----��		  �ܣ�ΪInfoϵͳ���񣬻�ȡMembers
----��		  �ߣ���ѧ�� 
----��		  ��: 2009-11-10 
----�� ��  �� ¼��
/*			
	ʱ��				�޸���		�޸�����
	2010-05-09			֣����		�����ĳ���ΪDisciplineCode+N'M',����ΪNULL
	2010-06-30			֣����		Ӧ��˫��ͶӶ�Ҫ���ֶ�Ա��ϵ
	2010-06-30			֣����		���ǶӵĶ�Ա�н������˶�Ա�����ܰ���˫����ϣ�Ҳ���ܰ�����Ա�ͽ�����
*/


CREATE PROCEDURE [dbo].[proc_info_Members]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #table_tmp (
								[KEY]				NCHAR(29),
								DISCIPLINE			NCHAR(2),
								SEX					NCHAR(1),
								[EVENT]				NCHAR(3),
								EVENT_PARENT		NCHAR(3),
								REGISTER_TEAM		INT,
								REGISTER_MEMBER		INT,
								SHOW_TEAM			TINYINT,
								SHOW_INSCRIPTION	TINYINT,
								NORDER				SMALLINT,
								IDFUNCTION			Nvarchar(1),
								QCODE				Nchar(1),
								BIB					Nvarchar(10),
								MEDICAL_CLASS		Nvarchar(30))

	INSERT INTO #table_tmp (DISCIPLINE, SEX, [EVENT], EVENT_PARENT,
							REGISTER_TEAM, REGISTER_MEMBER, NORDER, BIB)
	SELECT 	CAST(C.F_DisciplineCode AS NCHAR(2)), 
		CAST(E.F_GenderCode AS NCHAR(1)), 
		CAST(D.F_EventCode AS NCHAR(3)),
		CAST(D.F_EventCode AS NCHAR(3)),
		B.F_RegisterCode,
		G.F_RegisterCode,
		F.F_Order AS NORDER,
		CAST(F.F_ShirtNumber AS NVARCHAR(10)) AS BIB
	FROM TR_Register_Member AS F 
		LEFT JOIN TR_Inscription AS A ON A.F_RegisterID = F.F_RegisterID 
		LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TS_Discipline AS C ON B.F_DisciplineID = C.F_DisciplineID
		LEFT JOIN TS_Event D ON A.F_EventID = D.F_EventID
		LEFT JOIN TC_SEX AS E ON D.F_SexCode = E.F_SexCode
		LEFT JOIN TR_Register AS G ON F.F_MemberRegisterID = G.F_RegisterID
		WHERE C.F_DisciplineCode = @DisciplineCode
				AND B.F_RegTypeID IN (2, 3) -- 2 IS DOUBLE, 3 IS TEAM
				AND G.F_RegTypeID = 1       -- 1 IS Athlete
		

	UPDATE #table_tmp SET SHOW_TEAM = 1, SHOW_INSCRIPTION = 1
	UPDATE #table_tmp SET [KEY] = DISCIPLINE + SEX + [EVENT] + EVENT_PARENT 
			+Right('0000000000' + CAST( REGISTER_TEAM AS NVARCHAR(10)), 10) + Right('0000000000' + CAST( REGISTER_MEMBER AS NVARCHAR(10)), 10) FROM #table_tmp 


	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END
GO

--EXEC [proc_info_Members] 'SL'