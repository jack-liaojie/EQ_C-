IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_UpdateTeamSplitMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_UpdateTeamSplitMember]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_UpdateTeamSplitMember]    Script Date: 12/27/2010 13:47:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









--名    称：[[Proc_JU_UpdateTeamSplitMember]]
--描    述：更新Match下的运动员信息
--参数说明： 
--说    明：
--创 建 人：宁顺泽
--日    期：2010年12月24日


CREATE PROCEDURE [dbo].[Proc_JU_UpdateTeamSplitMember](
												@MatchID		    INT,
                                                @MatchSplitID       INT,
                                                @RegisterID         INT,
                                                @Position           INT,
                                                @Weigh				NVARCHAR(20)=N'',
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
	
	IF @Weigh=N''
	BEGIN
		UPDATE TS_Match_Split_Result SET F_RegisterID = (CASE WHEN @RegisterID = -1 THEN NULL ELSE @RegisterID END) WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @Position
	END
	else
		BEGIN
			Update TS_Match_Split_Info SET F_Memo=@Weigh where F_MatchID=@MatchID AND F_MatchSplitID=@MatchSplitID 
		END
    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    UPDATE TS_Match_Split_Result SET F_RegisterID = (CASE WHEN @RegisterID = -1 THEN NULL ELSE @RegisterID END) FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID
    AND A.F_MatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID AND B.F_FatherMatchSplitID = @MatchSplitID AND A.F_CompetitionPosition = @Position

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


