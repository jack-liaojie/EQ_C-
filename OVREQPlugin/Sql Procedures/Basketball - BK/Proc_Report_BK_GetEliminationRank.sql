IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEliminationRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetEliminationRank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--描    述：得到淘汰赛排名
--参数说明： 
--说    明：
--创 建 人：穆学峰
--日    期：2009年5月7日

CREATE Procedure [dbo].[Proc_Report_BK_GetEliminationRank](
				 @PhaseID		int,--对应类型的ID，与Type相关
                 @LanguageCode  char(3)
)
As
Begin
SET NOCOUNT ON 



create table #table_report
(
			Team1				nvarchar(100),
			Team2				nvarchar(100),
			Team3				nvarchar(100),
			Team4				nvarchar(100),
			Team5				nvarchar(100),
			Team6				nvarchar(100),
			Team7				nvarchar(100),
			Team8				nvarchar(100),
			Team9				nvarchar(100),
			Team10				nvarchar(100),
			Team11				nvarchar(100),
			Team12				nvarchar(100)
)

declare @team  as nvarchar(100)
declare @row as int
declare @eventid as int

set @row = 0

select @eventid = f_EventID from ts_phase where f_phaseID=@PhaseID

declare rank_cursor cursor for 
select A.F_EventRank as Rank, D.F_DelegationShortName as Team
from ts_event_Result as A 
left join tr_register_des as B on A.F_RegisterID = B.F_RegisterID 
left join tr_register as C on C.F_RegisterID = A.F_RegisterID
left join tc_Delegation_des as D on D.F_DelegationID = C.F_DelegationID
where  B.F_LanguageCode=@LanguageCode and A.F_EventID=@eventid
Order by A.F_EventDisplayPosition

--Proc_Report_GetEliminationRank 166,'CHN'
--select * from ts_event_result 
--select * from ts_phase where f_phaseID=166

open rank_cursor
fetch next from rank_cursor into @row, @team
insert  into #table_report(Team1) VALUES (Null)

While @@fetch_status = 0
begin
	if @row = 1 UPDATE #table_report set team1 = @team
	if @row = 2 UPDATE #table_report set team2 = @team
	if @row = 3 UPDATE #table_report set team3 = @team
	if @row = 4 UPDATE #table_report set team4 = @team
	if @row = 5 UPDATE #table_report set team5 = @team
	if @row = 6 UPDATE #table_report set team6 = @team
	if @row = 7 UPDATE #table_report set team7 = @team
	if @row = 8 UPDATE #table_report set team8 = @team
	if @row = 9 UPDATE #table_report set team9 = @team
	if @row = 10 UPDATE #table_report set team10 = @team
	if @row = 11 UPDATE #table_report set team11 = @team
	if @row = 12 UPDATE #table_report set team12 = @team
	
	fetch next from rank_cursor into @row, @team

end
close rank_cursor
deallocate rank_cursor

select * from #table_report

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




GO


