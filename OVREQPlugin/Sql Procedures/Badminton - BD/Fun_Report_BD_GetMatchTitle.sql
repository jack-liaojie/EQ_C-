IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetMatchTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetMatchTitle]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE FUNCTION [dbo].[Fun_Report_BD_GetMatchTitle]
								(
									@MatchID					INT,
                                    @MatchSplitID               INT,
                                    @Type                       INT, -- 1:Match描述加姓名 2：Game描述
                                    @LanguageCode               CHAR(3)
								)
RETURNS NVARCHAR(200)
AS
BEGIN

	DECLARE @ResultDes AS NVARCHAR(100)
	DECLARE @HomePoint AS INT
	DECLARE @AwayPoint AS INT
	DECLARE @HomeName AS NVARCHAR(200)
	DECLARE @AwayName AS NVARCHAR(200)
    DECLARE @AIRM AS NVARCHAR(50)
    DECLARE @BIRM AS NVARCHAR(50)
    DECLARE @EventType AS INT
    DECLARE @Apos AS INT
    DECLARE @Bpos AS INT

	SET @ResultDes = ''
	SELECT @Apos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
    SELECT @Bpos = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
    SELECT @EventType = C.F_PlayerRegTypeID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID

	IF (@EventType IN (1,2) AND @Type = 1)
	BEGIN
	    SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE, @HomeName = C.F_PrintLongName FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Apos
		SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE, @AwayName = C.F_PrintLongName FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Bpos

        SET @ResultDes = @HomeName + (CASE WHEN @AIRM IS NULL THEN '' ELSE '(' + @AIRM + ')' END) + ' - ' + @AwayName + (CASE WHEN @BIRM IS NULL THEN '' ELSE '(' + @BIRM + ')' END)
		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
		BEGIN
			SET @ResultDes = @ResultDes + '  ' + CAST(@HomePoint AS NVARCHAR(100)) + ' - ' + CAST(@AwayPoint AS NVARCHAR(100))
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
				--SET @ResultDes = @ResultDes + ', ' + (CASE WHEN @HomePoint+@AwayPoint <>0 THEN CAST(@HomePoint AS NVARCHAR(100)) + '-' + CAST(@AwayPoint AS NVARCHAR(100)) ELSE '' END)
				--SET @ResultDes = @ResultDes + @AIRM + @BIRM
				SET @ResultDes = @ResultDes + ', ' + (CASE WHEN @HomePoint+@AwayPoint <>0 THEN CAST(@HomePoint AS NVARCHAR(100))
								 + (CASE @AIRM 
								 WHEN '' THEN ''
								 ELSE @AIRM
								 END) + '-' + CAST(@AwayPoint AS NVARCHAR(100)) ELSE '' END) 
								 + (CASE @BIRM
								 WHEN '' THEN ''
								 ELSE @BIRM END)
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
			SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-2)
		END
	END
	IF (@EventType = 3 AND @Type = 1)
	BEGIN
	    IF @MatchSplitID = -1
	    BEGIN
			SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE, @HomeName = C.F_PrintLongName FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
			ON A.F_IRMID = B.F_IRMID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Apos
			SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE, @AwayName = C.F_PrintLongName FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
			ON A.F_IRMID = B.F_IRMID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Bpos
        END
        ELSE
        BEGIN
            SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE, @HomeName = C.F_PrintLongName FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B
			ON A.F_IRMID = B.F_IRMID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @MatchSplitID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE, @AwayName = C.F_PrintLongName FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B
			ON A.F_IRMID = B.F_IRMID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @MatchSplitID AND A.F_CompetitionPosition = @Bpos
        END
        
        SET @ResultDes = @HomeName + (CASE WHEN @AIRM IS NULL THEN '' ELSE '(' + @AIRM + ')' END) + ' - ' + @AwayName + (CASE WHEN @BIRM IS NULL THEN '' ELSE '(' + @BIRM + ')' END)
		
		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
		BEGIN
			SET @ResultDes = @ResultDes + '  ' + CAST(@HomePoint AS NVARCHAR(100)) + ' - ' + CAST(@AwayPoint AS NVARCHAR(100))
		END
	END
	ELSE IF (@EventType = 3 AND @Type = 2)
	BEGIN		
	    DECLARE @SubSplitID AS INT
	    DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @MatchSplitID ORDER BY F_Order

		OPEN One_Cursor
		FETCH NEXT FROM One_Cursor INTO @SubSplitID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @HomePoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @AIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE B.F_IRMCODE END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitID AND A.F_CompetitionPosition = @Apos
			SELECT @AwayPoint = (CASE WHEN A.F_Points IS NULL THEN 0 ELSE A.F_Points END), @BIRM = (CASE WHEN A.F_IRMID IS NULL THEN '' ELSE B.F_IRMCODE END) FROM TS_Match_Split_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SubSplitID AND A.F_CompetitionPosition = @Bpos

			IF ((@HomePoint+@AwayPoint)<>0 OR @AIRM <> '' OR @BIRM <> '')
			BEGIN
				SET @ResultDes = @ResultDes + ', ' + (CASE WHEN @HomePoint+@AwayPoint <>0 THEN CAST(@HomePoint AS NVARCHAR(100))
								 + (CASE @AIRM 
								 WHEN '' THEN ''
								 ELSE '(' + @AIRM + ')'
								 END) + '-' + CAST(@AwayPoint AS NVARCHAR(100)) ELSE '' END) 
								 + (CASE @BIRM
								 WHEN '' THEN ''
								 ELSE '(' + @BIRM + ')' END)
				--SET @ResultDes = @ResultDes + @AIRM + @BIRM
			END

		FETCH NEXT FROM One_Cursor INTO @SubSplitID
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
			SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-2)
		END
	END
	
	RETURN @ResultDes

END


GO

