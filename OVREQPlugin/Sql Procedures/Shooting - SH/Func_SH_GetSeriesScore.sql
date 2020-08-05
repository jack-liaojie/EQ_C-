IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetSeriesScore]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetSeriesScore]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2010-12-24 
----修改	记录:


CREATE FUNCTION [Func_SH_GetSeriesScore]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							F_RegisterID	INT,
							F_CompetitionPosition INT, 
							F_EventCode CHAR(3),
							F_Stage INT,
							F_Series INT,
							Series_Code NVARCHAR(10), 
							Series_Score INT
							)
AS
BEGIN

		DECLARE @EventCode NVARCHAR(3)
		DECLARE @PhaseCode NVARCHAR(1)
		DECLARE @StageCount INT
		DECLARE @SeriesCount INT
		DECLARE @SexCode	NVARCHAR(10)
		DECLARE @EventInfo  NVARCHAR(10)
		
		SELECT  @EventCode = Event_Code,
				@PhaseCode = Phase_Code,
				@StageCount = Stage_Count, 
				@SeriesCount = Series_Count,
				@SexCode = Gender_Code,
				@EventInfo = Event_Info 
		FROM dbo.Func_SH_GetEventCommonCodeInfo (@MatchID)
	
							
		DECLARE @N INT
		DECLARE @S INT
		SET @N = 1
		SET @S = 1
		
		WHILE @N <= @StageCount 
		BEGIN	
			SET @S = 1				
			WHILE @S <=  @SeriesCount
			BEGIN
				
				INSERT @retTable(F_EventCode, F_CompetitionPosition, F_Stage, F_Series, Series_Score, F_RegisterID)
				SELECT @EventCode, F_CompetitionPosition, @N, @S, '', F_RegisterID FROM TS_Match_Result
				WHERE F_MatchID = @MatchID
				SET @S = @S + 1
			END
			SET @N = @N + 1
		END

		 DECLARE @T1	 TABLE(
							F_RegisterID INT,
							F_CompetitionPosition INT, 
							F_EventCode CHAR(3),
							F_Stage INT,
							F_Series INT,
							Series_Code NVARCHAR(10), 
							Series_Score INT
							)
		DECLARE @III INT
		DECLARE @KKK INT
		
		SET @N = 1
		
		IF @EventInfo IN( '25P' , '25RF' )
		BEGIN
			WHILE @N <= @StageCount 
			BEGIN	
				SET @S = 1				
				WHILE @S <=  @SeriesCount
				BEGIN
					
					SET @III = 2*(@SeriesCount*(@N-1) + @S )-1
					SET @KKK = 2*(@SeriesCount*(@N-1) + @S )
					INSERT @T1(F_EventCode, F_CompetitionPosition, F_Stage, F_Series, Series_Score)
					SELECT @EventCode, A.F_CompetitionPosition, @N, @S, SUM(F_ActionDetail1) AS Total
					FROM TS_Match_ActionList A
					WHERE A.F_MatchID = @MatchID AND F_MatchSplitID BETWEEN @III AND @KKK
					GROUP BY A.F_CompetitionPosition
					SET @S = @S + 1
				END
				SET @N = @N + 1
			END
		END
		ELSE
		BEGIN
			WHILE @N <= @StageCount 
			BEGIN	
				SET @S = 1				
				WHILE @S <=  @SeriesCount
				BEGIN
					
					SET @III = @SeriesCount*(@N-1) + (@S-1)+1
					SET @KKK = @SeriesCount*(@N-1) + @S
					INSERT @T1(F_EventCode, F_CompetitionPosition, F_Stage, F_Series, Series_Score)
					SELECT @EventCode, A.F_CompetitionPosition, @N, @S, SUM(F_ActionDetail1) AS Total
					FROM TS_Match_ActionList A
					WHERE A.F_MatchID = @MatchID AND F_MatchSplitID BETWEEN @III AND @KKK
					GROUP BY A.F_CompetitionPosition
					SET @S = @S + 1
				END
				SET @N = @N + 1
			END
		END
		
		UPDATE @retTable SET F_RegisterID = R.F_RegisterID
		FROM @retTable A
		LEFT JOIN TS_Match_Result R ON R.F_CompetitionPosition = A.F_CompetitionPosition
		WHERE R.F_MatchID = @MatchID
		
		UPDATE @retTable SET Series_Score = B.Series_Score
		FROM @retTable A
		LEFT JOIN @T1 B
		ON A.F_CompetitionPosition = B.F_CompetitionPosition AND A.F_Stage = B.F_Stage AND A.F_Series = B.F_Series
					
		IF @PhaseCode IN( '9', 'A' ) UPDATE @retTable SET Series_Score = Series_Score/10
		IF @PhaseCode = '1' UPDATE @retTable SET Series_Score = Series_Score/10.0
		
		UPDATE @retTable SET Series_Code = B.F_SeriesCode
		FROM @retTable A
		LEFT JOIN TC_SH_SeriesCode B ON A.F_EventCode = B.F_EventCode AND A.F_Stage = B.F_StageNo AND A.F_Series = B.F_SeriesNo

		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetSeriesScore] (102)
-- SELECT * FROM dbo.[Func_SH_GetSeriesScore] (27)

--SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 