IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_SetMatch_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_SetMatch_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_SetMatch_Individual]
--描    述: 柔道项目单人项目设定一场比赛的信息.
--创 建 人: 邓年彩
--日    期: 2010年11月5日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_SetMatch_Individual]
	@MatchID						INT,
	@GoldenScore					INT,
	@ContestTime					NVARCHAR(100),
	@Technique						NVARCHAR(100),
	@StatusID						INT,
	@DecisionCode					NVARCHAR(100),
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0

	DECLARE @DecisionID					INT
	SELECT @DecisionID = D.F_DecisionID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_Decision AS D
		ON E.F_DisciplineID = D.F_DisciplineID AND D.F_DecisionCode = @DecisionCode
	WHERE M.F_MatchID = @MatchID
	
	UPDATE TS_Match
	SET F_MatchComment3 = CONVERT(NVARCHAR(100), @GoldenScore)
		, F_MatchComment4 = @ContestTime
		, F_MatchComment5 = @Technique
		, F_MatchStatusID = @StatusID
		, F_DecisionID = @DecisionID
	WHERE F_MatchID = @MatchID
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/