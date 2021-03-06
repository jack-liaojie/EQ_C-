IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCountry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCountry]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_DelCountry]
----功		  能：删除Country
----作		  者：张翠霞 
----日		  期: 2009-10-10 

CREATE PROCEDURE [dbo].[proc_DelCountry]
	@NOC			        CHAR(3),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Country失败，标示没有做任何操作！
					  -- @Result=1; 	删除Country成功！
					  -- @Result=-1;	删除Country失败，@NOC无效！
					  -- @Result=-2;	删除Country失败，@NOC被注册人员引用
                      -- @Result=-3;	删除Country失败，@NOC被记录人员引用

	IF NOT EXISTS(SELECT F_NOC FROM TC_Country WHERE F_NOC = @NOC)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF EXISTS(SELECT F_NOC FROM TR_Register WHERE F_NOC = @NOC)
	BEGIN
			SET @Result = -2
			RETURN
	END

    IF EXISTS(SELECT F_NOC FROM TS_Record_Member WHERE F_NOC = @NOC)
	BEGIN
			SET @Result = -3
			RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Country_Des WHERE F_NOC = @NOC

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DELETE FROM TS_ActiveNOC WHERE F_NOC = @NOC

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TC_Country WHERE F_NOC = @NOC

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


