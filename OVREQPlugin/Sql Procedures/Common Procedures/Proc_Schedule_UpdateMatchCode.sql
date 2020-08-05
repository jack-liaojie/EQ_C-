IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_UpdateMatchCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_UpdateMatchCode]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_UpdateMatchCode]
--描    述: 更新指定一场比赛的MatchCode
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年9月9日



CREATE PROCEDURE [dbo].[Proc_Schedule_UpdateMatchCode]
	@MatchID				INT,
	@MatchCode		        NVARCHAR(20),
	@Result					AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;	--@Result = 0;	更新失败，标示没有做任何操作！
						--@Result = 1;	更新成功  
						--@Result = -1; 更新失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	UPDATE TS_Match SET F_MatchCode = @MatchCode
	WHERE F_MatchID = @MatchID

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = 1

SET NOCOUNT OFF
END
