IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetResult_TeamEx]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetResult_TeamEx]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_BD_GetResult_TeamEx]
----功		  能：得到团体Match的比分等信息
----作		  者：张翠霞
----日		  期: 2010-01-25

----修改：王强2011-05-27，增加乒乓球团体赛使用的ABC  XYZ



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetResult_TeamEx] 
                   (	
					@MatchID			    INT,
					@LanguageCode           CHAR(3),
					@Swap                INT = 0
                   )	
AS
BEGIN
SET NOCOUNT ON
		DECLARE @ShowAll INT = 1
        CREATE TABLE #Temp_table(
								   F_MatchID       INT,
                                   F_MatchSplitID  INT,
                                   F_SplitOrder    INT,
                                   F_SplitType     INT,
                                   F_AName         NVARCHAR(200),
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(200),
                                   F_BNOC          NVARCHAR(10), 
                                   F_AMatch        INT,
                                   F_BMatch        INT,
                                   F_AMatchDes     NVARCHAR(10),
                                   F_BMatchDes     NVARCHAR(10),
                                   F_AIRM          NVARCHAR(10),
                                   F_BIRM          NVARCHAR(10),
                                   F_MatchTime     NVARCHAR(20),
                                   F_AGame1        NVARCHAR(10),
                                   F_AGame2        NVARCHAR(10), 
                                   F_AGame3        NVARCHAR(10),
                                   F_AGame4        NVARCHAR(10),
                                   F_AGame5        NVARCHAR(10),
                                   F_BGame1        NVARCHAR(10),
                                   F_BGame2        NVARCHAR(10),
                                   F_BGame3        NVARCHAR(10),
                                   F_BGame4        NVARCHAR(10),
                                   F_BGame5        NVARCHAR(10),
                                   F_Game1Time     NVARCHAR(10),
                                   F_Game2Time     NVARCHAR(10),
                                   F_Game3Time     NVARCHAR(10),
                                   F_Game4Time     NVARCHAR(10),
                                   F_Game5Time     NVARCHAR(10),
                                   F_MatchTitle    NVARCHAR(200),
                                   F_MatchResult   NVARCHAR(200),
                                   F_PosADes    NVARCHAR(10),
                                   F_PosBDes    NVARCHAR(10),
                                   F_TotalGamePtA INT,
                                   F_TotalGamePtB INT,
                                   F_WinMatchA INT,
                                   F_WinMatchB INT,
                                   F_WinnerName NVARCHAR(100),
                                   F_TeamNameA NVARCHAR(100),
                                   F_TeamNameB NVARCHAR(100),
                                   F_TotalTime NVARCHAR(100),
                                   F_NameA1 NVARCHAR(100),
                                   F_NameB1 NVARCHAR(100),
                                   F_NameA2 NVARCHAR(100),
                                   F_NameB2 NVARCHAR(100),
                                   F_EventRaceNum NVARCHAR(20),
                                   F_MatchDate NVARCHAR(20),
                                   F_CourtName NVARCHAR(20),
                                   F_StartTime NVARCHAR(20),
                                   F_DuelResult NVARCHAR(30)
                                )

        DECLARE @APosID INT = 1
        DECLARE @BPosID INT = 2
        IF @Swap = 1
        BEGIN
			SET @APosID = 2
			SET @BPosID = 1
        END
        DECLARE @GameCount INT
        SELECT @APosID = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @APosID
        SELECT @BPosID = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @BPosID

		INSERT INTO #Temp_Table(F_MatchID,F_MatchSplitID, F_SplitOrder, F_SplitType, F_AName, F_ANOC, F_BName, F_BNOC, F_AMatch, F_BMatch, F_AMatchDes,F_BMatchDes, F_AIRM, F_BIRM, F_MatchTime,
		F_AGame1, F_AGame2, F_AGame3, F_AGame4, F_AGame5, F_BGame1, F_BGame2, F_BGame3, F_BGame4, F_BGame5, F_Game1Time, F_Game2Time, F_Game3Time, F_Game4Time, F_Game5Time, F_MatchTitle, F_MatchResult,
				F_CourtName)
				SELECT @MatchID,A.F_MatchSplitID, A.F_Order, A.F_MatchSplitType
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Split_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = A.F_MatchSplitID AND X.F_CompetitionPosition = @APosID AND Y.F_LanguageCode = @LanguageCode)
        ,dbo.Fun_Report_BD_TT_GetDlgCodeForTeam( @MatchID, A.F_MatchSplitID, @APosID, @LanguageCode )
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Split_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = A.F_MatchSplitID AND X.F_CompetitionPosition = @BPosID AND Y.F_LanguageCode = @LanguageCode)
        ,dbo.Fun_Report_BD_TT_GetDlgCodeForTeam( @MatchID, A.F_MatchSplitID, @BPosID, @LanguageCode)
        ,(SELECT F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.F_MatchSplitID AND F_CompetitionPosition = @APosID)
        ,(SELECT F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.F_MatchSplitID AND F_CompetitionPosition = @BPosID)
        ,(SELECT ISNULL(CONVERT( NVARCHAR(10),F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = A.F_MatchSplitID AND X.F_CompetitionPosition = @APosID)
		 ,(SELECT ISNULL(CONVERT( NVARCHAR(10),F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = A.F_MatchSplitID AND X.F_CompetitionPosition = @BPosID)
        
        ,(SELECT Y.F_IRMCODE FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON X.F_IRMID = Y.F_IRMID WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = A.F_MatchSplitID AND X.F_CompetitionPosition = @APosID)
        ,(SELECT Y.F_IRMCODE FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON X.F_IRMID = Y.F_IRMID WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = A.F_MatchSplitID AND X.F_CompetitionPosition = @BPosID)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info  WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.F_MatchSplitID)
        ,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @APosID AND Y.F_Order = 1)
        ,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @APosID AND Y.F_Order = 2)
			,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @APosID AND Y.F_Order = 3)
			,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @APosID AND Y.F_Order = 4)
			,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @APosID AND Y.F_Order = 5)
			
		,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @BPosID AND Y.F_Order = 1)
        ,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
		FROM TS_Match_Split_Result AS X 
		LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
		LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
		WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @BPosID AND Y.F_Order = 2)
			,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @BPosID AND Y.F_Order = 3)
			,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @BPosID AND Y.F_Order = 4)
			,(SELECT ISNULL(CONVERT(NVARCHAR(10),X.F_Points),'') + ISNULL( '(' + Z.F_IRMCODE + ')' ,'')
			FROM TS_Match_Split_Result AS X 
			LEFT JOIN TS_Match_Split_Info AS Y ON X.F_MatchID = Y.F_MatchID AND X.F_MatchSplitID = Y.F_MatchSplitID 
			LEFT JOIN TC_IRM AS Z ON Z.F_IRMID = X.F_IRMID
			WHERE Y.F_FatherMatchSplitID = A.F_MatchSplitID AND X.F_MatchID = @MatchID AND X.F_CompetitionPosition = @BPosID AND Y.F_Order = 5)	
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = A.F_MatchSplitID AND F_Order = 1 AND F_SpendTime > 0)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = A.F_MatchSplitID AND F_Order = 2 AND F_SpendTime > 0)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = A.F_MatchSplitID AND F_Order = 3 AND F_SpendTime > 0)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = A.F_MatchSplitID AND F_Order = 4 AND F_SpendTime > 0)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = A.F_MatchSplitID AND F_Order = 5 AND F_SpendTime > 0)
        ,[dbo].[Fun_Report_BD_GetMatchTitle](A.F_MatchID, A.F_MatchSplitID, 1, @LanguageCode)
        ,[dbo].[Fun_Report_BD_GetMatchTitle](A.F_MatchID, A.F_MatchSplitID, 2, @LanguageCode)
				,C.F_CourtShortName
        FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match AS B ON B.F_MatchID = A.F_MatchID
				LEFT JOIN TC_Court_Des AS C ON C.F_CourtID = B.F_CourtID AND C.F_LanguageCode = 'ENG'
        WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 ORDER BY A.F_Order 

        --UPDATE #Temp_Table SET F_AMatch = NULL, F_BMatch = NULL WHERE F_AMatch + F_BMatch = 0
        --UPDATE #Temp_Table SET F_AGame1 = NULL, F_BGame1 = NULL WHERE F_AGame1 + F_BGame1 = 0
        --UPDATE #Temp_Table SET F_AGame2 = NULL, F_BGame2 = NULL WHERE F_AGame2 + F_BGame2 = 0
        --UPDATE #Temp_Table SET F_AGame3 = NULL, F_BGame3 = NULL WHERE F_AGame3 + F_BGame3 = 0
        --UPDATE #Temp_Table SET F_AGame4 = NULL, F_BGame4 = NULL WHERE F_AGame4 + F_BGame4 = 0
        --UPDATE #Temp_Table SET F_AGame5 = NULL, F_BGame5 = NULL WHERE F_AGame5 + F_BGame5 = 0
        UPDATE #Temp_table SET F_MatchResult = '(' + F_MatchResult + ')' WHERE F_MatchResult <> '' AND F_MatchResult IS NOT NULL
        
        --前两盘的人员
        DECLARE @RegIDA1 INT
        DECLARE @RegIDB1 INT
        DECLARE @RegIDA2 INT
        DECLARE @RegIDB2 INT
         --第4,5的人员
        DECLARE @RegIDA4 INT
        DECLARE @RegIDB4 INT
        DECLARE @RegIDA5 INT
        DECLARE @RegIDB5 INT
        
        
        
        SELECT @RegIDA1 = B1.F_RegisterID, @RegIDB1 = B2.F_RegisterID
        FROM TS_Match_Split_Info AS A
        LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = @APosID
        LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = @BPosID
        WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = 1
        
        SELECT @RegIDA2 = B1.F_RegisterID, @RegIDB2 = B2.F_RegisterID
        FROM TS_Match_Split_Info AS A
        LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = @APosID
        LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = @BPosID
        WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = 2
       
        SELECT @RegIDA4 = B1.F_RegisterID,@RegIDB4 = B2.F_RegisterID
        FROM TS_Match_Split_Info AS A
        LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = @APosID
        LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = @BPosID
        WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = 4
       
        SELECT @RegIDA5 = B1.F_RegisterID,@RegIDB5 = B2.F_RegisterID
        FROM TS_Match_Split_Info AS A
        LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = @APosID
        LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = @BPosID
        WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = 5
        
        DECLARE @DoubleRegIDA INT
        DECLARE @DoubleRegIDB INT
        DECLARE @DoubleOrder INT
        SELECT @DoubleRegIDA = B1.F_RegisterID, @DoubleRegIDB = B2.F_RegisterID, @DoubleOrder = A.F_Order
        FROM TS_Match_Split_Info AS A
        LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = @APosID
        LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = @BPosID
        WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_MatchSplitType IN (3,4,5)
        
        DECLARE @DoubleDesA NVARCHAR(10)
        DECLARE @DoubleDesB NVARCHAR(10)
        DECLARE @Temp NVARCHAR(10)
        
        --PRINT @RegIDB4
        --PRINT @RegIDB1
        ----PRINT @RegID
        --return
        
        --第三盘的
       
       --PRINT @RegIDB1
       --PRINT @RegIDB2
       --PRINT @RegIDB4
       --PRINT @RegIDB5
       --RETURN
       

	   SELECT @DoubleDesA = CASE @RegIDA4 WHEN @RegIDA1 THEN 'C/B' WHEN @RegIDA2 THEN 'C/A' ELSE 'C/-' END
	   SELECT @DoubleDesB = CASE @RegIDB5 WHEN @RegIDB1 THEN 'Z/Y' WHEN @RegIDB2 THEN 'Z/X' ELSE 'Z/-' END
        
        
        UPDATE #Temp_Table SET F_PosADes = 'A', F_PosBDes = 'X' WHERE  F_SplitOrder = 1
        UPDATE #Temp_Table SET F_PosADes = 'B', F_PosBDes = 'Y' WHERE  F_SplitOrder = 2
        UPDATE #Temp_Table SET F_PosADes = @DoubleDesA, F_PosBDes = @DoubleDesB WHERE F_SplitOrder = 3
        
		UPDATE #Temp_Table SET F_PosADes = CASE @RegIDA4 WHEN @RegIDA1 THEN 'A' WHEN @RegIDA2 THEN 'B' ELSE '-' END, 
									   F_PosBDes = 'Z' WHERE  F_SplitOrder = 4
				
		UPDATE #Temp_Table SET F_PosADes = 'C', F_PosBDes = CASE @RegIDB5 WHEN @RegIDB1 THEN 'X' WHEN @RegIDB2 THEN 'Y' ELSE '-' END 
		WHERE  F_SplitOrder = 5
		
		IF EXISTS ( SELECT * FROM #Temp_Table WHERE F_SplitOrder = 3 AND F_AName IS NULL )
		BEGIN
			UPDATE #Temp_Table SET F_AName = (SELECT F_AName FROM #Temp_Table WHERE F_SplitOrder = 5) + '/-'
			WHERE F_SplitOrder = 3
		END
		
		IF EXISTS ( SELECT * FROM #Temp_Table WHERE F_SplitOrder = 3 AND F_BName IS NULL )
		BEGIN
			UPDATE #Temp_Table SET F_BName = (SELECT F_BName FROM #Temp_Table WHERE F_SplitOrder = 4) + '/-'
			WHERE F_SplitOrder = 3
		END
		
		
        
   --     IF @Swap = 1
   --     BEGIN
			--UPDATE #Temp_Table SET F_PosADes = CASE @RegIDA4 WHEN @RegIDA1 THEN 'X' WHEN @RegIDA2 THEN 'Y' ELSE '-' END, 
			--					   F_PosBDes = 'C' 
			--WHERE  F_SplitOrder = 4
			
			--UPDATE #Temp_Table SET F_PosADes = 'Z',
			--					   F_PosBDes = CASE @RegIDB5 WHEN @RegIDB1 THEN 'A' WHEN @RegIDB2 THEN 'B' ELSE '-' END 
			--WHERE  F_SplitOrder = 5
   --     END
   --     ELSE
   --     BEGIN
			--UPDATE #Temp_Table SET F_PosADes = CASE @RegIDA4 WHEN @RegIDA1 THEN 'A' WHEN @RegIDA2 THEN 'B' ELSE '-' END, 
			--					   F_PosBDes = 'Z' 
			--WHERE  F_SplitOrder = 4
			
			--UPDATE #Temp_Table SET F_PosADes = 'C', 
			--					   F_PosBDes = CASE @RegIDB5 WHEN @RegIDB1 THEN 'X' WHEN @RegIDB2 THEN 'Y' ELSE '-' END 
			--WHERE  F_SplitOrder = 5
   --     END
        
        IF @ShowAll = 0 
        BEGIN
			DELETE FROM #Temp_Table WHERE F_AMatch IS NULL AND F_BMatch IS NULL
        END
        
        UPDATE #Temp_Table SET F_TotalGamePtA = 
        (
			SELECT SUM(C.F_Points) FROM TS_Match_Split_Info AS B
			LEFT JOIN TS_Match_Split_Result AS C ON C.F_MatchID = B.F_MatchID AND C.F_MatchSplitID = B.F_MatchSplitID AND C.F_CompetitionPosition = @APosID
			WHERE B.F_FatherMatchSplitID = A.F_MatchSplitID AND B.F_MatchID = @MatchID
        )
        FROM #Temp_Table AS A
        
        UPDATE #Temp_Table SET F_TotalGamePtB = 
        (
			SELECT SUM(C.F_Points) FROM TS_Match_Split_Info AS B
			LEFT JOIN TS_Match_Split_Result AS C ON C.F_MatchID = B.F_MatchID AND C.F_MatchSplitID = B.F_MatchSplitID AND C.F_CompetitionPosition = @BPosID
			WHERE B.F_FatherMatchSplitID = A.F_MatchSplitID AND B.F_MatchID = @MatchID
        )
        FROM #Temp_Table AS A
        
        UPDATE #Temp_Table SET F_WinMatchA = 
        (
			SELECT CASE B.F_ResultID WHEN 1 THEN 1 ELSE 0 END 
			FROM TS_Match_Split_Result AS B WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitID = A.F_MatchSplitID AND F_CompetitionPosition = @APosID
        )
        FROM #Temp_Table AS A
        
        UPDATE #Temp_Table SET F_WinMatchB = 
        (
			SELECT CASE B.F_ResultID WHEN 1 THEN 1 ELSE 0 END 
			FROM TS_Match_Split_Result AS B WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitID = A.F_MatchSplitID AND F_CompetitionPosition = @BPosID
        )
        FROM #Temp_Table AS A
        
        UPDATE #Temp_Table SET F_WinnerName = 
        (
			SELECT B.F_PrintLongName FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			WHERE A.F_ResultID = 1 AND A.F_MatchID = @MatchID
        )
        
        UPDATE #Temp_Table SET F_TeamNameA = 
        (
			SELECT B.F_PrintLongName FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			WHERE A.F_CompetitionPositionDes1 = @APosID AND A.F_MatchID = @MatchID
        )
        
        UPDATE #Temp_Table SET F_TeamNameB = 
        (
			SELECT B.F_PrintLongName FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			WHERE A.F_CompetitionPositionDes1 = @BPosID  AND A.F_MatchID = @MatchID
        )
        UPDATE #Temp_Table SET F_TotalTime = 
        (SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match WHERE F_MatchID = @MatchID)
        
        UPDATE #Temp_Table SET F_NameA1 = F_AName, F_NameB1 = F_BName WHERE F_SplitType IN (1,2)
        SET LANGUAGE us_english
        UPDATE #Temp_Table SET F_EventRaceNum = 
        (
			SELECT D.F_EventComment + B.F_RaceNum
			FROM TS_Match AS B 
			LEFT JOIN TS_Phase AS C ON C.F_PhaseID = B.F_PhaseID
			LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'ENG'
			WHERE B.F_MatchID = A.F_MatchID
        ),
        F_StartTime =
        (
			SELECT dbo.Fun_Report_BD_GetDateTime(B.F_StartTime,3)
			FROM TS_Match AS B 
			WHERE B.F_MatchID = A.F_MatchID
        ),
        F_MatchDate = (SELECT dbo.Fun_Report_BD_GetDateTime(F_MatchDate,4) FROM TS_Match WHERE TS_Match.F_MatchID = A.F_MatchID)
        FROM #Temp_Table AS A
        SET LANGUAGE '简体中文'
        UPDATE #Temp_Table SET F_NameA1 = D11.F_PrintLongName, F_NameA2 = D12.F_PrintLongName, F_NameB1 = D21.F_PrintLongName,
				F_NameB2 = D22.F_PrintLongName
        FROM #Temp_Table AS A
        LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_MatchID = @MatchID AND B1.F_CompetitionPosition = @APosID
        LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID
        LEFT JOIN TR_Register_Des AS D11 ON D11.F_RegisterID = C1.F_MemberRegisterID AND C1.F_Order = 1 AND D11.F_LanguageCode = @LanguageCode
        LEFT JOIN TR_Register_Des AS D12 ON D12.F_RegisterID = C1.F_MemberRegisterID AND C1.F_Order = 2 AND D12.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_MatchID = @MatchID AND B2.F_CompetitionPosition = @BPosID
        LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B2.F_RegisterID
        LEFT JOIN TR_Register_Des AS D21 ON D21.F_RegisterID = C2.F_MemberRegisterID AND C2.F_Order = 1 AND D21.F_LanguageCode = @LanguageCode
        LEFT JOIN TR_Register_Des AS D22 ON D22.F_RegisterID = C2.F_MemberRegisterID AND C2.F_Order = 2 AND D22.F_LanguageCode = @LanguageCode
        WHERE F_SplitType IN (3,4,5)
        
        UPDATE #Temp_Table SET F_DuelResult = dbo.Fun_Report_BD_GetMatchResultDes(F_MatchID, 4, 0)
        
        DECLARE @TempNameA NVARCHAR(200)
		DECLARE @TeamNameB NVARCHAR(200)
		IF @RegIDA4 = @RegIDA1
		BEGIN
			SELECT @TempNameA = (SELECT ISNULL(F_AName,'-') FROM #Temp_Table WHERE F_SplitOrder = 5) + ' / '
							  + (SELECT ISNULL(F_AName,'-') FROM #Temp_Table WHERE F_SplitOrder = 2)
			
			UPDATE #Temp_Table SET F_AName = @TempNameA WHERE F_SplitOrder = 3
		END
		ELSE IF @RegIDA4 = @RegIDA2
		BEGIN
			SELECT @TempNameA = (SELECT ISNULL(F_AName,'-') FROM #Temp_Table WHERE F_SplitOrder = 5) + ' / '
							  + (SELECT ISNULL(F_AName,'-') FROM #Temp_Table WHERE F_SplitOrder = 1)
			UPDATE #Temp_Table SET F_AName = @TempNameA WHERE F_SplitOrder = 3
		END
		
		IF @RegIDB5 = @RegIDB1
		BEGIN
			SELECT @TeamNameB = (SELECT ISNULL(F_BName,'-') FROM #Temp_Table WHERE F_SplitOrder = 4) + ' / '
							  + (SELECT ISNULL(F_BName,'-') FROM #Temp_Table WHERE F_SplitOrder = 2)
			UPDATE #Temp_Table SET F_BName = @TeamNameB WHERE F_SplitOrder = 3
		END
		ELSE IF @RegIDB5 = @RegIDB2
		BEGIN
			SELECT @TeamNameB = (SELECT ISNULL(F_BName,'-') FROM #Temp_Table WHERE F_SplitOrder = 4) + ' / '
							  + (SELECT ISNULL(F_BName,'-') FROM #Temp_Table WHERE F_SplitOrder = 1)
			UPDATE #Temp_Table SET F_BName = @TeamNameB WHERE F_SplitOrder = 3
		END
		
		
		
        SELECT * FROM #Temp_Table 
SET NOCOUNT OFF
END


GO

