IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelRegisterByDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelRegisterByDiscipline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_DelRegisterByDiscipline]
----功		  能：删除一个Discipline下的所有运动员
----作		  者：郑金勇
----日		  期: 2009-04-16 

CREATE PROCEDURE [dbo].[proc_DelRegisterByDiscipline] 
	@DisciplineID			    INT,
	@Result 					AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除运动员失败，标示没有做任何操作！
					-- @Result=1; 	删除运动员成功！
					-- @Result=-1; 	删除运动员失败，该@DisciplineID无效
                    -- @Result=-2;  删除运动员失败，该@DisciplineID下的运动员已经有参加比赛的了
	
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
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_ActiveFederation WHERE F_DisciplineID = @DisciplineID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Inscription WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Member WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Des WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Uniform WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Comment WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO