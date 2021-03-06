IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddPhaseCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddPhaseCompetitors]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[proc_AddPhaseCompetitors]
----功		  能：将Event中的运动员选择到Phase中
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_AddPhaseCompetitors]
	@EventID			INT,
    @PhaseID			INT,
    @NodeType			INT,
    @RegisterID		    INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加运动员失败，标示没有做任何操作！
					  -- @Result=1; 	添加运动员成功！

	IF NOT EXISTS(SELECT @EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = 0
		RETURN
	END

    IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = 0
		RETURN
	END

	IF @NodeType = -1
	BEGIN
		IF EXISTS(SELECT F_RegisterID FROM TS_Event_Competitors WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID)
		BEGIN
			SET @Result = 0
			RETURN
		END
		
		INSERT INTO TS_Event_Competitors (F_EventID, F_RegisterID) VALUES (@EventID, @RegisterID)
	END
	ELSE IF @NodeType = 0
	BEGIN
	
		IF NOT EXISTS(SELECT @PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
		BEGIN
			SET @Result = 0
			RETURN
		END
	
	    IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID)
		BEGIN
			SET @Result = 0
			RETURN
		END
		
		INSERT INTO TS_Phase_Competitors (F_PhaseID, F_RegisterID) VALUES (@PhaseID, @RegisterID)
		SET @Result = 1
	END

    
	RETURN

SET NOCOUNT OFF
END

GO

