IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_GF_GetMatchResult]
--描    述: 高尔夫项目获取成绩信息(包括各个洞的成绩)
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2010年09月28日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_GF_GetMatchResult]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SplitSQL		NVARCHAR(MAX)
	DECLARE @SplitNum		INT
	DECLARE @i				INT
	DECLARE @Tn_Net			NVARCHAR(50)
	DECLARE @SplitName		NVARCHAR(50)

	-- 计算一场 Match 有几个 Split
	SELECT @SplitNum = COUNT(F_MatchSplitID)
	FROM TS_Match_Split_Info
	WHERE F_MatchID = @MatchID AND (F_FatherMatchSplitID <= 0 OR F_FatherMatchSplitID IS NULL)

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
		F_CompetitionPosition	INT,
		[Order]                 INT,
		NOC						CHAR(3),
		Name					NVARCHAR(100),
        [Group]				    INT,
		Sides				    INT,
		Tee						INT,
		[Time]                  NVARCHAR(10), 	
		[Round Rank]		    NVARCHAR(100),
		[Total]				    NVARCHAR(100),
		F_MatchID               INT
	)

	-- 在临时表中插入基本信息
	INSERT #MatchResult
		(F_CompetitionPosition, [Order], [Group], Sides, Tee, [Time], NOC , Name, [Round Rank], [Total], F_MatchID)	
		(
			SELECT 
				  MR.F_CompetitionPosition 
				, MR.F_CompetitionPositionDes1
				, MR.F_CompetitionPositionDes2
				, MR.F_FinishTimeNumDes
				, MR.F_StartTimeNumDes
				, MR.F_StartTimeCharDes
				, D.F_DelegationCode
				, (CASE WHEN I.F_IRMCODE IS NULL THEN '' ELSE '(' + I.F_IRMCODE + ')' END) + RD.F_LongName
				, (CASE WHEN MR.F_PointsCharDes2 IS NULL THEN '' WHEN MR.F_PointsCharDes2 = '0' THEN 'Par' ELSE MR.F_PointsCharDes2 END) + '(' + MR.F_PointsCharDes1 + ')'
				  + '(Rk.' + (CASE WHEN MR.F_PointsNumDes1 IS NULL THEN '' ELSE CAST(MR.F_PointsNumDes1 AS NVARCHAR(10)) END) + ')'
				, (CASE WHEN MR.F_PointsCharDes4 IS NULL THEN 'Par' WHEN MR.F_PointsCharDes4 = '0' THEN 'Par' ELSE MR.F_PointsCharDes4 END) + '(' + CASE WHEN MR.F_PointsCharDes3 IS NULL THEN '' ELSE MR.F_PointsCharDes3 END + ')'
				  + '(Rk.' + (CASE WHEN MR.F_Rank IS NULL THEN '' ELSE CAST(MR.F_Rank AS NVARCHAR(10)) END) + ')'
				, MR.F_MatchID
			FROM TS_Match_Result AS MR
				LEFT JOIN TR_Register AS R
					ON MR.F_RegisterID = R.F_RegisterID
				LEFT JOIN TC_Delegation AS D
					ON R.F_DelegationID = D.F_DelegationID
				LEFT JOIN TR_Register_Des AS RD
					ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_IRM AS I
					ON MR.F_IRMID = I.F_IRMID
			WHERE MR.F_MatchID = @MatchID 
		)

	-- 遍历分段点加入临时表的字段
	SET @i = 1
	WHILE @i <= @SplitNum
	BEGIN
		
		-- 添加每个洞的标准杆，外加IN OUT
		SET @SplitSQL = ' ALTER TABLE #MatchResult ADD [' + CAST(@i AS NVARCHAR(10)) + '] INT ' 
		EXEC (@SplitSQL)
		
		IF @i = @SplitNum / 2
		BEGIN
		    SET @SplitSQL = ' ALTER TABLE #MatchResult ADD [' + 'OUT' + '] INT ' 
		    EXEC (@SplitSQL)
		END
		ELSE IF @i = @SplitNum
		BEGIN
		    SET @SplitSQL = ' ALTER TABLE #MatchResult ADD [' + 'IN' + '] INT ' 
		    EXEC (@SplitSQL)
		END

		-- 循环变量 + 1
		SET @i = @i + 1
	END

	-- 遍历分段点更新临时表的分段成绩
	SET @i = 1
	WHILE @i <= @SplitNum
	BEGIN
		SET @Tn_Net = '[' + CAST(@i AS NVARCHAR(10)) + ']' 
		SET @SplitName = CAST(@i AS NVARCHAR(10))
		
		SET @SplitSQL = 'Update #MatchResult 
			SET ' + @Tn_Net + ' = CASE 
					WHEN B.F_Points IS NOT NULL 
						THEN B.F_Points 
					ELSE 0 
				END' 
				+ 
			'				
			FROM #MatchResult AS A
			LEFT JOIN TS_Match_Split_Result AS B
				ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition =  B.F_CompetitionPosition
			LEFT JOIN TS_Match_Split_Info AS C
				ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID
			WHERE C.F_Order = ' + @SplitName + ' AND (C.F_FatherMatchSplitID = 0 OR C.F_FatherMatchSplitID IS NULL)'

		EXEC (@SplitSQL)

		-- 循环变量 + 1
		SET @i = @i + 1
	END
	
	--添加OUT IN信息
	IF @SplitNum > 0
	BEGIN
		DECLARE @OutCols AS NVARCHAR(MAX)
			
		SET @OutCols = ''
		SELECT @OutCols = @OutCols + ' + [' + CAST(F_Order AS NVARCHAR(MAX)) + ']' FROM TS_Match_Split_Info WHERE F_Order < (@SplitNum / 2 + 1) AND F_MatchID = @MatchID
		SET @SplitSQL = 'Update #MatchResult SET [OUT] = ' + RIGHT(@OutCols, (LEN(@OutCols) - 3))
		EXEC (@SplitSQL)
		
		SET @OutCols = ''
		SELECT @OutCols = @OutCols + ' + [' + CAST(F_Order AS NVARCHAR(MAX)) + ']' FROM TS_Match_Split_Info WHERE F_Order > (@SplitNum / 2)	AND F_MatchID = @MatchID
		SET @SplitSQL = 'Update #MatchResult SET [IN] = ' + RIGHT(@OutCols, (LEN(@OutCols) - 3))
		EXEC (@SplitSQL)
		
		SET @i = 1
	    WHILE @i <= @SplitNum
	    BEGIN
		
		-- 将0置为NULL
		SET @SplitSQL = ' Update #MatchResult SET [' + CAST(@i AS NVARCHAR(10)) + '] = NULL WHERE' + '[' + CAST(@i AS NVARCHAR(10)) + '] = 0'
		EXEC (@SplitSQL)

		-- 循环变量 + 1
		SET @i = @i + 1
	    END
	
		UPDATE #MatchResult SET [OUT] = NULL WHERE [OUT] = 0
		UPDATE #MatchResult SET [IN] = NULL WHERE [IN] = 0
	END

    SET @SplitSQL = ' ALTER TABLE #MatchResult ADD [' + 'Pos' + '] INT ' 
	  EXEC (@SplitSQL)
	UPDATE tr SET tr.[Pos] = mr.F_displayPosition from #MatchResult as tr
	left join TS_Match_Result as mr on tr.F_MatchID = mr.F_MatchID and tr.F_CompetitionPosition = mr.F_CompetitionPosition
	
	SET	@SplitSQL = 'ALTER TABLE #MatchResult DROP COLUMN F_MatchID'
		EXEC (@SplitSQL)

	SELECT * FROM #MatchResult ORDER BY [Order], F_CompetitionPosition

SET NOCOUNT OFF
END

GO



