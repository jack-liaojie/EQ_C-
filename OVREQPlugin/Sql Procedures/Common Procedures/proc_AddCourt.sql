IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCourt]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_AddCourt]
----功		  能：添加一个Court
----作		  者：张翠霞 
----日		  期: 2009-04-16 
----修改  王强  2012-09-14  增加F_Order
CREATE PROCEDURE [dbo].[proc_AddCourt]
    @VenueID			NVARCHAR(10),
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

	SET @Result = 0;  -- @Result=0; 	添加Court失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Court成功！此值即为CourtID
                      -- @Result=-1;    添加Court失败，@VenueID无效  
                      -- @Result=-2;    添加Court失败，@CourtCode已存在  

	DECLARE @NewCourtID AS INT

    IF @VenueID IS NOT NULL
    BEGIN
       IF NOT EXISTS(SELECT F_VenueID FROM TC_Venue WHERE F_VenueID = @VenueID)
	   BEGIN
			SET @Result=-1
			RETURN
	   END
       IF EXISTS(SELECT F_CourtID FROM TC_Court WHERE F_VenueID = @VenueID AND F_CourtCode = @CourtCode)
       BEGIN
            SET @Result=-2
			RETURN
       END
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_Court (F_VenueID, F_CourtCode, F_Order) VALUES (@VenueID, @CourtCode,@CourtOrder)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewCourtID = @@IDENTITY

        INSERT INTO TC_Court_Des (F_CourtID, F_LanguageCode, F_CourtLongName, F_CourtShortName, F_CourtComment) VALUES(@NewCourtID, @LanguageCode, @CourtLongName, @CourtShortName, @CourtComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewCourtID
	RETURN

SET NOCOUNT OFF
END

