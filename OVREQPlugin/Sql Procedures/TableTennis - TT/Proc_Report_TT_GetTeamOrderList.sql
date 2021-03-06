IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_GetTeamOrderList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_GetTeamOrderList]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_TT_GetTeamOrderList]
--描    述：获取团体赛出场顺序表
--创 建 人：王强
--日    期：2011-05-27


CREATE PROCEDURE [dbo].[Proc_Report_TT_GetTeamOrderList](
												@MatchID		    INT,
												@Swap INT = 0
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #TMP_TABLE
	(
		F_Position INT,
		TeamName NVARCHAR(100),
		PlayerName1 NVARCHAR(100),
		PlayerName2 NVARCHAR(100),
		PlayerName3 NVARCHAR(100),
		PlayerName4 NVARCHAR(100),
		PlayerName5 NVARCHAR(100)
	)
	
	CREATE TABLE #PlayName
	(
		F_Order INT,
		PlayerName NVARCHAR(100)
	)
	
	DECLARE @PosA INT = 1
	DECLARE @PosB INT = 2
	IF @Swap = 1
	BEGIN
		SET @PosA = 2
		SET @PosB = 1
	END
	
	INSERT INTO #TMP_TABLE (F_Position, TeamName)
	(
		SELECT 1, dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID) + ' - ' + B.F_PrintLongName
		FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @PosA
	)
	
	INSERT INTO #TMP_TABLE (F_Position, TeamName)
	(
		SELECT 2, dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID) + ' - ' + B.F_PrintLongName
		FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @PosB
	)

	INSERT INTO #PlayName (F_Order, PlayerName)
	(
		SELECT TOP 5 ROW_NUMBER() OVER(ORDER BY C.F_PrintLongName), C.F_PrintLongName
		FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_MemberRegisterID AND C.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	)
	
	--PRINT @PosA
	--return
	
	UPDATE #TMP_TABLE SET PlayerName1 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 1) WHERE F_Position = @PosA
	UPDATE #TMP_TABLE SET PlayerName2 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 2) WHERE F_Position = @PosA
	UPDATE #TMP_TABLE SET PlayerName3 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 3) WHERE F_Position = @PosA
	UPDATE #TMP_TABLE SET PlayerName4 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 4) WHERE F_Position = @PosA
	UPDATE #TMP_TABLE SET PlayerName5 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 5) WHERE F_Position = @PosA
	
	DELETE FROM #PlayName
	INSERT INTO #PlayName (F_Order, PlayerName)
	(
		SELECT TOP 5 ROW_NUMBER() OVER(ORDER BY C.F_PrintLongName), C.F_PrintLongName
		FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_MemberRegisterID AND C.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
	)
	--SELECT * FROM #PlayName
	--return
	UPDATE #TMP_TABLE SET PlayerName1 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 1) WHERE F_Position = @PosB
	UPDATE #TMP_TABLE SET PlayerName2 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 2) WHERE F_Position = @PosB
	UPDATE #TMP_TABLE SET PlayerName3 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 3) WHERE F_Position = @PosB
	UPDATE #TMP_TABLE SET PlayerName4 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 4) WHERE F_Position = @PosB
	UPDATE #TMP_TABLE SET PlayerName5 = (SELECT PlayerName FROM #PlayName WHERE F_Order = 5) WHERE F_Position = @PosB
	
	DROP TABLE #PlayName
	
	SELECT * FROM #TMP_TABLE

Set NOCOUNT OFF
End	


GO

