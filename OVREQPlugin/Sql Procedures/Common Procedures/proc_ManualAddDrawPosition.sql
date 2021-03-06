IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ManualAddDrawPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_ManualAddDrawPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_ManualAddDrawPosition]
----功		  能：手动添加一个赛事阶段的签位信息
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_ManualAddDrawPosition]
	@EventID				INT,
	@PhaseID				INT,
	@NodeType				INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					-- @Result = 1; 	添加成功！

	IF @NodeType = -1
	BEGIN
	
		IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
			BEGIN
				SET @Result = 0
				RETURN
			END

		DECLARE @EventPosition AS INT
		SELECT @EventPosition = ISNULL(MAX(F_EventPosition), 0) + 1 FROM TS_Event_Position WHERE F_EventID = @EventID
		INSERT INTO TS_Event_Position(F_EventID, F_EventPosition) VALUES (@EventID, @EventPosition)
		SET @Result = SCOPE_IDENTITY()
	
	END
	ELSE
	BEGIN
		
		IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
			BEGIN
				SET @Result = 0
				RETURN
			END

		DECLARE @PhasePosition AS INT
		SELECT @PhasePosition = ISNULL(MAX(F_PhasePosition), 0) + 1 FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID 
		INSERT INTO TS_Phase_Position(F_PhaseID, F_PhasePosition) VALUES (@PhaseID, @PhasePosition)
	    
		SET @Result = SCOPE_IDENTITY()
	END

	RETURN

SET NOCOUNT OFF
END

GO

