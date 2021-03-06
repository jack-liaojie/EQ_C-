/****** Object:  StoredProcedure [dbo].[Proc_EditClub]    Script Date: 11/17/2009 14:06:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditClub]
GO
/****** Object:  StoredProcedure [dbo].[Proc_EditClub]    Script Date: 11/17/2009 14:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_EditClub]
----功		  能：修改一个Club
----作		  者：张翠霞 
----日		  期: 2009-05-20
----修 改 记  录: 2009-11-17
----修    改  人：李燕
----修 改 内  容：增加另一种语言的描述信息

CREATE PROCEDURE [dbo].[Proc_EditClub]
    @ClubID             INT,
    @ClubCode			NVARCHAR(10),
    @LanguageCode		CHAR(3),
	@ClubLongName		NVARCHAR(50),
	@ClubShortName		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改Club失败，标示没有做任何操作！
					  -- @Result>=1; 	修改Club成功！
					  -- @Result=-1; 	修改Club失败, @ClubID不存在

	IF NOT EXISTS(SELECT F_CLubID FROM TC_CLub WHERE F_CLubID = @ClubID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        UPDATE TC_CLub SET F_ClubCode = @ClubCode WHERE F_CLubID = @ClubID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
        
        
        IF NOT EXISTS (SELECT F_CLubID FROM TC_Club_Des WHERE F_CLubID = @ClubID AND F_LanguageCode = @LanguageCode)
		BEGIN
			INSERT INTO TC_Club_Des (F_CLubID, F_LanguageCode, F_ClubLongName, F_ClubShortName) 
               VALUES(@ClubID, @LanguageCode, @ClubLongName, @ClubShortName)
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
            UPDATE TC_Club_Des SET F_LanguageCode = @LanguageCode, F_ClubLongName = @ClubLongName, F_ClubShortName = @ClubShortName WHERE F_CLubID = @ClubID AND F_LanguageCode = @LanguageCode
        
   
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

