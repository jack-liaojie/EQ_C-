IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetOfficails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetOfficails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetOfficails]
----功		  能：获取TVG需要的裁判员信息
----作		  者：王强
----日		  期: 2011-04-25

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetOfficails]
		@MatchID INT,
		@MatchSplitID INT = -1
AS
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @MatchType = 1
	BEGIN
		SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B.F_RegisterID) AS NOC, C.F_TvShortName AS TvName,
				D.F_FunctionShortName AS [Function]
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Servant AS B ON B.F_MatchID = A.F_MatchID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register AS E ON E.F_RegisterID = C.F_RegisterID
		LEFT JOIN TD_Function_Des AS D ON D.F_FunctionID = B.F_FunctionID AND D.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID
		ORDER BY D.F_FunctionShortName DESC
	END
	ELSE IF @MatchType = 3
	BEGIN
	
		DECLARE @CurrentSetID INT
		IF @MatchSplitID != -1
			SET @CurrentSetID = @MatchSplitID
		ELSE
			SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)

			
		SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B.F_RegisterID) AS NOC, C.F_TvShortName AS TvName,
				D.F_FunctionShortName AS [Function]
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Servant AS B ON B.F_MatchID = A.F_MatchID AND B.F_MatchSplitID = A.F_MatchSplitID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register AS E ON E.F_RegisterID = C.F_RegisterID
		LEFT JOIN TD_Function_Des AS D ON D.F_FunctionID = B.F_FunctionID AND D.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
		ORDER BY D.F_FunctionShortName DESC
		
		
	END
	
	SET NOCOUNT OFF
END


GO


