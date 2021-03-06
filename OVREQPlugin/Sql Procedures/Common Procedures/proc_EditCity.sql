/****** Object:  StoredProcedure [dbo].[proc_EditCity]    Script Date: 11/16/2009 16:32:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditCity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditCity]
GO
/****** Object:  StoredProcedure [dbo].[proc_EditCity]    Script Date: 11/16/2009 16:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_EditCity]
----功		  能：修改一个City
----作		  者：张翠霞 
----日		  期: 2009-04-16 

----修 改 记  录: 2009-11-16
----修    改  人：李燕
----修 改 内  容：增加另一种语言的描述信息

CREATE PROCEDURE [dbo].[proc_EditCity]
    @CityID             INT,
    @CityCode			NVARCHAR(10),
    @LanguageCode		CHAR(3),
	@CityLongName		NVARCHAR(50),
	@CityShortName		NVARCHAR(50),
	@CityComment		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改City失败，标示没有做任何操作！
					  -- @Result>=1; 	修改City成功！
					  -- @Result=-1; 	修改City失败, @CityID无效	

	IF NOT EXISTS(SELECT F_CityID FROM TC_City WHERE F_CityID = @CityID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        UPDATE TC_City SET F_CityCode = @CityCode WHERE F_CityID = @CityID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
       
         IF NOT EXISTS (SELECT F_CityID FROM TC_City_Des WHERE F_CityID = @CityID AND F_LanguageCode = @LanguageCode)
		 BEGIN
			  INSERT INTO TC_City_Des (F_CityID, F_LanguageCode, F_CityLongName, F_CityShortName, F_CityComment)
				VALUES (@CityID, @LanguageCode, @CityLongName, @CityShortName, @CityComment)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TC_City_Des SET F_LanguageCode = @LanguageCode, F_CityLongName = @CityLongName, F_CityShortName = @CityShortName, F_CityComment = @CityComment WHERE F_CityID = @CityID AND F_LanguageCode = @LanguageCode
	   
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
         END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

