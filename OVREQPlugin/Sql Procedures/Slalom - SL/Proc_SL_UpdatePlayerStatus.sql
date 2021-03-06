IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdatePlayerStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdatePlayerStatus]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_SL_UpdatePlayerStatus]
----功		  能：
----作		  者：吴定昉 
----日		  期: 2010-01-11 

CREATE PROCEDURE [dbo].[Proc_SL_UpdatePlayerStatus] 
	@MatchID				INT,
	@CompetitionPosition	INT,
    @Status                 INT,
	@Return  			    AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON
	
 	DECLARE @SQL		            NVARCHAR(max)
 	DECLARE @DisciplineCode NVARCHAR(10)
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseID	            INT
	DECLARE @RegisterID	            INT
	DECLARE @PhaseResultNumber	    INT
    DECLARE @NewPhaseCode           NVARCHAR(50) 
    DECLARE @NewMatchCode           NVARCHAR(50) 
	DECLARE	@TotalResult            NVARCHAR(50)
	DECLARE	@TotalBehind            NVARCHAR(50)
	DECLARE	@TotalRank              INT
	DECLARE	@TotalDisplayPosition	INT
	DECLARE	@TotalIRMID	            INT
    DECLARE @OldStatus              INT


	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效


	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

 	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID

    SELECT @RegisterID = F_RegisterID FROM TS_Match_Result 
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 

	SELECT @PhaseResultNumber = F_PhaseResultNumber FROM TS_Phase_Result 
	WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID

    SELECT @OldStatus = cast(F_RealScore as int) FROM TS_Match_Result 
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
    SET @SQL = ''

    IF @OldStatus IS NULL OR @OldStatus = 0
    BEGIN
        --//0->1
        IF @Status = 1
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END
         --//0->2
        IF @Status = 2
        BEGIN
            --//Clear old
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_RealScore = ''2'''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''2'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END
        --//0->4  
         IF @Status = 4
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''4'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END  
   END


    IF @OldStatus = 1
    BEGIN
        --//1->0
		IF @Status = 0
		BEGIN 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL , F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''0'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END

        --//1->2
        IF @Status = 2
        BEGIN
            --//Clear old
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_RealScore = ''2'''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''2'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END

        --//1->3
        IF @Status = 3
        BEGIN
            --//update old
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''4'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_RealScore = ''3'''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''3'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END

        --//1->4
        IF @Status = 4
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''4'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END
    END


    IF @OldStatus = 2
    BEGIN
        --//2->0
		IF @Status = 0
		BEGIN 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''0'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END

        --//2->1
		IF @Status = 1
		BEGIN 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END

        --//2->3
        IF @Status = 3
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''3'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END

        --//2->4
        IF @Status = 4
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''4'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END
    END


    IF @OldStatus = 3
    BEGIN
        --//3->0
		IF @Status = 0  
		BEGIN
			IF (@PhaseCode + @MatchCode = '201' OR @PhaseCode + @MatchCode = '101')
			BEGIN 
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET F_PhasePointsCharDes2 = NULL, '
				SET @SQL = @SQL + 'F_PhasePointsCharDes4 = NULL, F_PhaseRank = NULL, F_PhaseDisplayPosition = NULL, F_IRMID = NULL '
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
				EXEC (@SQL)
			END

			IF (@PhaseCode + @MatchCode = '901' OR @PhaseCode + @MatchCode = '902')
			BEGIN

				SET @NewPhaseCode = ''
				SET @NewMatchCode = ''

				IF(@MatchCode = '01')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '02'
					END
				ELSE IF	(@MatchCode = '02')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '01'
					END
			 
				SELECT @TotalResult = F_PointsCharDes2, @TotalBehind = F_PointsCharDes4, 
				@TotalRank = F_Rank, @TotalDisplayPosition = F_DisplayPosition, @TotalIRMID = F_IRMID FROM TS_Match_Result 
				WHERE F_MatchID = (
				SELECT M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE D.F_DisciplineCode = @DisciplineCode 
				AND E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode 
				AND P.F_PhaseCode = @NewPhaseCode 
				AND M.F_MatchCode = @NewMatchCode) 
				AND F_RegisterID = @RegisterID
	            
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
				SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
				IF @TotalResult IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@TotalResult as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
                    SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL '
                END
				IF @TotalBehind IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@TotalBehind as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL '
                END
				IF @TotalRank IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = NULL '
                END
				IF @TotalDisplayPosition IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL '
                END
				IF @TotalIRMID IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_IRMID = ''' + cast(@TotalIRMID as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_IRMID = NULL '
                END
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
 				EXEC (@SQL)
			END

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''0'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END
    
        --//3->1
		IF @Status = 1  
		BEGIN
			IF (@PhaseCode + @MatchCode = '201' OR @PhaseCode + @MatchCode = '101')
			BEGIN 
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET F_PhasePointsCharDes2 = NULL, '
				SET @SQL = @SQL + 'F_PhasePointsCharDes4 = NULL, F_PhaseRank = NULL, F_PhaseDisplayPosition = NULL, F_IRMID = NULL '
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
				EXEC (@SQL)
			END

			IF (@PhaseCode + @MatchCode = '901' OR @PhaseCode + @MatchCode = '902')
			BEGIN

				SET @NewPhaseCode = ''
				SET @NewMatchCode = ''

				IF(@MatchCode = '01')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '02'
					END
				ELSE IF	(@MatchCode = '02')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '01'
					END
			 
				SELECT @TotalResult = F_PointsCharDes2, @TotalBehind = F_PointsCharDes4, 
				@TotalRank = F_Rank, @TotalDisplayPosition = F_DisplayPosition, @TotalIRMID = F_IRMID  FROM TS_Match_Result 
				WHERE F_MatchID = (
				SELECT M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE D.F_DisciplineCode = @DisciplineCode 
				AND E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode 
				AND P.F_PhaseCode = @NewPhaseCode 
				AND M.F_MatchCode = @NewMatchCode) 
				AND F_RegisterID = @RegisterID
	            
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
				SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
				IF @TotalResult IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@TotalResult as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
                    SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL '
                END
				IF @TotalBehind IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@TotalBehind as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL '
                END
				IF @TotalRank IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = NULL '
                END
				IF @TotalDisplayPosition IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL '
                END
 				IF @TotalIRMID IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_IRMID = ''' + cast(@TotalIRMID as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_IRMID = NULL '
                END
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
 				EXEC (@SQL)
			END

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END
 
		--//3->2
		IF @Status = 2  
		BEGIN
			IF (@PhaseCode + @MatchCode = '201' OR @PhaseCode + @MatchCode = '101')
			BEGIN 
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET F_PhasePointsCharDes2 = NULL, '
				SET @SQL = @SQL + 'F_PhasePointsCharDes4 = NULL, F_PhaseRank = NULL, F_PhaseDisplayPosition = NULL, F_IRMID = NULL '
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
				EXEC (@SQL)
			END

			IF (@PhaseCode + @MatchCode = '901' OR @PhaseCode + @MatchCode = '902')
			BEGIN

				SET @NewPhaseCode = ''
				SET @NewMatchCode = ''

				IF(@MatchCode = '01')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '02'
					END
				ELSE IF	(@MatchCode = '02')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '01'
					END
			 
				SELECT @TotalResult = F_PointsCharDes2, @TotalBehind = F_PointsCharDes4, 
				@TotalRank = F_Rank, @TotalDisplayPosition = F_DisplayPosition, @TotalIRMID = F_IRMID FROM TS_Match_Result 
				WHERE F_MatchID = (
				SELECT M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE D.F_DisciplineCode = @DisciplineCode 
				AND E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode 
				AND P.F_PhaseCode = @NewPhaseCode 
				AND M.F_MatchCode = @NewMatchCode) 
				AND F_RegisterID = @RegisterID
	            
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
				SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
				IF @TotalResult IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@TotalResult as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL '
                END
				IF @TotalBehind IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@TotalBehind as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
				    SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL '
                END
				IF @TotalRank IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = NULL '
                END
				IF @TotalDisplayPosition IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL '
                END
				IF @TotalIRMID IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_IRMID = ''' + cast(@TotalIRMID as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_IRMID = NULL '
                END
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
 				EXEC (@SQL)
			END

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
 
            --//Clear old
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_RealScore = ''2'''
			EXEC (@SQL)
 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''2'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END

        --//3->4
        IF @Status = 4
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''4'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END
    END


    IF @OldStatus = 4
    BEGIN
        --//4->0
		IF @Status = 0
		BEGIN
			IF (@PhaseCode + @MatchCode = '201' OR @PhaseCode + @MatchCode = '101')
			BEGIN 
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET F_PhasePointsCharDes2 = NULL, '
				SET @SQL = @SQL + 'F_PhasePointsCharDes4 = NULL, F_PhaseRank = NULL, F_PhaseDisplayPosition = NULL, F_IRMID = NULL '
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
				EXEC (@SQL)
			END

			IF (@PhaseCode + @MatchCode = '901' OR @PhaseCode + @MatchCode = '902')
			BEGIN

				SET @NewPhaseCode = ''
				SET @NewMatchCode = ''

				IF(@MatchCode = '01')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '02'
					END
				ELSE IF	(@MatchCode = '02')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '01'
					END
			 
				SELECT @TotalResult = F_PointsCharDes2, @TotalBehind = F_PointsCharDes4, 
				@TotalRank = F_Rank, @TotalDisplayPosition = F_DisplayPosition, @TotalIRMID = F_IRMID FROM TS_Match_Result 
				WHERE F_MatchID = (
				SELECT M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE D.F_DisciplineCode = @DisciplineCode 
				AND E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode 
				AND P.F_PhaseCode = @NewPhaseCode 
				AND M.F_MatchCode = @NewMatchCode) 
				AND F_RegisterID = @RegisterID
	            
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
				SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
				IF @TotalResult IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@TotalResult as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL '
                END
				IF @TotalBehind IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@TotalBehind as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL '
                END
				IF @TotalRank IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = NULL '
                END
				IF @TotalDisplayPosition IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL '
                END
				IF @TotalIRMID IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_IRMID = ''' + cast(@TotalIRMID as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_IRMID = NULL '
                END
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
 				EXEC (@SQL)
			END
 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''0'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END
    
        --//4->1
		IF @Status = 1
		BEGIN
			IF (@PhaseCode + @MatchCode = '201' OR @PhaseCode + @MatchCode = '101')
			BEGIN 
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET F_PhasePointsCharDes2 = NULL, '
				SET @SQL = @SQL + 'F_PhasePointsCharDes4 = NULL, F_PhaseRank = NULL, F_PhaseDisplayPosition = NULL, F_IRMID = NULL '
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''''
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
				EXEC (@SQL)
			END

			IF (@PhaseCode + @MatchCode = '901' OR @PhaseCode + @MatchCode = '902')
			BEGIN

				SET @NewPhaseCode = ''
				SET @NewMatchCode = ''

				IF(@MatchCode = '01')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '02'
					END
				ELSE IF	(@MatchCode = '02')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '01'
					END
			 
				SELECT @TotalResult = F_PointsCharDes2, @TotalBehind = F_PointsCharDes4, 
				@TotalRank = F_Rank, @TotalDisplayPosition = F_DisplayPosition, @TotalIRMID = F_IRMID FROM TS_Match_Result 
				WHERE F_MatchID = (
				SELECT M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE D.F_DisciplineCode = @DisciplineCode 
				AND E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode 
				AND P.F_PhaseCode = @NewPhaseCode 
				AND M.F_MatchCode = @NewMatchCode) 
				AND F_RegisterID = @RegisterID
	            
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
				SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
				IF @TotalResult IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@TotalResult as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL '
                END
				IF @TotalBehind IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@TotalBehind as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL '
                END
				IF @TotalRank IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = NULL '
                END
				IF @TotalDisplayPosition IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL '
                END
				IF @TotalIRMID IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_IRMID = ''' + cast(@TotalIRMID as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_IRMID = NULL '
                END
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
 				EXEC (@SQL)
			END
 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END

        --//4->2
		IF @Status = 2
		BEGIN
			IF (@PhaseCode + @MatchCode = '201' OR @PhaseCode + @MatchCode = '101')
			BEGIN 
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET F_PhasePointsCharDes2 = NULL, '
				SET @SQL = @SQL + 'F_PhasePointsCharDes4 = NULL, F_PhaseRank = NULL, F_PhaseDisplayPosition = NULL, F_IRMID = NULL '
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''' '
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
				EXEC (@SQL)
			END

			IF (@PhaseCode + @MatchCode = '901' OR @PhaseCode + @MatchCode = '902')
			BEGIN

				SET @NewPhaseCode = ''
				SET @NewMatchCode = ''

				IF(@MatchCode = '01')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '02'
					END
				ELSE IF	(@MatchCode = '02')
					BEGIN
						SET @NewPhaseCode = '9'
						SET @NewMatchCode = '01'
					END
			 
				SELECT @TotalResult = F_PointsCharDes2, @TotalBehind = F_PointsCharDes4, 
				@TotalRank = F_Rank, @TotalDisplayPosition = F_DisplayPosition, @TotalIRMID = F_IRMID FROM TS_Match_Result 
				WHERE F_MatchID = (
				SELECT M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE D.F_DisciplineCode = @DisciplineCode 
				AND E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode 
				AND P.F_PhaseCode = @NewPhaseCode 
				AND M.F_MatchCode = @NewMatchCode) 
				AND F_RegisterID = @RegisterID
	            
				SET @SQL = ''
				SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
				SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
				IF @TotalResult IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@TotalResult as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL '
                END
				IF @TotalBehind IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@TotalBehind as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL '
                END
				IF @TotalRank IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseRank = NULL '
                END
				IF @TotalDisplayPosition IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL '
                END
				IF @TotalIRMID IS NOT NULL
				BEGIN
					SET @SQL = @SQL + ',F_IRMID = ''' + cast(@TotalIRMID as nvarchar(10)) + ''' '
				END
                ELSE
                BEGIN
					SET @SQL = @SQL + ',F_IRMID = NULL '
                END
				SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''''
				SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
 				EXEC (@SQL)
			END
 
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_Points = NULL, F_PointsCharDes1 = NULL,F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, '
			SET @SQL = @SQL + 'F_PointsCharDes4 = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_IRMID = NULL '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)

            --//Clear old
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''1'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_RealScore = ''2'''
			EXEC (@SQL)

			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''2'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
		END

        --//4->3
		IF @Status = 3
        BEGIN
			SET @SQL = ''
			SET @SQL = @SQL + 'UPDATE TS_Match_Result SET F_RealScore = ''3'' '
			SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''' '
			SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
			EXEC (@SQL)
        END
    END


    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END

	COMMIT TRANSACTION --成功提交事务


	SET @Return = 1
	RETURN


SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
