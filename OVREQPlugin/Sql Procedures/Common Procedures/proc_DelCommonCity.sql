IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCommonCity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCommonCity]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_DelCommonCity]
----功		  能：删除没有用到的所有的City(CommonCode导入)
----作		  者：张翠霞 
----日		  期: 2011-01-17

CREATE PROCEDURE [dbo].[proc_DelCommonCity] 
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除City失败，标示没有做任何操作！
					-- @Result=1; 	删除City成功！
	

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    DELETE FROM TC_City_Des WHERE F_CityID NOT IN (SELECT F_CityID FROM TC_Venue WHERE F_CityID IS NOT NULL)
    AND F_CityID NOT IN (SELECT F_CityID FROM TC_City WHERE F_CityCode = 'SZR')

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    DELETE FROM TC_City WHERE F_CityID NOT IN (SELECT F_CityID FROM TC_Venue WHERE F_CityID IS NOT NULL)
    AND F_CityID NOT IN (SELECT F_CityID FROM TC_City WHERE F_CityCode = 'SZR')

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


