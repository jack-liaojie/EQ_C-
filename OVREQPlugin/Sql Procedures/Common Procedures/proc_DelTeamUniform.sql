IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelTeamUniform]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelTeamUniform]
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






----�洢�������ƣ�[proc_DelTeamUniform]
----��		  �ܣ�ɾ��һ������Ķӷ�
----��		  �ߣ�����
----��		  ��: 2009-04-24

CREATE PROCEDURE [dbo].[proc_DelTeamUniform] 
						@RegisterID         INT,
						@UniformID			INT,
						@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ��TeamUniformʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��TeamUniform�ɹ���
					-- @Result=-1; 	ɾ��TeamUniformʧ�ܣ���RegisterID��Ч
                    -- @Result=-2; 	ɾ��TeamUniformʧ�ܣ���UniformID��Ч
                    -- @Result=-3;  ɾ��TeamUniformʧ�ܣ���Uniform�ѱ�ʹ��
	
	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF NOT EXISTS(SELECT F_UniformID FROM TR_Uniform WHERE F_RegisterID = @RegisterID)
    BEGIN
        SET @Result = -2
        RETURN
    END
	
    IF EXISTS(SELECT F_UniformID FROM TS_Match_Result WHERE F_RegisterID = @RegisterID AND F_UniformID = @UniformID)
    BEGIN
        SET @Result = -2
        RETURN
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TR_Uniform WHERE F_RegisterID = @RegisterID AND F_UniformID = @UniformID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

set ANSI_NULLS OFF
set QUOTED_IDENTIFIER OFF
go

