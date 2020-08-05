IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_DeleteRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_DeleteRecord]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--��    ��: [Proc_AR_DeleteRecord]
--��    ��: �����Ŀ,ɾ��������¼
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2011��6��17��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_AR_DeleteRecord]
	@RecordID		INT,
	@RecordValue	INT,
	@Return  		AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @OldRecordID	    INT
	DECLARE @NewRecordID	    INT
	DECLARE @Equalled           INT 
	DECLARE @NewEqualled           INT 
	DECLARE @Active             INT 
	DECLARE @SubCode           NVARCHAR(10) 
	
	SET @Return=0;  -- @Return=0; 	ɾ���ɹ������أ�
					-- @Return=1; 	ƽ��¼�����أ�
					-- @Return=2; 	��Ȼ��󣬲�ɾ�����޸ģ�
					-- @Return=-1; 	����ʧ��
	if not exists(select * from TS_Event_Record where F_RecordID = @RecordID)
	begin
		set @Return = -1
	end
	select @SubCode=F_SubEventCode from TS_Event_Record
	where F_RecordID=@RecordID
	
	DECLARE @OldRecord INT
	set @OldRecord = (SELECT TOP 1 CAST(F_RecordValue AS INT) FROM TS_Event_Record 
						WHERE ISNULL(F_SubEventCode,'0') = @SubCode AND F_RecordID != @RecordID ORDER BY F_RecordValue DESC)
	
	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --�趨����
	
	IF(@OldRecord >@RecordValue )
	BEGIN
		--ɾ����¼��Ϣ
		DELETE FROM TS_Event_Record	WHERE F_RecordID = @RecordID AND F_IsNewCreated =1
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Return=-1
			RETURN
		END
		
		UPDATE TS_Event_Record SET  F_Active = 1 
			WHERE F_RecordID = (SELECT TOP 1 F_RecordID FROM TS_Event_Record 
							WHERE ISNULL(F_SubEventCode,'0') = @SubCode AND F_RecordID != @RecordID ORDER BY F_RecordValue DESC )
			
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Return=-1
			RETURN
		END
		
	SET @Return = 0
	
	END
	ELSE IF(@OldRecord =@RecordValue )
		BEGIN
		--ɾ����¼��Ϣ
		UPDATE TS_Event_Record SET F_Equalled = 1, F_Active =0, F_RecordValue = @RecordValue 
			WHERE F_RecordID = @RecordID AND F_IsNewCreated =1
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Return=-1
			RETURN
		END
		
		UPDATE TS_Event_Record SET  F_Active = 1 
			WHERE F_RecordID = (SELECT TOP 1 F_RecordID FROM TS_Event_Record 
							WHERE ISNULL(F_SubEventCode,'0') = @SubCode   AND F_RecordID != @RecordID  ORDER BY F_RecordValue DESC )
			
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Return=-1
			RETURN
		END
		SET @Return = 1
		END
	ELSE IF(@OldRecord <@RecordValue )
		BEGIN
		--ɾ����¼��Ϣ
		UPDATE TS_Event_Record SET F_Equalled = 0, F_Active =1, F_RecordValue = @RecordValue 
			WHERE F_RecordID = @RecordID AND F_IsNewCreated =1
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Return=-1
			RETURN
		END
		
		UPDATE TS_Event_Record SET  F_Active = 0 
			WHERE F_RecordID = (SELECT TOP 1 F_RecordID  FROM TS_Event_Record 
							WHERE ISNULL(F_SubEventCode,'0') = @SubCode  AND F_RecordID != @RecordID  ORDER BY F_RecordValue DESC )
			
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Return=-1
			RETURN
		END
		
	SET @Return = 2
	
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	RETURN


SET NOCOUNT OFF
END

GO


