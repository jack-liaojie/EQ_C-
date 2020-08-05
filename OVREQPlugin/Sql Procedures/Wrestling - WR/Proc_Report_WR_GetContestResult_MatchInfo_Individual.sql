IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetContestResult_MatchInfo_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetContestResult_MatchInfo_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetContestResult_MatchInfo_Individual]
--描    述: 获取一场比赛的裁判.
--创 建 人: 宁顺泽
--日    期: 2011年10月19日 星期3
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetContestResult_MatchInfo_Individual]
	@MatchID						INT,
	@LanguageCode					CHAR(3)=N'ENG'
AS
BEGIN
SET NOCOUNT ON

	select 
		RDa.F_PrintLongName as LongName_Red
		,RDb.F_PrintLongName AS LongName_Blue
		,DA.F_DelegationCode as Noc_Red
		,DB.F_DelegationCode as Noc_Blue
		,case when MRA.F_ResultID=1 then  RDa.F_PrintLongName+N'('+Da.F_DelegationCode+N')' 
			when MRB.F_ResultID =1 then RDb.F_PrintLongName+N'('+DB.F_DelegationCode+N')'
			else N'' end as Winner_Noc_Name
		,MRA.F_Points as PointsTotal_Red
		,MRB.F_Points as PointsTotal_Blue
		,case when isnull(MSIA1.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100), MSRA1.F_Points) end as PointsSplit1_Red
		,case when isnull(MSIA2.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRA2.F_Points) end  as PointsSplit2_Red
		,case when isnull(MSIA3.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRA3.F_Points) end as PointsSplit3_Red
		,case when isnull(MSIA1.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRB1.F_Points) end as PointsSplit1_Blue
		,case when isnull(MSIA2.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRB2.F_Points) end as PointsSplit2_Blue
		,case when isnull(MSIA3.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRB3.F_Points) end as PointsSplit3_Blue
		,MRA.F_PointsNumDes2 as ClassPts_Red
		,MRB.F_PointsNumDes2 as ClassPts_Blue
		,case when charindex(N'FREESTYLE',ED.F_EventLongName,0)>0 then N'2 minutes' else N'90"' end as StyleTime
		,case when MRA.F_PointsNumDes2=5 or MRB.F_PointsNumDes2=5 
					then case  when MRA.F_IRMID=3 OR MRB.F_IRMID=3 then N'EV 5:0' else N'TO 5:0' end
			when MRA.F_PointsNumDes2=4 OR MRB.F_PointsNumDes2=4
					then case when MRA.F_PointsNumDes2=0 OR MRB.F_PointsNumDes2=0 then N'ST 4:0' else N'SP 4:1' end
			when MRA.F_PointsNumDes2=3 OR MRB.F_PointsNumDes2=3
					then case when MRA.F_PointsNumDes2=0 OR MRB.F_PointsNumDes2=0 then N'PO 3:0' else N'PP 3:1' end 
			else N''
			end as ClassPoints
		,case when MRA.F_PointsNumDes2=5 or MRB.F_PointsNumDes2=5 
					then case  when MRA.F_IRMID=3 OR MRB.F_IRMID=3 then N'DISQUALIFICATION FROM ANY COMPETITION DUE TO INFRIGEMENT OF THE RULES' else N'VICTORY BY FALL - FORFEIT - INJURY - WITHDRWAL' end
			when MRA.F_PointsNumDes2=4 OR MRB.F_PointsNumDes2=4
					then case when MRA.F_PointsNumDes2=0 OR MRB.F_PointsNumDes2=0 then N'GREAT SUPERIORITY - A DIFFERENCE OF 6 POINTS.THE LOSER WITHOUT ANY POINTS' else N'VICTORY BY TECHNICAL SUPERIORITY WITH LOSER SCORING TECHNICAL POINTS' end
			when MRA.F_PointsNumDes2=3 OR MRB.F_PointsNumDes2=3
					then case when MRA.F_PointsNumDes2=0 OR MRB.F_PointsNumDes2=0 then N'DECISION BY POINTS - THE LOSER WITHOUT TECHNICAL POINTS' else N'DECISION BY POINTS - THE LOSER WITH TECHNICAL POINTS' end 
			else N''
			end as ClassPointsDesp
		,convert(nvarchar(10),EPA.F_EventPosition) as PosA
		,convert(nvarchar(10),EPB.F_EventPosition) as PosB
		,case when convert(nvarchar(10),isnull(MSRA1.F_PointsNumDes3,0))=N'0' then N'' else convert(nvarchar(10),MSRA1.F_PointsNumDes3) end as PointsAddtime1_red
		,case when convert(nvarchar(10),isnull(MSRA2.F_PointsNumDes3,0))=N'0' then N'' else convert(nvarchar(10),MSRA2.F_PointsNumDes3) end  as PointsAddtime2_red
		,case when convert(nvarchar(10),isnull(MSRA3.F_PointsNumDes3,0))=N'0' then N'' else convert(nvarchar(10),MSRA3.F_PointsNumDes3) end  as PointsAddtime3_red
		,case when convert(nvarchar(10),isnull(MSRB1.F_PointsNumDes3,0))=N'0' then N'' else convert(nvarchar(10),MSRB1.F_PointsNumDes3) end  as PointsAddtime1_blue
		,case when convert(nvarchar(10),isnull(MSRB2.F_PointsNumDes3,0))=N'0' then N'' else convert(nvarchar(10),MSRB2.F_PointsNumDes3) end  as PointsAddtime2_blue
		,case when convert(nvarchar(10),isnull(MSRB3.F_PointsNumDes3,0))=N'0' then N'' else convert(nvarchar(10),MSRB3.F_PointsNumDes3) end  as PointsAddtime3_blue
		,case when isnull(MSIA1.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRA1.F_Points+isnull(MSRA1.F_PointsNumDes3,0)) end as PointsSplitTotal1_red
		,case when isnull(MSIA2.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRA2.F_Points+isnull(MSRA2.F_PointsNumDes3,0)) end as PointsSplitTotal2_red
		,case when isnull(MSIA3.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRA3.F_Points+isnull(MSRA3.F_PointsNumDes3,0)) end as PointsSplitTotal3_red
		,case when isnull(MSIA1.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRB1.F_Points+isnull(MSRB1.F_PointsNumDes3,0)) end  as PointsSplitTotal1_blue
		,case when isnull(MSIA2.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRB2.F_Points+isnull(MSRB2.F_PointsNumDes3,0)) end as PointsSplitTotal2_blue
		,case when isnull(MSIA3.F_MatchSplitStatusID,0)<100 then N'' else convert(nvarchar(100),MSRB3.F_Points+isnull(MSRB3.F_PointsNumDes3,0)) end as PointsSplitTotal3_blue
	from TS_Match as M
	LEFT JOIN TS_Phase aS P
		ON P.F_PhaseID =m.F_PhaseID
	LEFT JOIN TS_Event as E
		ON P.F_EventID=E.F_EventID
	LEFT JOIN TS_Event_Des as ED 
		ON ED.F_EventID=E.F_EventID and Ed.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Match_Result aS MRA
		ON M.F_MatchID=MRA.F_MatchID and MRA.F_CompetitionPosition=1
	LEFT JOIN TR_Register AS RA
		ON RA.F_RegisterID=MRA.F_RegisterID
	LEFT JOIN TR_Register_Des as RDa
		ON RDa.F_RegisterID=Ra.F_RegisterID and RDA.F_LanguageCode=@LanguageCode
	LEFT JOIN TC_Delegation aS DA
		ON DA.F_DelegationID=RA.F_DelegationID
	LEFT JOIN TS_Match_Split_Result AS MSRA1
		ON MRA.F_MatchID=MSRA1.F_MatchID and MSRA1.F_CompetitionPosition=MRA.F_CompetitionPosition And MSRA1.F_MatchSplitID=1
	LEFT JOIN TS_Match_Split_Info as MSIA1
		ON MSIA1.F_MatchID=MSRA1.F_MatchID and MSIA1.F_MatchSplitID=1
	LEFT JOIN TS_Match_Split_Result AS MSRA2
		ON MRA.F_MatchID=MSRA2.F_MatchID and MSRA2.F_CompetitionPosition=MRA.F_CompetitionPosition And MSRA2.F_MatchSplitID=2
	LEFT JOIN TS_Match_Split_Info aS MSIA2
		ON MSIA2.F_MatchID=MSRA2.F_MatchID and MSIA2.F_MatchSplitID=2
	LEFT JOIN TS_Match_Split_Info as MSIA3
		ON MRA.F_MatchID=MSIA3.F_MatchID and MSIA3.F_MatchSplitID=3 and MSIA3.F_MatchSplitStatusID>99
	LEFT JOIN TS_Match_Split_Result AS MSRA3
		ON MSIA3.F_MatchID=MSRA3.F_MatchID and MSRA3.F_CompetitionPosition=1 and MSRA3.F_MatchSplitID=MSIA3.F_MatchSplitID
	LEFT JOIN TS_Event_Position AS EPA
		ON E.F_EventID=EPa.F_EventID and EPa.F_RegisterID=MRA.F_RegisterID and EPA.F_RegisterID<>-1
		
	LEFT JOIN TS_Match_Result AS MRB
		ON M.F_MatchID=MRB.F_MatchID and MRB.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS RB
		ON RB.F_RegisterID=MRB.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDb
		ON RDb.F_RegisterID=Rb.F_RegisterID and RDb.F_LanguageCode=@LanguageCode
	LEFT JOIN TC_Delegation aS DB
		ON DB.F_DelegationID=RB.F_DelegationID
	LEFT JOIN TS_Match_Split_Result AS MSRB1
		ON MRB.F_MatchID=MSRB1.F_MatchID and MSRB1.F_CompetitionPosition=MRB.F_CompetitionPosition And MSRB1.F_MatchSplitID=1
	LEFT JOIN TS_Match_Split_Result AS MSRB2
		ON MRB.F_MatchID=MSRB2.F_MatchID and MSRB2.F_CompetitionPosition=MRB.F_CompetitionPosition And MSRB2.F_MatchSplitID=2
	LEFt JOIN TS_Match_Split_Info as MSIB3
		ON MRB.F_MatchID=MSIB3.F_MatchID and MSIB3.F_MatchSplitID=3 and MSIB3.F_MatchSplitStatusID>99
	LEFT JOIN TS_Match_Split_Result AS MSRB3
		ON MSIB3.F_MatchID=MSRB3.F_MatchID and MSRB3.F_CompetitionPosition=2 And MSRB3.F_MatchSplitID=MSIB3.F_MatchSplitID
	LEFT JOIN TS_Event_Position aS EPB
		ON E.F_EventID=EPB.F_EventID and EPb.F_RegisterID=MRB.F_RegisterID and EPb.F_RegisterID<>-1
	
	where M.F_MatchID=@MatchID and m.F_MatchStatusID>99

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_WR_GetMatchServant] 2, 'ENG'

*/