IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_DailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_DailySchedule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_Report_TE_DailySchedule]
----功		  能：得到网球项目下的一天的全部竞赛日程
----作		  者：郑金勇
----日		  期: 2010-10-13
----修 改 记  录：
/*
                  李燕          2011-3-1   增加按OrderInSession的排序
                  李燕          2011-5-8   更改EventName为简称
*/


CREATE PROCEDURE [dbo].[Proc_Report_TE_DailySchedule] 
                   (	
					@DisciplineID			INT,
                    @DateID                 INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_WEEKENG       NVARCHAR(3),
                                   F_WEEKCHN       NVARCHAR(3),
                                   F_Date          NVARCHAR(50),
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(100),
                                   F_CourtCode     NVARCHAR(10),
                                   F_CourtShortName		NVARCHAR(50),
                                   F_EventName     NVARCHAR(100),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(10), 
                                   F_Umpire1Name   NVARCHAR(100),
                                   F_Umpire1NOC    NVARCHAR(10),
                                   F_Umpire2Name   NVARCHAR(100),
                                   F_Umpire2NOC    NVARCHAR(10),
                                   F_MatchDate     DATETIME,
                                   F_MatchTime     DATETIME,
                                   F_APlayerDes	   NVARCHAR(100),
                                   F_BPlayerDes	   NVARCHAR(100),
                                   F_Umpire1Title  NVARCHAR(100),
                                   F_Umpire2Title  NVARCHAR(100),
                                   F_Umpire1Des	   NVARCHAR(100),
                                   F_Umpire2Des	   NVARCHAR(100),
                                   F_OrderInSession            INT,
                                   F_EventCode     NVARCHAR(10),
                                   F_PhaseCode     NVARCHAR(10),
                                   F_MatchStatus   INT,
                                   F_VSDES         NVARCHAR(20),
                                   F_RowNum        INT,
                                   F_EventID       INT
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
										F_SourceMatchRank		    INT,
                                        )

        INSERT INTO #Temp_PlayerSource (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_RegisterID,
		F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_MatchName)
		SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_RegisterID, A.F_StartPhaseID,
        A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, C.F_MatchLongName
        FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
        LEFT JOIN TS_Match_Des AS C ON B.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
        LEFT JOIN TS_Event AS E ON D.F_EventID = E.F_EventID
        LEFT JOIN TS_DisciplineDate AS F ON B.F_MatchDate = F.F_Date
        WHERE E.F_DisciplineID = @DisciplineID AND F.F_DisciplineID = @DisciplineID AND F.F_DisciplineDateID = @DateID AND E.F_PlayerRegTypeID <> 3

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


        INSERT INTO #Temp_Table(F_MatchDate, F_MatchTime, F_WEEKENG, F_Date, F_MatchID, F_StartTime, F_CourtCode, F_CourtShortName, F_EventName, F_RoundName, F_MatchNum, F_AName, F_ANOC, F_BName, F_BNOC, F_Umpire1Name, F_Umpire1NOC, F_Umpire2Name, F_Umpire2NOC, F_OrderInSession, F_EventCode, F_PhaseCode, F_MatchStatus, F_VSDES, F_EventID)
        SELECT A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)), [dbo].[Func_Report_TE_GetDateTime](A.F_MatchDate, 7, @LanguageCode), A.F_MatchID, [dbo].[Func_Report_TE_GetDateTime](A.F_StartTime, 9, @LanguageCode)
        , RIGHT(F.F_CourtCode,2), H.F_CourtShortName, E.F_EventLongName, [dbo].[Fun_Report_TE_GetPhaseName](A.F_MatchID, @LanguageCode), A.F_RaceNum
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1 AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1 AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2 AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2)
        , A.F_OrderInSession
        , D.F_EventCode
        , B.F_PhaseCode
        , A.F_MatchStatusID
        , 'vs'
        , D.F_EventID
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
        LEFT JOIN TC_Court_Des AS H ON A.F_CourtID = H.F_CourtID AND H.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_DisciplineDate AS G ON A.F_MatchDate = G.F_Date
        WHERE D.F_DisciplineID = @DisciplineID AND G.F_DisciplineID = @DisciplineID AND G.F_DisciplineDateID = @DateID AND D.F_PlayerRegTypeID <> 3

      
        
        UPDATE A SET A.F_EventName = C.F_GenderCode +  CASE B.F_PlayerRegTypeID WHEN 1 THEN N'S' WHEN 2 THEN N'D' WHEN 3 THEN 'T' ELSE N'X' END 
			FROM #Temp_Table AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
        LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode
        
        UPDATE #Temp_Table SET F_AName = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
        WHERE B.F_CompetitionPositionDes1 = 1 AND A.F_AName IS NULL AND A.F_ANOC IS NULL

        UPDATE #Temp_Table SET F_BName = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
        WHERE B.F_CompetitionPositionDes1 = 2 AND A.F_BName IS NULL AND A.F_BNOC IS NULL
				
	    SET LANGUAGE N'简体中文'
	    UPDATE #Temp_table SET F_WEEKCHN = UPPER(LEFT(DATENAME(WEEKDAY, F_MatchDate), 3))
	    
--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
		
		UPDATE A SET A.F_RowNum = B.F_RowNum FROM #Temp_table AS A LEFT JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY F_CourtCode ORDER BY F_StartTime, F_MatchNum) AS F_RowNum, F_CourtCode, F_StartTime FROM #Temp_table ) AS B 
                ON A.F_CourtCode = B.F_CourtCode AND A.F_StartTime = B.F_StartTime
            
		CREATE TABLE #Temp_StartTime ( 
		                               F_CourtCode    NVARCHAR(10),
		                               F_StartTime    NVARCHAR(100),
		                             )
		
		INSERT INTO #Temp_StartTime(F_CourtCode)
		        SELECT DISTINCT F_CourtCode FROM #Temp_table 
		
		UPDATE A SET A.F_StartTime = B.F_StartTime FROM #Temp_StartTime AS A LEFT JOIN #Temp_table AS B ON A.F_CourtCode = B.F_CourtCode AND B.F_RowNum = 1
         
        UPDATE A SET A.F_StartTime =  B.F_StartTime FROM #Temp_table AS A LEFT JOIN #Temp_StartTime AS B ON A.F_CourtCode = B.F_CourtCode
        
		
		---对于StatusID为100，110的比赛，A,B分别代表胜负
		UPDATE #Temp_table SET F_AName = C.F_PrintLongName, F_ANOC = D.F_DelegationCode ,F_VSDES = 'd.'
		        FROM #Temp_table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
		             LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		             LEFT JOIN TR_Register AS R ON C.F_RegisterID = R.F_RegisterID
		             LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
		        WHERE A.F_MatchStatus IN (100, 110) AND B.F_Rank = 1
		        
		UPDATE #Temp_table SET F_BName = C.F_PrintLongName, F_BNOC = D.F_DelegationCode
		        FROM #Temp_table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
		             LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		             LEFT JOIN TR_Register AS R ON C.F_RegisterID = R.F_RegisterID
		             LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
		        WHERE A.F_MatchStatus IN (100, 110) AND B.F_Rank = 2
		        
		UPDATE #Temp_Table SET F_APlayerDes = F_AName
		UPDATE #Temp_Table SET F_BPlayerDes = F_BName 
		UPDATE #Temp_Table SET F_APlayerDes = F_AName + '('+ F_ANOC +')' WHERE F_ANOC IS NOT NULL
		UPDATE #Temp_Table SET F_BPlayerDes = F_BName + '('+ F_BNOC +')' WHERE F_BNOC IS NOT NULL
		UPDATE #Temp_Table SET F_Umpire1Title = '主裁判: ' WHERE F_Umpire1Name IS NOT NULL 
		UPDATE #Temp_Table SET F_Umpire2Title = '主裁判: ' WHERE F_Umpire2Name IS NOT NULL
		UPDATE #Temp_Table SET F_Umpire1Des = F_Umpire1Name WHERE F_Umpire1NOC IS NOT NULL
		UPDATE #Temp_Table SET F_Umpire2Des = F_Umpire2Name WHERE F_Umpire2NOC IS NOT NULL
		
        SELECT [dbo].[Fun_TE_GetMatchSplitsPointsDes](F_MatchID, 2, 0) AS F_PointDes, * FROM #Temp_Table ORDER BY (CASE F_CourtCode WHEN '16' THEN 1 ELSE 2 END), F_CourtCode,F_OrderInSession, F_MatchNum 
SET NOCOUNT OFF
END




GO

--execute Proc_Report_TE_DailySchedule 1, 1, 'CHN'