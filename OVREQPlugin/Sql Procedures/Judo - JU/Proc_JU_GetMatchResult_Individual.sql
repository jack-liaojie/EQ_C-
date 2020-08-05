IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchResult_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchResult_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_GetMatchResult_Individual]
--描    述: 获取单人项目的一场比赛参赛者成绩.
--创 建 人: 邓年彩
--日    期: 2010年11月4日 星期四
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchResult_Individual]
	@MatchID						INT,
	@Color							INT,	-- 1 - 蓝方, 2 - 白方.
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END

	SELECT MR.F_CompetitionPosition AS CompPos
		, CompName = 
			CASE 
			WHEN R.F_RegisterID=-1 THEN N'BYE'
			WHEN ISNULL(IC.F_InscriptionComment2,N'')!=N'' THEN RD.F_LongName+N'--!!!-('+IC.F_InscriptionComment2+N')' 
			ELSE DD.F_DelegationShortName + N' - ' + RD.F_LongName
		END
		, F_PointsNumDes1 AS [IPP]
		, F_PointsNumDes2 AS [WAZ]
		, F_PointsNumDes3 AS [YUK]
		, [S1] = CASE MR.F_PointsNumDes4 WHEN 1 THEN 1 ELSE 0 END
		, [S2] = CASE MR.F_PointsNumDes4 WHEN 2 THEN 1 ELSE 0 END
		, [S3] = CASE MR.F_PointsNumDes4 WHEN 3 THEN 1 ELSE 0 END
		, [S4] = CASE MR.F_PointsNumDes4 WHEN 4 THEN 1 ELSE 0 END
		, [SH] = CASE MR.F_PointsCharDes4 WHEN N'H' THEN 1 ELSE 0 END
		, [SX] = CASE MR.F_PointsCharDes4 WHEN N'X' THEN 1 ELSE 0 END
		, [Hantei] = CASE MR.F_PointsCharDes1 WHEN N'1' THEN 1 ELSE 0 END
		, I.F_IRMCODE AS [IRMCode]
		, MR.F_ResultID AS [ResultID]
		, MR.F_Rank AS [Rank]
	FROM TS_Match_Result AS MR
	LEFT JOIN TS_Match AS M
		ON MR.F_MatchID=M.F_MatchID
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID
	LEFT JOIN TR_Register AS R
		ON MR.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD
		ON D.F_DelegationID=DD.F_DelegationID and DD.F_LanguageCode=@LanguageCode
	LEFT JOIN TR_Inscription AS IC
		ON IC.F_EventID=p.F_EventID AND IC.F_RegisterID=R.F_RegisterID
	LEFT JOIN TC_IRM AS I
		ON MR.F_IRMID = I.F_IRMID
	WHERE MR.F_MatchID = @MatchID AND MR.F_CompetitionPositionDes1 = @Color

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatchResult_Individual] 2 ,1

*/