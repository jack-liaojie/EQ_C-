/****** Object:  StoredProcedure [dbo].[proc_DeleteRecord]    Script Date: 11/11/2009 19:05:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DeleteRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DeleteRecord]
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteRecord]    Script Date: 11/11/2009 18:43:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_DeleteRecord]
----功		  能：删除Record
----作		  者：郑金勇 
----日		  期: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_DeleteRecord]
	@RecordID     			INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Record失败，标示没有做任何操作！
					  -- @Result=1; 	删除Record成功！

	IF NOT EXISTS(SELECT F_RecordID FROM TS_Event_Record WHERE F_RecordID = @RecordID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_Record_Values WHERE F_RecordID = @RecordID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Record_Member WHERE F_RecordID = @RecordID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Event_Record WHERE F_RecordID = @RecordID

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