IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCommonCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCommonCourt]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_AddCommonCourt]
----功		  能：添加一个Court(CommonCode数据)
----作		  者：张翠霞 
----日		  期: 20011-01-17 

CREATE PROCEDURE [dbo].[proc_AddCommonCourt]
    @VenueCode			NVARCHAR(50),
    @CourtCode          NVARCHAR(10),
    @LanguageCode		CHAR(3),
	@CourtLongName		NVARCHAR(50),
	@CourtShortName		NVARCHAR(50),
	@CourtComment		NVARCHAR(50),
	@DisciplineCode		CHAR(2),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Court失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Court成功！此值即为CourtID
                      -- @Result=-1; 	添加Court失败！场馆不存在


	DECLARE @VenueID AS INT
    DECLARE @CourtID AS INT
    DECLARE @DisciplineID AS INT

    IF EXISTS(SELECT F_VenueID FROM TC_Venue WHERE F_VenueCode = @VenueCode)
    BEGIN
        SELECT TOP 1 @VenueID = F_VenueID FROM TC_Venue WHERE F_VenueCode = @VenueCode
    END
    ELSE
    BEGIN
        SET @Result = -1
        RETURN
    END

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS(SELECT F_CourtID FROM TC_Court WHERE F_CourtCode = @CourtCode)
    BEGIN
        SELECT TOP 1 @CourtID = F_CourtID FROM TC_Court WHERE F_CourtCode = @CourtCode
        UPDATE TC_Court SET F_VenueID = @VenueID WHERE F_CourtID = @CourtID AND F_CourtCode = @CourtCode
    END
    ELSE
    BEGIN
        INSERT INTO TC_Court (F_VenueID, F_CourtCode) VALUES (@VenueID, @CourtCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @CourtID = @@IDENTITY
    END

        DELETE FROM TC_Court_Des WHERE F_CourtID = @CourtID AND F_LanguageCode = @LanguageCode

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TC_Court_Des (F_CourtID, F_LanguageCode, F_CourtLongName, F_CourtShortName, F_CourtComment) VALUES(@CourtID, @LanguageCode, @CourtLongName, @CourtShortName, @CourtComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
	IF EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode)
    BEGIN
        SELECT TOP 1 @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
        
        IF NOT EXISTS(SELECT F_VenueID FROM TD_Discipline_Venue WHERE F_DisciplineID = @DisciplineID AND F_VenueID = @VenueID)
        BEGIN
            INSERT INTO TD_Discipline_Venue (F_DisciplineID, F_VenueID) VALUES(@DisciplineID, @VenueID)
            
            IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
        END
    END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @CourtID
	RETURN

SET NOCOUNT OFF
END

GO


