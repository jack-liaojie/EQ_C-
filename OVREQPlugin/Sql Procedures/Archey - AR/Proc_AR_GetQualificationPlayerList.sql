IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetQualificationPlayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetQualificationPlayerList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_GetQualificationPlayerList]
--描    述: 射箭项目,获取预赛运动员列表
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年03月31日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetQualificationPlayerList]
	@MatchID				INT,
	@LanguageCode			CHAR(3) = 'CHN'
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(MAX)
	DECLARE @EndIdx			INT
	DECLARE @ArrowIdx		INT
	DECLARE @EndCount		INT
	DECLARE @ArrowCount		INT
	DECLARE @EventID		INT
  
	-- 计算一场 Match 有几个分段        -- 计算一场 Match 有几个门
	---SELECT @EndCount = F_MatchComment1, @ArrowCount = F_MatchComment2 FROM TS_Match WHERE F_MatchID = @MatchID

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
		F_CompetitionPosition	INT,
		[Target]				NVARCHAR(100),
		[Name]					NVARCHAR(100),
		NOC						NVARCHAR(100),
		LongDistinceA			int,
		LongDistinceB			int,
		ShortDistinceA			int,
		ShortDistinceB			int,
		LRankA					NVARCHAR(100),
		LRankB					NVARCHAR(100),
		SRankA					NVARCHAR(100),
		SRankB					NVARCHAR(100),
		[10s]					int,
		[Xs]					int,
		[Total]					int,
		[Rank]					int,
		[IRM]					NVARCHAR(100),
		F_MatchID				int,
		F_RegisterID			int NULL,
		F_Records				NVARCHAR(100)
	)


	-- 在临时表中插入基本信息
	INSERT INTO #MatchResult 
		(F_CompetitionPosition, [Target], [Name], NOC, LongDistinceA,LongDistinceB,ShortDistinceA,ShortDistinceB,
		LRankA,LRankB,SRankA,SRankB,[10s],Xs,[Total],[Rank],[IRM],F_MatchID,F_RegisterID,F_Records) 
	SELECT
		  MR.F_CompetitionPosition 
		, MR.F_Comment
		, RD.F_LongName
		, DD.F_DelegationShortName 
		, MR.F_PointsNumDes1
		, MR.F_PointsNumDes2
		, MR.F_PointsNumDes3
		, MR.F_PointsNumDes4
		, MR.F_PointsCharDes1
		, MR.F_PointsCharDes2
		, MR.F_PointsCharDes3
		, MR.F_PointsCharDes4
        , MR.F_WinPoints
        , MR.F_LosePoints
        , MR.F_Points
        , MR.F_Rank 
        , II.F_IRMCODE
        , MR.F_MatchID
        , MR.F_RegisterID
        , dbo.Fun_AR_GetRecordString(@MatchID,MR.F_RegisterID,'0') AS F_Records
	FROM TS_Match_Result AS MR  
		LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
		LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode =  @LanguageCode  
		LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
		LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
		LEFT JOIN TC_IRM AS II ON MR.F_IRMID = II.F_IRMID AND II.F_DisciplineID = E.F_DisciplineID 
		LEFT JOIN TC_IRM_Des AS ID ON II.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation_Des AS DD ON DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode =  @LanguageCode 
			WHERE MR.F_MatchID = @MatchID



----主键及聚集索引--400ms

	CREATE TABLE #Temp_Result(
		[F_MatchSplitID] [int] NOT NULL,
		[F_MatchSplitCode] [nvarchar](20) COLLATE Chinese_PRC_CI_AS NOT NULL,
		[F_MatchSplitType] [int] NOT NULL,
		[F_CompetitionPosition] [int] NOT NULL,
		[F_Points] [int] NULL,
		PRIMARY KEY CLUSTERED 
		(
		[F_MatchSplitType] ASC,
		[F_MatchSplitCode] ASC,
		[F_CompetitionPosition] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF)
	)

	INSERT INTO #Temp_Result (F_MatchSplitID, F_CompetitionPosition, F_Points, F_MatchSplitCode, F_MatchSplitType)
	SELECT A.F_MatchSplitID, A.F_CompetitionPosition, A.F_Points, B.F_MatchSplitCode, B.F_MatchSplitType
		 FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
			WHERE A.F_MatchID = @MatchID


	--获取每一轮的成绩
	SET @EndIdx = 1
	WHILE @EndIdx <= @EndCount
	BEGIN

		SET @SQL = 'UPDATE #MatchResult SET [End ' + CAST(@EndIdx AS NVARCHAR(MAX)) + '] = B.F_Points' 
					+ ' FROM #MatchResult AS A LEFT JOIN #Temp_Result AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition '
					+ ' WHERE B.F_MatchSplitType = 0 AND B.F_MatchSplitCode = ' + CAST(@EndIdx AS NVARCHAR(MAX))

		EXEC (@SQL)
		SET @EndIdx = @EndIdx + 1
	END

	--获取每一箭的成绩
	SET @ArrowCount = @ArrowCount * @EndCount
    SET @ArrowIdx = 1
    WHILE @ArrowIdx <= @ArrowCount
    BEGIN

		SET @SQL = 'UPDATE #MatchResult SET [' + CAST(@ArrowIdx AS NVARCHAR(MAX)) + '] = B.F_Points' 
					+ ' FROM #MatchResult AS A LEFT JOIN #Temp_Result AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition '
					+ ' WHERE B.F_MatchSplitType = 1 AND B.F_MatchSplitCode = ' + CAST(@ArrowIdx AS NVARCHAR(MAX))

		EXEC (@SQL)
		SET @ArrowIdx = @ArrowIdx + 1
    END


--	ALTER TABLE #MatchResult DROP COLUMN F_RegisterID
	SELECT * FROM #MatchResult 
	ORDER BY LEFT(RIGHT('00000'+[Target],5) + '99999',6),
	F_CompetitionPosition

	TRUNCATE TABLE #Temp_Result
	DROP TABLE #Temp_Result

	TRUNCATE TABLE #MatchResult
	DROP TABLE #MatchResult
	RETURN

SET NOCOUNT OFF
END

GO

/*
EXEC Proc_AR_GetQualificationPlayerList 129
*/
