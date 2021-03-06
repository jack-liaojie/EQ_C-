IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_DelRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_DelRound]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



----存储过程名称：[Proc_Schedule_DelRound]
----功		  能：删除一个Round，
----作		  者：郑金勇 
----日		  期: 2009-04-09
--修改记录：
/*			
			时间				修改人		修改内容
			2009年11月12日		邓年彩		修改存储过程名称, proc_DelRound->Proc_Schedule_DelRound		
*/


CREATE PROCEDURE [dbo].[Proc_Schedule_DelRound] 
	@RoundID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Round失败，标示没有做任何操作！
					-- @Result=1; 	删除Round成功！
					-- @Result=-1; 	删除Round失败，该RoundID无效
					-- @Result=-2; 	删除Round失败，该Round下已经有Match了
	IF NOT EXISTS(SELECT F_RoundID FROM TS_Round WHERE F_RoundID = @RoundID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_RoundID = @RoundID)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
		DELETE FROM TS_Round_Des WHERE F_RoundID = @RoundID 
		IF @@error <> 0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Round WHERE F_RoundID = @RoundID 
		IF @@error <> 0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END





