IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchSummaryResult]') AND type = N'FN')
DROP FUNCTION [dbo].[Fun_GetMatchSummaryResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Fun_GetMatchSummaryResult]
--描    述：获取一场比赛的所有参赛者成绩概况
--参数说明： 
--说    明：
--创 建 人：邓年彩
--日    期：2009年11月23日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE FUNCTION [dbo].[Fun_GetMatchSummaryResult]
	(
		@MatchID		INT,
		@LanguageCode	CHAR(3)
	)
RETURNS NVARCHAR(500)
AS
BEGIN

	DECLARE @MatchSummaryResult		NVARCHAR(500)
	DECLARE @CompetitionTypeID		INT

	SELECT @CompetitionTypeID = C.F_CompetitionTypeID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B
		ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C
		ON B.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID	

	SET @MatchSummaryResult = N''

	-- 对抗类项目
	IF @CompetitionTypeID = 1
	BEGIN	
		DECLARE @HomePoints		INT
		DECLARE @AwayPoints		INT
		SELECT @HomePoints = [dbo].Fun_GetMatchOnePoints(@MatchID, 1)
		SELECT @AwayPoints = [dbo].Fun_GetMatchOnePoints(@MatchID, 2)

		-- 当对阵双方有一方轮空时都不显示成绩
		IF (@HomePoints <> -1 OR @AwayPoints <> -1)
		BEGIN
			SET @MatchSummaryResult = CAST(@HomePoints AS NVARCHAR(10)) + N' : ' + CAST(@AwayPoints AS NVARCHAR(10))
		END
	END
	-- 非对抗类项目
	ELSE
	BEGIN
		DECLARE @CompetitorsCount	INT
		DECLARE @Points				NVARCHAR(10)
		DECLARE @i					INT
		
		SELECT @CompetitorsCount = COUNT(A.F_CompetitionPosition) 
		FROM TS_Match_Result AS A
		WHERE A.F_MatchID = @MatchID
		
		SET @i = 1
		WHILE @i <= @CompetitorsCount
		BEGIN
			SELECT @Points = [dbo].Fun_GetMatchOnePoints(@MatchID, @i)
			-- 当有一个参赛者轮空时, 不显示其成绩
			IF @Points <> -1
			BEGIN
				IF @Points IS NOT NULL
				BEGIN
					SET @MatchSummaryResult = @MatchSummaryResult + CAST(@Points AS NVARCHAR(10)) + N', '
				END
				ELSE
				BEGIN
					SET @MatchSummaryResult = @MatchSummaryResult + N', '
				END
			END
			SET @i = @i + 1
		END

		-- 去掉最后的', '
		IF LEN(@MatchSummaryResult) >= 2
		BEGIN 
			SET @MatchSummaryResult = LEFT(@MatchSummaryResult, LEN(@MatchSummaryResult) - 2)
		END
	END

	RETURN @MatchSummaryResult

END