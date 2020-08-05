IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelMatchModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelMatchModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_DelMatchModel]
--描    述：删除一Match的晋级方案模型
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年12月10日



CREATE PROCEDURE [dbo].[Proc_DelMatchModel](
				@MatchID			INT,
				@MatchModelID		INT,
				@Result			AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result=0; 	删除该Phase的晋级方案模型失败，标示没有做任何操作！
					-- @Result=1; 	删除该Phase的晋级方案模型成功！

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_Match_Model_Match_Result_Des WHERE F_MatchID = @MatchID AND F_MatchModelID = @MatchModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result WHERE F_MatchID = @MatchID AND F_MatchModelID = @MatchModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Match_Model WHERE F_MatchID = @MatchID AND F_MatchModelID = @MatchModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

