IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchRank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_GF_GetMatchRank]
--描    述: 高尔夫项目，添加一个洞的杆数后，计算排名，在界面更新。
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2010年10月05日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_GF_GetMatchRank]
	@MatchID				INT,
	@LanguageCode           CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
		F_CompetitionPosition	INT,
		[Order]                 INT,
		[Name]                  NVARCHAR(150),	
		[Round Rank]		    NVARCHAR(100),
		[Total]				    NVARCHAR(100),
		[Pos]                   INT,                 
	)

	-- 在临时表中插入基本信息
	INSERT #MatchResult
		(F_CompetitionPosition, [Order], [Name], [Round Rank], [Total], Pos)	
		(
			SELECT 
				  MR.F_CompetitionPosition 
				, MR.F_CompetitionPositionDes1
				, (CASE WHEN I.F_IRMCODE IS NULL THEN '' ELSE '(' + I.F_IRMCODE + ')' END)+RD.F_LongName 
				, (CASE WHEN MR.F_PointsCharDes2 IS NULL THEN '' WHEN MR.F_PointsCharDes2 = '0' THEN 'Par' ELSE MR.F_PointsCharDes2 END) + '(' + MR.F_PointsCharDes1 + ')'
				  + '(Rk.' + (CASE WHEN MR.F_PointsNumDes1 IS NULL THEN '' ELSE CAST(MR.F_PointsNumDes1 AS NVARCHAR(10)) END) + ')'
				, (CASE WHEN MR.F_PointsCharDes4 IS NULL THEN 'Par' WHEN MR.F_PointsCharDes4 = '0' THEN 'Par' ELSE MR.F_PointsCharDes4 END) + '(' + CASE WHEN MR.F_PointsCharDes3 IS NULL THEN '' ELSE MR.F_PointsCharDes3 END + ')'
				  + '(Rk.' + (CASE WHEN MR.F_Rank IS NULL THEN '' ELSE CAST(MR.F_Rank AS NVARCHAR(10)) END) + ')'
				, F_DisplayPosition  
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
			WHERE MR.F_MatchID = @MatchID 
		)

	SELECT * FROM #MatchResult ORDER BY [Order], F_CompetitionPosition

SET NOCOUNT OFF
END

GO



