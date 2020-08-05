if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchSourcePhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchSourcePhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdateMatchSourcePhase]
----功		  能：更改SoucePhase
----作		  者：郑金勇 
----日		  期: 2009-04-19

CREATE PROCEDURE [dbo].[Proc_UpdateMatchSourcePhase] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@SourcePhaseID				INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	IF @SourcePhaseID = -1 OR @SourcePhaseID = 0
	BEGIN
		SET @SourcePhaseID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Match_Result SET F_SourcePhaseID = @SourcePhaseID 
					WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
