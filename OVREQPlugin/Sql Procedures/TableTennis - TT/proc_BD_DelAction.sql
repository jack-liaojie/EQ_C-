IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_BD_DelAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_BD_DelAction]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[proc_BD_DelAction]
----功		  能：删除最新添加的1分
----作		  者：张翠霞 
----日		  期: 2010-01-08 

CREATE PROCEDURE [dbo].[proc_BD_DelAction]
    @CompetitionPosition     INT,
    @MatchID		         INT,
	@MatchSplitID		     INT,
	@RegisterID		         INT,
	@ActionTypeID		     INT,
	@ActionScore             INT,
	@Result 			     AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Action失败，标示没有做任何操作！
					  -- @Result=1; 	删除Action成功！
					  
	IF @ActionTypeID = 1
	BEGIN
		DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_RegisterID = @RegisterID
				AND F_ActionDetail1 >= @ActionScore
	END
	ELSE IF @ActionTypeID = 2
	BEGIN
		DECLARE @MaxActionOrder INT
		SELECT @MaxActionOrder = MAX(F_ActionOrder) FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @CompetitionPosition
		IF @MaxActionOrder IS NOT NULL
			DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @CompetitionPosition AND F_ActionDetail1 >= @ActionScore
	END
	
	SET @Result = 1
	RETURN


SET NOCOUNT OFF
END


GO

