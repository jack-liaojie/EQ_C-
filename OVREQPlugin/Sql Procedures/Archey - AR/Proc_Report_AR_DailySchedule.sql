IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_DailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_DailySchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_AR_DailySchedule]
----功		  能：得到射箭项目下的一天的全部竞赛日程
----作		  者：崔凯
----日		  期: 2011-10-18
----修 改 记  录：
/*

*/


CREATE PROCEDURE [dbo].[Proc_Report_AR_DailySchedule] 
                   (	
					@DisciplineID			INT,
					@EventID				INT,
                    @DateID                 INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        --SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_WEEKCHN       NVARCHAR(3),
                                   F_Date          NVARCHAR(11),
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(100),
                                   F_CourtCode     NVARCHAR(10),
                                   F_CourtShortName		NVARCHAR(50),
                                   F_EventName     NVARCHAR(100),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(100),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(100), 
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
								   F_SessionName		NVARCHAR(20),
                                   F_ABackNo        NVARCHAR(20),
								   F_BBackNo		NVARCHAR(20),
                                   F_ATarget        NVARCHAR(20),
								   F_BTarget		NVARCHAR(20),
                                   F_ARegisterID        int,
								   F_BRegisterID		int,
								   F_StartTimeOrder		int
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
										F_PhaseOrder				INT,
                                        )

        INSERT INTO #Temp_PlayerSource (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_RegisterID,
		F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_MatchName,F_PhaseOrder)
		SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_RegisterID, A.F_StartPhaseID,
        A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, C.F_MatchLongName,D.F_Order
        FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID AND ISNULL(B.F_MatchCode,'') != 'QR'
        LEFT JOIN TS_Match_Des AS C ON B.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Session AS S ON S.F_SessionID = B.F_SessionID AND S.F_DisciplineID = @DisciplineID
        LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
        LEFT JOIN TS_Event AS E ON D.F_EventID = E.F_EventID
        LEFT JOIN TS_DisciplineDate AS F ON B.F_MatchDate = F.F_Date
        WHERE E.F_DisciplineID = @DisciplineID AND F.F_DisciplineID = @DisciplineID  AND E.F_EventID = @EventID
        --AND ((F.F_DisciplineDateID = @DateID AND @DateID <>-1)  OR (@DateID =-1 AND F.F_DisciplineDateID >= @DateID)) --AND E.F_PlayerRegTypeID =@RegTypeID

        UPDATE #Temp_PlayerSource SET F_StartPhaseName = B.F_PhaseLongName 
			FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourcePhaseName = B.F_PhaseLongName 
			FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
			
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_RaceNum 
			FROM #Temp_PlayerSource AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseName = B.F_PhaseShortName FROM #Temp_PlayerSource AS A 
			LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourceMatchName = ' 比赛' + CAST (F_SourceMatchOrder AS NVARCHAR(10)) 
			WHERE @LanguageCode = 'CHN'

		UPDATE #Temp_PlayerSource SET F_RegisterName = B.F_LongName FROM #Temp_PlayerSource AS A 
			LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_RegisterName = CASE WHEN F_SourceMatchRank =1 THEN LTRIM(RTRIM(F_SourceMatchName))+' 胜者 '
															ELSE LTRIM(RTRIM(F_SourceMatchName)) + ' 负者' END
			WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchPhaseName)) + ' 排名 ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) 
			WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN' AND F_PhaseOrder=2
		UPDATE #Temp_PlayerSource SET F_RegisterName = '排名赛 ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) 
			WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN' AND F_PhaseOrder=1
		UPDATE #Temp_PlayerSource SET F_RegisterName = '-轮空-' WHERE F_RegisterID = -1

        INSERT INTO #Temp_Table(F_MatchDate, F_MatchTime, F_WEEKCHN, F_Date, F_MatchID, F_StartTime, F_CourtCode, F_CourtShortName, F_EventName, 
        F_RoundName, F_MatchNum,F_SessionName, F_AName, F_ANOC, F_BName, F_BNOC, F_Umpire1Name, F_Umpire1NOC, F_Umpire2Name, F_Umpire2NOC, 
        F_OrderInSession, F_EventCode, F_PhaseCode, F_MatchStatus, F_VSDES, F_ABackNo,F_BBackNo,F_StartTimeOrder,F_ATarget,F_BTarget,F_ARegisterID,F_BRegisterID)
        SELECT A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), 
        UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)), 
        [dbo].FUN_AR_GetDatetime(A.F_MatchDate, 1, @LanguageCode), 
        A.F_MatchID, 
        [dbo].FUN_AR_GetDatetime(A.F_StartTime, 4, @LanguageCode)
        , RIGHT(F.F_CourtCode,2), H.F_CourtShortName, E.F_EventLongName, 
			CASE WHEN C.F_PhaseShortName ='决赛' AND A.F_MatchCode ='01' THEN '金牌赛' 
			WHEN C.F_PhaseShortName ='决赛' AND A.F_MatchCode ='02' THEN '铜牌赛'  ELSE C.F_PhaseShortName  END, 
			A.F_RaceNum , 'Session ' + CAST(S.F_SessionNumber AS VARCHAR)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1 AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation_DES AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation_DES AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1 AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 1)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Servant AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2 AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_NOC FROM TS_Match_Servant AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_MatchID = A.F_MatchID AND X.F_Order = 2)
        , A.F_OrderInSession
        , D.F_EventCode
        , B.F_PhaseCode
        , A.F_MatchStatusID
        , 'vs' 
        ,(SELECT Y.F_InscriptionRank FROM TS_Match_Result AS X LEFT JOIN TR_Inscription AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_EventID =@EventID)
        ,(SELECT Y.F_InscriptionRank FROM TS_Match_Result AS X LEFT JOIN TR_Inscription AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_EventID =@EventID)
        , ROW_NUMBER() over(order by RIGHT('000000' + dbo.FUN_AR_GetDatetime(A.F_StartTime, 4, @LanguageCode),6)) AS F_StartTimeOrder 
        ,(SELECT X.F_Comment FROM TS_Match_Result AS X LEFT JOIN TR_Inscription AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_EventID =@EventID)
        ,(SELECT X.F_Comment FROM TS_Match_Result AS X LEFT JOIN TR_Inscription AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_EventID =@EventID)
        ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X LEFT JOIN TR_Inscription AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_EventID =@EventID)
        ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X LEFT JOIN TR_Inscription AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_EventID =@EventID)
        
        FROM TS_Match AS A 
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
        LEFT JOIN TC_Court_Des AS H ON A.F_CourtID = H.F_CourtID AND H.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_DisciplineDate AS G ON A.F_MatchDate = G.F_Date
        LEFT JOIN TS_Session AS S ON S.F_SessionID = A.F_SessionID AND S.F_DisciplineID = @DisciplineID
        WHERE D.F_DisciplineID = @DisciplineID AND G.F_DisciplineID = @DisciplineID AND ISNULL(A.F_MatchCode,'') !='QR' AND E.F_EventID = @EventID
         --AND ((G.F_DisciplineDateID >= @DateID AND @DateID <> -1)  OR (@DateID = -1 AND G.F_DisciplineDateID != @DateID)) --AND D.F_PlayerRegTypeID =@RegTypeID

        UPDATE #Temp_Table SET F_EventName = CASE F_EventCode WHEN '001' THEN 'RM' WHEN '002' THEN 'CM' WHEN '101' THEN 'RW' WHEN '102' THEN 'CW' WHEN '201' THEN 'XD' ELSE F_EventName END
        
        
        UPDATE #Temp_Table SET F_AName = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
			WHERE B.F_CompetitionPositionDes1 = 1 AND A.F_AName IS NULL AND A.F_ANOC IS NULL

        UPDATE #Temp_Table SET F_BName = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
			WHERE B.F_CompetitionPositionDes1 = 2 AND A.F_BName IS NULL AND A.F_BNOC IS NULL
				
	    SET LANGUAGE N'简体中文'
	    UPDATE #Temp_table SET F_WEEKCHN = UPPER(LEFT(DATENAME(WEEKDAY, F_MatchDate), 3))
	    
--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
		
		---对于StatusID为100，110的比赛，A,B分别代表胜负
		UPDATE #Temp_table SET F_AName = C.F_PrintLongName, F_ANOC = DD.F_DelegationShortName ,F_VSDES = 'd.'
		        FROM #Temp_table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
		             LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		             LEFT JOIN TR_Register AS R ON C.F_RegisterID = R.F_RegisterID
		             LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
		             LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
		        WHERE A.F_MatchStatus IN (100, 110) AND B.F_Rank = 1
		        
		UPDATE #Temp_table SET F_BName = C.F_PrintLongName, F_BNOC = DD.F_DelegationShortName
		        FROM #Temp_table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
		             LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		             LEFT JOIN TR_Register AS R ON C.F_RegisterID = R.F_RegisterID
		             LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
		             LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
		        WHERE A.F_MatchStatus IN (100, 110) AND B.F_Rank = 2
		        
		UPDATE #Temp_Table SET F_APlayerDes = F_AName
		UPDATE #Temp_Table SET F_BPlayerDes = F_BName 
		--UPDATE #Temp_Table SET F_APlayerDes = F_AName + '('+ F_ANOC +')' WHERE F_ANOC IS NOT NULL
		--UPDATE #Temp_Table SET F_BPlayerDes = F_BName + '('+ F_BNOC +')' WHERE F_BNOC IS NOT NULL
		--UPDATE #Temp_Table SET F_Umpire1Title = 'Chair Umpire: ' WHERE F_Umpire1Name IS NOT NULL 
		--UPDATE #Temp_Table SET F_Umpire2Title = 'Chair Umpire: ' WHERE F_Umpire2Name IS NOT NULL
		--UPDATE #Temp_Table SET F_Umpire1Des = F_Umpire1Name + '('+ F_Umpire1NOC +')' WHERE F_Umpire1NOC IS NOT NULL
		--UPDATE #Temp_Table SET F_Umpire2Des = F_Umpire2Name + '('+ F_Umpire2NOC +')' WHERE F_Umpire2NOC IS NOT NULL
		
        SELECT * FROM #Temp_Table ORDER BY F_MatchNum 
        --SELECT * FROM #Temp_PlayerSource 
        
SET NOCOUNT OFF
END


GO



/*
exec Proc_Report_AR_DailySchedule 1,1,-1, 'CHN'
*/