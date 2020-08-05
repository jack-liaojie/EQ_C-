IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetSplitResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetSplitResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2010-12-24 
----修改	记录:


CREATE FUNCTION [Func_SH_GetSplitResult]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							F_CompetitionPosition INT, 
							F_Stage INT, 
							F_Series1 INT, 
							F_Series2 INT, 
							F_Series3 INT, 
							F_Series4 INT,
							F_Series5 INT, 
							F_Series6 INT
							)
AS
BEGIN

		--根据EventCode来决定有几个Stage和Series
		
		DECLARE @EventCode CHAR(3)
		DECLARE @StageCount INT
		DECLARE @SeriesCount INT

		SELECT @EventCode = Event_Code,
				@StageCount = Stage_Count, 
				@SeriesCount = Series_Count 
		FROM dbo.[Func_SH_GetStageCount] (@MatchID)

		DECLARE @T1  Table(F_CompetitionPosition INT, F_Series INT, F_Total INT)

		DECLARE @N INT
		SET @N = 1
		WHILE @N <= @StageCount * @SeriesCount
		BEGIN					
			INSERT @T1(F_CompetitionPosition, F_Series, F_Total)
			SELECT A.F_CompetitionPosition, @N, SUM(F_ActionDetail1) AS Total
			FROM TS_Match_Result A
			LEFT JOIN TS_Match_ActionList B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
			WHERE A.F_MatchID = @MatchID AND F_MatchSplitID BETWEEN 10*(@N-1)+1 AND 10*@N
			GROUP BY A.F_CompetitionPosition
			SET @N = @N + 1
		END
							
		-- 一维转成二维
		IF @StageCount = 1
		BEGIN
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2, F_Series3, F_Series4, F_Series5, F_Series6)
			SELECT F_CompetitionPosition, 1, [1], [2], [3], [4], [5], [6]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([1], [2], [3], [4], [5], [6])
			)
			as t
		END

		IF @StageCount = 2
		BEGIN
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2, F_Series3)
			SELECT F_CompetitionPosition, 1, [1], [2], [3]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([1], [2], [3])
			)
			as t
			
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2, F_Series3)
			SELECT F_CompetitionPosition, 2, [4], [5], [6]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([4], [5], [6])
			)
			as t
			
		END
		
		IF @StageCount = 3 AND @SeriesCount = 4
		BEGIN
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2, F_Series3, F_Series4)
			SELECT F_CompetitionPosition, 1, [1], [2], [3], [4]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([1], [2], [3], [4])
			)
			as t
			
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2, F_Series3, F_Series4)
			SELECT F_CompetitionPosition, 2,  [5], [6], [7], [8]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ( [5], [6], [7], [8] )
			)
			as t
			
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2, F_Series3, F_Series4)
			SELECT F_CompetitionPosition, 3, [9], [10], [11], [12]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([9], [10], [11], [12] )
			)
			as t			
		END		
		
		
		IF @StageCount = 3 AND @SeriesCount = 2
		BEGIN
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2)
			SELECT F_CompetitionPosition, 1, [1], [2]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([1], [2])
			)
			as t
			
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2)
			SELECT F_CompetitionPosition, 2,  [3], [4]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ( [3], [4] )
			)
			as t
			
			INSERT @retTable(F_CompetitionPosition, F_Stage, F_Series1, F_Series2)
			SELECT F_CompetitionPosition, 3, [5], [6]
			FROM @T1
			pivot (
				sum(F_Total) FOR F_Series IN ([5], [6])
			)
			as t			
		END	
				
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetSplitResult] (1)
-- SELECT * FROM dbo.[Func_SH_GetSplitResult] (27)

--SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 