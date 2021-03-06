IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_AddSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_AddSession]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----存储过程名称：[Proc_Schedule_AddSession]
----功		  能：添加一个Session，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-16 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年11月10日		邓年彩		添加 F_SessionEnd 字段		
			2009年11月12日		邓年彩		修改存储过程名称, proc_AddSession->Proc_Schedule_AddSession	
			2010年6月23日		邓年彩		若 SessionNumber 按照一个大项来排, 而不是按照一天.
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_AddSession]
    @DisciplineID       INT,
	@SessionDate		DATETIME,
	@SessionNumber		INT,
	@SessionTime		DATETIME,
	@SessionEndTime		DATETIME,
	@SeesionTypeID		INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Session失败，标示没有做任何操作！
					-- @Result>=1; 	添加Session成功！此值即为SessionID
					-- @Result=-1; 	添加Session失败, @SeesionTypeID 无效
                    -- @Result=-2; 	添加Session失败, @DisciplineID 无效
	DECLARE @NewSessionID AS INT

    IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF NOT EXISTS(SELECT F_SessionTypeID FROM TC_SessionType WHERE F_SessionTypeID = @SeesionTypeID)
	BEGIN
		SET @SeesionTypeID = NULL
--		SET @Result = -1
--		RETURN
	END


	IF @SessionNumber = 0 OR @SessionNumber IS NULL
	BEGIN
		SELECT @SessionNumber = (CASE WHEN MAX(F_SessionNumber) IS NULL THEN 0 ELSE MAX(F_SessionNumber) END) + 1 FROM TS_Session WHERE F_DisciplineID = @DisciplineID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Session (F_DisciplineID, F_SessionDate, F_SessionNumber, F_SessionTime, F_SessionEndTime, F_SessionTypeID)
			VALUES (@DisciplineID, @SessionDate, @SessionNumber, @SessionTime, @SessionEndTime, @SeesionTypeID)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewSessionID = @@IDENTITY

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewSessionID
	RETURN

SET NOCOUNT OFF
END
GO

set ANSI_NULLS OFF
set QUOTED_IDENTIFIER OFF
go
