IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchMessage]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_GetMatchMessage]
--描    述: 柔道获取每场比赛的对阵信息
--创 建 人: 宁顺泽
--日    期: 2011年6月14日 星期二
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchMessage]
	@SessionNumber					INT,
	@CourtCode						NVARCHAR(20),
	@MatchType						INT,
	@Result							NVARCHAR(MAX) output
AS
BEGIN
SET NOCOUNT ON
	create TABLE #Tamp_Table
	(
		MatchID					INT,
		Session					NVARCHAR(MAX),
		Court					NVARCHAR(MAX),
		MatchNo					NVARCHAR(MAX),
		MatchTime				NVARCHAR(MAX),
		Weight					NVARCHAR(MAX),
		BlueNocCode				NVARCHAR(MAX),
		BlueCountryEN			NVARCHAR(MAX),
		BlueCountryCH			NVARCHAR(MAX),
		BlueLongNameEN			NVARCHAR(MAX),
		BlueShortNameEN			NVARCHAR(MAX),
		BlueLongNameCH			NVARCHAR(MAX),
		BlueShortNameCH			NVARCHAR(MAX),
		WhiteNocCode			NVARCHAR(MAX),
		WhiteCountryEN			NVARCHAR(MAX),
		WhiteCountryCH			NVARCHAR(MAX),
		WhiteLongNameEN			NVARCHAR(MAX),
		WhiteShortNameEN		NVARCHAR(MAX),
		WhiteLongNameCH			NVARCHAR(MAX),
		WhiteShortNameCH		NVARCHAR(MAX),
		MatchType				NVARCHAR(MAX),
		GroupGameNo				NVARCHAR(MAX),
		BlueGroupScore			NVARCHAR(MAX),
		WhiteGroupScore			NVARCHAR(MAX),
		NotMatch				NVARCHAR(MAX)
	)

	DECLARE @MessageProperty		NVARCHAR(MAX)
	DECLARE @Content				NVARCHAR(MAX)
	DECLARE @OutputXML				NVARCHAR(MAX)
	
	
	if(@MatchType=1)
	begin
	insert into #Tamp_Table (MatchID,Session,Court,MatchNo,MatchTime,Weight,BlueNocCode,BlueCountryEN,BlueCountryCH,BlueLongNameEN,BlueShortNameEN,
							BlueLongNameCH,BlueShortNameCH,WhiteNocCode,WhiteCountryEN,WhiteCountryCH,WhiteLongNameEN,WhiteShortNameEN,WhiteLongNameCH,
							WhiteShortNameCH,MatchType,GroupGameNo,BlueGroupScore,WhiteGroupScore,NotMatch)
	(select
		 M.F_MatchID
		,case when S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber) else CONVERT(NVARCHAR(10),S.F_SessionNumber) end  AS Session
		,RIGHT(CD.F_CourtShortName,1) as Court
		,M.F_RaceNum AS MatchNo
		,[dbo].[Func_Report_JU_GetDateTime](M.F_MatchDate,7,N'ENG')+N' '+[dbo].[Func_Report_JU_GetDateTime](M.F_StartTime,4,N'ENG') as MatchTime
		,ED.F_EventShortName+N','+PD.F_PhaseLongName AS Weight
		,ISNULL(D1.F_DelegationCode,N'') AS BlueNocCode
		,ISNULL(DD1.F_DelegationLongName,N'') AS BlueCountryEN
		,ISNULL(DD1_CHN.F_DelegationLongName,N'') AS BlueCountryCH
		,ISNULL(RD1.F_LongName,N'') aS BlueLongNameEN 
		,ISNULL(RD1.F_ShortName,N'') AS BlueShortNameEN
		,ISNULL(Rd1_CHN.F_LongName,N'') AS BlueLongNameCH
		,ISNULL(Rd1_CHN.F_ShortName,N'') AS BlueShortNameCH		
		,ISNULL(D2.F_DelegationCode,N'') AS WhiteNocCode
		,ISNULL(DD2.F_DelegationLongName,N'') AS WhiteCountryEN
		,ISNULL(DD2_CHN.F_DelegationLongName,N'') AS WhiteCountryCH
		,ISNULL(RD2.F_LongName,N'') AS WhiteLongNameEN
		,ISNULL(RD2.F_ShortName,N'') AS WhiteShortNameEN
		,ISNULL(Rd2_CHN.F_LongName,N'') AS WhiteLongNameCH 
		,ISNULL(Rd2_CHN.F_ShortName,N'') AS WhiteShortNameCH
		,N'1' as MatchType
		,N'0' as GroupGameNo
		,N'-1' AS BlueGroupScore
		,N'-1' as WhiteGroupScore
		,case when ISNULL(MR1.F_RegisterID,N'-1')=N'-1' then N'1' 
			when ISNULL(MR2.F_RegisterID,N'-1')=N'-1' then N'1'
			else N'0' end AS NotMatch
	from TS_Match AS M
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	LEFT JOIN TC_Court_Des AS CD 
		ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFt JOIN TS_Event_Des AS ED 
		ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Match_Result AS MR1
		ON M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPositionDes1=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID =R1.F_RegisterID 
	LEFT JOIN TR_Register_Des aS RD1 
		ON R1.F_RegisterID=RD1.F_RegisterID aND RD1.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des AS Rd1_CHN
		ON R1.F_RegisterID=Rd1_CHN.F_RegisterID AND Rd1_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD1
		ON DD1.F_DelegationID=D1.F_DelegationID AND DD1.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des AS DD1_CHN
		ON DD1_CHN.F_DelegationID=D1.F_DelegationID AND DD1_CHN.F_LanguageCode=N'CHN'
		
	LEFT JOIN TS_Match_Result AS MR2
		ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPositionDes1=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID =R2.F_RegisterID
	LEFt JOIN TR_Register_Des AS RD2
		ON RD2.F_RegisterID=R2.F_RegisterID AND RD2.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des AS Rd2_CHN
		ON Rd2_CHN.F_RegisterID=R2.F_RegisterID and Rd2_CHN.F_LanguageCode=N'CHN'
	LEFt JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFt JOIN TC_Delegation_Des AS DD2
		ON D2.F_DelegationID=DD2.F_DelegationID AND DD2.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des AS DD2_CHN
		ON D2.F_DelegationID=DD2_CHN.F_DelegationID AND DD2_CHN.F_LanguageCode=N'CHN'
	
	where E.F_PlayerRegTypeID=1 AND S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode AND (ISNULL(MR1.F_RegisterID,N'-1')<>N'-1' OR ISNULL(MR2.F_RegisterID,N'-1')<>N'-1'))	
	END		
	else
	begin
	insert into #Tamp_Table (MatchID,Session,Court,MatchNo,MatchTime,Weight,BlueNocCode,BlueCountryEN,BlueCountryCH,BlueLongNameEN,BlueShortNameEN,
							BlueLongNameCH,BlueShortNameCH,WhiteNocCode,WhiteCountryEN,WhiteCountryCH,WhiteLongNameEN,WhiteShortNameEN,WhiteLongNameCH,
							WhiteShortNameCH,MatchType,GroupGameNo,BlueGroupScore,WhiteGroupScore,NotMatch)
	(
		select 
		M.F_MatchID
		,case when S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber) else CONVERT(NVARCHAR(10),S.F_SessionNumber) end  AS Session
		,RIGHT(CD.F_CourtShortName,1) as Court
		,M.F_RaceNum as MatchNo
		,[dbo].[Func_Report_JU_GetDateTime](M.F_MatchDate,7,N'ENG')+N' '+[dbo].[Func_Report_JU_GetDateTime](M.F_StartTime,4,N'ENG') as MatchTime
		,ED.F_EventShortName+N','+PD.F_PhaseLongName+N','+ISNULL(MSI.F_Memo,N'') AS Weight
		,ISNULL(D1.F_DelegationCode,N'') AS BlueNocCode
		,ISNULL(DD1_ENG.F_DelegationLongName,N'') AS BlueCountryEN
		,ISNULL(DD1_CHN.F_DelegationLongName,N'') as BlueCountryCH
		,ISNULL(RDA1_ENG.F_LongName,N'') as BlueLongNameEN
		,ISNULL(RDA1_ENG.F_ShortName,N'') as BlueShortNameEN
		,ISNULL(RDA1_CHN.F_LongName,N'') AS BlueLongNameCH
		,ISNULL(RDA1_CHN.F_ShortName,N'') as BlueShortNameCH
		,ISNULL(D2.F_DelegationCode,N'') AS WhiteNocCode
		,ISNULL(DD2_ENG.F_DelegationLongName,N'') AS WhiteCountryEN
		,ISNULL(DD2_CHN.F_DelegationLongName,N'') as WhiteCountryCH
		,ISNULL(RDA2_ENG.F_LongName,N'') as WhiteLongNameEN
		,ISNULL(RDA2_ENG.F_ShortName,N'') as WhiteShortNameEN
		,ISNULL(RDA2_CHN.F_LongName,N'') as WhiteLongNameCH
		,ISNULL(RDA2_CHN.F_ShortName,N'') as WhiteShortNameCH
		,2 as MatchType
		,MSR1.F_MatchSplitID AS GroupGameno
		,ISNULL(MR1.F_WinSets,0) AS BlueGroupScore
		,ISNULL(MR2.F_WinSets,0) as WhitegroupScore
		,case when ISNULL(MSR1.F_RegisterID,N'-1')=N'-1' then N'1' 
			when ISNULL(MSR2.F_RegisterID,N'-1')=N'-1' then N'1'
			else  N'0' end as NotMatch
	from TS_Match as M
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	LEFT JOIN TC_Court_Des AS CD 
		ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFt JOIN TS_Event_Des AS ED 
		ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
		
	LEFT JOIN TS_Match_Result AS MR1
		ON MR1.F_MatchID=M.F_MatchID AND MR1.F_CompetitionPositionDes1=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD1_ENG
		ON DD1_ENG.F_DelegationID=D1.F_DelegationID aND DD1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD1_CHN
		ON DD1_CHN.F_DelegationID=D1.F_DelegationID and DD1_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TS_Match_Split_Result AS MSR1
		ON MSR1.F_MatchID=MR1.F_MatchID aND MSR1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR1.F_MatchSplitID=1
	LEFT JOIN TR_Register AS RA1
		ON RA1.F_RegisterID=MSR1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA1_ENG
		ON RA1.F_RegisterID=RDA1_ENG.F_RegisterID and RDA1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA1_CHN
		ON RA1.F_RegisterID=RDA1_CHN.F_RegisterID and RDA1_CHN.F_LanguageCode=N'CHN'
	LEft JOIN TS_Match_Split_Info as MSI
		ON MSR1.F_MatchID=MSI.F_MatchID AND MSI.F_MatchSplitID=MSR1.F_MatchSplitID
		
	LEFT JOIN TS_Match_Result AS MR2
		ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPositionDes1=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD2_ENG
		ON DD2_ENG.F_DelegationID=D2.F_DelegationID aND DD2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD2_CHN
		ON DD2_CHN.F_DelegationID=D2.F_DelegationID and DD2_CHN.F_LanguageCode=N'CHN'
	
	LEFT JOIN TS_Match_Split_Result AS MSR2
		ON MSR2.F_MatchID=MR2.F_MatchID aND MSR2.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR2.F_MatchSplitID=1
	LEFT JOIN TR_Register AS RA2
		ON RA2.F_RegisterID=MSR2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA2_ENG
		ON RA2.F_RegisterID=RDA2_ENG.F_RegisterID and RDA2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA2_CHN
		ON RA2.F_RegisterID=RDA2_CHN.F_RegisterID and RDA2_CHN.F_LanguageCode=N'CHN'
		
	where E.F_PlayerRegTypeID=3 AND S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode and (ISNULL(MSR1.F_RegisterID,N'-1')<>N'-1' OR ISNULL(MSR2.F_RegisterID,N'-1')<>N'-1')
	)
	
	insert into #Tamp_Table (MatchID,Session,Court,MatchNo,MatchTime,Weight,BlueNocCode,BlueCountryEN,BlueCountryCH,BlueLongNameEN,BlueShortNameEN,
							BlueLongNameCH,BlueShortNameCH,WhiteNocCode,WhiteCountryEN,WhiteCountryCH,WhiteLongNameEN,WhiteShortNameEN,WhiteLongNameCH,
							WhiteShortNameCH,MatchType,GroupGameNo,BlueGroupScore,WhiteGroupScore,NotMatch)
	(
		select 
		M.F_MatchID
		,case when S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber) else CONVERT(NVARCHAR(10),S.F_SessionNumber) end  AS Session
		,RIGHT(CD.F_CourtShortName,1) as Court
		,M.F_RaceNum as MatchNo
		,[dbo].[Func_Report_JU_GetDateTime](M.F_MatchDate,7,N'ENG')+N' '+[dbo].[Func_Report_JU_GetDateTime](M.F_StartTime,4,N'ENG') as MatchTime
		,ED.F_EventShortName+N','+PD.F_PhaseLongName+N','+ISNULL(MSI.F_Memo,N'') AS Weight
		,ISNULL(D1.F_DelegationCode,N'') AS BlueNocCode
		,ISNULL(DD1_ENG.F_DelegationLongName,N'') AS BlueCountryEN
		,ISNULL(DD1_CHN.F_DelegationLongName,N'') as BlueCountryCH
		,ISNULL(RDA1_ENG.F_LongName,N'') as BlueLongNameEN
		,ISNULL(RDA1_ENG.F_ShortName,N'') as BlueShortNameEN
		,ISNULL(RDA1_CHN.F_LongName,N'') AS BlueLongNameCH
		,ISNULL(RDA1_CHN.F_ShortName,N'') as BlueShortNameCH
		,ISNULL(D2.F_DelegationCode,N'') AS WhiteNocCode
		,ISNULL(DD2_ENG.F_DelegationLongName,N'') AS WhiteCountryEN
		,ISNULL(DD2_CHN.F_DelegationLongName,N'') as WhiteCountryCH
		,ISNULL(RDA2_ENG.F_LongName,N'') as WhiteLongNameEN
		,ISNULL(RDA2_ENG.F_ShortName,N'') as WhiteShortNameEN
		,ISNULL(RDA2_CHN.F_LongName,N'') as WhiteLongNameCH
		,ISNULL(RDA2_CHN.F_ShortName,N'') as WhiteShortNameCH
		,2 as MatchType
		,MSR1.F_MatchSplitID AS GroupGameno
		,ISNULL(MR1.F_WinSets,0) AS BlueGroupScore
		,ISNULL(MR2.F_WinSets,0) as WhitegroupScore
		,case when ISNULL(MSR1.F_RegisterID,N'-1')=N'-1' then N'1' 
			when ISNULL(MSR2.F_RegisterID,N'-1')=N'-1' then N'1'
			else  N'0' end as NotMatch
	from TS_Match as M
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	LEFT JOIN TC_Court_Des AS CD 
		ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG' 
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFt JOIN TS_Event_Des AS ED 
		ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
		
	LEFT JOIN TS_Match_Result AS MR1
		ON MR1.F_MatchID=M.F_MatchID AND MR1.F_CompetitionPositionDes1=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD1_ENG
		ON DD1_ENG.F_DelegationID=D1.F_DelegationID aND DD1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD1_CHN
		ON DD1_CHN.F_DelegationID=D1.F_DelegationID and DD1_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TS_Match_Split_Result AS MSR1
		ON MSR1.F_MatchID=MR1.F_MatchID aND MSR1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR1.F_MatchSplitID=2
	LEFT JOIN TR_Register AS RA1
		ON RA1.F_RegisterID=MSR1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA1_ENG
		ON RA1.F_RegisterID=RDA1_ENG.F_RegisterID and RDA1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA1_CHN
		ON RA1.F_RegisterID=RDA1_CHN.F_RegisterID and RDA1_CHN.F_LanguageCode=N'CHN'
	LEft JOIN TS_Match_Split_Info as MSI
		ON MSR1.F_MatchID=MSI.F_MatchID AND MSI.F_MatchSplitID=MSR1.F_MatchSplitID
		
	LEFT JOIN TS_Match_Result AS MR2
		ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPositionDes1=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD2_ENG
		ON DD2_ENG.F_DelegationID=D2.F_DelegationID aND DD2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD2_CHN
		ON DD2_CHN.F_DelegationID=D2.F_DelegationID and DD2_CHN.F_LanguageCode=N'CHN'
	
	LEFT JOIN TS_Match_Split_Result AS MSR2
		ON MSR2.F_MatchID=MR2.F_MatchID aND MSR2.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR2.F_MatchSplitID=2
	LEFT JOIN TR_Register AS RA2
		ON RA2.F_RegisterID=MSR2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA2_ENG
		ON RA2.F_RegisterID=RDA2_ENG.F_RegisterID and RDA2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA2_CHN
		ON RA2.F_RegisterID=RDA2_CHN.F_RegisterID and RDA2_CHN.F_LanguageCode=N'CHN'
		
	where E.F_PlayerRegTypeID=3 AND S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode  and (ISNULL(MSR1.F_RegisterID,N'-1')<>N'-1' OR ISNULL(MSR2.F_RegisterID,N'-1')<>N'-1')
	)
	
	insert into #Tamp_Table (MatchID,Session,Court,MatchNo,MatchTime,Weight,BlueNocCode,BlueCountryEN,BlueCountryCH,BlueLongNameEN,BlueShortNameEN,
							BlueLongNameCH,BlueShortNameCH,WhiteNocCode,WhiteCountryEN,WhiteCountryCH,WhiteLongNameEN,WhiteShortNameEN,WhiteLongNameCH,
							WhiteShortNameCH,MatchType,GroupGameNo,BlueGroupScore,WhiteGroupScore,NotMatch)
	(
		select 
		M.F_MatchID
		,case when S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber) else CONVERT(NVARCHAR(10),S.F_SessionNumber) end  AS Session
		,RIGHT(CD.F_CourtShortName,1) as Court
		,M.F_RaceNum as MatchNo
		,[dbo].[Func_Report_JU_GetDateTime](M.F_MatchDate,7,N'ENG')+N' '+[dbo].[Func_Report_JU_GetDateTime](M.F_StartTime,4,N'ENG') as MatchTime
		,ED.F_EventShortName+N','+PD.F_PhaseLongName+N','+ISNULL(MSI.F_Memo,N'') AS Weight
		,ISNULL(D1.F_DelegationCode,N'') AS BlueNocCode
		,ISNULL(DD1_ENG.F_DelegationLongName,N'') AS BlueCountryEN
		,ISNULL(DD1_CHN.F_DelegationLongName,N'') as BlueCountryCH
		,ISNULL(RDA1_ENG.F_LongName,N'') as BlueLongNameEN
		,ISNULL(RDA1_ENG.F_ShortName,N'') as BlueShortNameEN
		,ISNULL(RDA1_CHN.F_LongName,N'') AS BlueLongNameCH
		,ISNULL(RDA1_CHN.F_ShortName,N'') as BlueShortNameCH
		,ISNULL(D2.F_DelegationCode,N'') AS WhiteNocCode
		,ISNULL(DD2_ENG.F_DelegationLongName,N'') AS WhiteCountryEN
		,ISNULL(DD2_CHN.F_DelegationLongName,N'') as WhiteCountryCH
		,ISNULL(RDA2_ENG.F_LongName,N'') as WhiteLongNameEN
		,ISNULL(RDA2_ENG.F_ShortName,N'') as WhiteShortNameEN
		,ISNULL(RDA2_CHN.F_LongName,N'') as WhiteLongNameCH
		,ISNULL(RDA2_CHN.F_ShortName,N'') as WhiteShortNameCH
		,2 as MatchType
		,MSR1.F_MatchSplitID AS GroupGameno
		,ISNULL(MR1.F_WinSets,0) AS BlueGroupScore
		,ISNULL(MR2.F_WinSets,0) as WhitegroupScore
		,case when ISNULL(MSR1.F_RegisterID,N'-1')=N'-1' then N'1' 
			when ISNULL(MSR2.F_RegisterID,N'-1')=N'-1' then N'1'
			else  N'0' end as NotMatch
	from TS_Match as M
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	LEFT JOIN TC_Court_Des AS CD 
		ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFt JOIN TS_Event_Des AS ED 
		ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
		
	LEFT JOIN TS_Match_Result AS MR1
		ON MR1.F_MatchID=M.F_MatchID AND MR1.F_CompetitionPositionDes1=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD1_ENG
		ON DD1_ENG.F_DelegationID=D1.F_DelegationID aND DD1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD1_CHN
		ON DD1_CHN.F_DelegationID=D1.F_DelegationID and DD1_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TS_Match_Split_Result AS MSR1
		ON MSR1.F_MatchID=MR1.F_MatchID aND MSR1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR1.F_MatchSplitID=3
	LEFT JOIN TR_Register AS RA1
		ON RA1.F_RegisterID=MSR1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA1_ENG
		ON RA1.F_RegisterID=RDA1_ENG.F_RegisterID and RDA1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA1_CHN
		ON RA1.F_RegisterID=RDA1_CHN.F_RegisterID and RDA1_CHN.F_LanguageCode=N'CHN'
	LEft JOIN TS_Match_Split_Info as MSI
		ON MSR1.F_MatchID=MSI.F_MatchID AND MSI.F_MatchSplitID=MSR1.F_MatchSplitID
		
	LEFT JOIN TS_Match_Result AS MR2
		ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPositionDes1=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD2_ENG
		ON DD2_ENG.F_DelegationID=D2.F_DelegationID aND DD2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD2_CHN
		ON DD2_CHN.F_DelegationID=D2.F_DelegationID and DD2_CHN.F_LanguageCode=N'CHN'
	
	LEFT JOIN TS_Match_Split_Result AS MSR2
		ON MSR2.F_MatchID=MR2.F_MatchID aND MSR2.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR2.F_MatchSplitID=3
	LEFT JOIN TR_Register AS RA2
		ON RA2.F_RegisterID=MSR2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA2_ENG
		ON RA2.F_RegisterID=RDA2_ENG.F_RegisterID and RDA2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA2_CHN
		ON RA2.F_RegisterID=RDA2_CHN.F_RegisterID and RDA2_CHN.F_LanguageCode=N'CHN'
		
	where E.F_PlayerRegTypeID=3 AND S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode  and (ISNULL(MSR1.F_RegisterID,N'-1')<>N'-1' OR ISNULL(MSR2.F_RegisterID,N'-1')<>N'-1')
	)
		
	insert into #Tamp_Table (MatchID,Session,Court,MatchNo,MatchTime,Weight,BlueNocCode,BlueCountryEN,BlueCountryCH,BlueLongNameEN,BlueShortNameEN,
							BlueLongNameCH,BlueShortNameCH,WhiteNocCode,WhiteCountryEN,WhiteCountryCH,WhiteLongNameEN,WhiteShortNameEN,WhiteLongNameCH,
							WhiteShortNameCH,MatchType,GroupGameNo,BlueGroupScore,WhiteGroupScore,NotMatch)
	(
		select 
		M.F_MatchID
		,case when S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber) else CONVERT(NVARCHAR(10),S.F_SessionNumber) end  AS Session
		,RIGHT(CD.F_CourtShortName,1) as Court
		,M.F_RaceNum as MatchNo
		,[dbo].[Func_Report_JU_GetDateTime](M.F_MatchDate,7,N'ENG')+N' '+[dbo].[Func_Report_JU_GetDateTime](M.F_StartTime,4,N'ENG') as MatchTime
		,ED.F_EventShortName+N','+PD.F_PhaseLongName+N','+ISNULL(MSI.F_Memo,N'') AS Weight
		,ISNULL(D1.F_DelegationCode,N'') AS BlueNocCode
		,ISNULL(DD1_ENG.F_DelegationLongName,N'') AS BlueCountryEN
		,ISNULL(DD1_CHN.F_DelegationLongName,N'') as BlueCountryCH
		,ISNULL(RDA1_ENG.F_LongName,N'') as BlueLongNameEN
		,ISNULL(RDA1_ENG.F_ShortName,N'') as BlueShortNameEN
		,ISNULL(RDA1_CHN.F_LongName,N'') AS BlueLongNameCH
		,ISNULL(RDA1_CHN.F_ShortName,N'') as BlueShortNameCH
		,ISNULL(D2.F_DelegationCode,N'') AS WhiteNocCode
		,ISNULL(DD2_ENG.F_DelegationLongName,N'') AS WhiteCountryEN
		,ISNULL(DD2_CHN.F_DelegationLongName,N'') as WhiteCountryCH
		,ISNULL(RDA2_ENG.F_LongName,N'') as WhiteLongNameEN
		,ISNULL(RDA2_ENG.F_ShortName,N'') as WhiteShortNameEN
		,ISNULL(RDA2_CHN.F_LongName,N'') as WhiteLongNameCH
		,ISNULL(RDA2_CHN.F_ShortName,N'') as WhiteShortNameCH
		,2 as MatchType
		,MSR1.F_MatchSplitID AS GroupGameno
		,ISNULL(MR1.F_WinSets,0) AS BlueGroupScore
		,ISNULL(MR2.F_WinSets,0) as WhitegroupScore
		,case when ISNULL(MSR1.F_RegisterID,N'-1')=N'-1' then N'1' 
			when ISNULL(MSR2.F_RegisterID,N'-1')=N'-1' then N'1'
			else  N'0' end as NotMatch
	from TS_Match as M
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	LEFT JOIN TC_Court_Des AS CD 
		ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFt JOIN TS_Event_Des AS ED 
		ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
		
	LEFT JOIN TS_Match_Result AS MR1
		ON MR1.F_MatchID=M.F_MatchID AND MR1.F_CompetitionPositionDes1=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD1_ENG
		ON DD1_ENG.F_DelegationID=D1.F_DelegationID aND DD1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD1_CHN
		ON DD1_CHN.F_DelegationID=D1.F_DelegationID and DD1_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TS_Match_Split_Result AS MSR1
		ON MSR1.F_MatchID=MR1.F_MatchID aND MSR1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR1.F_MatchSplitID=4
	LEFT JOIN TR_Register AS RA1
		ON RA1.F_RegisterID=MSR1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA1_ENG
		ON RA1.F_RegisterID=RDA1_ENG.F_RegisterID and RDA1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA1_CHN
		ON RA1.F_RegisterID=RDA1_CHN.F_RegisterID and RDA1_CHN.F_LanguageCode=N'CHN'
	LEft JOIN TS_Match_Split_Info as MSI
		ON MSR1.F_MatchID=MSI.F_MatchID AND MSI.F_MatchSplitID=MSR1.F_MatchSplitID
		
	LEFT JOIN TS_Match_Result AS MR2
		ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPositionDes1=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD2_ENG
		ON DD2_ENG.F_DelegationID=D2.F_DelegationID aND DD2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD2_CHN
		ON DD2_CHN.F_DelegationID=D2.F_DelegationID and DD2_CHN.F_LanguageCode=N'CHN'
	
	LEFT JOIN TS_Match_Split_Result AS MSR2
		ON MSR2.F_MatchID=MR2.F_MatchID aND MSR2.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR2.F_MatchSplitID=4
	LEFT JOIN TR_Register AS RA2
		ON RA2.F_RegisterID=MSR2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA2_ENG
		ON RA2.F_RegisterID=RDA2_ENG.F_RegisterID and RDA2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA2_CHN
		ON RA2.F_RegisterID=RDA2_CHN.F_RegisterID and RDA2_CHN.F_LanguageCode=N'CHN'
		
	where E.F_PlayerRegTypeID=3 AND S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode  and (ISNULL(MSR1.F_RegisterID,N'-1')<>N'-1' OR ISNULL(MSR2.F_RegisterID,N'-1')<>N'-1')
	)
	
	insert into #Tamp_Table (MatchID,Session,Court,MatchNo,MatchTime,Weight,BlueNocCode,BlueCountryEN,BlueCountryCH,BlueLongNameEN,BlueShortNameEN,
							BlueLongNameCH,BlueShortNameCH,WhiteNocCode,WhiteCountryEN,WhiteCountryCH,WhiteLongNameEN,WhiteShortNameEN,WhiteLongNameCH,
							WhiteShortNameCH,MatchType,GroupGameNo,BlueGroupScore,WhiteGroupScore,NotMatch)
	(
		select 
		M.F_MatchID
		,case when S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber) else CONVERT(NVARCHAR(10),S.F_SessionNumber) end  AS Session
		,RIGHT(CD.F_CourtShortName,1) as Court
		,M.F_RaceNum as MatchNo
		,[dbo].[Func_Report_JU_GetDateTime](M.F_MatchDate,7,N'ENG')+N' '+[dbo].[Func_Report_JU_GetDateTime](M.F_StartTime,4,N'ENG') as MatchTime
		,ED.F_EventShortName+N','+PD.F_PhaseLongName+N','+ISNULL(MSI.F_Memo,N'') AS Weight
		,ISNULL(D1.F_DelegationCode,N'') AS BlueNocCode
		,ISNULL(DD1_ENG.F_DelegationLongName,N'') AS BlueCountryEN
		,ISNULL(DD1_CHN.F_DelegationLongName,N'') as BlueCountryCH
		,ISNULL(RDA1_ENG.F_LongName,N'') as BlueLongNameEN
		,ISNULL(RDA1_ENG.F_ShortName,N'') as BlueShortNameEN
		,ISNULL(RDA1_CHN.F_LongName,N'') AS BlueLongNameCH
		,ISNULL(RDA1_CHN.F_ShortName,N'') as BlueShortNameCH
		,ISNULL(D2.F_DelegationCode,N'') AS WhiteNocCode
		,ISNULL(DD2_ENG.F_DelegationLongName,N'') AS WhiteCountryEN
		,ISNULL(DD2_CHN.F_DelegationLongName,N'') as WhiteCountryCH
		,ISNULL(RDA2_ENG.F_LongName,N'') as WhiteLongNameEN
		,ISNULL(RDA2_ENG.F_ShortName,N'') as WhiteShortNameEN
		,ISNULL(RDA2_CHN.F_LongName,N'') as WhiteLongNameCH
		,ISNULL(RDA2_CHN.F_ShortName,N'') as WhiteShortNameCH
		,2 as MatchType
		,MSR1.F_MatchSplitID AS GroupGameno
		,ISNULL(MR1.F_WinSets,0) AS BlueGroupScore
		,ISNULL(MR2.F_WinSets,0) as WhitegroupScore
		,case when ISNULL(MSR1.F_RegisterID,N'-1')=N'-1' then N'1' 
			when ISNULL(MSR2.F_RegisterID,N'-1')=N'-1' then N'1'
			else  N'0' end as NotMatch
	from TS_Match as M
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	LEFT JOIN TC_Court_Des AS CD 
		ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=p.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFt JOIN TS_Event_Des AS ED 
		ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
		
	LEFT JOIN TS_Match_Result AS MR1
		ON MR1.F_MatchID=M.F_MatchID AND MR1.F_CompetitionPositionDes1=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD1_ENG
		ON DD1_ENG.F_DelegationID=D1.F_DelegationID aND DD1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD1_CHN
		ON DD1_CHN.F_DelegationID=D1.F_DelegationID and DD1_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TS_Match_Split_Result AS MSR1
		ON MSR1.F_MatchID=MR1.F_MatchID aND MSR1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR1.F_MatchSplitID=5
	LEFT JOIN TR_Register AS RA1
		ON RA1.F_RegisterID=MSR1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA1_ENG
		ON RA1.F_RegisterID=RDA1_ENG.F_RegisterID and RDA1_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA1_CHN
		ON RA1.F_RegisterID=RDA1_CHN.F_RegisterID and RDA1_CHN.F_LanguageCode=N'CHN'
		LEft JOIN TS_Match_Split_Info as MSI
		ON MSR1.F_MatchID=MSI.F_MatchID AND MSI.F_MatchSplitID=MSR1.F_MatchSplitID
		
	LEFT JOIN TS_Match_Result AS MR2
		ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPositionDes1=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD2_ENG
		ON DD2_ENG.F_DelegationID=D2.F_DelegationID aND DD2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Delegation_Des as DD2_CHN
		ON DD2_CHN.F_DelegationID=D2.F_DelegationID and DD2_CHN.F_LanguageCode=N'CHN'
	
	LEFT JOIN TS_Match_Split_Result AS MSR2
		ON MSR2.F_MatchID=MR2.F_MatchID aND MSR2.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR2.F_MatchSplitID=5
	LEFT JOIN TR_Register AS RA2
		ON RA2.F_RegisterID=MSR2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDA2_ENG
		ON RA2.F_RegisterID=RDA2_ENG.F_RegisterID and RDA2_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register_Des aS RDA2_CHN
		ON RA2.F_RegisterID=RDA2_CHN.F_RegisterID and RDA2_CHN.F_LanguageCode=N'CHN'
		
	where E.F_PlayerRegTypeID=3 AND S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode  and (ISNULL(MSR1.F_RegisterID,N'-1')<>N'-1' OR ISNULL(MSR2.F_RegisterID,N'-1')<>N'-1')
	)
	
	END
		
	select @Content=( select 
						Match.Session
						,Match.Court 
						,Match.MatchNo
						,Match.MatchTime
						,Match.Weight
						,Match.BlueNocCode
						,Match.BlueCountryEN
						,Match.BlueCountryCH
						,Match.BlueLongNameEN
						,Match.BlueShortNameEN
						,Match.BlueLongNameCH
						,Match.BlueShortNameCH
						,Match.WhiteNocCode
						,Match.WhiteCountryEN
						,Match.WhiteCountryCH
						,Match.WhiteLongNameEN
						,Match.WhiteShortNameEN
						,Match.WhiteLongNameCH
						,Match.WhiteShortNameCH
						,Match.MatchType
						,Match.GroupGameNo
						,Match.BlueGroupScore
						,Match.WhiteGroupScore
						,Match.NotMatch
						from #Tamp_Table AS Match
						ORDER by CONVERT(int,Match.MatchNo), Match.GroupGameNo
						for xml Auto
	)
	
	set @Result=N'<?xml version="1.0"?><xml>'+@Content+N'</xml>'
	
	
	
SET NOCOUNT OFF
END

/*



*/