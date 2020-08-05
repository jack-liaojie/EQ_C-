IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetStageScore]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetStageScore]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2010-12-24 
----修改	记录:


CREATE FUNCTION [Func_SH_GetStageScore]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							F_EventCode CHAR(3),
							F_CompetitionPosition INT, 
							F_RegisterID INT,
							F_Stage INT, 
							F_StageCode NVARCHAR(10),
							F_SubTotal INT, 
							F_StageRank INT
							)
AS
BEGIN

		DECLARE @EventCode CHAR(3)
		DECLARE @PhaseCode CHAR(1)
		DECLARE @EventInfo NVARCHAR(10)
		DECLARE @StageCount INT
		DECLARE @SeriesCount INT
		
		DECLARE @StageCode CHAR(3)

		SELECT  @EventCode = Event_Code,
				@PhaseCode = Phase_Code,
				@StageCount = Stage_Count, 
				@SeriesCount = Series_Count,
				@PhaseCode = Event_Info 
		FROM dbo.Func_SH_GetEventCommonCodeInfo (@MatchID)
			
		DECLARE @N INT
		DECLARE @S INT
		
		SET @N = 1
		WHILE @N <= @StageCount
		BEGIN
			INSERT @retTable(F_EventCode, F_CompetitionPosition, F_Stage, F_SubTotal, F_RegisterID)
			SELECT @EventCode, F_CompetitionPosition, @N, '', F_RegisterID
			FROM TS_Match_Result WHERE F_MatchID = @MatchID 							
			SET @N = @N + 1
		END
			
			
			
			
		DECLARE @T1		 TABLE(
							F_CompetitionPosition INT, 
							F_Stage INT, 
							F_SubTotal INT
							)	
				
		SET @N = 1
		
		IF @PhaseCode IN ('25P','25RF')
		BEGIN
			WHILE @N <= @StageCount
			BEGIN										
				INSERT @T1(F_CompetitionPosition, F_Stage, F_SubTotal)
				SELECT B.F_CompetitionPosition, @N, SUM(ISNULL(F_ActionDetail1,0))/10
				FROM TS_Match_ActionList B 
				WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitID BETWEEN 2*@SeriesCount*(@N-1)+1 AND @SeriesCount*2*@N
				GROUP BY B.F_CompetitionPosition
				
				SET @N = @N + 1
			END
		END
		ELSE
		BEGIN
			WHILE @N <= @StageCount
			BEGIN										
				INSERT @T1(F_CompetitionPosition, F_Stage, F_SubTotal)
				SELECT B.F_CompetitionPosition, @N, SUM(ISNULL(F_ActionDetail1,0))/10
				FROM TS_Match_ActionList B 
				WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitID BETWEEN @SeriesCount*(@N-1)+1 AND @SeriesCount*@N
				GROUP BY B.F_CompetitionPosition
				
				SET @N = @N + 1
			END
		END
		
		--SELECT @StageCode = F_StageCode FROM TC_SH_StageCode
		--WHERE F_EventCode = @EventCode AND F_StageNo = @StageCount
		
		UPDATE @retTable
		SET F_SubTotal = B.F_SubTotal 
		FROM @retTable A
		LEFT JOIN @T1 B
		ON A.F_CompetitionPosition = B.F_CompetitionPosition AND A.F_Stage = B.F_Stage
		
			
		-- set rank
		UPDATE @retTable
		SET F_StageRank = B.Rk 
		FROM @retTable A
		LEFT JOIN (SELECT F_CompetitionPosition, RANK() OVER (ORDER BY F_SubTotal DESC) Rk FROM @retTable) B
		ON A.F_CompetitionPosition = B.F_CompetitionPosition 
		
		
		UPDATE @retTable SET F_StageCode = B.F_StageCode
		FROM @retTable A
		LEFT JOIN TC_SH_StageCode B ON A.F_EventCode = B.F_EventCode AND A.F_Stage = B.F_StageNo 

								
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetStageScore] (102)
-- SELECT * FROM dbo.[Func_SH_GetStageScore] (14)

--SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 