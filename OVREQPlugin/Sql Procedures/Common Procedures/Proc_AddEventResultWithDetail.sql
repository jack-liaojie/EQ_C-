IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddEventResultWithDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddEventResultWithDetail]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_AddEventResultWithDetail]
----功		  能：TS_Event_Result中添加一条记录
----作		  者：郑金勇
----日		  期: 2009-09-09 

CREATE PROCEDURE [dbo].[Proc_AddEventResultWithDetail]
    @EventID				INT,
	@EventRank			    INT,
	@SourcePhaseID		    INT,
	@SourcePhaseRank		INT, 
	@SourceMatchID		    INT, 
	@SourceMatchRank		INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功,返回EventResultID
                      -- @Result = -1; 	添加失败，该EventID不存在

    IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
    BEGIN
      SET @Result = -1
      RETURN
    END

	DECLARE @EventResultID AS INT
    SELECT @EventResultID = (CASE WHEN MAX(F_EventResultNumber) IS NULL THEN 0 ELSE MAX(F_EventResultNumber) END) + 1 FROM TS_Event_Result WHERE F_EventID = @EventID

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Event_Result (F_EventID, F_EventResultNumber, F_EventRank, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank) 
				VALUES (@EventID, @EventResultID, @EventRank, @SourcePhaseID, @SourcePhaseRank, @SourceMatchID, @SourceMatchRank)


		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @EventResultID
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO