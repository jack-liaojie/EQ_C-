IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BDTT_AllRank_PlayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BDTT_AllRank_PlayerList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BDTT_AllRank_PlayerList]
--描    述：获取全排名报表第一列的运动员名称
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年08月03日


CREATE PROCEDURE [dbo].[Proc_Report_BDTT_AllRank_PlayerList](
												@EventID		   INT,
												@LanguageCode	   NVARCHAR(10)
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @RankSize INT = 8
	DECLARE @EventType INT
	SELECT @EventType = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
	--如果有设置的数字超过13的，则为16人
	IF EXISTS
	(SELECT A.F_MatchID FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	WHERE B.F_EventID = @EventID AND CONVERT(INT, A.F_MatchComment1) >= 13
	)
		SET @RankSize = 16
	
	DECLARE @PhaseComment NVARCHAR(30)
	IF @RankSize = 8
	BEGIN
		SET @PhaseComment = '32-3'
	END
	ELSE IF @RankSize = 16
	BEGIN
		SET @PhaseComment = '32-4'
	END
	ELSE
		RETURN
	
	DECLARE @PhaseID INT
	
	SELECT @PhaseID = A.F_PhaseID FROM TS_Phase AS A
	LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID
	WHERE A.F_EventID = @EventID AND B.F_PhaseComment = @PhaseComment 
	
	CREATE TABLE #TMP_TABLE
	(
		F_POS INT,
		F_RegisterName NVARCHAR(20),
		F_NOCName NVARCHAR(20)
	)
	
	INSERT INTO #TMP_TABLE
	SELECT 
	ROW_NUMBER() OVER( ORDER BY CONVERT(INT,B.F_MatchComment1),A.F_CompetitionPositionDes1 ) AS F_Pos,
	dbo.Fun_BDTT_GetRegisterName(A.F_RegisterID,21, @LanguageCode, 0 ) AS F_RegisterName,
	dbo.Fun_BDTT_GetPlayerNOCName(A.F_RegisterID)
	FROM TS_Match_Result AS A
	LEFT JOIN TS_Match AS B ON B.F_MatchID = A.F_MatchID
    WHERE B.F_PhaseID = @PhaseID AND B.F_MatchComment1 IS NOT NULL
    ORDER BY F_Pos
	
	SELECT F_Pos, CONVERT(NVARCHAR(10), F_POS) + '.' + F_RegisterName + 
	CASE WHEN @EventType != 3 THEN '(' + F_NOCName + ')' ELSE '' END AS F_RegisterName
	FROM #TMP_TABLE
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

--Proc_Report_BDTT_AllRank_PlayerList 5,8,'CHN'