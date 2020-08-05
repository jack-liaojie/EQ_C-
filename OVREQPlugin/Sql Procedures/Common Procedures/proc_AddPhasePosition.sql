IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddPhasePosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddPhasePosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[proc_AddPhasePosition]
----功		  能：为编排模型服务，添加一个赛事阶段的签位信息
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_AddPhasePosition]
	@PhaseID				INT,
	@PhasePosition		    INT,
	@StartPhaseID		    INT, 
	@StartPhasePosition		INT,
	@SourcePhaseID		    INT,
	@SourcePhaseRank		INT, 
	@SourceMatchID		    INT, 
	@SourceMatchRank		INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加位置失败，标示没有做任何操作！
					  -- @Result>=1; 	添加位置成功！为新的F_ItemID

	

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Phase_Position (F_PhaseID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank) 
			VALUES (@PhaseID, @PhasePosition, @StartPhaseID, @StartPhasePosition, @SourcePhaseID, @SourcePhaseRank, @SourceMatchID, @SourceMatchRank)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SET @Result = @@IDENTITY

	COMMIT TRANSACTION --成功提交事务

	RETURN

SET NOCOUNT OFF
END

GO



