IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_DailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_DailySchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_BD_DailySchedule]
----功		  能：得到该项目下的全部竞赛日程
----作		  者：张翠霞
----日		  期: 2010-01-19
----修 改 记  录：
/*
                 2011-04-29     李燕     更改名字的显示
*/ 
--2012-07-31  王强   日期改为中文，全运会比赛


CREATE PROCEDURE [dbo].[Proc_Report_BD_DailySchedule] 
                   (	
					@DisciplineID			INT,
					@DayID                  INT,
                    @SessionID              INT,
					@LanguageCode           CHAR(3),
					@IsDay                  INT
                   )	
AS
BEGIN
SET NOCOUNT ON

        SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_WEEKENG       NVARCHAR(3),
                                   F_WEEKCHN       NVARCHAR(3),
                                   F_Date          NVARCHAR(11),
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(10),
                                   F_CourtCode     NVARCHAR(10),
                                   F_EventName     NVARCHAR(100),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(30),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(30), 
                                   F_Umpire1Name   NVARCHAR(100),
                                   F_Umpire1NOC    NVARCHAR(10),
                                   F_Umpire2Name   NVARCHAR(100),
                                   F_Umpire2NOC    NVARCHAR(10),
                                   F_MatchDate     DATETIME,
                                   F_MatchTime     DATETIME,
                                   F_EventCode     NVARCHAR(10),
                                   F_PosA INT,
                                   F_PosB INT,
                                   F_RaceNum NVARCHAR(20)
                                )

        CREATE TABLE #Temp_PlayerSource(
                                        F_MatchID                   INT,
                                        F_CompetitionPosition       INT,
                                        F_CompetitionPositionDes1   INT,
                                        F_MatchName				    NVARCHAR(150),
                                        F_RegisterID                INT,
                                        F_RegisterName              NVARCHAR(100),
                                        F_StartPhaseID			    INT,
										F_StartPhaseName		    NVARCHAR(100),
										F_StartPhasePosition	    INT,
										F_SourcePhaseID			    INT,
										F_SourcePhaseName		    NVARCHAR(100),
										F_SourcePhaseRank		    INT,
										F_SourceMatchPhaseID	    INT,
										F_SourceMatchPhaseName	    NVARCHAR(100),
										F_SourceMatchID			    INT,
										F_SourceMatchOrder		    INT,
										F_SourceMatchName		    NVARCHAR(100),
										F_SourceMatchRank		    INT
                                        )
		IF @IsDay = 1
		BEGIN
			INSERT INTO #Temp_PlayerSource (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_RegisterID,
			F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_MatchName)
			SELECT A.F_MatchID, A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes1, A.F_RegisterID, A.F_StartPhaseID,
			A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, C.F_MatchLongName
			FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
			LEFT JOIN TS_Match_Des AS C ON B.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
			LEFT JOIN TS_Event AS E ON D.F_EventID = E.F_EventID
			LEFT JOIN TS_Session AS F ON F.F_SessionID = B.F_SessionID
			LEFT JOIN TS_DisciplineDate AS G ON G.F_Date = F.F_SessionDate
			WHERE E.F_DisciplineID = @DisciplineID AND G.F_DisciplineDateID = @DayID
		END
        ELSE
        BEGIN
			INSERT INTO #Temp_PlayerSource (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_RegisterID,
			F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_MatchName)
			SELECT A.F_MatchID, A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes1, A.F_RegisterID, A.F_StartPhaseID,
			A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, C.F_MatchLongName
			FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
			LEFT JOIN TS_Match_Des AS C ON B.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
			LEFT JOIN TS_Event AS E ON D.F_EventID = E.F_EventID
			WHERE B.F_SessionID = @SessionID AND E.F_DisciplineID = @DisciplineID
        END
        --SELECT * FROM #Temp_PlayerSource
        --return

        UPDATE #Temp_PlayerSource SET F_StartPhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourcePhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #Temp_PlayerSource AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourceMatchName = F_SourceMatchPhaseName + ' Match' + CAST (F_SourceMatchOrder AS NVARCHAR(10)) WHERE @LanguageCode = 'ENG'
        UPDATE #Temp_PlayerSource SET F_SourceMatchName = F_SourceMatchPhaseName + ' 第' + CAST (F_SourceMatchOrder AS NVARCHAR(10)) + '场' WHERE @LanguageCode = 'CHN'

		UPDATE #Temp_PlayerSource SET F_RegisterName = B.F_LongName FROM #Temp_PlayerSource AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
        
        UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' 签位' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' 第' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) + '名' WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' 第' + CAST(F_SourceMatchRank AS NVARCHAR(100)) + '名' WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'

		IF @IsDay = 1
		BEGIN
			INSERT INTO #Temp_Table(F_EventCode, F_MatchDate, F_MatchTime, F_WEEKENG, F_Date, F_MatchID, F_StartTime, F_CourtCode, F_EventName, F_RoundName, F_MatchName, F_MatchNum, F_AName, F_ANOC, F_BName,
			F_BNOC, F_Umpire1Name, F_Umpire1NOC, F_Umpire2Name, F_Umpire2NOC, F_PosA, F_PosB,F_RaceNum)
			SELECT D.F_EventCode
			, A.F_MatchDate
			, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114)
			, UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3))
			, [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 8), A.F_MatchID
			, [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3)
			, CAST(F.F_CourtID AS NVARCHAR(10))
			, E.F_EventComment
			, [dbo].[Fun_Report_BD_GetPhaseName](A.F_MatchID, @LanguageCode)
			, MD.F_MatchLongName
			, CONVERT( INT,A.F_RaceNum)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
			,dbo.Fun_BDTT_GetPlayerNOCName(X1.F_RegisterID)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
			,dbo.Fun_BDTT_GetPlayerNOCName(X2.F_RegisterID)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1 AND Y.F_LanguageCode = @LanguageCode)
			,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2 AND Y.F_LanguageCode = @LanguageCode)
			,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2)
			,CASE WHEN D.F_PlayerRegTypeID IN (1,2) THEN  dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 1) ELSE NULL END, 
			 CASE WHEN D.F_PlayerRegTypeID IN (1,2)	THEN  dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 2) ELSE NULL END
			,A.F_RaceNum
			FROM TS_Match AS A 
			LEFT JOIN TS_Match_Result AS X1 ON X1.F_MatchID = A.F_MatchID AND X1.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS X2 ON X2.F_MatchID = A.F_MatchID AND X2.F_CompetitionPositionDes1 = 2
			LEFT JOIN TS_Match_Des AS MD ON A.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
			LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
			LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
			--LEFT JOIN TS_Phase_Position AS Z1 ON Z1.F_RegisterID = X1.F_RegisterID AND Z1.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = D.F_EventID)
			--LEFT JOIN TS_Phase_Position AS Z2 ON Z2.F_RegisterID = X2.F_RegisterID AND Z2.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = D.F_EventID)
			LEFT JOIN TS_Session AS G ON G.F_SessionID = A.F_SessionID
			LEFT JOIN TS_DisciplineDate AS H ON H.F_Date = G.F_SessionDate
			WHERE D.F_DisciplineID = @DisciplineID AND H.F_DisciplineDateID = @DayID
		END
		ELSE
		BEGIN
			INSERT INTO #Temp_Table(F_EventCode, F_MatchDate, F_MatchTime, F_WEEKENG, F_Date, F_MatchID, F_StartTime, F_CourtCode, F_EventName, F_RoundName, F_MatchName, F_MatchNum, F_AName, F_ANOC, F_BName,
			F_BNOC, F_Umpire1Name, F_Umpire1NOC, F_Umpire2Name, F_Umpire2NOC, F_PosA, F_PosB,F_RaceNum)
			SELECT D.F_EventCode
			, A.F_MatchDate
			, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114)
			, UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3))
			, [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 8), A.F_MatchID
			, [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3)
			, CAST(F.F_CourtID AS NVARCHAR(10))
			,E.F_EventComment
			, [dbo].[Fun_Report_BD_GetPhaseName](A.F_MatchID, @LanguageCode)
			, MD.F_MatchLongName
			, CONVERT( INT,A.F_RaceNum)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
			,dbo.Fun_BDTT_GetPlayerNOCName(X1.F_RegisterID)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
			,dbo.Fun_BDTT_GetPlayerNOCName(X2.F_RegisterID)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1 AND Y.F_LanguageCode = @LanguageCode)
			,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1)
			,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2 AND Y.F_LanguageCode = @LanguageCode)
			,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2)
			,CASE WHEN D.F_PlayerRegTypeID IN (1,2) THEN dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 1) ELSE NULL END, 
			 CASE WHEN D.F_PlayerRegTypeID IN (1,2)	THEN dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 2) ELSE NULL END
			,A.F_RaceNum
			FROM TS_Match AS A 
			LEFT JOIN TS_Match_Result AS X1 ON X1.F_MatchID = A.F_MatchID AND X1.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS X2 ON X2.F_MatchID = A.F_MatchID AND X2.F_CompetitionPositionDes1 = 2
			LEFT JOIN TS_Match_Des AS MD ON A.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
			LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
			LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
			--LEFT JOIN TS_Phase_Position AS Z1 ON Z1.F_RegisterID = X1.F_RegisterID AND Z1.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = D.F_EventID)
			--LEFT JOIN TS_Phase_Position AS Z2 ON Z2.F_RegisterID = X2.F_RegisterID AND Z2.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = D.F_EventID)
			WHERE D.F_DisciplineID = @DisciplineID AND A.F_SessionID = @SessionID
		END
       

        UPDATE #Temp_Table SET F_AName = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
        WHERE B.F_CompetitionPositionDes1 = 1 AND A.F_AName IS NULL AND A.F_ANOC IS NULL

        UPDATE #Temp_Table SET F_BName = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
        WHERE B.F_CompetitionPositionDes1 = 2 AND A.F_BName IS NULL AND A.F_BNOC IS NULL
		
		--团体赛，名称不含NOC
		UPDATE #Temp_Table SET F_AName = F_AName + ' (' + F_ANOC + ')' WHERE F_EventCode <> '203' AND F_ANOC IS NOT NULL		
		UPDATE #Temp_Table SET F_BName = F_BName + ' (' + F_BNOC + ')' WHERE F_EventCode <> '203' AND F_BNOC IS NOT NULL				
		
		--UPDATE #Temp_Table SET F_EventName = CASE F_EventCode WHEN '001' THEN 'MS' WHEN '002' THEN 'WT' WHEN '101' THEN 'WS' WHEN '102' THEN 'WD' WHEN '201' THEN 'XD' WHEN '202' THEN 'T' ELSE F_EventName END
		
	    SET LANGUAGE N'简体中文'
	    UPDATE #Temp_table SET F_WEEKCHN = UPPER(LEFT(DATENAME(WEEKDAY, F_MatchDate), 3))
	    
--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)

        SELECT * FROM #Temp_Table ORDER BY CONVERT(INT,F_CourtCode), F_MatchTime, F_MatchNum
SET NOCOUNT OFF
END



GO


