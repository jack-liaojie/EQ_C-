IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_DeleteMatchJudge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_DeleteMatchJudge]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_JU_DeleteMatchJudge]
--描    述: 柔道项目为一场 Match 删除一个裁判
--创 建 人: 邓年彩
--日    期: 2009年12月14日
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_DeleteMatchJudge]
	@MatchID						INT,
	@ServantNum						INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @Order					INT

	SELECT @Order = F_Order
	FROM TS_Match_Servant
	WHERE F_MatchID = @MatchID
		AND F_ServantNum = @ServantNum

	SET Implicit_Transactions off
	BEGIN TRANSACTION		-- 设定事务

	DELETE TS_Match_Servant
	WHERE F_MatchID = @MatchID
		AND F_ServantNum = @ServantNum

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- 事务回滚
		SET @Result = 0		-- 更新失败
		RETURN
	END

	UPDATE TS_Match_Servant
	SET F_Order = F_Order - 1 
	WHERE F_MatchID = @MatchID
		AND F_Order > @Order

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- 事务回滚
		SET @Result = 0		-- 更新失败
		RETURN
	END

	COMMIT TRANSACTION		-- 成功提交事务
	SET @Result = 1			-- 更新成功
	RETURN

SET NOCOUNT OFF
END


/*

-- Just for test
DECLARE @Result	INT
EXEC [Proc_JU_DeleteMatchJudge] 1611, 1, @Result OUTPUT

*/