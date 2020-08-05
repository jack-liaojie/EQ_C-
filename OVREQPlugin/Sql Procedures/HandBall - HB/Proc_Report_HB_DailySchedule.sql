
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_DailySchedule]    Script Date: 08/29/2012 15:03:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_DailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_DailySchedule]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_DailySchedule]    Script Date: 08/29/2012 15:03:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_Report_HB_DailySchedule]
----功		  能：得到该项目下今日赛程
----作		  者：李燕
----日		  期: 2010-10-27

----功		  能：增加队伍颜色输出
----作		  者：翟广鹏
----日		  期: 2011-3-10


CREATE PROCEDURE [dbo].[Proc_Report_HB_DailySchedule] 
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
                                   F_WEEKENG       NVARCHAR(20),
                                   F_WEEKCHN       NVARCHAR(20),
                                   F_MatchID       INT,
                                   F_MatchNum      INT,
                                   F_Gender        NVARCHAR(50),
                                   F_EventCode     NVARCHAR(10),
                                   F_PhaseName     NVARCHAR(200),
                                   F_Team          NVARCHAR(200),
                                   F_HRegID        INT,
                                   F_VRegID        INT,
                                   F_HName         NVARCHAR(100),
                                   F_VName         NVARCHAR(100),
                                   F_Date          NVARCHAR(20),
                                   F_MatchDate     DATETIME,
                                   F_StartTime     NVARCHAR(5),
                                   F_EndTime       NVARCHAR(5),
                                   F_Location      NVARCHAR(100),
                                   F_City          NVARCHAR(100),
                                   F_PhaseID       INT,
                                   F_PhaseIsPool   INT,
                                   F_HUnitformID	int,
                                   F_HShitColor			NVARCHAR(20),
                                   F_HShotsColor			NVARCHAR(20),
                                   F_HSocksColor		NVARCHAR(20),
                                   F_HGKColor			NVARCHAR(20),
                                   F_VUnitformID	int,
                                   F_VShitColor			NVARCHAR(20),
                                   F_VShotsColor			NVARCHAR(20),
                                   F_VSocksColor			NVARCHAR(20),
                                   F_VGKColor			NVARCHAR(20),
                                )


        INSERT INTO #Temp_Table(F_MatchID, F_MatchNum, F_Gender, F_EventCode, F_PhaseName,F_Date, F_MatchDate, F_StartTime, F_EndTime, F_Location, F_PhaseID, F_PhaseIsPool, F_City)
        SELECT A.F_MatchID, A.F_MatchNum, D.F_SexLongName, C.F_EventCode, F.F_PhaseLongName, 
               UPPER(LEFT(CONVERT (NVARCHAR(100), A.F_MatchDate, 113), 11)), A.F_MatchDate,
               LEFT(CONVERT (NVARCHAR(100), A.F_StartTime, 108), 5), LEFT(CONVERT (NVARCHAR(100), A.F_EndTime, 108), 5), 
               E.F_VenueShortName, B.F_PhaseID, B.F_PhaseIsPool, TCD.F_CityLongName
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS F ON B.F_PhaseID = F.F_PhaseID AND F.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS H ON C.F_EventID = H.F_EventID AND H.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Sex_Des AS D ON C.F_SexCode = D.F_SexCode AND D.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Venue_Des AS E ON A.F_VenueID = E.F_VenueID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_DisciplineDate AS G ON A.F_MatchDate = G.F_Date
        LEFT JOIN TC_Venue AS TV ON E.F_VenueID = TV.F_VenueID
        LEFT JOIN TC_City_Des AS TCD ON TV.F_CityID = TCD.F_CityID AND TCD.F_LanguageCode = @LanguageCode
       
        WHERE C.F_DisciplineID = @DisciplineID AND G.F_DisciplineDateID = @DateID ORDER BY A.F_RaceNum

        UPDATE #Temp_table SET F_PhaseName = CASE WHEN C.F_PhaseLongName IS NULL THEN A.F_PhaseName ELSE C.F_PhaseLongName + ' - '+ A.F_PhaseName END 
             FROM #Temp_table AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
                  LEFT JOIN TS_Phase_Des AS C ON B.F_FatherPhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
               WHERE A.F_PhaseIsPool = 1
         
        --UPDATE #Temp_table SET F_Location = F_Location + (CASE WHEN F_City IS NULL THEN '' ELSE ', ' + F_City END)
                       
        UPDATE #Temp_Table SET F_HRegID = F_RegisterID FROM #Temp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
        UPDATE #Temp_Table SET F_VRegID = F_RegisterID FROM #Temp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2
        UPDATE #Temp_Table SET F_HName = C.F_DelegationCode  FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.F_HRegID = B.F_RegisterID LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
        UPDATE #Temp_Table SET F_VName = C.F_DelegationCode  FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.F_VRegID = B.F_RegisterID LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID

        UPDATE #Temp_Table SET F_HName = B.F_CompetitorSourceDes FROM #Temp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1 AND B.F_LanguageCode = @LanguageCode WHERE F_HRegID IS NULL 
        UPDATE #Temp_Table SET F_VName = C.F_CompetitorSourceDes FROM #Temp_Table AS A LEFT JOIN TS_Match_Result_Des AS C ON A.F_MatchID = C.F_MatchID AND C.F_CompetitionPosition = 2 AND C.F_LanguageCode = @LanguageCode WHERE F_VRegID IS NULL  
    
        IF(@LanguageCode = 'ENG')
        BEGIN
            UPDATE #Temp_Table SET F_Team = F_HName + ' vs ' + F_VName
        END
        ELSE
        BEGIN
            UPDATE #Temp_Table SET F_Team = F_HName + ' vs ' + F_VName
        END
        
        SET LANGUAGE 'ENGLISH'
        UPDATE #Temp_Table SET F_WEEKENG = UPPER(LEFT(DATENAME(WEEKDAY, F_MatchDate), 3))
        
        SET LANGUAGE N'简体中文'
        UPDATE #Temp_Table SET F_WEEKCHN = DATENAME(WEEKDAY, F_MatchDate)

        UPDATE #Temp_Table SET F_StartTime = RIGHT(F_StartTime, LEN(F_StartTime) - 1) WHERE LEFT(F_StartTime, 1) = '0'
        
        UPDATE #Temp_Table SET F_HUnitformID=TMR.F_UniformID from #Temp_Table as TT left join TS_Match_Result as TMR on TMR.F_MatchID=TT.F_MatchID and TMR.F_RegisterID=TT.F_HRegID
        UPDATE #Temp_Table SET F_VUnitformID=TMR.F_UniformID from #Temp_Table as TT left join TS_Match_Result as TMR on TMR.F_MatchID=TT.F_MatchID and TMR.F_RegisterID=TT.F_VRegID


		UPDATE #Temp_Table SET F_HShitColor=TCD.F_ColorShortName from #Temp_Table as TT left join TR_Uniform as TU on TU.F_UniformID=TT.F_HUnitformID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TU.F_Shirt AND TCD.F_LanguageCode=@LanguageCode
UPDATE #Temp_Table SET F_HShotsColor=TCD.F_ColorShortName from #Temp_Table as TT left join TR_Uniform as TU on TU.F_UniformID=TT.F_HUnitformID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TU.F_Shorts AND TCD.F_LanguageCode=@LanguageCode
UPDATE #Temp_Table SET F_HSocksColor=TCD.F_ColorShortName from #Temp_Table as TT left join TR_Uniform as TU on TU.F_UniformID=TT.F_HUnitformID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TU.F_Socks AND TCD.F_LanguageCode=@LanguageCode
UPDATE #Temp_Table SET F_HGKColor=TCD.F_ColorShortName from #Temp_Table as TT LEFT JOIN TS_Match_Result AS TMR ON TMR.F_MatchID=TT.F_MatchID AND TMR.F_RegisterID=TT.F_HRegID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TMR.F_UniformID2 AND TCD.F_LanguageCode=@LanguageCode

UPDATE #Temp_Table SET F_VShitColor=TCD.F_ColorShortName from #Temp_Table as TT left join TR_Uniform as TU on TU.F_UniformID=TT.F_VUnitformID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TU.F_Shirt AND TCD.F_LanguageCode=@LanguageCode
UPDATE #Temp_Table SET F_VShotsColor=TCD.F_ColorShortName from #Temp_Table as TT left join TR_Uniform as TU on TU.F_UniformID=TT.F_VUnitformID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TU.F_Shorts AND TCD.F_LanguageCode=@LanguageCode
UPDATE #Temp_Table SET F_VSocksColor=TCD.F_ColorShortName from #Temp_Table as TT left join TR_Uniform as TU on TU.F_UniformID=TT.F_VUnitformID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TU.F_Socks AND TCD.F_LanguageCode=@LanguageCode
UPDATE #Temp_Table SET F_VGKColor=TCD.F_ColorShortName from #Temp_Table as TT LEFT JOIN TS_Match_Result AS TMR ON TMR.F_MatchID=TT.F_MatchID AND TMR.F_RegisterID=TT.F_VRegID LEFT JOIN TC_Color_Des AS TCD ON TCD.F_ColorID=TMR.F_UniformID2 AND TCD.F_LanguageCode=@LanguageCode





        SELECT * FROM #Temp_Table ORDER BY F_Gender ,CAST (F_StartTime AS DaTETIME), F_MatchNum
SET NOCOUNT OFF
END


GO


