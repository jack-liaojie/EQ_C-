IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchSplitResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchSplitResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_JU_GetMatchSplitResult_Team]
--描    述: 获取团体项目的一场比赛参赛者成绩.
--创 建 人: 宁顺泽
--日    期: 2010年12月28日 星期一
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchSplitResult_Team]
	@MatchID						INT,
	@MatchSplitID					INT,
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
	DECLARE @TeamName NVARCHAR(100)
	SELECT @TeamName=RD.F_LongName 
	FROM TS_Match_Result AS MR
		LEFT JOIN TR_Register_Des AS RD
			ON MR.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
	WHERE MR.F_MatchID=@MatchID AND MR.F_CompetitionPosition=@Color
		
	SELECT MR.F_CompetitionPosition AS CompPos
		, CompName = CASE R.F_RegisterID
			WHEN -1 THEN N'BYE'
			ELSE D.F_DelegationCode +N' - ' +@TeamName+ N' - ' + RD.F_LongName
		END
		, MR.F_PointsNumDes1 AS [IPP]
		, MR.F_PointsNumDes2 AS [WAZ]
		, MR.F_PointsNumDes3 AS [YUK]
		, [S1] = CASE MR.F_SplitPointsNumDes3 WHEN 1 THEN 1 ELSE 0 END
		, [S2] = CASE MR.F_SplitPointsNumDes3 WHEN 2 THEN 1 ELSE 0 END
		, [S3] = CASE MR.F_SplitPointsNumDes3 WHEN 3 THEN 1 ELSE 0 END
		, [S4] = CASE MR.F_SplitPointsNumDes3 WHEN 4 THEN 1 ELSE 0 END
		, [SH] = CASE MR.F_PointsCharDes3 WHEN N'H' THEN 1 ELSE 0 END
		, [SX] = CASE MR.F_PointsCharDes3 WHEN N'X' THEN 1 ELSE 0 END
		, [Hantei] = CASE MR.F_PointsCharDes1 WHEN N'1' THEN 1 ELSE 0 END
		, I.F_IRMCODE AS [IRMCode]
		, MR.F_ResultID AS [ResultID]
		, MR.F_Rank AS [Rank]
	FROM TS_Match_Split_Result AS MR
	LEFT JOIN TR_Register AS R
		ON MR.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_IRM AS I
		ON MR.F_IRMID = I.F_IRMID
	WHERE MR.F_MatchID = @MatchID AND F_MatchSplitID=@MatchSplitID AND MR.F_CompetitionPosition = @Color

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatchSplitResult_Team] 45,1,2

*/
GO


