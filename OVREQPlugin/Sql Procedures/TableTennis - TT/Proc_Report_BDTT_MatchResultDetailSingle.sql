IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BDTT_MatchResultDetailSingle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BDTT_MatchResultDetailSingle]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BDTT_MatchResultDetailSingle]
--描    述：获取全排名报表的详细成绩
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年08月22日


CREATE PROCEDURE [dbo].[Proc_Report_BDTT_MatchResultDetailSingle](
												@EventID		   INT,
												@LanguageCode	   NVARCHAR(10)
)
As
Begin
SET NOCOUNT ON 
	
	SELECT A.F_PhaseID, D.F_PhaseShortName, dbo.Fun_BDTT_GetRegisterName(B1.F_RegisterID, 21, @LanguageCode, 0 ) AS F_PlayerA,
		   dbo.Fun_BDTT_GetRegisterName(B2.F_RegisterID, 21, @LanguageCode, 0 ) AS F_PlayerB,
		   dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 1) AS F_PosA,
		   dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 2) AS F_PosB,
		   dbo.Fun_BDTT_GetPlayerNOCName(B1.F_RegisterID) AS F_NOCA,
		   dbo.Fun_BDTT_GetPlayerNOCName(B2.F_RegisterID) AS F_NOCB,
		   dbo.Fun_Report_BD_GetMatchResultDes(A.F_MatchID, 12, 0) AS F_MatchScoreDes,
		   dbo.Fun_Report_BD_GetMatchResultDes(A.F_MatchID, 5, 0) AS F_GameScoreDes
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	RIGHT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_EventID = @EventID
	LEFT JOIN TS_Phase_Des AS D ON D.F_PhaseID = A.F_PhaseID AND D.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchStatusID IN (100,110) ORDER BY C.F_Order,A.F_Order
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

--Proc_Report_BDTT_AllRank_Result 5,8,'CHN'