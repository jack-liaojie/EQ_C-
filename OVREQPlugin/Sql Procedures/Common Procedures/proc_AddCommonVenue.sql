IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCommonVenue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCommonVenue]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_AddCommonVenue]
----功		  能：添加一个Venue(CommonCode数据)
----作		  者：张翠霞 
----日		  期: 2011-01-17 

CREATE PROCEDURE [dbo].[proc_AddCommonVenue]
    @VenueCode			NVARCHAR(10),
    @LanguageCode		CHAR(3),
	@VenueLongName		NVARCHAR(100),
	@VenueShortName		NVARCHAR(100),
	@VenueComment		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Venue失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Venue成功！此值即为VenueID
                      -- @Result=-1; 	添加Venue失败！城市不存在


	DECLARE @VenueID AS INT
    DECLARE @CityID AS INT
    

    IF EXISTS(SELECT F_CityID FROM TC_City WHERE F_CityCode = 'SZR')
    BEGIN
        SELECT @CityID = F_CityID FROM TC_City WHERE F_CityCode = 'SZR'
    END
    ELSE
    BEGIN
        SET @Result = -1
        RETURN
    END

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS(SELECT F_VenueID FROM TC_Venue WHERE F_VenueCode = @VenueCode)
    BEGIN
        SELECT TOP 1 @VenueID = F_VenueID FROM TC_Venue WHERE F_VenueCode = @VenueCode
        UPDATE TC_Venue SET F_CityID = @CityID WHERE F_VenueID = @VenueID AND F_VenueCode = @VenueCode
    END
    ELSE
    BEGIN
        INSERT INTO TC_Venue (F_CityID, F_VenueCode) VALUES (@CityID, @VenueCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @VenueID = @@IDENTITY
    END

        DELETE FROM TC_Venue_Des WHERE F_VenueID = @VenueID AND F_LanguageCode = @LanguageCode

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TC_Venue_Des (F_VenueID, F_LanguageCode, F_VenueLongName, F_VenueShortName, F_VenueComment) VALUES(@VenueID, @LanguageCode, @VenueLongName, @VenueShortName, @VenueComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @VenueID
	RETURN

SET NOCOUNT OFF
END

GO


