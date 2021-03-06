IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_RemoveMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_RemoveMatchOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_BK_RemoveMatchOfficial]
--描    述：删除Match下的官员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_BK_RemoveMatchOfficial](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

    CREATE TABLE #table_Tmp(
                             F_MatchID      INT,
                             F_ServantNum   INT,
                             F_RowCount     INT
                            )

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    DELETE FROM  TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    INSERT INTO #table_Tmp(F_MatchID, F_ServantNum, F_RowCount)
    SELECT F_MatchID, F_ServantNum, ROW_NUMBER() OVER (ORDER BY F_ServantNum) FROM TS_Match_Servant WHERE F_MatchID = @MatchID

    UPDATE TS_Match_Servant SET F_Order = B.F_RowCount FROM TS_Match_Servant AS A LEFT JOIN #table_Tmp AS B ON A.F_MatchID = B.F_MatchID
    AND A.F_ServantNum = B.F_ServantNum WHERE A.F_MatchID = @MatchID

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

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO



