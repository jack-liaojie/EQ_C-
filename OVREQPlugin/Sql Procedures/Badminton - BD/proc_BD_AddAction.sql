IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_BD_AddAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_BD_AddAction]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[proc_BD_AddAction]
----功		  能：为比赛得分方添加1分
----作		  者：张翠霞 
----日		  期: 2010-01-08 

CREATE PROCEDURE [dbo].[proc_BD_AddAction]
    @CompetitionPosition     INT,
    @MatchID		         INT,
	@MatchSplitID		     INT,
	@RegisterID		         INT,
	@ActionTypeID		     INT,
    @ActionScore             INT,
    @PointType               INT,
	@Result 			     AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Action失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Action成功！此值即为ActionNumberID

    IF NOT EXISTS(SELECT F_ActionTypeID FROM TD_ActionType WHERE F_ActionTypeID = @ActionTypeID)
    BEGIN
        SET @Result = -1
        RETURN
    END

	DECLARE @ActionNumberID AS INT
	DECLARE @MaxScore INT
	DECLARE @ActionOrder INT
	
	SELECT @ActionOrder = ISNULL(MAX( F_ActionOrder),0) + 1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID 

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
		DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID 
				AND F_CompetitionPosition = @CompetitionPosition AND F_RegisterID = @RegisterID AND F_ActionDetail1 >= @ActionScore
		
		INSERT INTO TS_Match_ActionList (F_CompetitionPosition, F_MatchID, F_MatchSplitID, F_RegisterID, F_ActionTypeID, F_ActionDetail1, F_ActionDetail2, F_ActionOrder)
        VALUES (@CompetitionPosition, @MatchID, @MatchSplitID, @RegisterID, @ActionTypeID, @ActionScore, @PointType, @ActionOrder)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=-2
			RETURN
		END
		SET @ActionNumberID = @@IDENTITY

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @ActionNumberID
	RETURN

SET NOCOUNT OFF
END


GO

