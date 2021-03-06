IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_DeleteAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_DeleteAction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_HO_DeleteAction]
----功		  能：删除一个Action
----作		  者：张翠霞 
----日		  期: 2012-08-30

CREATE PROCEDURE [dbo].[Proc_HO_DeleteAction] 
	@ActionID			    INT,
	@Result 			    AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Action失败，标示没有做任何操作！
					-- @Result=1; 	删除Action成功！
					-- @Result=-1; 	删除Action失败，该@ActionID无效
           
	
	IF NOT EXISTS(SELECT F_ActionNumberID  FROM TS_Match_ActionList WHERE F_ActionNumberID = @ActionID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_Match_ActionList WHERE F_ActionNumberID = @ActionID

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


