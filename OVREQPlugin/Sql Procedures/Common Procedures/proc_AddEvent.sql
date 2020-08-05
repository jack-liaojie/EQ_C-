if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddEvent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddEvent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_AddEvent
----功		  能：添加一个Event，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09 

CREATE PROCEDURE proc_AddEvent 
	@DisciplineID		INT,
	@EventCode			NVARCHAR(10),
	@OpenDate			DATETIME,
	@CloseDate			DATETIME,
	@Order				INT,
	@SexCode			INT,
	@PlayerRegTypeID	INT,
	@EventInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@EventLongName		NVARCHAR(100),
	@EventShortName		NVARCHAR(50),
	@EventComment		NVARCHAR(100),
	@CompetitionType	INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Event失败，标示没有做任何操作！
					-- @Result>=1; 	添加Event成功！此值即为EventID
					-- @Result=-1; 	添加Event失败，@DisciplineID无效
	DECLARE @NewEventID AS INT	

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Event WHERE F_DisciplineID = @DisciplineID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Event (F_DisciplineID, F_EventCode, F_OpenDate, F_CloseDate, F_Order, F_SexCode, F_EventInfo, F_PlayerRegTypeID, F_CompetitionTypeID)
			VALUES (@DisciplineID, @EventCode, @OpenDate, @CloseDate, @Order, @SexCode, @EventInfo, @PlayerRegTypeID, @CompetitionType)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewEventID = @@IDENTITY

		insert into TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName, F_EventComment)
			VALUES (@NewEventID, @languageCode, @EventLongName, @EventShortName, @EventComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewEventID
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

