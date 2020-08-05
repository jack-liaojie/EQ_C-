IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_SetMatchSplitInfo_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_SetMatchSplitInfo_Team]
GO
/****** Object:  StoredProcedure [dbo].[Proc_JU_SetMatchSplitInfo_Team]    Script Date: 12/27/2010 14:39:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [[Proc_JU_SetMatchSplitInfo_Team]]
--描    述: 柔道项目团体项目中设定一场比赛的信息.
--创 建 人: 宁顺泽
--日    期: 2010年12月25号 星期六
--修改记录：
/*			
	日期					修改人		修改内容
	2011年2月28				宁顺泽		团体赛每场比赛都有加时赛
*/



CREATE PROCEDURE [dbo].[Proc_JU_SetMatchSplitInfo_Team]
	@MatchID						INT,
	@MatchSplitID					INT,
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

	DECLARE @DecisionID				INT
	SELECT @DecisionID = D.F_DecisionID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_Decision AS D
		ON E.F_DisciplineID = D.F_DisciplineID AND D.F_DecisionCode = @DecisionCode
	WHERE M.F_MatchID = @MatchID
	
	
	UPDATE TS_Match_Split_Info
	SET 
		F_MatchSplitComment1=CONVERT(NVARCHAR(100), @GoldenScore)
		,F_MatchSplitComment2 = @ContestTime
		, F_MatchSplitComment3 = @Technique
		, F_MatchSplitStatusID = @StatusID
		, F_DecisionID = @DecisionID
	WHERE F_MatchID = @MatchID AND F_MatchSplitID=@MatchSplitID
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/

GO


