IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TT_GetMatchPointType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TT_GetMatchPointType]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_TT_GetMatchPointType]
								(
									@MatchID					INT
								)
RETURNS NVARCHAR(100)--返回'0'表示无赛点，'A1'为A方金牌赛点，'A2'为A方赛点，'A3'为A方盘点,
					---A4为A方局点，B1,B2,B3,B4同
AS
BEGIN
	DECLARE @MatchPtA INT
	DECLARE @MatchPtB INT
	DECLARE @SetPtA INT
	DECLARE @SetPtB INT
	DECLARE @GamePtA INT
	DECLARE @GamePtB INT
	DECLARE @MatchType INT
	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @TmpSplitID INT
	DECLARE @Res INT
	DECLARE @IsMatchPoint INT = 0
	DECLARE @IsSetPoint INT = 0
	DECLARE @IsGamePoint INT = 0
	DECLARE @PointSide INT
	DECLARE @MaxGames INT
	SELECT @MaxGames = CASE F_CompetitionRuleID WHEN 2 THEN 3 ELSE 2 END FROM TS_Match WHERE F_MatchID = @MatchID


	SELECT @MatchPtA = ISNULL(F_Points,0) FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
	SELECT @MatchPtB = ISNULL(F_Points,0) FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	SELECT @PhaseCode = B.F_PhaseCode FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	WHERE A.F_MatchID = @MatchID
	
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID

	IF @MatchType = 1
	BEGIN
		IF @MatchPtA < @MaxGames AND @MatchPtB < @MaxGames
		BEGIN
			SET @IsMatchPoint = 0
		END
		ELSE
		BEGIN
			SET @IsMatchPoint = 1
		END
		
		IF (@MatchPtA + @MatchPtB) = @MaxGames*2+1
			RETURN '0'
			
		
		SELECT @TmpSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = (@MatchPtA + @MatchPtB + 1)
		SET @Res = dbo.[Fun_TT_GetGamePoint](@MatchID, @TmpSplitID)
		
		IF @Res = 0
			RETURN '0'
		--A方赛点	
		IF @Res = 1
		BEGIN
			SET @IsGamePoint = 1
			SET @PointSide = 1
			
			IF @MatchPtA < @MatchPtB
			BEGIN
				SET @IsMatchPoint = 0
			END
			
		END
		ELSE IF @Res = 2
		BEGIN
			SET @IsGamePoint = 1
			SET @PointSide = 2
			
			IF @MatchPtA > @MatchPtB
			BEGIN
				SET @IsMatchPoint = 0
			END
		END
		ELSE
			RETURN '0'
		
	END
	ELSE IF @MatchType = 3
	BEGIN
		DECLARE @CurrentSetID INT
		DECLARE @CurrentGameID INT
		DECLARE @IsPool INT
		SELECT @IsPool = B.F_PhaseIsPool FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
		WHERE F_MatchID = @MatchID
		
		--如果是小组赛
		--IF @IsPool = 1
		--BEGIN
		--	IF @MatchPtA + @MatchPtB != 4
		--	BEGIN
		--		SET @IsMatchPoint = 0
		--	END
		--	ELSE
		--	BEGIN
		--		SET @IsMatchPoint = 1
		--	END
		--END
		--ELSE
		--BEGIN
			IF @MatchPtA = 2 OR @MatchPtB = 2
			BEGIN
				SET @IsMatchPoint = 1
			END
			ELSE
			BEGIN
				SET @IsMatchPoint = 0
			END
		--END
		
		--首先取出最大的有状态的splitID
		
		SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
		IF @CurrentSetID = 0
			RETURN '0'
		
		--取盘比分
		SELECT @SetPtA = ISNULL(B.F_Points,0), @SetPtB = ISNULL(C.F_Points,0)
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_MatchSplitID = A.F_MatchSplitID 
				AND B.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C ON C.F_MatchID = A.F_MatchID AND C.F_MatchSplitID = A.F_MatchSplitID 
				AND C.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
		
		
		IF @SetPtA < @MaxGames AND @SetPtB < @MaxGames
		BEGIN
			SET @IsSetPoint = 0
			SET @IsMatchPoint = 0
		END
		ELSE
		BEGIN
			
			SET @IsSetPoint = 1
			
			IF @IsMatchPoint = 1
			BEGIN
				IF @SetPtA >= @SetPtB AND @MatchPtA >= @MatchPtB
					SET @IsMatchPoint = 1
				ELSE IF @SetPtA <= @SetPtB AND @MatchPtA <= @MatchPtB
					SET @IsMatchPoint = 1
				ELSE
					SET @IsMatchPoint = 0
			END
			
			
		END
		
		SET @CurrentGameID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 2)
		
		
		IF @CurrentGameID = 0
			RETURN '0'
			
		SET @Res = dbo.[Fun_TT_GetGamePoint](@MatchID, @CurrentGameID)
		
		IF @Res = 0
			RETURN '0'
		
		
		IF @Res = 1
		BEGIN
			SET @IsGamePoint = 1
			SET @PointSide = 1
			IF @SetPtA < @SetPtB
			BEGIN
				SET @IsSetPoint = 0
				SET @IsMatchPoint = 0
			END
			
			IF @MatchPtA < @MatchPtB
				SET @IsMatchPoint = 0
		END
		
		IF @Res = 2
		BEGIN
			SET @IsGamePoint = 1
			SET @PointSide = 2
			IF @SetPtA > @SetPtB
			BEGIN
				SET @IsSetPoint = 0
				SET @IsMatchPoint = 0
			END
			
			IF @MatchPtA > @MatchPtB
				SET @IsMatchPoint = 0
		END
	END
	
	IF @IsMatchPoint = 1
	BEGIN
		IF @PhaseCode = '1'
			BEGIN
				IF @PointSide = 1
					RETURN 'A1'
				ELSE
					RETURN 'B1'
			END
	
		IF @PointSide = 1
			RETURN 'A2'
		ELSE
			RETURN 'B2'
	END
	
	IF @IsSetPoint = 1
	BEGIN
		IF @PointSide = 1
			RETURN 'A3'
		ELSE
			RETURN 'B3'
	END
	
	IF @IsGamePoint = 1
	BEGIN
		IF @PointSide = 1
			RETURN 'A4'
		ELSE
			RETURN 'B4'
	END
	
	RETURN '0'
END



GO


