IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_DelMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_DelMatchOfficial]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_DelMatchOfficial]
--描    述：删除Match下的官员
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月06日


CREATE PROCEDURE [dbo].[Proc_BD_DelMatchOfficial](
												@MatchID		    INT,
												@MatchSplitID       INT,
                                                @RegisterID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH
	
	DECLARE @MatchType INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	IF @MatchSplitID = -1
	BEGIN
		SET @MatchType = 1
	END
	
	IF @MatchType = 3
	BEGIN
	    DELETE FROM TS_Match_Split_Servant WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_RegisterID = @RegisterID

		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
	END
	ELSE
	BEGIN
    DELETE FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

