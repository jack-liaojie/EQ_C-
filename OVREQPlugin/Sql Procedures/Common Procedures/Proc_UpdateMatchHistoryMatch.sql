if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchHistoryMatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchHistoryMatch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdateMatchHistoryMatch]
----功		  能：更改HistoryMatch
----作		  者：郑金勇 
----日		  期: 2009-09-16

CREATE PROCEDURE [dbo].[Proc_UpdateMatchHistoryMatch] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@HistoryMatchID				INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	IF @HistoryMatchID = -1 OR @HistoryMatchID = 0
	BEGIN
		SET @HistoryMatchID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Match_Result SET F_HistoryMatchID = @HistoryMatchID 
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

