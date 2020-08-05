if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdatePhaseRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdatePhaseRegister]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdatePhaseRegister]
----功		  能：更改小组赛的签位
----作		  者：郑金勇 
----日		  期: 2009-04-17

CREATE PROCEDURE [dbo].[Proc_UpdatePhaseRegister] (	
	@PhaseID					INT,
	@PhasePosition		INT,
	@RegisterID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	编辑Sport失败，标示没有做任何操作！
					-- @Result = 1; 	编辑Sport成功！

	IF (@RegisterID = -2 OR @RegisterID = 0)
	BEGIN
		SET @RegisterID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Phase_Position SET F_RegisterID = @RegisterID 
			WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @PhasePosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		UPDATE TS_Match_Result SET F_RegisterID = @RegisterID
			WHERE F_StartPhaseID = @PhaseID AND F_StartPhasePosition = @PhasePosition

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
SET ANSI_NULLS ON 
GO

