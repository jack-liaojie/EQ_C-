IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddRSCEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddRSCEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：proc_AddRSCEvent
----功		  能：添加一个Event，根据RSCCode
----作		  者：张翠霞
----日		  期: 2009-11-18 

CREATE PROCEDURE [dbo].[proc_AddRSCEvent]
    @DisciplineCode     CHAR(2),
	@EventCode			NVARCHAR(10),
	@Order				INT,
	@GenderCode			NVARCHAR(10),
	@languageCode		CHAR(3),
	@EventLongName		NVARCHAR(100),
	@EventShortName		NVARCHAR(50),
	@EventComment		NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Event失败，标示没有做任何操作！
					-- @Result>=1; 	添加Event成功！此值即为EventID
					-- @Result=-1; 	添加Event失败，没有有效的DisciplineID
                    -- @Result=-2; 	添加Event失败，没有有效的SexCode

    DECLARE @DisciplineID AS INT
	DECLARE @EventID AS INT
    DECLARE @SexCode AS INT

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode)
	BEGIN
		SET @Result = -1
		RETURN
	END
    ELSE
    BEGIN
        SELECT TOP 1 @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
    END

	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Event WHERE F_DisciplineID = @DisciplineID
	END

    IF NOT EXISTS(SELECT F_SexCode FROM TC_Sex WHERE F_GenderCode = @GenderCode)
    BEGIN
		SET @Result = -2
		RETURN
	END
    ELSE
    BEGIN
        SELECT TOP 1 @SexCode = F_SexCode FROM TC_Sex WHERE F_GenderCode = @GenderCode
    END

    IF @languageCode = 'CHI'
    BEGIN
        SET @languageCode = 'CHN'
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS (SELECT F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_EventCode = @EventCode AND F_SexCode = @SexCode)
    BEGIN
        SELECT @EventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_EventCode = @EventCode AND F_SexCode = @SexCode
        UPDATE TS_Event SET F_Order = @Order WHERE F_DisciplineID = @DisciplineID AND F_EventCode = @EventCode AND F_SexCode = @SexCode
    END
    ELSE
    BEGIN
        INSERT INTO TS_Event (F_DisciplineID, F_EventCode, F_Order, F_SexCode)
			VALUES (@DisciplineID, @EventCode, @Order, @SexCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @EventID = @@IDENTITY
    END

        DELETE FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @languageCode
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName, F_EventComment)
			VALUES (@EventID, @languageCode, @EventLongName, @EventShortName, @EventComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @EventID
	RETURN

SET NOCOUNT OFF
END

GO


