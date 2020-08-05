IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineAthletes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineAthletes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----��   �ƣ�[Proc_GetDisciplineAthletes]
----��   �ܣ��õ�ָ����Ŀ�µı���������Ϣ
----��	 �ߣ�֣����
----��   �ڣ�2010-08-27 

/*
	����˵����
	���	��������			����˵��
	1		@DisciplineCode		ָ���ı���ID
*/

/*
	�����������õ�ָ����Ŀ�µı���������Ϣ��
			  
*/

/*
�޸ļ�¼��
	���	����			�޸���		�޸�����
	1						

*/

CREATE PROCEDURE [dbo].[Proc_GetDisciplineAthletes]
		@DisciplineCode			AS NVARCHAR(50)
AS
BEGIN
	
SET NOCOUNT ON
	
	CREATE TABLE #Temp_Athletes(
		[�˶�Ա���] [nvarchar](255) NULL,
		[����] [nvarchar](255) NULL,
		[�Ա�] [nvarchar](255) NULL,
		[��������] [nvarchar](255) NULL,
		[����] [nvarchar](255) NULL,
		[���(cm)] [nvarchar](255) NULL,
		[����(kg)] [nvarchar](255) NULL,
		[ע��֤��/��Ա֤��] [nvarchar](255) NULL,
		[������λ] [nvarchar](255) NULL,
		[������λ����] [nvarchar](255) NULL,
		[�ּƵ�λ] [nvarchar](255) NULL,
		[�ּƵ�λ����] [nvarchar](255) NULL,
		[����Ƿ�����] [nvarchar](255) NULL,
		[������Ŀ] [nvarchar](255) NULL,
		[������Ŀ����] [nvarchar](255) NULL,
		[�����ɼ�] [nvarchar](255) NULL,
		[�Ƿ�Ԥ����Ա] [nvarchar](255) NULL,
		[��Ϻ���] [nvarchar](255) NULL,
		[��������] [nvarchar](255) NULL,
		[�������] [nvarchar](255) NULL,
		[�������˳��] [nvarchar](255) NULL,
		[����������] [nvarchar](255) NULL,	----��������Ŀר��
		[F23] [nvarchar](255) NULL,
		F_RegisterID		INT,
		F_DelegationID		INT,
		F_TeamCode			NVARCHAR(255),
		F_TeamID			INT,
		F_EventID			INT,
		F_EventSexCode		INT,
		F_PlayerRegTypeID	INT,
		F_RegisterRegTypeID			INT,
		F_TeamRegTypeID				INT,
		F_TeamLevel					INT
	)
	
	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	DECLARE @LanguageCode AS CHAR(3)
	SET @LanguageCode = 'CHN'
	
	
	----Step 1: Single Player
	INSERT INTO #Temp_Athletes(F_RegisterID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_RegisterRegTypeID
				, ������Ŀ����, ������Ŀ, �����ɼ�)
	SELECT A.F_RegisterID, A.F_EventID, B.F_SexCode, B.F_PlayerRegTypeID, D.F_RegTypeID, B.F_EventCode, C.F_EventLongName
			, A.F_InscriptionResult FROM TR_Inscription AS A 
			LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
			LEFT JOIN TS_Event_Des AS C ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS D ON A.F_RegisterID = D.F_RegisterID
		 WHERE B.F_DisciplineID = @DisciplineID AND B.F_PlayerRegTypeID = 1
	
	----Step 2: Double Player
	----Step 3: Team Player
	
	INSERT INTO #Temp_Athletes(F_RegisterID, F_TeamID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_TeamRegTypeID
				, ������Ŀ����, ������Ŀ, �����ɼ�, ��Ϻ���, F_TeamLevel)
	SELECT A.F_RegisterID, A.F_RegisterID, A.F_EventID, B.F_SexCode, B.F_PlayerRegTypeID, D.F_RegTypeID, B.F_EventCode, C.F_EventLongName
			, A.F_InscriptionResult, ROW_NUMBER() OVER(PARTITION BY A.F_EventID, D.F_DelegationID ORDER BY A.F_RegisterID), 0 AS F_TeamLevel FROM TR_Inscription AS A 
			LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
			LEFT JOIN TS_Event_Des AS C ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS D ON A.F_RegisterID = D.F_RegisterID
		 WHERE B.F_DisciplineID = @DisciplineID AND B.F_PlayerRegTypeID IN (2, 3)
	
	
	DECLARE @Level AS INT
	SET @Level = 0
	WHILE EXISTS(SELECT C.F_RegisterID FROM #Temp_Athletes AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID
					LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
					WHERE A.F_TeamLevel = 0 AND C.F_RegTypeID IN (2, 3))
	BEGIN
		SET @Level = @Level + 1
		UPDATE #Temp_Athletes SET F_TeamLevel = @Level WHERE F_TeamLevel = 0
		
		INSERT INTO #Temp_Athletes(F_RegisterID, F_TeamID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_TeamRegTypeID 
				, ������Ŀ����, ������Ŀ, �����ɼ�, ��Ϻ���, F_TeamLevel)
		SELECT C.F_RegisterID, C.F_RegisterID, A.F_EventID, A.F_EventSexCode, A.F_PlayerRegTypeID, C.F_RegTypeID
				, A.������Ŀ����,  A.������Ŀ, A.�����ɼ�, A.��Ϻ���, 0 AS F_TeamLevel 
				FROM #Temp_Athletes AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID
					LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
					WHERE A.F_TeamLevel = @Level AND C.F_RegTypeID IN (2, 3)
		
	END
	
	SET @Level = @Level + 1
	UPDATE #Temp_Athletes SET F_TeamLevel = @Level WHERE F_TeamLevel = 0
	DECLARE @MaxLevel AS INT
	SET @MaxLevel = @Level
	SET @Level = 1
	

	
	INSERT INTO #Temp_Athletes(F_RegisterID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_RegisterRegTypeID
			, ������Ŀ����, ������Ŀ, �����ɼ�, ��Ϻ���, ����������)
	SELECT B.F_MemberRegisterID, A.F_EventID, A.F_EventSexCode, A.F_PlayerRegTypeID, C.F_RegTypeID
				, A.������Ŀ����,  A.������Ŀ, A.�����ɼ�, A.��Ϻ���, B.F_ShirtNumber FROM #Temp_Athletes AS A 
					LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID
					LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
					WHERE A.F_TeamLevel > 0 AND C.F_RegTypeID = 1


	----Step 4: Player that not Inscrption
	INSERT INTO #Temp_Athletes(F_RegisterID, F_RegisterRegTypeID)
		SELECT F_RegisterID, F_RegTypeID FROM TR_Register WHERE 
			F_RegisterID NOT IN (SELECT F_RegisterID FROM #Temp_Athletes WHERE F_RegisterRegTypeID = 1)
			AND F_RegTypeID = 1
	
	----Step 5: Non Athlete Register
	INSERT INTO #Temp_Athletes(F_RegisterID, F_RegisterRegTypeID)
		SELECT F_RegisterID, F_RegTypeID FROM TR_Register WHERE 
			F_RegisterID NOT IN (SELECT F_RegisterID FROM #Temp_Athletes WHERE F_RegisterRegTypeID = 1)
			AND F_RegTypeID NOT IN (1, 2, 3)
			
	----Step 6: Fill Register Description
	UPDATE A SET A.�˶�Ա��� = B.F_RegisterCode, A.���� = F.F_LongName, A.�Ա� = C.F_SexLongName, A.�������� = LEFT(CONVERT(NVARCHAR(MAX)
		, B.F_Birth_Date, 120 ), 10), A.[���(cm)] = B.F_Height, A.[����(kg)] = B.F_Weight 
		, A.������λ���� = D.F_DelegationCode, A.������λ = E.F_DelegationLongName, A.F_DelegationID = B.F_DelegationID FROM #Temp_Athletes AS A 
		LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Sex_Des AS C ON B.F_SexCode = C.F_SexCode AND C.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS E ON B.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS F ON A.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = @LanguageCode
	
			
	SELECT  [�˶�Ա���], [����], [�Ա�], [��������], [����], [���(cm)], [����(kg)]
			, [ע��֤��/��Ա֤��], [������λ], [������λ����], [�ּƵ�λ], [�ּƵ�λ����]
			, [����Ƿ�����], [������Ŀ], [������Ŀ����], [�����ɼ�], [�Ƿ�Ԥ����Ա]
			, [��Ϻ���], [��������], [�������], [�������˳��], [����������]
			--, [F23]
			--, [F_RegisterID], [F_DelegationID], [F_TeamCode], [F_TeamID], [F_EventID]
			--, [F_EventSexCode], [F_PlayerRegTypeID], [F_RegisterRegTypeID], [F_TeamRegTypeID], [F_TeamLevel]
		 FROM #Temp_Athletes WHERE F_RegisterRegTypeID = 1 ORDER BY F_DelegationID, F_EventID
	
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC Proc_GetDisciplineAthletes 'TS'