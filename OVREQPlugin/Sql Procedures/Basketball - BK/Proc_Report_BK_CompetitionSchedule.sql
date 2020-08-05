IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_CompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_BK_CompetitionSchedule]
----功		  能：得到篮球单项下的全部竞赛日程
----作		  者：吴定昉
----日		  期: 2011-06-08
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年9月20日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/

create procedure [dbo].[Proc_Report_BK_CompetitionSchedule]
( 
   @EventID int,
   @DateID int,
   @MatchID int,
   @LanguageCode char(3)
)
as
begin
  set nocount on
   
  set language English
    create table #Temp_table(
                               F_EventID                  int,  
                               F_MatchID                  int,  -- 比赛主键 TS_Match
                               F_StartTime                NVARCHAR(10), -- 开球时间 TS_Match
                               F_EndTime                  NVARCHAR(10), -- 开球时间 TS_Match
                               F_MatchNum                 INT, -- 比赛次序 TS_Match   
                               F_VenueID                  int, -- 比赛场馆ID                       
                               F_VenueLongName            nvarchar(100), -- 比赛场馆名称 TC_Venue_Des
                               F_CityLongName             nvarchar(100), -- 比赛场馆所属的城市名称 TC_City_Des
                               F_SessionTime              nvarchar(50), -- 比赛指定时间 TS_Session    
                               F_RegisterID_A             int, --  TS_Match_Member A队伍的注册ID
                               F_DelegationID_A           int, -- TR_Register A队伍的代表团ID
                               F_DelegationShortName_A     nvarchar(100), -- TC_Delegation_Des A队伍的代表团名称
                               F_DelegationCode_A         NVARCHAR(10),
                               F_RegisterID_B             int, --  TS_Match_Member B队伍的注册ID
                               F_DelegationID_B           int, -- TR_Register B队伍的代表团ID
                               F_DelegationCode_B         NVARCHAR(10),
                               F_DelegationShortName_B    nvarchar(100), -- TC_Delegation_Des B队伍的代表团名称
                               F_RoundID                  INT,
                               F_Round					  nvarchar(100),
                               F_PhaseID                  int, -- TS_Phase F_PhaseID
                               F_FatherPhaseID			  int,
                               F_PhaseIsPool              INT,
                               F_PhaseLongName            nvarchar(100), -- TS_Phase_Des 一场特定的比赛属于某个特定的比赛流程的名称
                               F_MatchDate                DATETIME,
                               F_MatchStatus			  int,
                               F_VS_Result_A		      nvarchar(100),--双方的比赛结果A
                               F_VS_Result_B			  nvarchar(100),--双方的比赛结果B
                               F_VS_Result				  nvarchar(100),--双方的比赛结果 例7:6
                               F_VS_1T_A				  nvarchar(100),
                               F_VS_1T_B				  nvarchar(100),
                               F_VS_1T					  nvarchar(100),--第1节比分
                               F_VS_2T_A				  nvarchar(100),
                               F_VS_2T_B				  nvarchar(100),
                               F_VS_2T					  nvarchar(100),--第2节比分
                               F_VS_3T_A				  nvarchar(100),
                               F_VS_3T_B				  nvarchar(100),
                               F_VS_3T					  nvarchar(100),--第3节比分
                               F_VS_4T_A				  nvarchar(100),
                               F_VS_4T_B				  nvarchar(100),
                               F_VS_4T					  nvarchar(100),--第4节比分
                               F_VS_ET_A				  nvarchar(100),
                               F_VS_ET_B				  nvarchar(100),
                               F_VS_ET					  nvarchar(100) --加时比分
                              )
                         
    insert into #Temp_table(
                             F_EventID,
                             F_MatchID,
                             F_StartTime,
                             F_EndTime,
                             F_MatchNum,
                             F_VenueID,
                             F_VenueLongName,
                             F_CityLongName,
                             F_SessionTime,
                             F_RegisterID_A,
                             F_DelegationID_A,
                             F_DelegationShortName_A,
                             F_DelegationCode_A,
                             F_RegisterID_B,
                             F_DelegationID_B,
                             F_DelegationShortName_B,
                             F_DelegationCode_B,
                             F_RoundID,
                             F_Round,
                             F_PhaseID,
                             F_FatherPhaseID,
                             F_PhaseIsPool      ,
                             F_PhaseLongName,
                             F_MatchDate,
                             F_VS_Result_A,
                             F_VS_Result_B,
                             F_VS_Result,
                             F_MatchStatus
                            )
    select n.F_EventID,a.F_MatchID,LEFT(CONVERT (NVARCHAR(100), A.F_StartTime, 108), 5),
          LEFT(CONVERT (NVARCHAR(100), A.F_EndTime, 108), 5),a.F_MatchNum,a.F_VenueID,b.F_VenueLongName,
          d.F_CityLongName,e.F_SessionTime,f.F_RegisterID,g.F_DelegationID,
          h.F_DelegationShortName,TDA.F_DelegationCode,
          i.F_RegisterID,j.F_DelegationID,k.F_DelegationShortName, TDB.F_DelegationCode,R.F_RoundID,RD.F_RoundLongName,
          n.F_PhaseID,n.F_FatherPhaseID,n.F_PhaseIsPool,m.F_PhaseLongName, A.F_MatchDate,
          CASE WHEN a.F_MatchStatusID = 110 THEN CONVERT(NVARCHAR(100), f.F_Points) ELSE '' END,
          CASE WHEN a.F_MatchStatusID = 110 THEN CONVERT(NVARCHAR(100), i.F_Points) ELSE '' END,
          CASE WHEN a.F_MatchStatusID = 110 THEN CONVERT(NVARCHAR(100), f.F_Points) +' : '+CONVERT(NVARCHAR(100),i.F_Points) 
          ELSE '' END,
          a.F_MatchStatusID
    from TS_Match as a
    LEFT join TC_Venue_Des as b on a.F_VenueID=b.F_VenueID and b.F_LanguageCode=@LanguageCode
    LEFT join TC_Venue as c on a.F_VenueID=c.F_VenueID
    LEFT join TC_City_Des as d on c.F_CityID=d.F_CityID and d.F_LanguageCode=@LanguageCode
    LEFT join TS_Session as e on a.F_SessionID=e.F_SessionID
    LEFT join TS_Match_Result as f on a.F_MatchID=f.F_MatchID and f.F_CompetitionPosition=1 --比赛双方
    LEFT join TR_Register as g on f.F_RegisterID=g.F_RegisterID
    LEFT join TC_Delegation_Des as h on g.F_DelegationID=h.F_DelegationID and h.F_LanguageCode=@LanguageCode
    LEFT JOIN TC_Delegation AS TDA ON g.F_DelegationID = TDA.F_DelegationID
    LEFT join TS_Match_Result as i on a.F_MatchID=i.F_MatchID and i.F_CompetitionPosition=2 --比赛双方
    LEFT join TR_Register as j on i.F_RegisterID=j.F_RegisterID
    LEFT join TC_Delegation_Des as k on j.F_DelegationID=k.F_DelegationID and k.F_LanguageCode=@LanguageCode
    LEFT JOIN TC_Delegation AS TDB ON j.F_DelegationID = TDB.F_DelegationID
    LEFT join TS_Phase_Des as m on a.F_PhaseID=m.F_PhaseID and m.F_LanguageCode=@LanguageCode
    LEFT join TS_Phase as n on a.F_PhaseID=n.F_PhaseID
    LEFT join TS_Event as u on n.F_EventID=u.F_EventID
    LEFT join TS_Discipline as v on u.F_DisciplineID=v.F_DisciplineID
    LEFT JOIN TS_Round AS R ON R.F_RoundID = a.F_RoundID
    LEFT JOIN TS_Round_Des AS RD ON RD.F_RoundID = a.F_RoundID and rd.F_LanguageCode=@LanguageCode
    --where u.F_EventID=@EventID
 
     
    --delete from #Temp_table where F_RegisterID_A is null or F_RegisterID_B is null or F_RegisterID_A = -1 or F_RegisterID_B = -1

    IF @EventID is not null and @EventID <> -1
        delete from #Temp_table where F_EventID <> @EventID or F_EventID is null
      
    IF @DateID is not null and @DateID <> -1
        delete from #Temp_table where F_MatchDate <> (select f_date from TS_DisciplineDate where f_DisciplineDateid = @DateID)
        or F_MatchDate is null
    
    IF @MatchID is not null and @MatchID <> -1
        delete from #Temp_table where F_MatchID <> @MatchID or F_MatchID is null
    
    UPDATE #Temp_table SET F_PhaseLongName = C.F_PhaseLongName + ' ' + A.F_PhaseLongName 
         FROM #Temp_table AS A LEFT JOIN TS_Phase AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
         WHERE A.F_PhaseIsPool = 1
    
    
    UPDATe #Temp_Table SET F_DelegationCode_A = B.F_CompetitorSourceDes FROM #Temp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1 AND B.F_LanguageCode = @LanguageCode
                                         WHERE F_RegisterID_A IS NULL

    UPDATe #Temp_Table SET F_DelegationCode_B = B.F_CompetitorSourceDes FROM #Temp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2 AND B.F_LanguageCode = @LanguageCode
                                         WHERE F_RegisterID_B IS NULL
    
    
    
    DECLARE @DisciplineID INT
    
    SELECT @DisciplineID = TSD.F_DisciplineID FROM TS_Event AS TSE LEFT JOIN TS_Discipline AS TSD ON TSE.F_DisciplineID = TSD.F_DisciplineID WHERE TSE.F_EventID = @EventID
    
    DECLARE @TempMatchID AS INT
    DECLARE @1T_A AS NVARCHAR(100)
    DECLARE @1T_B AS NVARCHAR(100)
    DECLARE @1T   AS NVARCHAR(100)
    DECLARE @2T_A AS NVARCHAR(100)
    DECLARE @2T_B AS NVARCHAR(100)
    DECLARE @2T   AS NVARCHAR(100)
    DECLARE @3T_A AS NVARCHAR(100)
    DECLARE @3T_B AS NVARCHAR(100)
    DECLARE @3T   AS NVARCHAR(100)
    DECLARE @4T_A AS NVARCHAR(100)
    DECLARE @4T_B AS NVARCHAR(100)
    DECLARE @4T   AS NVARCHAR(100)
    DECLARE @ET_A AS NVARCHAR(100)
    DECLARE @ET_B AS NVARCHAR(100)
    DECLARE @ET   AS NVARCHAR(100)
    DECLARE Match_CURSOR CURSOR FOR 
	SELECT F_MatchID FROM #Temp_table WHERE F_MatchStatus = 110
	OPEN Match_CURSOR
	FETCH NEXT FROM Match_CURSOR INTO @TempMatchID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.[Proc_Report_BK_GetMatchResult] @TempMatchID,@1T_A OUTPUT,@1T_B OUTPUT,@1T OUTPUT,
		@2T_A OUTPUT,@2T_B OUTPUT,@2T OUTPUT,@3T_A OUTPUT,@3T_B OUTPUT,@3T OUTPUT,
		@4T_A OUTPUT,@4T_B OUTPUT,@4T OUTPUT,@ET_A OUTPUT,@ET_B OUTPUT,@ET OUTPUT
		UPDATE A SET A.F_VS_1T_A = @1T_A,A.F_VS_1T_B = @1T_B,A.F_VS_1T = @1T,
		A.F_VS_2T_A = @2T_A,A.F_VS_2T_B = @2T_B,A.F_VS_2T = @2T,
		A.F_VS_3T_A = @3T_A,A.F_VS_3T_B = @3T_B,A.F_VS_3T = @3T,
		A.F_VS_4T_A = @4T_A,A.F_VS_4T_B = @4T_B,A.F_VS_4T = @4T,
		A.F_VS_ET_A = @ET_A,A.F_VS_ET_B = @ET_B,A.F_VS_ET = @ET FROM #Temp_table AS A WHERE A.F_MatchID = @TempMatchID
		SELECT @1T_A = NULL,@1T_B = NULL,@1T = NULL,@2T_A = NULL,@2T_B = NULL,@2T = NULL,
		@3T_A = NULL,@3T_B = NULL,@3T = NULL,@4T_A = NULL,@4T_B = NULL,@4T = NULL,@ET_A = NULL,@ET_B = NULL,@ET = NULL
		FETCH NEXT FROM Match_CURSOR INTO @TempMatchID
	END
	CLOSE Match_CURSOR
	DEALLOCATE Match_CURSOR

    delete #Temp_Table where F_MatchNum > 100
    
    select F_MatchNum AS 'MatchNumber',F_Round as 'Round',
		   LEFT(CONVERT(NVARCHAR(100), F_MatchDate, 10),5) AS 'MatchDate',
		   REPLACE(CONVERT(NVARCHAR(100), F_MatchDate, 111),'/','-') AS 'MatchDate_YYYYMMDD',
		   F_StartTime as 'StartTime',F_EndTime as 'EndTime',
           F_DelegationShortName_A AS 'TeamA', F_DelegationShortName_B AS 'TeamB',F_PhaseLongName as 'Phase',F_VenueLongName as 'Venue', 
           F_VS_1T_A as 'VS1TA', F_VS_1T_B as 'VS1TB', F_VS_1T as 'VS1T', 
           F_VS_2T_A as 'VS2TA', F_VS_2T_B as 'VS2TB', F_VS_2T as 'VS2T',
           F_VS_3T_A as 'VS3TA', F_VS_3T_B as 'VS3TB', F_VS_3T as 'VS3T',
           F_VS_4T_A as 'VS4TA', F_VS_4T_B as 'VS4TB', F_VS_4T as 'VS4T', 
           F_VS_ET_A as 'VSETA', F_VS_ET_B as 'VSETB', F_VS_ET as 'VSET',
           F_VS_Result_A as 'VSFTA', F_VS_Result_B as 'VSFTB', F_VS_Result as 'VSFT'
    from #Temp_table
    order by case when F_MatchDate IS null then 1 else 0 END ,F_MatchDate,F_MatchNum
        
  set nocount off
end
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--exec [Proc_Report_BK_CompetitionSchedule] 135,'CHN'

--exec [Proc_Report_BK_CompetitionSchedule] 1,1,-1,'ENG'
