IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetDataForTS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetDataForTS]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetDataForTS]
--描    述: 获取Match状态
--创 建 人: 宁顺泽
--日    期: 2011年7月11日 星期1
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetDataForTS]
	@MatchID						INT,
	@currentID						int,---1,下场比赛，2---这场比赛
	@TSResult						nvarchar(100) OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	declare @sessionID int
	declare @courtID   int
	
	declare @name nvarchar(90)
	
	declare @racenum int 
	select @sessionID=s.F_SessionNumber,@courtID=isnull(m.F_CourtID,0),@racenum=convert(decimal,m.F_RaceNum) 
	from TS_Match as m
	LEFT JOIN TS_Session AS S
		ON S.F_SessionID=m.F_SessionID
	where m.F_MatchID=@MatchID
	
	if @currentID=1
	begin
		set @racenum=@racenum+1
	end
	
	declare @EventName nvarchar(10)
	
	
	select @EventName=RIGHT(ED.F_EventLongName,LEN(ED.F_EventLongName)-CHARINDEX(N'-',F_EventLongName)+1) 
			,@name=Da.F_DelegationCode+N'|'+RDA.F_SBShortName+N'|'+Db.F_DelegationCode+N'|'+RDB.F_SBShortName+N'|' 
	from TS_Match AS M
	LEFT JOIN TS_Phase as P
		on P.F_PhaseID=m.F_PhaseID
	LEFT JOIN TS_Event AS E
		ON E.F_EventID=P.F_EventID
	LEFT JOIN TS_Event_Des as ED 
		on eD.F_EventID= e.F_EventID AND ed.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=s.F_SessionID
	LEFT JOIN TS_Match_Result aS MRA
		ON m.F_MatchID=MRA.F_MatchID and MRA.F_CompetitionPosition=1
	LEFT JOIN TR_Register As RA
		ON MRA.F_RegisterID =Ra.F_RegisterID
	LEFT JOIN TR_Register_Des as RDA
		ON RDA.F_RegisterID=Ra.F_RegisterID and RDA.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation AS DA
		ON Da.F_DelegationID=RA.F_DelegationID
		
	LEFT JOIN TS_Match_Result aS MRB
		ON M.F_MatchID=MRB.F_MatchID and MRb.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS RB
		ON MRB.F_RegisterID=RB.F_RegisterID
	LEFT JOIN TR_Register_Des as RDB
		ON RDB.F_RegisterID=RB.F_RegisterID and RDB.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation AS DB
		ON DB.F_DelegationID=Rb.F_DelegationID
	where M.F_CourtID=@courtID and convert(nvarchar(10),@racenum)=m.F_RaceNum and S.F_SessionNumber=@sessionID
	
	if @name is NULL
	begin
		set @TSResult=N''
	end
	else 
	begin
		set @TSResult=CONVERT(nvarchar(10),@sessionID)+N'|'+CONVERT(nvarchar(10),@courtID)+N'|'+convert(nvarchar(10),@racenum)+N'|'+@EventName+N'|'+@name
	end
	

SET NOCOUNT OFF
END

/*

-- Just for test


*/