/****** Object:  StoredProcedure [dbo].[Proc_DelClub]    Script Date: 11/11/2009 13:39:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelClub]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DelClub]    Script Date: 11/11/2009 13:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_DelClub]
----功		  能：删除一个Club
----作		  者：张翠霞 
----日		  期: 2009-05-20 

CREATE PROCEDURE [dbo].[Proc_DelClub] 
	@ClubID			    INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Club失败，标示没有做任何操作！
					-- @Result=1; 	删除Club成功！
					-- @Result=-1; 	删除Club失败，该@ClubID无效
                    -- @Result=-2;  删除Club失败，该Club下有运动员存在
	
	IF NOT EXISTS(SELECT F_CLubID FROM TC_CLub WHERE F_CLubID = @ClubID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF EXISTS(SELECT F_CLubID FROM TR_Register WHERE F_CLubID = @ClubID)
    BEGIN
        SET @Result = -2
        RETURN
    END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Club_Des WHERE F_CLubID = @ClubID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DELETE FROM TS_ActiveClub WHERE F_CLubID = @ClubID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DELETE FROM TC_CLub WHERE F_CLubID = @ClubID

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

