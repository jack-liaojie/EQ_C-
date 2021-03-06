IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_UpdateMatchPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_UpdateMatchPoints]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_UpdateMatchPoints]
--描    述: 更新指定一场比赛一个参赛者的比分, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_UpdateMatchPoints]
	@MatchID				INT,
	@RegisterID				INT,
	@Points					INT,
	@Result					AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;	--@Result = 0;	更新失败，标示没有做任何操作！
						--@Result = 1;	更新成功  
						--@Result = -1; 更新失败，@MatchID, @RegisterID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	UPDATE TS_Match_Result SET F_Points = @Points
	WHERE F_matchID = @MatchID
		AND F_RegisterID = @RegisterID

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = 1

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO