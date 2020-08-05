IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_SetRecordRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_SetRecordRegister]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [proc_SetRecordRegister]
--��    ��: ָ����¼�Ĵ����ߺͼ�¼�ı�����
--����˵��: 
--˵    ��: 
--�� �� ��: ֣����
--��    ��: 2010��12��30��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[proc_SetRecordRegister]
	@RecordID			INT,
	@RegisterID			INT,
	@Result				INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	ָ��ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	ָ���ɹ���

	
	IF NOT EXISTS(SELECT F_RecordID FROM TS_Event_Record WHERE F_RecordID = @RecordID)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = 0
		RETURN
	END

	UPDATE TS_Event_Record SET F_RegisterID = @RegisterID WHERE F_RecordID = @RecordID
	SET @Result = 1

	RETURN
SET NOCOUNT OFF
END

GO


