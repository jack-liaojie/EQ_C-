IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetBracketPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetBracketPlayers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetBracketPlayers]
----功		  能：获取TVG需要的比赛晋级
----作		  者：王强
----日		  期: 2011-04-26

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetBracketPlayers]
		@EventID INT,
		@PlayerNum INT --8为8进4， 4为4进2
AS
BEGIN
	
SET NOCOUNT ON

		IF @PlayerNum NOT IN (8,4)
			RETURN
		
		DECLARE @MatchCount INT
		DECLARE @PhaseID INT
		SET @MatchCount = @PlayerNum/4
		
		SELECT @PhaseID = F_PhaseID FROM TS_Match 
		WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID)
		GROUP BY F_PhaseID HAVING COUNT(F_PhaseID) = @MatchCount
		
		
		SELECT '[Image]' + CASE [dbo].[Fun_BDTT_GetPlayerNOC](D.F_RegisterID) WHEN '' THEN NULL ELSE [dbo].[Fun_BDTT_GetPlayerNOC](D.F_RegisterID) END
				AS PrevNOC, REPLACE(E.F_TvShortName,'/',' / ') AS PrevRoundName, 
			   '[Image]' + CASE [dbo].[Fun_BDTT_GetPlayerNOC](B.F_RegisterID) WHEN '' THEN NULL ELSE [dbo].[Fun_BDTT_GetPlayerNOC](B.F_RegisterID) END
			   AS NextNOC, REPLACE(C.F_TvShortName,'/', ' / ') AS NextRoundName,
			   CASE D.F_ResultID
			   WHEN 2 THEN 1
			   ELSE NULL END AS Remark
			    FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Result AS D ON D.F_MatchID = B.F_SourceMatchID
		LEFT JOIN TR_Register_Des AS E ON E.F_RegisterID = D.F_RegisterID AND E.F_LanguageCode = 'ENG'
		WHERE A.F_PhaseID = @PhaseID	
	
SET NOCOUNT OFF
END


GO


