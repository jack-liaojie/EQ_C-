IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetSplit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetSplit]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_TVG_JU_GetSplit]
--描    述: 
--创 建 人: 宁顺泽
--日    期: 2011年06月1日 星期3
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetSplit]
(
	@MatchID			INT
)

		

AS
BEGIN
SET NOCOUNT ON

	Create table #table_temp
(
	SplitID			INT,
	SplitCode		NVARCHAR(10)
)	

	DECLARE @PlayerRegTypeID		INT
		
	SELECT @PlayerRegTypeID = E.F_PlayerRegTypeID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE M.F_MatchID = @MatchID


	

delete from #table_temp

insert into #table_temp values(1,N'Split 1')
insert into #table_temp values(2,N'Split 2')
insert into #table_temp values(3,N'Split 3')
insert into #table_temp values(4,N'Split 4')
insert into #table_temp values(5,N'Split 5')
--insert into #table_temp values(6,N'Split 6')


IF @PlayerRegTypeID <>3
BEGIN
	delete from #table_temp
END

select SplitCode,SplitID from #table_temp
		
SET NOCOUNT OFF
END


