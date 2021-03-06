IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCommonEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCommonEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：proc_AddCommonEvent
----功		  能：添加一个Event，根据CommonCode
----作		  者：张翠霞
----日		  期: 2011-01-20 

CREATE PROCEDURE [dbo].[proc_AddCommonEvent]
    @DisciplineCode     CHAR(2),
	@EventCode			NVARCHAR(10),
	@GenderCode			NVARCHAR(10),
	@languageCode		CHAR(3),
	@EventLongName		NVARCHAR(100),
	@EventShortName		NVARCHAR(50),
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
    DECLARE @Order AS INT

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode)
	BEGIN
		SET @Result = -1
		RETURN
	END
    ELSE
    BEGIN
        SELECT TOP 1 @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
    END

	SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Event WHERE F_DisciplineID = @DisciplineID

    IF NOT EXISTS(SELECT F_SexCode FROM TC_Sex WHERE F_GenderCode = @GenderCode)
    BEGIN
		SET @Result = -2
		RETURN
	END
    ELSE
    BEGIN
        SELECT TOP 1 @SexCode = F_SexCode FROM TC_Sex WHERE F_GenderCode = @GenderCode
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS (SELECT F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_EventCode = @EventCode AND F_SexCode = @SexCode)
    BEGIN
        SELECT @EventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_EventCode = @EventCode AND F_SexCode = @SexCode
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

		INSERT INTO TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName)
			VALUES (@EventID, @languageCode, @EventLongName, @EventShortName)

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


