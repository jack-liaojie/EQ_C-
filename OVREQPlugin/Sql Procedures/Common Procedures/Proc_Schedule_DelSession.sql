IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_DelSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_DelSession]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Schedule_DelSession]
----功		  能：删除一个Session
----作		  者：郑金勇 
----日		  期: 2009-04-16 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年11月12日		邓年彩		修改存储过程名称, proc_DelSession->Proc_Schedule_DelSession		
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_DelSession] 
	@SessionID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Session失败，标示没有做任何操作！
					-- @Result=1; 	删除Session成功！
					-- @Result=-1; 	删除Session失败，该@SessionID无效
					-- @Result=-2; 	删除Session失败，有比赛属于该Session的有,不允许删除
	

	IF NOT EXISTS(SELECT F_SessionID FROM TS_Session WHERE F_SessionID = @SessionID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_SessionID = @SessionID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_Session WHERE F_SessionID = @SessionID 
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




