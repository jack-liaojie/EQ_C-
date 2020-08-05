

/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetMatchSplitsPointsDes]    Script Date: 08/18/2011 14:12:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TE_GetMatchSplitsPointsDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TE_GetMatchSplitsPointsDes]
GO


/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetMatchSplitsPointsDes]    Script Date: 08/18/2011 14:12:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE FUNCTION [dbo].[Fun_TE_GetMatchSplitsPointsDes]
								(
									@MatchID					INT,
									@Type						INT = 1,  --1表示成绩按Position排列，2表示成绩按胜负排列
									@FatherSplitID              INT = 0   --0表示单项赛
								)
RETURNS nvarchar(100)
AS
BEGIN

	DECLARE @Return		AS NVARCHAR(100)
	SET @Return = ''
	
	DECLARE @Points		AS NVARCHAR(100)
	DECLARE @Points1	AS INT
	DECLARE @Points2	AS INT
	DECLARE @TBPoints   AS INT
	
	DECLARE @Postion1	AS INT
	DECLARE @Postion2	AS INT
	
	DECLARE @AIRMCode   AS NVARCHAR(20)
	DECLARE @BIRMCode   AS NVARCHAR(20)
	
	IF @Type = 1
	BEGIN
		SET @Postion1 = 1
		SET @Postion2 = 2
	END
	ELSE IF @Type = 2
	BEGIN
		SELECT @Postion1 = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_Rank = 1
		SELECT @Postion2 = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_Rank = 2
	END
	
	DECLARE @loop		AS INT
	SET @loop = 1

	DECLARE @MaxLoop	AS INT
	DECLARE @T_SplitResults AS TABLE(F_SplitNumber				INT,
									F_MatchSplitID				INT,
									F_MatchSplitStatusID		INT,
									F_CompetitionPosition		INT,
									F_Points					INT,
									F_TBPoints                  INT,
									F_Rank                      INT)
	INSERT INTO @T_SplitResults(F_SplitNumber, F_MatchSplitID, F_MatchSplitStatusID, F_CompetitionPosition, F_Points, F_TBPoints, F_Rank)
		SELECT DENSE_RANK() OVER( ORDER BY A.F_Order ASC) AS F_SplitNumber, A.F_MatchSplitID, A.F_MatchSplitStatusID, B.F_CompetitionPosition, B.F_Points, B.F_SplitPoints, B.F_Rank  
		 FROM TS_Match_Split_Info AS A 
		      INNER JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
			WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = @FatherSplitID AND A.F_MatchSplitStatusID IN (50, 100, 110, 120)

	SELECT @MaxLoop = MAX(F_SplitNumber) FROM @T_SplitResults		
	
	WHILE (@loop <= @MaxLoop)
	BEGIN

		SELECT  @Points1 = F_Points FROM @T_SplitResults 
		WHERE F_CompetitionPosition = @Postion1 AND F_SplitNumber=@loop

		SELECT  @Points2 = F_Points FROM @T_SplitResults 
		WHERE F_CompetitionPosition = @Postion2 AND F_SplitNumber=@loop
		
		SET @TBPoints= NULL
		SELECT @TBPoints = F_TBPoints FROM @T_SplitResults
		WHERE  F_SplitNumber=@loop AND F_Rank = 2		
				
		SET @Points1 = ISNULL(@Points1, '')
		SET @Points2 = ISNULL(@Points2, '')

		SET @Points = cast(@Points1  AS NVARCHAR(50)) + '-' + cast(@Points2  AS NVARCHAR(50)) + (CASE WHEN @TBPoints IS NULL THEN ' ' ELSE '(' + CAST(@TBPoints AS NVARCHAR(50)) + ') 'END)
		SET @Return = @Return + @Points

		SET @loop = @loop + 1
	END
	
	IF(@FatherSplitID = 0)   ---单项赛
	BEGIN
		SELECT @AIRMCode = B.F_IRMCode FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID  WHERE A.F_MatchID = @MatchID AND F_CompetitionPosition = @Postion1
		SELECT @BIRMCode = B.F_IRMCode FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID  WHERE A.F_MatchID = @MatchID AND F_CompetitionPosition = @Postion2
		
		SET @Return = LTRIM(RTRIM(@Return)) + ISNULL(@AIRMCode, '') + ' ' +  ISNULL(@BIRMCode, '')
    END
    ELSE
    BEGIN
        SELECT @AIRMCode = B.F_IRMCode FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID  WHERE A.F_MatchID = @MatchID AND F_CompetitionPosition = @Postion1 AND F_MatchSplitID = @FatherSplitID
		SELECT @BIRMCode = B.F_IRMCode FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID  WHERE A.F_MatchID = @MatchID AND F_CompetitionPosition = @Postion2 AND F_MatchSplitID = @FatherSplitID
		
		SET @Return = LTRIM(RTRIM(@Return)) + ISNULL(@AIRMCode, '') + ' ' +  ISNULL(@BIRMCode, '')
    END
	 
	RETURN @Return

END



GO


