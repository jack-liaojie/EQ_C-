IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCommonCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCommonCourt]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_DelCommonCourt]
----功		  能：删除所有的Court(CommonCode导入)
----作		  者：张翠霞 
----日		  期: 2011-01-17 

CREATE PROCEDURE [dbo].[proc_DelCommonCourt] 
        @Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;  -- @Result=0; 	删除Court失败，标示没有做任何操作！
					-- @Result=1; 	删除Court成功！
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Court_Des WHERE F_CourtID NOT IN (SELECT DISTINCT F_CourtID FROM TS_Match WHERE F_CourtID IS NOT NULL)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
            SET @Result=0
			RETURN
		END

        DELETE FROM TC_Court WHERE F_CourtID NOT IN (SELECT DISTINCT F_CourtID FROM TS_Match WHERE F_CourtID IS NOT NULL)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
            SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

    SET @Result=1
	RETURN

SET NOCOUNT OFF
END

GO


