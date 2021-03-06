IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelPhaseCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelPhaseCompetitors]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[proc_DelPhaseCompetitors]
----功		  能：移除Phase中已选择的运动员
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_DelPhaseCompetitors]
	@EventID			INT,
    @PhaseID			INT,
    @NodeType			INT,
    @RegisterID		    INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=-1; 	移除运动员失败，该运动员已经存在签位信息！
                      -- @Result=0; 	移除运动员失败！没有任何操作！
					  -- @Result=1; 	移除运动员成功！

	IF @NodeType = -1
	BEGIN
		IF EXISTS(SELECT F_EventPosition FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID)
		BEGIN
			SET @Result = -1
			RETURN
		END

		DELETE FROM TS_Event_Competitors WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID
		SET @Result = 1
	END
	ELSE IF @NodeType = 0
	BEGIN
		IF EXISTS(SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID)
		BEGIN
			SET @Result = -1
			RETURN
		END

		DELETE FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID
		SET @Result = 1
	END


    
	RETURN

SET NOCOUNT OFF
END

GO


