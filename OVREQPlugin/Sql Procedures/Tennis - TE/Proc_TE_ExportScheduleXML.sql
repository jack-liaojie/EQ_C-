IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_ExportScheduleXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_ExportScheduleXML]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_TE_ExportScheduleXML]
----功		  能：得到参加TE项目的今日赛程列表
----作		  者：李燕
----日		  期: 2011-04-11
----修 改  记 录：
/*
                  2011-4-20     李燕     过滤团体赛的虚拟比赛
*/



CREATE PROCEDURE [dbo].[Proc_TE_ExportScheduleXML] 
                   @DateID			INT,
                   @OutputXML		NVARCHAR(MAX) OUTPUT
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @ScheduleList AS NVARCHAR(MAX)
	
	DECLARE @DisciplineID INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

    CREATE TABLE #table
                       ( F_MatchCode     NVARCHAR(20),
                         F_Field         NVARCHAR(2),
                         F_DateTime      NVARCHAR(20),
                         F_PhaseName     NVARCHAR(50),
                         F_EventName     NVARCHAR(50),
                         F_Noc_A         NVARCHAR(3),
                         F_Noc_B         NVARCHAR(3),
                         F_Athlete_A1    NVARCHAR(50),
                         F_Athlete_A2    NVARCHAR(50),
                         F_Athlete_B1    NVARCHAR(50),
                         F_Athlete_B2    NVARCHAR(50),
                         F_Athlete_A1ID  INT,
                         F_Athlete_B1ID  INT,
                         F_MatchID       INT,
                         F_RegTypeID     INT 
                        )

    INSERT INTO #table(F_MatchCode, F_Field, F_DateTime, F_PhaseName, F_EventName, F_Noc_A, F_Noc_B,F_Athlete_A1ID, F_Athlete_B1ID, F_MatchID, F_RegTypeID)
    SELECT D.F_DisciplineCode + F.F_GenderCode + C.F_EventCode + B.F_PhaseCode + A.F_MatchCode AS F_MatchCode
                , RIGHT(G.F_CourtCode, 2) AS F_Field
                , LEFT(CONVERT(NVARCHAR(100), E.F_Date, 112), 8) + REPLACE(LEFT(CONVERT(NVARCHAR(100), F_StartTime, 8), 6), ':', '') AS F_DateTime
                , PD.F_PhaseLongName AS F_PhaseName
                , ED.F_EventLongName AS F_EventName
                , (SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
                   LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1) AS F_Noc_A
                , (SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
                   LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2) AS F_Noc_B
                , (CASE C.F_PlayerRegTypeID WHEN 1 THEN (SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1)
                   WHEN 2 THEN (SELECT TOP 1 Y.F_MemberRegisterID FROM TS_Match_Result AS X LEFT JOIN TR_Register_Member AS Y ON X.F_RegisterID = Y.F_RegisterID 
				   WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1) ELSE '' END) AS F_Athlete_A1ID
                , (CASE C.F_PlayerRegTypeID WHEN 1 THEN (SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
                   WHEN 2 THEN (SELECT TOP 1 Y.F_MemberRegisterID FROM TS_Match_Result AS X LEFT JOIN TR_Register_Member AS Y ON X.F_RegisterID = Y.F_RegisterID 
				   WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2) ELSE '' END) AS F_Athlete_B1ID
                , A.F_MatchID
                , C.F_PlayerRegTypeID
                FROM TS_Match AS A
                LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
                LEFT JOIN TS_Phase_Des AS PD ON A.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = 'ENG'
                LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
                LEFT JOIN TS_Event_Des AS ED ON C.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
                LEFT JOIN TC_Sex AS F ON C.F_SexCode = F.F_SexCode
                LEFT JOIN TS_Discipline AS D ON C.F_DisciplineID = D.F_DisciplineID
                LEFT JOIN TS_DisciplineDate AS E ON A.F_MatchDate = E.F_Date AND E.F_DisciplineID = @DisciplineID
                LEFT JOIN TC_Court AS G ON A.F_CourtID = G.F_CourtID
                WHERE E.F_DisciplineDateID = @DateID AND D.F_DisciplineID = @DisciplineID
                AND A.F_MatchStatusID >= 30 AND A.F_MatchID NOT IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID <=0 AND F_RegisterID IS NULL)
                  ORDER BY A.F_CourtID, A.F_RaceNum

               UPDATE #table SET F_DateTime = CASE  LEFT( F_DateTime,8) WHEN '20110813' THEN '20110604' 
                                                                         WHEN '20110814' THEN '20110605'
                                                                         WHEN '20110815' THEN '20110606'
                                                                         WHEN '20110816' THEN '20110607'
                                                                         WHEN '20110817' THEN '20110608'
                                                                         WHEN '20110818' THEN '20110609'
                                                                         WHEN '20110819' THEN '20110610'
                                                                         WHEN '20110820' THEN '20110611'
                                                                         WHEN '20110821' THEN '20110612'
                                                                         ELSE F_DateTime END +  RIGHT(F_DateTime, 4)
               
               
               UPDATE #table SET F_Field = CAST(CAST(F_Field AS INT) - 1 AS NVARCHAR(2))
               UPDATE #table SET F_Field = 'CC' WHERE F_Field = '0'
               
               UPDATE #table SET F_Athlete_A1 = F_SBShortName FROM TR_Register_Des WHERE F_RegisterID = F_Athlete_A1ID AND F_LanguageCode = 'ENG'
               UPDATE #table SET F_Athlete_B1 = F_SBShortName FROM TR_Register_Des WHERE F_RegisterID = F_Athlete_B1ID AND F_LanguageCode = 'ENG'
               
               UPDATE #table SET F_Athlete_A2 = TRD.F_SBShortName 
                  FROM #table AS TT LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 1
                  LEFT JOIN TR_Register_Member AS TRM ON MR.F_RegisterID = TRM.F_RegisterID AND TRM.F_MemberRegisterID <> F_Athlete_A1ID
                  LEFT JOIN TR_Register_Des AS TRD ON TRM.F_MemberRegisterID = TRD.F_RegisterID AND TRD.F_LanguageCode = 'ENG'
                 WHERE TT.F_RegTypeID = 2
               
               UPDATE #table SET F_Athlete_B2 = TRD.F_SBShortName 
                  FROM #table AS TT LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 2
                  LEFT JOIN TR_Register_Member AS TRM ON MR.F_RegisterID = TRM.F_RegisterID AND TRM.F_MemberRegisterID <> F_Athlete_B1ID
                  LEFT JOIN TR_Register_Des AS TRD ON TRM.F_MemberRegisterID = TRD.F_RegisterID AND TRD.F_LanguageCode = 'ENG'
                 WHERE TT.F_RegTypeID = 2
 

                UPDATE #table SET F_Noc_A = '' WHERE F_Noc_A IS NULL
                UPDATE #table SET F_Noc_B = '' WHERE F_Noc_B IS NULL
                UPDATE #table SET F_Athlete_A1 = '' WHERE F_Athlete_A1 IS NULL
                UPDATE #table SET F_Athlete_A2 = '' WHERE F_Athlete_A2 IS NULL
                UPDATE #table SET F_Athlete_B1 = '' WHERE F_Athlete_B1 IS NULL
                UPDATE #table SET F_Athlete_B2 = '' WHERE F_Athlete_B2 IS NULL
                
                UPDATE #table SET F_Field = RIGHT(F_Field,1) WHERE LEFT(F_Field, 1) = '0'

	SET @ScheduleList = (SELECT
			Schedule.F_MatchCode AS MatchCode
			, Schedule.F_Field AS Field
			, Schedule.F_DateTime AS [DateTime]
			, Schedule.F_PhaseName AS PhaseName
			, Schedule.F_EventName AS EventName
			, Schedule.F_Noc_A AS Noc_A
            , Schedule.F_Noc_B AS Noc_B
            , Schedule.F_Athlete_A1 AS Athlete_A1
            , Schedule.F_Athlete_A2 AS Athlete_A2
            , Schedule.F_Athlete_B1 AS Athlete_B1
            , Schedule.F_Athlete_B2 AS Athlete_B2
            FROM (SELECT * FROM #table) AS Schedule
            FOR XML AUTO)

	IF @ScheduleList IS NULL
	BEGIN
		SET @ScheduleList = N''
	END

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
						<ScheduleInfo>'
					+ @ScheduleList
					+ N'
                        </ScheduleInfo>'

	RETURN

SET NOCOUNT OFF
END

GO

--declare @xml nvarchar(max)
--exec Proc_TE_ExportScheduleXML 8, @xml output
--select @xml