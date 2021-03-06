IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_UpdateSplitTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_UpdateSplitTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_UpdateSplitTime]
--描    述：更新Match下Split的时间
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2010年10月18日


CREATE PROCEDURE [dbo].[Proc_BD_UpdateSplitTime](
												@MatchID		    INT,
                                                @MatchSplitID       INT,
                                                @SpendTime          INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    CREATE TABLE #tab_Tmp(
                          F_MatchSplitID    INT,
                          F_Time            INT
                          )

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    UPDATE TS_Match_Split_Info SET F_SpendTime = @SpendTime WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DECLARE @SplitID AS INT
        DECLARE @TmpSpendTime AS INT

		DECLARE ONE_CURSOR CURSOR FOR SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		OPEN ONE_CURSOR
		FETCH NEXT FROM ONE_CURSOR INTO @SplitID
		WHILE @@FETCH_STATUS = 0 
		BEGIN
            IF EXISTS(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @SplitID)
            BEGIN
				SELECT @TmpSpendTime = SUM(F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @SplitID
				UPDATE TS_Match_Split_Info SET F_SpendTime = @TmpSpendTime WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SplitID

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
            END

			FETCH NEXT FROM ONE_CURSOR INTO @SplitID
		END
		CLOSE ONE_CURSOR
		DEALLOCATE ONE_CURSOR
        --END ONE_CURSOR

        SELECT @TmpSpendTime = SUM(F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
        UPDATE TS_Match SET F_SpendTime = @TmpSpendTime WHERE F_MatchID = @MatchID

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

