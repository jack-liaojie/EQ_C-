IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchJudge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchJudge]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_WR_UpdateMatchJudge]
--描    述: 柔道项目为一场 Match 更新一个裁判的信息  
--创 建 人: 邓年彩
--日    期: 2010年11月8日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchJudge]
	@MatchID						INT,
	@ServantNum						INT,
	@RegisterID						INT,
	@FunctionID						INT,
	@Order							INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	DECLARE @OldOrder				INT

	SELECT @OldOrder = F_Order
	FROM TS_Match_Servant
	WHERE F_MatchID = @MatchID
		AND F_ServantNum = @ServantNum

	SET Implicit_Transactions off
	BEGIN TRANSACTION		-- 设定事务

	IF @RegisterID IS NOT NULL
	BEGIN
		UPDATE TS_Match_Servant
		SET F_RegisterID = @RegisterID
			, F_FunctionID = @FunctionID
		WHERE F_MatchID = @MatchID
			AND F_ServantNum = @ServantNum
	END

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- 事务回滚
		SET @Result = 0		-- 更新失败
		RETURN
	END

	IF @FunctionID IS NOT NULL
	BEGIN
		UPDATE TS_Match_Servant
		SET F_FunctionID = @FunctionID
		WHERE F_MatchID = @MatchID
			AND F_ServantNum = @ServantNum
	END

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- 事务回滚
		SET @Result = 0		-- 更新失败
		RETURN
	END

	IF @Order IS NOT NULL
	BEGIN
		UPDATE TS_Match_Servant
		SET F_Order = @Order
		WHERE F_MatchID = @MatchID
			AND F_ServantNum = @ServantNum

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- 事务回滚
			SET @Result = 0		-- 更新失败
			RETURN
		END

		UPDATE TS_Match_Servant
		SET F_Order = @OldOrder
		WHERE F_MatchID = @MatchID
			AND F_Order = @Order
			AND F_ServantNum <> @ServantNum

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- 事务回滚
			SET @Result = 0		-- 更新失败
			RETURN
		END
	END

	COMMIT TRANSACTION		-- 成功提交事务
	SET @Result = 1			-- 更新成功
	RETURN

SET NOCOUNT OFF
END


/*

-- Just for test
DECLARE @Result	INT
EXEC [Proc_JU_UpdateMatchJudge] 1611, 1, 1065, 104, NULL, @Result OUTPUT

*/