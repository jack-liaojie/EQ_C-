IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SCB_JU_GetSessionCourtCurrentMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SCB_JU_GetSessionCourtCurrentMatchID]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Func_SCB_JU_GetSessionCourtCurrentMatchID]
--描    述: 获取一个 Session 一个 Court 的当前比赛的 MatchID.
--创 建 人: 邓年彩
--日    期: 2011年3月31日 星期四
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE FUNCTION [Func_SCB_JU_GetSessionCourtCurrentMatchID]
(
	@SessionID				INT,
	@CourtID				INT
)
RETURNS INT
AS
BEGIN

	DECLARE @MatchID		INT
	
	/*
	1. 取最后一场 StartList 或 Running 的比赛, 
	2. 如没有, 取最后一场 Unofficial 或 Officail 的比赛, 
	3. 如还没有取第一场比赛.
	*/
	SELECT TOP 1 @MatchID = M.F_MatchID
	FROM TS_Match AS M	
	WHERE M.F_MatchStatusID =50
		AND M.F_SessionID = @SessionID
		AND M.F_CourtID = @CourtID
	ORDER BY CONVERT(int,ISNULL(m.F_RaceNum,N'0')) DESC 
		
	IF @MatchID IS NULL
	BEGIN
		SELECT TOP 1 @MatchID = M.F_MatchID
		FROM TS_Match AS M	
		WHERE M.F_MatchStatusID=100
			AND M.F_SessionID = @SessionID
			AND M.F_CourtID = @CourtID
		ORDER BY CONVERT(int,ISNULL(m.F_RaceNum,N'0')) DESC 
		
	END
	
	IF @MatchID IS NULL
	BEGIN
		SELECT TOP 1 @MatchID = M.F_MatchID
		FROM TS_Match AS M	
		WHERE M.F_MatchStatusID<50
			AND M.F_SessionID = @SessionID
			AND M.F_CourtID = @CourtID
		ORDER BY CONVERT(int,ISNULL(m.F_RaceNum,N'0'))  
		
	END

	RETURN @MatchID

END
GO

/*

-- Just for test
select dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](1)
select dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](5)
select dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](10)

*/