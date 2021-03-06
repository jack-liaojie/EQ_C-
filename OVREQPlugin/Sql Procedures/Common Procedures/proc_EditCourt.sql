/****** Object:  StoredProcedure [dbo].[proc_EditCourt]    Script Date: 12/24/2009 16:55:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditCourt]
GO
/****** Object:  StoredProcedure [dbo].[proc_EditCourt]    Script Date: 12/24/2009 16:55:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_EditCourt]
----功		  能：更新一个Court
----作		  者：张翠霞 
----日		  期: 2009-04-16 

----修 改 记  录: 2009-11-16
----修    改  人：李燕
----修 改 内  容：增加另一种语言的描述信息
----修改：王强  2012-09-14 增加修改F_Order

CREATE PROCEDURE [dbo].[proc_EditCourt] 
	@CourtID			INT,
	@VenueID			INT,
    @LanguageCode		CHAR(3),
	@CourtLongName		NVARCHAR(50),
	@CourtShortName		NVARCHAR(50),
	@CourtComment		NVARCHAR(50),
    @CourtCode          NVARCHAR(10),
    @CourtOrder         INT,
	@Result 			AS INT OUTPUT

AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	更新Court失败，标示没有做任何操作！
					-- @Result=1; 	更新Court成功！
					-- @Result=-1; 	更新Court失败，该@CourtID无效
                    -- @Result=-2;  更新Court失败，该@VenueID无效
	
	IF NOT EXISTS(SELECT F_CourtID FROM TC_Court WHERE F_CourtID = @CourtID)
	BEGIN
		SET @Result = -1
		RETURN
	END


    IF @VenueID IS NOT NULL
    BEGIN
		IF NOT EXISTS(SELECT F_VenueID FROM TC_Venue WHERE F_VenueID = @VenueID)
		BEGIN
			SET @Result = -2
			RETURN
		END
        IF EXISTS(SELECT F_CourtID FROM TC_Court WHERE F_VenueID = @VenueID AND F_CourtCode = @CourtCode AND F_CourtID <> @CourtID)
        BEGIN
			SET @Result = -3
			RETURN
		END
    END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        UPDATE TC_Court SET F_VenueID = @VenueID, F_CourtCode = @CourtCode, F_Order = @CourtOrder WHERE F_CourtID = @CourtID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
        
         IF NOT EXISTS (SELECT F_CourtID FROM TC_Court_Des WHERE F_CourtID = @CourtID AND F_LanguageCode = @LanguageCode)
		 BEGIN
			  INSERT INTO TC_Court_Des (F_CourtID, F_LanguageCode, F_CourtLongName, F_CourtShortName, F_CourtComment)
				VALUES (@CourtID, @LanguageCode, @CourtLongName, @CourtShortName, @CourtComment)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
		     UPDATE TC_Court_Des SET F_languageCode = @LanguageCode, F_CourtLongName = @CourtLongName, F_CourtShortName = @CourtShortName, F_CourtComment = @CourtComment WHERE F_CourtID = @CourtID AND F_LanguageCode = @LanguageCode

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

