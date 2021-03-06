IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchCompetitors]') AND type = N'FN')
DROP FUNCTION [dbo].[Fun_GetMatchCompetitors]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Fun_GetMatchCompetitors]
--描    述：得到一场比赛的所有参赛者名称信息
--参数说明： 
--说    明：
--创 建 人：邓年彩
--日    期：2009年11月23日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE FUNCTION [dbo].[Fun_GetMatchCompetitors]
	(
		@MatchID		INT,
		@LanguageCode	CHAR(3)
	)
RETURNS NVARCHAR(1000)
AS
BEGIN

	DECLARE @MatchCompetitors		NVARCHAR(1000)
	DECLARE @CompetitionTypeID		INT

	SELECT @CompetitionTypeID = C.F_CompetitionTypeID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B
		ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C
		ON B.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID	

	-- 对抗类项目
	IF @CompetitionTypeID = 1
	BEGIN	
		DECLARE @Home		NVARCHAR(50)
		DECLARE @Away		NVARCHAR(50)
		SELECT @Home = [dbo].Fun_GetMatchOneCompetitor(@MatchID, 1, @LanguageCode)
		SELECT @Away = [dbo].Fun_GetMatchOneCompetitor(@MatchID, 2, @LanguageCode)
		SET @MatchCompetitors = @Home + N' vs ' + @Away
	END
	-- 非对抗类项目
	ELSE
	BEGIN
		DECLARE @CompetitorsCount	INT
		DECLARE @CompetitorName		NVARCHAR(50)
		DECLARE @i					INT
		
		SELECT @CompetitorsCount = COUNT(A.F_CompetitionPosition) 
		FROM TS_Match_Result AS A
		WHERE A.F_MatchID = @MatchID
		
		SET @i = 1
		SET @MatchCompetitors = N''
		WHILE @i <= @CompetitorsCount
		BEGIN
			SELECT @CompetitorName = [dbo].Fun_GetMatchOneCompetitor(@MatchID, @i, @LanguageCode)
			IF @CompetitorName <> 'BYE'
			BEGIN
				SET @MatchCompetitors = @MatchCompetitors + @CompetitorName + N', '
			END
			SET @i = @i + 1
		END

		IF LEN(@MatchCompetitors) >= 2
		BEGIN 
			SET @MatchCompetitors = LEFT(@MatchCompetitors, LEN(@MatchCompetitors) - 2)
		END
	END

	RETURN @MatchCompetitors

END
