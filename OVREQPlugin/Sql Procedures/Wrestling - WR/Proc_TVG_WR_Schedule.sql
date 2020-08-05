IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_Schedule]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_TVG_WR_Schedule]
--描    述: 获取 Medallists 屏幕数据集 
--创 建 人: 宁顺泽
--日    期: 2011年2月25日 星期5
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_Schedule]
	@SessionID							INT
AS
BEGIN
SET NOCOUNT ON

	CREATE Table #Temp_Table
	(
		F_PhaseID int
	)
	insert into #Temp_Table(F_PhaseID)
		select F_PhaseID from 
			TS_Match AS M LEFT JOIN TC_Court AS C on C.F_CourtID =M.F_CourtID
			where F_SessionID=@SessionID and C.F_CourtCode=N'F26WR01'
		group by F_PhaseID
		
	CREATE TABLE #Temp_Tab
	(
			Name NVARCHAR(100),
			EventName NVARCHAR(100),
			Match_Order  int
	)
	
	insert into #Temp_Tab(Name,EventName,Match_Order)
	select ED.F_EventLongName+N' - '+PD.F_PhaseLongName,Ed.F_EventShortName,  
		case when CHARINDEX('Semifinal',Pd.F_PhaseLongName)<>0 OR CHARINDEX('Gold',Pd.F_PhaseLongName)<>0 OR CHARINDEX('Bronze',Pd.F_PhaseLongName)<>0 then ISNULL(p.F_Order,0)+400 
			else p.F_Order end
	From #Temp_Table AS temp
	LEFT JOIN TS_Phase AS P
		ON temp.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD 
		ON PD.F_PhaseID=P.F_PhaseID AND F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event_Des AS ED
		ON P.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
	ORDER BY ED.F_EventShortName

select Name from #Temp_Tab order by EventName DESC,Match_Order
	

SET NOCOUNT OFF
END

------------------
--exec [dbo].[Proc_TVG_JU_Schedule] 940
------------------------