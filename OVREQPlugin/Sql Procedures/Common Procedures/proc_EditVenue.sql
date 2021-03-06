/****** Object:  StoredProcedure [dbo].[proc_EditVenue]    Script Date: 11/16/2009 15:22:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditVenue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditVenue]
GO
/****** Object:  StoredProcedure [dbo].[proc_EditVenue]    Script Date: 11/16/2009 15:15:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_EditVenue]
----功		  能：更新一个Venue
----作		  者：张翠霞 
----日		  期: 2009-04-16 

----修 改 记  录: 2009-11-16
----修    改  人：李燕
----修 改 内  容：增加另一种语言的描述信息

CREATE PROCEDURE [dbo].[proc_EditVenue] 
	@VenueID			INT,
	@VenueCode			NVARCHAR(50),
    @CityID             INT,
    @LanguageCode		CHAR(3),
	@VenueLongName		NVARCHAR(50),
	@VenueShortName		NVARCHAR(50),
	@VenueComment		NVARCHAR(50),
	@Result 			AS INT OUTPUT

AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	更新Venue失败，标示没有做任何操作！
					-- @Result=1; 	更新Venue成功！
					-- @Result=-1; 	更新Venue失败，该@VenueID无效
                    -- @Result=-2;  更新Venue失败，该@CityID无效
	

	IF NOT EXISTS(SELECT F_VenueID FROM TC_Venue WHERE F_VenueID = @VenueID)
	BEGIN
		SET @Result = -1
		RETURN
	END


    IF @CityID IS NOT NULL
    BEGIN
    IF NOT EXISTS(SELECT F_CityID FROM TC_City WHERE F_CityID = @CityID)
	BEGIN
		SET @Result = -2
		RETURN
	END
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        UPDATE TC_Venue SET F_CityID = @CityID, F_VenueCode = @VenueCode WHERE F_VenueID = @VenueID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

       IF NOT EXISTS (SELECT F_VenueID FROM TC_Venue_Des WHERE F_VenueID = @VenueID AND F_LanguageCode = @LanguageCode)
	   BEGIN
			SELECT F_VenueID FROM TC_Venue_Des WHERE F_VenueID = @VenueID AND F_LanguageCode = @LanguageCode
			INSERT INTO TC_Venue_Des (F_VenueID, F_LanguageCode, F_VenueLongName, F_VenueShortName, F_VenueComment)
				VALUES (@VenueID, @LanguageCode, @VenueLongName, @VenueShortName, @VenueComment)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TC_Venue_Des SET F_LanguageCode = @LanguageCode, F_VenueLongName = @VenueLongName, F_VenueShortName = @VenueShortName, F_VenueComment = @VenueComment WHERE F_VenueID = @VenueID AND F_LanguageCode = @LanguageCode

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
GO





