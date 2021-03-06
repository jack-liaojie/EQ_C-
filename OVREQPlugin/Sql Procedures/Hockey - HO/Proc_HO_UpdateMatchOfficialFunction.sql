IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_UpdateMatchOfficialFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_UpdateMatchOfficialFunction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_HO_UpdateMatchOfficialFunction]
--描    述：更新Match下的官员Function
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月20日


CREATE PROCEDURE [dbo].[Proc_HO_UpdateMatchOfficialFunction](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @FunctionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	
	UPDATE TS_Match_Servant SET F_FunctionID = (CASE WHEN @FunctionID = -1 THEN NULL ELSE @FunctionID END) WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID

	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End

GO


