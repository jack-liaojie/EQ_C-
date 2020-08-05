
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_CompetitionSchedule]    Script Date: 08/29/2012 08:30:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_CompetitionSchedule]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_CompetitionSchedule]    Script Date: 08/29/2012 08:30:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_WP_CompetitionSchedule]
----功		  能：得到足球项目下的全部竞赛日程
----作		  者：朱煜
----日		  期: 2010-03-20
  --1、	杨佳鹏	2011-1-28
  --	将大项ID换成小项的ID
  --2   翟广鹏 2011-03-02
  --    将对阵国家名字换成NOC
  --	杨佳鹏 2011-03-08
  --	增加字段长度，以防被截断
create procedure [dbo].[Proc_Report_HB_CompetitionSchedule]
( 
   @EventID int,
   @LanguageCode char(3)
)
as
begin
  set nocount on
   
  declare @rest_day nvarchar(100)
  if @LanguageCode = 'CHN' 
  begin
	set @rest_day = '休息日' 
	  set language English
  end
  
  if @LanguageCode = 'ENG' 
  begin
	set @rest_day = 'REST DAY'
	set language Chinese
  end
   

    create table #Temp_table(
                               F_MatchID                  int,  -- 比赛主键 TS_Match
                               F_StartTime                NVARCHAR(10), -- 开球时间 TS_Match
                               F_MatchNum                  INT, -- 比赛次序 TS_Match   
                               F_VenueID                  int, -- 比赛场馆ID                       
                               F_VenueLongName            nvarchar(100), -- 比赛场馆名称 TC_Venue_Des
                               F_CityLongName             nvarchar(100), -- 比赛场馆所属的城市名称 TC_City_Des
                               F_SessionTime              nvarchar(50), -- 比赛指定时间 TS_Session    
                               F_RegisterID_A             int, --  TS_Match_Member A队伍的注册ID
                               F_DelegationID_A           int, -- TR_Register A队伍的代表团ID
                               F_DelegationLongName_A     nvarchar(100), -- TC_Delegation_Des A队伍的代表团名称
                               F_DelegationCode_A         NVARCHAR(10),
                               F_RegisterID_B             int, --  TS_Match_Member B队伍的注册ID
                               F_DelegationID_B           int, -- TR_Register B队伍的代表团ID
                               F_DelegationCode_B         NVARCHAR(10),
                               F_DelegationLongName_B     nvarchar(100), -- TC_Delegation_Des B队伍的代表团名称
                               F_PhaseID                  int, -- TS_Phase F_PhaseID
                               F_PhaseLongName            nvarchar(100), -- TS_Phase_Des 一场特定的比赛属于某个特定的比赛流程的名称
                               F_MatchDate                DATETIME,
                               F_VS_Result				  nvarchar(100) --双方的比赛结果 例7:6
                              )
                         
    insert into #Temp_table(
                             F_MatchID,
                             F_StartTime,
                             F_MatchNum,
                             F_VenueID,
                             F_VenueLongName,
                             F_CityLongName,
                             F_SessionTime,
                             F_RegisterID_A,
                             F_DelegationID_A,
                             F_DelegationLongName_A,
                             F_DelegationCode_A,
                             F_RegisterID_B,
                             F_DelegationID_B,
                             F_DelegationLongName_B
                             ,F_DelegationCode_B,
                             F_PhaseID,
                             F_PhaseLongName,
                             F_MatchDate,
                             F_VS_Result
                            )
    select a.F_MatchID,LEFT(CONVERT (NVARCHAR(100), A.F_StartTime, 108), 5),a.F_MatchNum,a.F_VenueID,b.F_VenueLongName,
          d.F_CityLongName,e.F_SessionTime,f.F_RegisterID,g.F_DelegationID,
          h.F_DelegationLongName,TDA.F_DelegationCode,
          i.F_RegisterID,j.F_DelegationID,k.F_DelegationLongName, TDB.F_DelegationCode,
          n.F_PhaseID,m.F_PhaseLongName, A.F_MatchDate,CASE WHEN a.F_MatchStatusID = 110 THEN CONVERT(NVARCHAR(100), f.F_Points) +' : '+CONVERT(NVARCHAR(100),i.F_Points) ELSE '' END
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
    where u.F_EventID=@EventID
    
    
    UPDATe #Temp_Table SET F_DelegationCode_A = B.F_CompetitorSourceDes FROM #Temp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1 AND B.F_LanguageCode = @LanguageCode
                                         WHERE F_RegisterID_A IS NULL

    UPDATe #Temp_Table SET F_DelegationCode_B = B.F_CompetitorSourceDes FROM #Temp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2 AND B.F_LanguageCode = @LanguageCode
                                         WHERE F_RegisterID_B IS NULL
    
    
    
    DECLARE @DisciplineID INT
    
    SELECT @DisciplineID = TSD.F_DisciplineID FROM TS_Event AS TSE LEFT JOIN TS_Discipline AS TSD ON TSE.F_DisciplineID = TSD.F_DisciplineID WHERE TSE.F_EventID = @EventID
    
    insert into #Temp_table(
                             F_MatchDate,F_VenueLongName
                           )  
    select d.F_Date,
    @rest_day
    from TS_DisciplineDate as d
    where d.F_DisciplineID=@DisciplineID AND d.F_Date not in
    (select DISTINCT a.F_Date from TS_DisciplineDate as a 
     inner join TS_Match as c on a.F_Date=c.F_MatchDate INNER JOIN TS_Phase AS f ON c.F_PhaseID = f.F_PhaseID
     where a.F_DisciplineID=@DisciplineID  AND f.F_EventID = @EventID)
     AND d.F_Date < (select DISTINCT MAX(a.F_Date) from TS_DisciplineDate as a 
     inner join TS_Match as c on a.F_Date=c.F_MatchDate INNER JOIN TS_Phase AS f ON c.F_PhaseID = f.F_PhaseID
     where a.F_DisciplineID=@DisciplineID AND f.F_EventID = @EventID )
     AND d.F_Date>(select DISTINCT MIN(a.F_Date) from TS_DisciplineDate as a 
     inner join TS_Match as c on a.F_Date=c.F_MatchDate  INNER JOIN TS_Phase AS f ON c.F_PhaseID = f.F_PhaseID
     where a.F_DisciplineID=@DisciplineID  AND f.F_EventID = @EventID )
    
    
    select dbo.[Func_HB_GetChineseDate] ( F_MatchDate) as 'MatchDate',F_MatchNum AS 'MatchNumber',F_VenueLongName as 'Venue',F_StartTime as 'Kick-off',
           F_DelegationCode_A AS 'TeamA', F_DelegationCode_B AS 'TeamB',F_PhaseLongName as 'Phase',F_VS_Result AS 'Result'
    from #Temp_table
    order by case when F_MatchDate IS null then 1 else 0 END ,F_MatchDate,F_MatchNum
    
  set nocount off
end
SET ANSI_NULLS OFF

GO


