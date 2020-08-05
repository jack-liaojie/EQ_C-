IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetHolePar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetHolePar]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_GF_GetHolePar]
----功		  能：得到一场比赛的洞的信息
----作		  者：张翠霞 
----日		  期: 2010-09-27

CREATE PROCEDURE [dbo].[Proc_Report_GF_GetHolePar] (	
	@MatchID					INT
)	
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
	
	CREATE TABLE #TableHole(
	                        Par NVARCHAR(10)
	                        )
	                        
	INSERT INTO #TableHole(Par)
	VALUES('Par')

	-- 遍历分段点加入临时表的字段
	SET @i = 1
	WHILE @i <= @SplitNum
	BEGIN
		
		-- 添加每个洞的标准杆，外加IN OUT
		SET @SplitSQL = ' ALTER TABLE #TableHole ADD [' + CAST(@i AS NVARCHAR(10)) + '] INT ' 
		EXEC (@SplitSQL)
		
		IF @i = @SplitNum / 2
		BEGIN
		    SET @SplitSQL = ' ALTER TABLE #TableHole ADD [' + 'OUT' + '] INT ' 
		    EXEC (@SplitSQL)
		END
		ELSE IF @i = @SplitNum
		BEGIN
		    SET @SplitSQL = ' ALTER TABLE #TableHole ADD [' + 'IN' + '] INT ' 
		    EXEC (@SplitSQL)
		    
		    SET @SplitSQL = ' ALTER TABLE #TableHole ADD [' + 'Total' + '] INT ' 
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
		
		SET @SplitSQL = 'Update #TableHole 
			SET ' + @Tn_Net + ' = CAST(F_MatchSplitComment AS INT)' 
				+ 
			'				
			FROM TS_Match_Split_Info
			WHERE F_Order = ' + @SplitName + ' AND F_MatchID = ' + CAST(@MatchID AS NVARCHAR(10)) +  ' AND (F_FatherMatchSplitID = 0 OR F_FatherMatchSplitID IS NULL)'

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
		SET @SplitSQL = 'Update #TableHole SET [OUT] = ' + RIGHT(@OutCols, (LEN(@OutCols) - 3))
		EXEC (@SplitSQL)
		
		SET @OutCols = ''
		SELECT @OutCols = @OutCols + ' + [' + CAST(F_Order AS NVARCHAR(MAX)) + ']' FROM TS_Match_Split_Info WHERE F_Order > (@SplitNum / 2)	AND F_MatchID = @MatchID
		SET @SplitSQL = 'Update #TableHole SET [IN] = ' + RIGHT(@OutCols, (LEN(@OutCols) - 3))
		EXEC (@SplitSQL)
		
		SET @OutCols = ''
		SELECT @OutCols = @OutCols + ' + [' + CAST(F_Order AS NVARCHAR(MAX)) + ']' FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		SET @SplitSQL = 'Update #TableHole SET [Total] = ' + RIGHT(@OutCols, (LEN(@OutCols) - 3))
		EXEC (@SplitSQL)
    END
	
	SELECT * FROM #TableHole
	
SET NOCOUNT OFF
END


GO


