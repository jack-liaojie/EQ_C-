IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_TS_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_TS_GetMatchInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_BD_TS_GetMatchInfo]
--描    述: 获取比赛信息
--创 建 人: 王强
--日    期: 2011-6-28
--修改记录：
/*			
			日期					修改人		修改内容
			
*/



CREATE PROCEDURE [dbo].[Proc_BD_TS_GetMatchInfo]
		@MatchID INT,
		@LanguageCode NVARCHAR(10)
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #TMP_TABLE
	(
		F_SubMatchNo INT,
		F_SubMatchType INT,
		F_AthleteA1 NVARCHAR(200),
		F_AthleteA2 NVARCHAR(200),
		F_AthleteB1 NVARCHAR(200),
		F_AthleteB2 NVARCHAR(200),
		F_NOCA1 NVARCHAR(10),
		F_NOCA2 NVARCHAR(10),
		F_NOCB1 NVARCHAR(10),
		F_NOCB2 NVARCHAR(10)
	)
	
	DECLARE @MatchType INT
	
	SELECT @MatchType = C.F_PlayerRegTypeID FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	IF @MatchType = 1
	BEGIN
		INSERT INTO #TMP_TABLE
		SELECT 0, 0, ISNULL(C1.F_SBShortName,''), NULL,  
			   ISNULL(C2.F_SBShortName,''), NULL, 
			   dbo.Fun_BDTT_GetPlayerNOC(B1.F_RegisterID), NULL,
			   dbo.Fun_BDTT_GetPlayerNOC(B2.F_RegisterID), NULL
		FROM TS_Match AS A 
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = @LanguageCode
		WHERE A.F_MatchID = @MatchID
		
	END 
	ELSE IF @MatchType = 2
	BEGIN
		INSERT INTO #TMP_TABLE
		SELECT 0 AS Match_No, 0 AS MatchType, D1.F_SBShortName,D2.F_SBShortName,
			   D3.F_SBShortName, D4.F_SBShortName, 
			   dbo.Fun_BDTT_GetPlayerNOC(D1.F_RegisterID),
			   dbo.Fun_BDTT_GetPlayerNOC(D2.F_RegisterID),
			   dbo.Fun_BDTT_GetPlayerNOC(D3.F_RegisterID),
			   dbo.Fun_BDTT_GetPlayerNOC(D4.F_RegisterID)
		FROM TS_Match AS A 
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	
		LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
		LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
		LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = @LanguageCode
		
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		
		LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
		LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
		LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = @LanguageCode
		WHERE A.F_MatchID = @MatchID
		
		
	END
	ELSE IF @MatchType = 3
	BEGIN
		
		INSERT INTO #TMP_TABLE
		SELECT A.F_Order, A.F_MatchSplitType, C1.F_SBShortName, NULL, C2.F_SBShortName, NULL,
				dbo.Fun_BDTT_GetPlayerNOC(C1.F_RegisterID), NULL,dbo.Fun_BDTT_GetPlayerNOC(C2.F_RegisterID),NULL
		FROM TS_Match_Split_Info AS A 
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = @LanguageCode
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND F_MatchSplitType IN (1,2)
		
		INSERT INTO #TMP_TABLE
		SELECT A.F_Order, A.F_MatchSplitType, D1.F_SBShortName, D2.F_SBShortName,  
		   D3.F_SBShortName, D4.F_SBShortName,
		   dbo.Fun_BDTT_GetPlayerNOC(D1.F_RegisterID),
		   dbo.Fun_BDTT_GetPlayerNOC(D2.F_RegisterID),
		   dbo.Fun_BDTT_GetPlayerNOC(D3.F_RegisterID),
		   dbo.Fun_BDTT_GetPlayerNOC(D4.F_RegisterID)
		FROM TS_Match_Split_Info AS A 
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
	
		LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
		LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
		LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = @LanguageCode
		
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		
		LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
		LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
		LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = @LanguageCode
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND F_MatchSplitType IN (3,4,5)
				
	END
	
	--DECLARE @MatchStartTime NVARCHAR(30)
	--SELECT dbo.Fun_Report_BD_GetDateTime(F_StartTime,3) FROM TS_Match WHERE F_MatchID = @MatchID
	
	SELECT @MatchType AS F_MatchType, * FROM #TMP_TABLE

SET NOCOUNT OFF
END

