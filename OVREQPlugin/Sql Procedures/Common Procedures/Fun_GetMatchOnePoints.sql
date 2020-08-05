IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchOnePoints]') AND type = N'FN')
DROP FUNCTION [dbo].[Fun_GetMatchOnePoints]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Fun_GetMatchOnePoints]
--描    述：根据 @MatchID, @CompetitionPosition 得到一场比赛的一个参赛者成绩信息
--参数说明： 
--说    明：
--创 建 人：邓年彩
--日    期：2009年11月23日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE FUNCTION [dbo].[Fun_GetMatchOnePoints]
	(
		@MatchID				INT,
		@CompetitionPosition	INT
	)
RETURNS INT
AS
BEGIN

	DECLARE @Points		INT
	
	-- F_CompetitionPosition 可能不是连续的或不从1开始, 所以按照 F_CompetitionPosition 重新排名
	SELECT @Points = 
		CASE 
			WHEN A.F_RegisterID = -1 THEN -1
			ELSE A.F_Points
		END
	FROM
	(
		SELECT X.F_MatchID
			, RANK() OVER (ORDER BY X.F_CompetitionPosition) AS F_CompetitionPosition
			, X.F_Points
			, X.F_RegisterID
		FROM TS_Match_Result AS X
		WHERE X.F_MatchID = @MatchID 
	) AS A
	WHERE A.F_MatchID = @MatchID 
		AND A.F_CompetitionPosition = @CompetitionPosition

	RETURN @Points

END