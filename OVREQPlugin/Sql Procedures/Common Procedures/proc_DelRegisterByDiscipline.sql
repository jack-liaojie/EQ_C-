IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelRegisterByDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelRegisterByDiscipline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[proc_DelRegisterByDiscipline]
----��		  �ܣ�ɾ��һ��Discipline�µ������˶�Ա
----��		  �ߣ�֣����
----��		  ��: 2009-04-16 

CREATE PROCEDURE [dbo].[proc_DelRegisterByDiscipline] 
	@DisciplineID			    INT,
	@Result 					AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ���˶�Աʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ���˶�Ա�ɹ���
					-- @Result=-1; 	ɾ���˶�Աʧ�ܣ���@DisciplineID��Ч
                    -- @Result=-2;  ɾ���˶�Աʧ�ܣ���@DisciplineID�µ��˶�Ա�Ѿ��вμӱ�������
	
	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF EXISTS(SELECT F_RegisterID FROM TS_Match_Split_Result WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID))
    BEGIN
        SET @Result = -2
        RETURN
    END
	
    IF EXISTS(SELECT F_RegisterID FROM TS_Match_Result WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID))
    BEGIN
        SET @Result = -2
        RETURN
    END

    IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Result WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID))
    BEGIN
        SET @Result = -2
        RETURN
    END

    IF EXISTS(SELECT F_RegisterID FROM TS_Event_Result WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID))
    BEGIN
        SET @Result = -2
        RETURN
    END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_ActiveFederation WHERE F_DisciplineID = @DisciplineID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Inscription WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Member WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Des WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Uniform WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Comment WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO