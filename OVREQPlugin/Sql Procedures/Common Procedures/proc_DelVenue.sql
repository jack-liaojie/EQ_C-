IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelVenue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelVenue]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[proc_DelVenue]
----功		  能：删除一个Venue
----作		  者：张翠霞 
----日		  期: 2009-04-16 

CREATE PROCEDURE [dbo].[proc_DelVenue] 
	@VenueID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Venue失败，标示没有做任何操作！
					-- @Result=1; 	删除Venue成功！
					-- @Result=-1; 	删除Venue失败，该@VenueID无效
                    -- @Result=-2;  删除Venue失败，Venue下有Court存在
                    -- @Result=-3;  删除Venue失败，有比赛用到，不能删除
	
	IF NOT EXISTS(SELECT F_VenueID FROM TC_Venue WHERE F_VenueID = @VenueID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF EXISTS(SELECT F_VenueID FROM TC_Court WHERE F_VenueID = @VenueID)
    BEGIN
       SET @Result = -2
       RETURN
    END
    
    IF EXISTS(SELECT F_VenueID FROM TS_Match WHERE F_VenueID = @VenueID)
    BEGIN
       SET @Result = -3
       RETURN
    END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Venue_Des WHERE F_VenueID = @VenueID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TD_Discipline_Venue WHERE F_VenueID = @VenueID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_Venue WHERE F_VenueID = @VenueID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


