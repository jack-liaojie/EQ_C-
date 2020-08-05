IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetMatchPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetMatchPlayers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetMatchPlayers]
----功		  能：获取TVG需要的参赛运动员信息
----作		  者：王强
----日		  期: 2011-04-25

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetMatchPlayers]
		@MatchID INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @MatchTypeID INT
	SELECT @MatchTypeID = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @MatchTypeID = 1
	BEGIN
		SELECT REPLACE(B.F_TvShortName,'/',' / ') AS F_TvLongName
		FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID
		ORDER BY B.F_TvShortName
	END
	
	IF @MatchTypeID = 3
	BEGIN
		SELECT DISTINCT REPLACE(B.F_TvShortName,'/',' / ')
		FROM TS_Match_Split_Result AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID
		ORDER BY REPLACE(B.F_TvShortName,'/',' / ')
	END
	
SET NOCOUNT OFF
END


GO


