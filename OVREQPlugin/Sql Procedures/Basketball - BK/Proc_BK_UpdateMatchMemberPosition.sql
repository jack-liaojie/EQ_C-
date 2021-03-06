IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_UpdateMatchMemberPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_UpdateMatchMemberPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_BK_UpdateMatchMemberPosition]
--描    述：更新Match下的官员Position
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_BK_UpdateMatchMemberPosition](
												@MatchID		    INT,
                                                @MemberID           INT,
                                                @TeamPos            INT,
                                                @PositionID         INT,
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
	
    UPDATE TS_Match_Member SET F_PositionID = (CASE WHEN @PositionID = -1 THEN NULL ELSE @PositionID END) WHERE F_MatchID = @MatchID AND F_RegisterID = @MemberID AND F_CompetitionPosition = @TeamPos

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


