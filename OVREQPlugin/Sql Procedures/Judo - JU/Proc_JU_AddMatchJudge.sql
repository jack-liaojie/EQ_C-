IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_AddMatchJudge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_AddMatchJudge]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_JU_AddMatchJudge]
--描    述: 柔道项目为一场 Match 添加一个裁判  
--创 建 人: 邓年彩
--日    期: 2010年11月8日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_AddMatchJudge]
	@MatchID						INT,
	@RegisterID						INT,
	@FunctionID						INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ServantNum				INT
	DECLARE @Order					INT

	SELECT @ServantNum = MAX(A.F_ServantNum) + 1, @Order = MAX(A.F_Order) + 1
	FROM TS_Match_Servant AS A
	WHERE A.F_MatchID = @MatchID

	IF @ServantNum IS NULL
	BEGIN
		SET @ServantNum = 1
	END
	
	IF @Order IS NULL
	BEGIN
		SET @Order = 1
	END

	INSERT TS_Match_Servant
	(F_MatchID, F_ServantNum, F_RegisterID, F_FunctionID, F_Order)
	VALUES
	(@MatchID, @ServantNum, @RegisterID, @FunctionID, @Order)

	IF @@error<>0 
	BEGIN 
		SET @Result = 0		-- 添加失败
		RETURN
	END

	SET @Result = 1			-- 添加成功

SET NOCOUNT OFF
END


/*

-- Just for test
DECLARE @Result	INT
EXEC [Proc_JU_AddMatchJudge] 1610, 1064, 104, @Result OUTPUT
EXEC [Proc_JU_AddMatchJudge] 1610, 1068, 102, @Result OUTPUT
EXEC [Proc_JU_AddMatchJudge] 1610, 2157, 88, @Result OUTPUT
EXEC [Proc_JU_AddMatchJudge] 1610, 2158, 89, @Result OUTPUT
EXEC [Proc_JU_AddMatchJudge] 1610, 2159, 90, @Result OUTPUT
EXEC [Proc_JU_AddMatchJudge] 1610, 2160, 91, @Result OUTPUT

*/