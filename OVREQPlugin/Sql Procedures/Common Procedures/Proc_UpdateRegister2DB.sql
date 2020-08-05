IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateRegister2DB]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateRegister2DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----��   �ƣ�[Proc_UpdateRegister2DB]
----��   �ܣ�����ʱ���е���Ա�ͱ�����Ϣ���µ����ݿ�
----��	 �ߣ�֣����
----��   �ڣ�2011-06-12 

/*
	����˵����
	���	��������			����˵��
	1		@DisciplineCode		ָ���ı���Code
*/

/*
	�����������˴洢���̵Ĳ��ܹ����б����������ݵĸ��£�
			  ���������Ǳ������ݸ��º����ӣ���������ֻ�ܹ����ӡ�
			  
*/

/*
�޸ļ�¼��
	���	����			�޸���		�޸�����
	1						

*/

CREATE PROCEDURE [dbo].[proc_UpdateRegister2DB] 
	@DisciplineCode			NVARCHAR(50),
	@Result 				AS INT OUTPUT
	
AS
BEGIN

SET NOCOUNT ON

	SET @Result = 0
	
		
		
	DECLARE @DisciplineID AS INT
	SELECT 	@DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
		DELETE FROM Temp_Athletes WHERE �˶�Ա��� IS NULL
		DELETE FROM Temp_Athletes WHERE �˶�Ա��� = ''
	
		UPDATE A SET A.F_DelegationID = B.F_DelegationID FROM Temp_Athletes AS A LEFT JOIN TC_Delegation AS B ON A.������λ���� = B.F_DelegationCode
	
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
	
		INSERT INTO TR_Register(F_RegisterCode, F_RegTypeID, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_Bib, F_DelegationID, F_DisciplineID)
			SELECT DISTINCT �˶�Ա���, 1, CASE �Ա� WHEN '��' THEN 1 WHEN 'Ů' THEN 2 ELSE NULL END, ��������, CASE [���(cm)] WHEN N'' THEN NULL ELSE [���(cm)] END
			, CASE [����(kg)] WHEN N'' THEN NULL ELSE [����(kg)] END, CASE [����������] WHEN N'' THEN NULL ELSE [����������] END
			, F_DelegationID, @DisciplineID
				FROM Temp_Athletes WHERE �˶�Ա��� IS NOT NULL 
	
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM Temp_Athletes AS A LEFT JOIN TR_Register AS B ON A.�˶�Ա��� = B.F_RegisterCode 
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName, F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName)
			SELECT DISTINCT F_RegisterID, 'CHN', ����, ����, ����, ����, ����, ����, ����, ���� FROM Temp_Athletes WHERE F_RegisterID IS NOT NULL
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		

		UPDATE A SET A.F_EventID = B.F_EventID, A.F_EventSexCode = B.F_SexCode, A.F_PlayerRegTypeID = B.F_PlayerRegTypeID 
			FROM Temp_Athletes AS A LEFT JOIN TS_Event AS B ON REPLACE(A.������Ŀ����, @DisciplineCode, '') = REPLACE(B.F_EventCode, @DisciplineCode, '')
			
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END		
		
		UPDATE Temp_Athletes SET F_TeamCode = @DisciplineCode + ������λ���� + ������Ŀ���� + RIGHT((N'000'+ ��Ϻ���), 3)
			WHERE ������λ���� IS NOT NULL AND ������Ŀ���� IS NOT NULL AND ��Ϻ��� IS NOT NULL AND �˶�Ա��� IS NOT NULL
				AND F_PlayerRegTypeID IN (2,3)
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END		
		
		INSERT INTO TR_Register(F_RegisterCode, F_RegTypeID, F_SexCode, F_DelegationID, F_DisciplineID)
			SELECT DISTINCT F_TeamCode, F_PlayerRegTypeID, F_EventSexCode, F_DelegationID, @DisciplineID
				FROM Temp_Athletes WHERE F_TeamCode IS NOT NULL 
				
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END	
		
		UPDATE A SET A.F_TeamID = B.F_RegisterID FROM Temp_Athletes AS A LEFT JOIN TR_Register AS B ON A.F_TeamCode = B.F_RegisterCode 
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName, F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName)
			SELECT DISTINCT F_TeamID, 'CHN', F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName FROM
			(SELECT DISTINCT A.F_TeamID, B.F_DelegationLongName FROM Temp_Athletes AS A 
			LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID WHERE F_TeamID IS NOT NULL AND B.F_LanguageCode = 'CHN') AS A
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
	
		
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order) 
			SELECT F_TeamID, F_RegisterID, ROW_NUMBER() OVER(PARTITION  BY F_TeamID ORDER BY F_RegisterID) AS F_Order FROM
			(
			SELECT DISTINCT F_TeamID, F_RegisterID FROM Temp_Athletes WHERE F_TeamID IS NOT NULL AND F_RegisterID IS NOT NULL
			) AS A
			
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
			
		DECLARE @StrSql AS NVARCHAR(MAX)
		SET @StrSql = ''
		
		SELECT @StrSql = @StrSql + ' ; ' +  N'EXEC proc_UpdateDoubleName ' + CAST(F_RegisterID AS NVARCHAR(100)) + N', ''CHN'', NULL'  from TR_Register where F_RegTypeID = 2
		
		EXEC (@StrSql)
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TS_ActiveDelegation (F_DelegationID, F_DisciplineID, F_Order)
			SELECT F_DelegationID, F_DisciplineID, ROW_NUMBER() OVER ( ORDER BY F_DelegationID) FROM
			(
			SELECT  DISTINCT F_DelegationID, F_DisciplineID FROM TR_Register WHERE F_DelegationID IS NOT NULL AND F_DisciplineID IS NOT NULL
			EXCEPT 
			SELECT F_DelegationID, F_DisciplineID FROM TS_ActiveDelegation
			) AS A
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Inscription (F_EventID, F_RegisterID) 
		SELECT DISTINCT F_EventID, F_RegisterID FROM Temp_Athletes WHERE F_PlayerRegTypeID = 1
		EXCEPT SELECT F_EventID, F_RegisterID FROM TR_Inscription
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Inscription (F_EventID, F_RegisterID) SELECT DISTINCT F_EventID, F_TeamID FROM Temp_Athletes WHERE F_PlayerRegTypeID IN (2, 3)
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Athletes]') AND type in (N'U'))
		BEGIN
			DROP TABLE [dbo].[Temp_Athletes]
			
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		


	COMMIT TRANSACTION --�ɹ��ύ����
	
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END






GO


--EXEC proc_UpdateRegister2DB 'TE', 0
--GO