
/****** Object:  StoredProcedure [dbo].[Proc_Report_FB_TeamStartList]    Script Date: 10/13/2010 13:29:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_TeamStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_TeamStartList]
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_FB_TeamStartList]    Script Date: 10/13/2010 13:29:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_FB_TeamStartList]
--描    述：得到该场Match的出场队员信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月21日
--修 改 人：翟广鹏
--日    期: 2011年3月4日
--修改说明：更改首发队员判断条件为matchmember表中startup,更改主客队选项


CREATE PROCEDURE [dbo].[Proc_Report_FB_TeamStartList](
												@MatchID		    INT,
												@TeamPos            INT,        --0为包括主客队，1为主队，2为客队
												@Startup			INT,        --1 为首发队员，0或NULL为替补
												@LanguageCode		CHAR(3)
												
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @DisciplineID  INT
	SELECT @DisciplineID = D.F_DisciplineID  
	     FROM TS_Match AS M 
	     LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	     LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID 
	     LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	     WHERE M.F_MatchID = @MatchID
	             
    CREATE TABLE #Tmp_Table(
                                F_TeamID        INT,
                                F_TeamPos       INT,
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           INT,
                                F_FunctionID    INT,
                                F_PositionID    INT,
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(50),
                                F_Function      NVARCHAR(100),
                                F_Position      NVARCHAR(300),
                                F_Birth_Date    NVARCHAR(11),
                                F_Height        INT,
                                F_Weight        INT,
                                F_HeightDes     NVARCHAR(20),
                                F_WeightDes     NVARCHAR(20),
                                F_ClubName      NVARCHAR(50),
                                F_MP            INT,
                                F_MIN           INT,
                                F_GF            INT,
                                F_GA            INT,
                                F_YCard         INT,
                                F_2YCard        INT,
                                F_RCard         INT,
                                F_HomeNOC       NVARCHAR(10),
                                F_VisitNOC      NVARCHAR(10),
                                F_PositionOrder INT,
                                F_Startup		INT              
                                )


		INSERT INTO #Tmp_Table (F_TeamID, F_TeamPos, F_RegisterID, F_PrintLN, F_PrintSN, F_NOC, F_NOCDes, F_Bib, F_FunctionID, F_PositionID, F_Birth_Date, F_Height, F_Weight, F_ClubName,F_PositionOrder,F_Startup)
           SELECT H.F_RegisterID,B.F_CompetitionPosition,B.F_RegisterID,D.F_PrintLongName,D.F_PrintShortName, F.F_DelegationCode, G.F_DelegationShortName,  B.F_ShirtNumber,
                  B.F_FunctionID,B.F_PositionID,UPPER(LEFT(CONVERT (NVARCHAR(100), C.F_Birth_Date, 120), 11)), C.F_Height, C.F_Weight,  I.F_ClubLongName,1, B.F_StartUp
           FROM  TS_Match_Result AS A 
				LEFT JOIN TS_Match_Member AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition AND A.F_MatchID = B.F_MatchID
				LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
				LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
				LEFT JOIN TD_Position AS E ON B.F_PositionID = E.F_PositionID
				LEFT JOIN TC_Delegation AS F ON C.F_DelegationID = F.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS G ON F.F_DelegationID = G.F_DelegationID AND G.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Match_Result AS H ON H.F_MatchID = B.F_MatchID AND H.F_CompetitionPosition=A.F_CompetitionPosition
				LEFT JOIN TC_Club_Des as I on C.F_ClubID = I.F_CLubID AND G.F_LanguageCode = @LanguageCode
            WHERE A.F_MatchID = @MatchID --AND A.F_CompetitionPosition = @TeamPos
           
           if @TeamPos=1
           delete from #Tmp_Table where F_TeamPos=2
           else if @TeamPos=2
           delete from #Tmp_Table where F_TeamPos=1
   
   
		UPDATE #Tmp_Table SET F_HomeNOC = C.F_DelegationCode 
             FROM TS_Match_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                   LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
                 WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
                 
        UPDATE #Tmp_Table SET F_VisitNOC = C.F_DelegationCode 
             FROM TS_Match_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                   LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
                 WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
   
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionCode 
            FROM #Tmp_Table AS A LEFT JOIN  TD_Function AS B ON A.F_FunctionID = B.F_FunctionID

                  
    UPDATE #Tmp_Table SET F_Position = B.F_PositionCode
         FROM  #Tmp_Table AS A LEFT JOIN TD_Position AS B ON A.F_PositionID = B.F_PositionID
                               LEFT JOIN TD_Position_Des AS C ON B.F_PositionID = C.F_PositionID AND C.F_LanguageCode = @LanguageCode
   
    UPDATE #Tmp_Table SET F_Position = B.F_PositionCode, F_PositionOrder = CAST( C.F_PositionComment AS INT) 
         FROM  #Tmp_Table AS A LEFT JOIN TD_Position AS B ON A.F_PositionID = B.F_PositionID
                               LEFT JOIN TD_Position_Des AS C ON B.F_PositionID = C.F_PositionID AND C.F_LanguageCode = @LanguageCode
         
    UPDATE #Tmp_Table SET F_HeightDes = LEFT(F_Height / 100.0, 4) --+ ' / ' + CONVERT(NVARCHAR(2), F_Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(2), (F_Height * 100 / 254) % 12) + '"'

    UPDATE #Tmp_Table SET F_WeightDes = CONVERT(NVARCHAR(3), F_Weight) --+ ' / ' + CONVERT(NVARCHAR(5), F_Weight * 22 / 10)

    UPDATE #Tmp_Table SET F_Birth_Date = RIGHT(F_Birth_Date, 10) WHERE LEFT(F_Birth_Date, 1) = '0' 
   
   
      DECLARE @MatchDate AS DateTime
   SELECT @MatchDate = F_MatchDate  FROM TS_Match WHERE F_MatchID = @MatchID

    
    
    --插入比赛次数
    
    UPDATE A SET F_MP = B.Value FROM #Tmp_Table AS A LEFT JOIN
     (
	   select TMS.F_RegisterID,COUNT(*) AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Member AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID 
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 
	   	   group by TMS.F_RegisterID
		     ) AS B ON A.F_RegisterID = B.F_RegisterID
    
   
   UPDATE A SET F_MIN = B.Value FROM #Tmp_Table AS A LEFT JOIN
    (
	   select TMS.F_RegisterID,sum(cast(TMS.F_StatisticValue as int))/60  AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Statistic AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TD_Statistic AS TDS ON TMS.F_StatisticID = TDS.F_StatisticID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 AND TDS.F_StatisticCode = 'Player_TimePlayed'
	   group by TMS.F_RegisterID
	 )  AS B ON A.F_RegisterID = B.F_RegisterID
	  
	UPDATE A SET F_GF = B.Value FROM #Tmp_Table AS A LEFT JOIN
	  (
	   select TMS.F_RegisterID,sum(cast(TMS.F_StatisticValue as int)) AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Statistic AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TD_Statistic AS TDS ON TMS.F_StatisticID = TDS.F_StatisticID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID
	    LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = TMS.F_MatchID AND TMSI.F_MatchSplitID = TMS.F_MatchSplitID
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 AND  
	   TDS.F_StatisticCode IN('Player_Goal','Player_PGoal','Player_FCGoal')
	    AND TMSI.F_MatchSplitCode <>'51' 
	   group by TMS.F_RegisterID
	  )  AS B ON A.F_RegisterID = B.F_RegisterID
	
	  UPDATE A SET F_GA = B.Value FROM #Tmp_Table AS A LEFT JOIN
	  (
	   select TMS.F_RegisterID,sum(cast(TMS.F_StatisticValue as int)) AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Statistic AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TD_Statistic AS TDS ON TMS.F_StatisticID = TDS.F_StatisticID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID
	   LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = TMS.F_MatchID AND TMSI.F_MatchSplitID = TMS.F_MatchSplitID
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 AND  
	   TDS.F_StatisticCode IN('Player_GoalAgainst')
	    AND TMSI.F_MatchSplitCode <>'51' 
	   group by TMS.F_RegisterID
	  )  AS B ON A.F_RegisterID = B.F_RegisterID
	  
	   UPDATE A SET F_YCard = B.Value FROM #Tmp_Table AS A LEFT JOIN
	  (
	   select TMS.F_RegisterID,sum(cast(TMS.F_StatisticValue as int)) AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Statistic AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TD_Statistic AS TDS ON TMS.F_StatisticID = TDS.F_StatisticID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 AND  
	   TDS.F_StatisticCode IN('Player_YCard')
	   group by TMS.F_RegisterID
	  )  AS B ON A.F_RegisterID = B.F_RegisterID
	  
	   UPDATE A SET F_2YCard = B.Value FROM #Tmp_Table AS A LEFT JOIN
	  (
	   select TMS.F_RegisterID,sum(cast(TMS.F_StatisticValue as int)) AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Statistic AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TD_Statistic AS TDS ON TMS.F_StatisticID = TDS.F_StatisticID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 AND  
	   TDS.F_StatisticCode IN('Player_2YCard')
	   group by TMS.F_RegisterID
	  )  AS B ON A.F_RegisterID = B.F_RegisterID
	  
	   UPDATE A SET F_RCard = B.Value FROM #Tmp_Table AS A LEFT JOIN
	  (
	   select TMS.F_RegisterID,sum(cast(TMS.F_StatisticValue as int)) AS Value
	   from #Tmp_Table AS players LEFT JOIN TS_Match_Statistic AS TMS ON players.F_RegisterID = TMS.F_RegisterID
	   LEFT JOIN TD_Statistic AS TDS ON TMS.F_StatisticID = TDS.F_StatisticID
	   LEFT JOIN TS_Match AS TSM ON TMS.F_MatchID = TSM.F_MatchID
	   where TSM.F_MatchDate < @MatchDate AND TSM.F_MatchStatusID = 110 AND  
	   TDS.F_StatisticCode IN('Player_RCard')
	   group by TMS.F_RegisterID
	  )  AS B ON A.F_RegisterID = B.F_RegisterID
   
    UPDATE #Tmp_Table SET F_PrintLN  = F_PrintLN + ' (C)' WHERE F_Function = 'C'
     
	if @Startup=1
	SELECT * FROM #Tmp_Table where F_Startup=1 ORDER BY F_TeamPos, F_PositionOrder, F_Bib
	else 
	SELECT * FROM #Tmp_Table where F_Startup is null or F_Startup=0 ORDER BY F_TeamPos, F_Bib
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO
--exec  Proc_Report_FB_TeamStartList 50,0,1,'ENG'