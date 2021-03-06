IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_GetMatchInfo]
----功		  能：得到一场比赛的详细信息
----作		  者：郑金勇 
----日		  期: 2009-08-12

CREATE PROCEDURE [dbo].[Proc_GetMatchInfo] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @MatchCompetitorNum AS INT
	SELECT @MatchCompetitorNum = COUNT(F_CompetitionPosition) FROM TS_Match_Result WHERE F_MatchID = @MatchID

	SELECT *, B.F_MatchComment2 AS MatchComment2, @MatchCompetitorNum AS MatchCompetitorNum FROM TS_Match AS A LEFT JOIN TS_Match_Des AS B
					  ON A.F_MatchID=B.F_MatchID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID 

SET NOCOUNT OFF
END




