IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetMatchResultDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetMatchResultDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
修改日志：2011-03-10，增加两个类型，把2 - 0改为2 : 0，小分改为21 : 0
*/

CREATE FUNCTION [dbo].[Fun_Report_BD_GetMatchResultDes]
								(
									@MatchID					INT,
									@Type                       INT,
									@WinnerFirst                INT --0为主客队顺序,--1为Winner First --2为LoserFirst
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	
	DECLARE @ResultDes AS NVARCHAR(200)
	DECLARE @HomePoint AS INT
	DECLARE @AwayPoint AS INT
    DECLARE @Apos AS INT
    DECLARE @Bpos AS INT
    DECLARE @AIRMID AS INT
    DECLARE @BIRMID AS INT
    DECLARE @AIRM AS NVARCHAR(25)
    DECLARE @BIRM AS NVARCHAR(25)
    DECLARE @EventType AS INT
    DECLARE @TimeStr NVARCHAR(50)
    DECLARE @Minutes INT

	IF @WinnerFirst = 0
	BEGIN
		SELECT @Apos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
		SELECT @Bpos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	END
    ELSE IF @WinnerFirst = 1
    BEGIN
		SELECT @Apos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_ResultID = 1
		SELECT @Bpos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_ResultID = 2
    END
    ELSE IF @WinnerFirst = 2
    BEGIN
		SELECT @Apos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_ResultID = 2
		SELECT @Bpos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_ResultID = 1
    END
    ELSE
    BEGIN
		SET @Apos = 1
		SET @Bpos = 2
    END
    
    SELECT @EventType = C.F_PlayerRegTypeID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID

	SET @ResultDes = ''

	IF (@Type = 1)
    BEGIN
		SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Apos
		SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Bpos
		
		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
	    BEGIN
		    SET @ResultDes = CAST(@HomePoint AS NVARCHAR(100)) + (CASE WHEN @AIRM IS NULL THEN '' ELSE '(' + @AIRM + ')' END) + ' - ' + CAST(@AwayPoint AS NVARCHAR(100)) + (CASE WHEN @BIRM IS NULL THEN '' ELSE '(' + @BIRM + ')' END)
	    END
    END
    ELSE IF(@Type = 12)
    BEGIN
    
		DECLARE @MatchStat INT
		SELECT @MatchStat = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
		IF @MatchStat NOT IN (100,110)
			SET @ResultDes = ''
		ELSE
		BEGIN
				SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
			ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Apos
			SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
			ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Bpos
			
			--IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
		 --   BEGIN
				SET @ResultDes = ISNULL( CAST(@HomePoint AS NVARCHAR(100)),'') + (CASE WHEN @AIRM IS NULL THEN '' ELSE '(' + @AIRM + ')' END) + ' : ' + ISNULL(CAST(@AwayPoint AS NVARCHAR(100)),'') + (CASE WHEN @BIRM IS NULL THEN '' ELSE '(' + @BIRM + ')' END)
		  --  END
			IF @ResultDes = ' : '
				SET @ResultDes = ''
		END
		
    END
    ELSE IF (@EventType IN (1,2) AND @Type = 2)
    BEGIN
        DECLARE @SplitID AS INT
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SplitID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitID AND A.F_CompetitionPosition = @Bpos

			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ',' + (CASE WHEN @HomePoint+@AwayPoint <>0 THEN CAST(@HomePoint AS NVARCHAR(100)) + '-' + CAST(@AwayPoint AS NVARCHAR(100)) ELSE '' END)
				SET @ResultDes = @ResultDes + @AIRM + @BIRM
			END

		FETCH NEXT FROM One_Cursor INTO @SplitID
		END

		CLOSE One_Cursor
		DEALLOCATE One_Cursor
		 
		SET @ResultDes = LTRIM(RTRIM(@ResultDes))
		IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
		BEGIN
			SET @ResultDes =''
		END	
		ELSE
		BEGIN
			SET @ResultDes = '(' + RIGHT(@ResultDes, LEN(@ResultDes)-1) + ')'
		END
    END
    ELSE IF (@EventType = 3 AND @Type = 2)
    BEGIN
        DECLARE @SubSplitID AS INT
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SubSplitID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitID AND A.F_CompetitionPosition = @Bpos

			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ',' + CAST(@HomePoint AS NVARCHAR(100)) + @AIRM + '-' + CAST(@AwayPoint AS NVARCHAR(100)) + @BIRM
			END		

		FETCH NEXT FROM One_Cursor INTO @SubSplitID
		END

		CLOSE One_Cursor
		DEALLOCATE One_Cursor
		 
		SET @ResultDes = LTRIM(RTRIM(@ResultDes))
		IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
		BEGIN
			SET @ResultDes = ''
		END	
		ELSE
		BEGIN
			SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-1)
		END
    END
    ELSE IF (@EventType IN (1,2) AND @Type = 3)
    BEGIN
        DECLARE @SplitIDTmp AS INT
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SplitIDTmp

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitIDTmp AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitIDTmp AND A.F_CompetitionPosition = @Bpos

			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ',' + (CASE WHEN @HomePoint+@AwayPoint <>0 THEN CAST(@HomePoint AS NVARCHAR(100)) + '-' + CAST(@AwayPoint AS NVARCHAR(100)) ELSE '' END)
				SET @ResultDes = @ResultDes + @AIRM + @BIRM
			END

		FETCH NEXT FROM One_Cursor INTO @SplitIDTmp
		END

		CLOSE One_Cursor
		DEALLOCATE One_Cursor
		 
		SET @ResultDes = LTRIM(RTRIM(@ResultDes))
		IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
		BEGIN
			SET @ResultDes =''
		END	
		ELSE
		BEGIN
			SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-1)
		END
    END
    ELSE IF (@EventType = 3 AND @Type = 3)
    BEGIN
        DECLARE @SubSplitTmpID AS INT
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SubSplitTmpID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitTmpID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitTmpID AND A.F_CompetitionPosition = @Bpos

			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ',' + CAST(@HomePoint AS NVARCHAR(100)) + @AIRM + '-' + CAST(@AwayPoint AS NVARCHAR(100)) + @BIRM
			END		

		FETCH NEXT FROM One_Cursor INTO @SubSplitTmpID
		END

		CLOSE One_Cursor
		DEALLOCATE One_Cursor
		 
		SET @ResultDes = LTRIM(RTRIM(@ResultDes))
		IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
		BEGIN
			SET @ResultDes = ''
		END	
		ELSE
		BEGIN
			SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-1)
		END
    END
    ELSE IF (@Type = 4)
    BEGIN
		SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Apos
		SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Bpos
		
		--IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
	 --   BEGIN
		    SET @ResultDes = ISNULL( CAST(@HomePoint AS NVARCHAR(100)),'') 
							  +(CASE WHEN @AIRM IS NULL THEN '' ELSE '(' + @AIRM + ')' END) + ' : ' 
							  + ISNULL(CAST(@AwayPoint AS NVARCHAR(100)),'') 
							  + (CASE WHEN @BIRM IS NULL THEN '' ELSE '(' + @BIRM + ')' END)
			IF @ResultDes = ' : '
				SET @ResultDes = ''
	  --  END
    END
    ELSE IF (@EventType IN (1,2) AND @Type = 5)
    BEGIN
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SplitID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitID AND A.F_CompetitionPosition = @Bpos
			
			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ',' + (CASE WHEN @HomePoint+@AwayPoint <>0 THEN CAST(@HomePoint AS NVARCHAR(100)) + ':' + CAST(@AwayPoint AS NVARCHAR(100)) ELSE '' END)
				SET @ResultDes = @ResultDes + @AIRM + @BIRM
			END

		FETCH NEXT FROM One_Cursor INTO @SplitID
		END

		CLOSE One_Cursor
		DEALLOCATE One_Cursor
		 
		SET @ResultDes = LTRIM(RTRIM(@ResultDes))
		IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
		BEGIN
			SET @ResultDes =''
		END	
		ELSE
		BEGIN
			SET @ResultDes = '(' + RIGHT(@ResultDes, LEN(@ResultDes)-1) + ')'
		END
		
		SELECT @Minutes = F_SpendTime/60 FROM TS_Match WHERE F_MatchID = @MatchID
		IF @Minutes > 0
			SET @ResultDes += ('  ' + CONVERT( NVARCHAR(10),@Minutes) + '''')
    END
    ELSE IF (@EventType = 3 AND @Type = 5)
    BEGIN
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SubSplitID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitID AND A.F_CompetitionPosition = @Bpos

			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ',' + CAST(@HomePoint AS NVARCHAR(100)) + @AIRM + ':' + CAST(@AwayPoint AS NVARCHAR(100)) + @BIRM
			END		

		FETCH NEXT FROM One_Cursor INTO @SubSplitID
		END

		CLOSE One_Cursor
		DEALLOCATE One_Cursor
		 
		SET @ResultDes = LTRIM(RTRIM(@ResultDes))
		IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
		BEGIN
			SET @ResultDes = ''
		END	
		ELSE
		BEGIN
			SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-1)
		END
		SELECT @Minutes = F_SpendTime/60 FROM TS_Match WHERE F_MatchID = @MatchID
		IF @Minutes > 0
			SET @ResultDes += ('  ' + CONVERT( NVARCHAR(10),@Minutes) + '''')
    END
   
    
    IF @ResultDes IS NULL
		RETURN ''
		
	RETURN @ResultDes

END


GO

