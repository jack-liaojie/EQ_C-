IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchOneCompetitor]') AND type = N'FN')
DROP FUNCTION [dbo].[Fun_GetMatchOneCompetitor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Fun_GetMatchOneCompetitor]
--描    述：根据 @MatchID, @CompetitionPosition 得到一场比赛的一个参赛者名称信息
--参数说明： 
--说    明：
--创 建 人：邓年彩
--日    期：2009年11月23日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE FUNCTION [dbo].[Fun_GetMatchOneCompetitor]
	(
		@MatchID				INT,
		@CompetitionPosition	INT,
		@LanguageCode			CHAR(3)
	)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @CompetitorName		NVARCHAR(100)
	
	SELECT @CompetitorName = 
		CASE
			WHEN A.F_RegisterID = -1 THEN N'BYE'
			WHEN B.F_LongName IS NOT NULL THEN B.F_LongName
			WHEN A.F_RegisterID IS NOT NULL THEN N''
			WHEN (A.F_StartPhaseID IS NOT NULL AND A.F_StartPhasePosition IS NOT NULL) 
				THEN LTRIM(RTRIM(C.F_PhaseLongName)) + N' Position ' + CAST(A.F_StartPhasePosition AS NVARCHAR(10))
			WHEN (A.F_SourcePhaseID IS NOT NULL AND A.F_SourcePhaseRank IS NOT NULL)
				THEN LTRIM(RTRIM(D.F_PhaseLongName)) + N' Rank ' + CAST(A.F_SourcePhaseRank AS NVARCHAR(10))
			WHEN (A.F_SourceMatchID IS NOT NULL AND A.F_SourceMatchRank IS NOT NULL)
				THEN LTRIM(RTRIM(G.F_PhaseLongName)) + N' ' + LTRIM(RTRIM(F.F_MatchLongName)) 
					+ N' Rank ' + CAST(A.F_SourceMatchRank AS NVARCHAR(10))
			WHEN H.F_CompetitorSourceDes IS NOT NULL THEN H.F_CompetitorSourceDes
			ELSE N''
		END
	FROM
	(
		SELECT X.F_MatchID
			, RANK() OVER (ORDER BY X.F_CompetitionPosition) AS F_CompetitionPosition
			, X.F_RegisterID
			, X.F_StartPhaseID, X.F_StartPhasePosition
			, X.F_SourcePhaseID, X.F_SourcePhaseRank
			, X.F_SourceMatchID, X.F_SourceMatchRank
		FROM TS_Match_Result AS X
		WHERE X.F_MatchID = @MatchID 
	) AS A
	LEFT JOIN TR_Register_Des AS B
		ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	-- F_StartPhaseID, F_StartPhasePosition
	LEFT JOIN TS_Phase_Des AS C
		ON A.F_StartPhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
	-- F_SourcePhaseID, F_SourcePhaseRank
	LEFT JOIN TS_Phase_Des AS D
		ON A.F_SourcePhaseID = D.F_PhaseID AND D.F_LanguageCode = @LanguageCode
	-- F_SourceMatchID, F_SourceMatchRank
	LEFT JOIN TS_Match AS E
		ON A.F_SourceMatchID = E.F_MatchID
	LEFT JOIN TS_Match_Des AS F
		ON A.F_SourceMatchID = F.F_MatchID AND F.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Phase_Des AS G
		ON E.F_PhaseID = G.F_PhaseID AND G.F_LanguageCode = @LanguageCode
	-- TS_Match_Result_Des
	LEFT JOIN TS_Match_Result_Des AS H
		ON A.F_MatchID = H.F_MatchID AND A.F_CompetitionPosition = H.F_CompetitionPosition AND H.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID 
		AND A.F_CompetitionPosition = @CompetitionPosition

	RETURN @CompetitorName

END