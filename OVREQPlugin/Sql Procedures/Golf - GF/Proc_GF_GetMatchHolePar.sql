IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchHolePar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchHolePar]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_GF_GetMatchHolePar]
----��		  �ܣ��õ�һ�������Ķ�����Ϣ
----��		  �ߣ��Ŵ�ϼ 
----��		  ��: 2010-09-27

CREATE PROCEDURE [dbo].[Proc_GF_GetMatchHolePar] (	
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

    -- ����һ�� Match �м��� Split
	SELECT @SplitNum = COUNT(F_MatchSplitID)
	FROM TS_Match_Split_Info
	WHERE F_MatchID = @MatchID AND (F_FatherMatchSplitID <= 0 OR F_FatherMatchSplitID IS NULL)
	
	CREATE TABLE #TableHole(
	                        Par NVARCHAR(10)
	                        )
	                        
	INSERT INTO #TableHole(Par)
	VALUES('Par')

	-- �����ֶε������ʱ����ֶ�
	SET @i = 1
	WHILE @i <= @SplitNum
	BEGIN
		
		-- ���ÿ�����ı�׼�ˣ����IN OUT
		SET @SplitSQL = ' ALTER TABLE #TableHole ADD [' + CAST(@i AS NVARCHAR(10)) + '] INT ' 
		EXEC (@SplitSQL)

		-- ѭ������ + 1
		SET @i = @i + 1
	END

	-- �����ֶε������ʱ��ķֶγɼ�
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
			WHERE F_Order = ' + @SplitName + 'AND F_MatchID = ' + CAST(@MatchID AS NVARCHAR(10)) + ' AND (F_FatherMatchSplitID = 0 OR F_FatherMatchSplitID IS NULL)'

		EXEC (@SplitSQL)

		-- ѭ������ + 1
		SET @i = @i + 1
	END
	
	IF @SplitNum > 0
	BEGIN
		ALTER TABLE #TableHole DROP COLUMN Par	
		SELECT * FROM #TableHole
	END
	
SET NOCOUNT OFF
END

GO


