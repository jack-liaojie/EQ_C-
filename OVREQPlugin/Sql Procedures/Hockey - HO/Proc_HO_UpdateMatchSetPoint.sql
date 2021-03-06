IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_UpdateMatchSetPoint]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_UpdateMatchSetPoint]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_HO_UpdateMatchSetPoint]
--描    述：更新Match下Split的比分及结果
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月27日


CREATE PROCEDURE [dbo].[Proc_HO_UpdateMatchSetPoint](
												@MatchID		    INT,
                                                @SplitOrder         INT,
                                                @HTeamPos            INT,
                                                @VTeamPos            INT,
                                                @HSetPt             INT,
                                                @VSetPt             INT,
                                                @HSetRank           INT,
                                                @VSetRank           INT,
                                                @HSetResult         INT,
                                                @VSetResult         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 


    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

    DECLARE @MatchSplitID INT
    IF(NOT EXISTS (SELECT  F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND CONVERT(INT,F_MatchSplitCode) = @SplitOrder))
    BEGIN
        RETURN
    END
    ELSE
    BEGIN
        SELECT @MatchSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND CONVERT(INT,F_MatchSplitCode) = @SplitOrder
    END
    
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    UPDATE TS_Match_Split_Result SET F_Points = @HSetPt, F_Rank = @HSetRank, F_ResultID =  @HSetResult 
        WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @HTeamPos

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

     UPDATE TS_Match_Split_Result SET F_Points = @VSetPt, F_Rank = @VSetRank, F_ResultID =  @VSetResult 
        WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @VTeamPos

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


