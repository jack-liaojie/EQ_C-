
/****** Object:  StoredProcedure [dbo].[Proc_Report_TE_GetEliminationRank]    Script Date: 06/14/2011 08:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetEliminationRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetEliminationRank]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_TE_GetEliminationRank]    Script Date: 06/14/2011 08:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--描    述：得到淘汰赛排名
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年6月14日

CREATE Procedure [dbo].[Proc_Report_TE_GetEliminationRank](
				 @EventID		int,--对应类型的ID，与Type相关
                 @LanguageCode  char(3)
)
As
Begin
SET NOCOUNT ON 



create table #table_report
(
			Player1				nvarchar(100),
			Player2				nvarchar(100),
			Player3				nvarchar(100),
			Player4				nvarchar(100),
			Player5				nvarchar(100),
			Player6				nvarchar(100),
			Player7				nvarchar(100),
			Player8				nvarchar(100),
			Team1				nvarchar(100),
			Team2				nvarchar(100),
			Team3				nvarchar(100),
			Team4				nvarchar(100),
			Team5				nvarchar(100),
			Team6				nvarchar(100),
			Team7				nvarchar(100),
			Team8				nvarchar(100)
)

declare @player as nvarchar(100)
declare @team  as nvarchar(100)
declare @row as int

set @row = 0


declare rank_cursor cursor for 
select A.F_EventRank as Rank, B.F_PrintShortName as Player, D.F_DelegationLongName as Team
from ts_event_Result as A 
left join tr_register_des as B on A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode=@LanguageCode
left join tr_register as C on C.F_RegisterID = A.F_RegisterID
left join tc_delegation_des as D on D.F_DelegationID = C.F_DelegationID AND D.F_LanguageCode = @LanguageCode
where A.F_EventID=@eventid
Order by A.F_EventDisplayPosition

--Proc_Report_GetEliminationRank 166,'CHN'
--select * from ts_event_result 
--select * from ts_phase where f_phaseID=166

open rank_cursor
fetch next from rank_cursor into @row, @player, @team
insert  into #table_report(Player1) VALUES (Null)

While @@fetch_status = 0
begin
	if @row = 1 UPDATE #table_report set player1 = @player, team1 = @team
	if @row = 2 UPDATE #table_report set player2 = @player, team2 = @team
	if @row = 3 UPDATE #table_report set player3 = @player, team3 = @team
	if @row = 4 UPDATE #table_report set player4 = @player, team4 = @team
	if @row = 5 UPDATE #table_report set player5 = @player, team5 = @team
	if @row = 6 UPDATE #table_report set player6 = @player, team6 = @team
	if @row = 7 UPDATE #table_report set player7 = @player, team7 = @team
	if @row = 8 UPDATE #table_report set player8 = @player, team8 = @team
	
	fetch next from rank_cursor into @row, @player, @team

end
close rank_cursor
deallocate rank_cursor

select * from #table_report

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




GO


