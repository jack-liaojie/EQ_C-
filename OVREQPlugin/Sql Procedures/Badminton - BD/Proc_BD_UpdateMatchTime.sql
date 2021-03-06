IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_UpdateMatchTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_UpdateMatchTime]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_UpdateMatchTime]
--描    述：更新Match下Match的时间
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年07月14日


CREATE PROCEDURE [dbo].[Proc_BD_UpdateMatchTime](
												@MatchID		    INT,
                                                @MatchSplitID       INT,
                                                @SpendTime          NVARCHAR(10),
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH
	
	DECLARE @MatchType AS INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	IF (@MatchType = 1 AND @MatchSplitID = 0)
    BEGIN
        UPDATE TS_Match SET F_SpendTime = [dbo].[Fun_BD_CharTimeToINT](@SpendTime) WHERE F_MatchID = @MatchID
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
    END
    ELSE
    BEGIN
        UPDATE TS_Match_Split_Info SET F_SpendTime = [dbo].[Fun_BD_CharTimeToINT](@SpendTime) WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
        
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

