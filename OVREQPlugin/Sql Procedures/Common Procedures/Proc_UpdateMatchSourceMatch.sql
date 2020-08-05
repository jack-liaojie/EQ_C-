if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchSourceMatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchSourceMatch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdateMatchSourceMatch]
----功		  能：更改SouceMatch
----作		  者：郑金勇 
----日		  期: 2009-04-19

CREATE PROCEDURE [dbo].[Proc_UpdateMatchSourceMatch] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@SourceMatchID				INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	IF @SourceMatchID = -1 OR @SourceMatchID = 0
	BEGIN
		SET @SourceMatchID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Match_Result SET F_SourceMatchID = @SourceMatchID 
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

