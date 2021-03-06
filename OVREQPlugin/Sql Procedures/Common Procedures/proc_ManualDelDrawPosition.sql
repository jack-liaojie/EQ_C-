IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ManualDelDrawPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_ManualDelDrawPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_ManualDelDrawPosition]
----功		  能：手动删除一个赛事阶段的签位信息
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_ManualDelDrawPosition]
	@ItemID				    INT,
	@NodeType				INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					-- @Result = 1; 	添加成功！

	IF @NodeType = -1
	BEGIN
	
		IF NOT EXISTS(SELECT F_ItemID FROM TS_Event_Position WHERE F_ItemID = @ItemID)
		BEGIN
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Event_Position WHERE F_ItemID = @ItemID

		SET @Result = 1
		
    END
	ELSE IF @NodeType = 0
	BEGIN
	
		IF NOT EXISTS(SELECT F_ItemID FROM TS_Phase_Position WHERE F_ItemID = @ItemID)
		BEGIN
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Phase_Position WHERE F_ItemID = @ItemID

		SET @Result = 1
		
	END

	RETURN

SET NOCOUNT OFF
END

GO

