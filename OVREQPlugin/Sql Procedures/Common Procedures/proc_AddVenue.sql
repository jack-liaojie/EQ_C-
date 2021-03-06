IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddVenue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddVenue]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_AddVenue]
----功		  能：添加一个Venue
----作		  者：张翠霞 
----日		  期: 2009-04-16 

CREATE PROCEDURE [dbo].[proc_AddVenue]
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

	SET @Result = 0;  -- @Result=0; 	添加Venue失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Venue成功！此值即为VenueID
					  -- @Result=-1; 	添加Venue失败, @CityID无效

	DECLARE @NewVenueID AS INT

    IF @CityID IS NOT NULL
    BEGIN
    IF NOT EXISTS(SELECT F_CityID FROM TC_City WHERE F_CityID = @CityID)
	BEGIN
		SET @Result = -1
		RETURN
	END
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_Venue (F_CityID, F_VenueCode) VALUES (@CityID, @VenueCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewVenueID = @@IDENTITY

        INSERT INTO TC_Venue_Des (F_VenueID, F_LanguageCode, F_VenueLongName, F_VenueShortName, F_VenueComment) VALUES(@NewVenueID, @LanguageCode, @VenueLongName, @VenueShortName, @VenueComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewVenueID
	RETURN

SET NOCOUNT OFF
END

GO


