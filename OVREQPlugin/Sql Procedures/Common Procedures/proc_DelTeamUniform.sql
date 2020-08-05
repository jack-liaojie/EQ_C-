IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelTeamUniform]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelTeamUniform]
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






----存储过程名称：[proc_DelTeamUniform]
----功		  能：删除一个队伍的队服
----作		  者：李燕
----日		  期: 2009-04-24

CREATE PROCEDURE [dbo].[proc_DelTeamUniform] 
						@RegisterID         INT,
						@UniformID			INT,
						@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除TeamUniform失败，标示没有做任何操作！
					-- @Result=1; 	删除TeamUniform成功！
					-- @Result=-1; 	删除TeamUniform失败，该RegisterID无效
                    -- @Result=-2; 	删除TeamUniform失败，该UniformID无效
                    -- @Result=-3;  删除TeamUniform失败，该Uniform已被使用
	
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
	BEGIN TRANSACTION --设定事务

		DELETE FROM TR_Uniform WHERE F_RegisterID = @RegisterID AND F_UniformID = @UniformID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

set ANSI_NULLS OFF
set QUOTED_IDENTIFIER OFF
go

