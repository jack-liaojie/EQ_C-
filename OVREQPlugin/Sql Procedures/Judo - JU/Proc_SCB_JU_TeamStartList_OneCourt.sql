IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_TeamStartList_OneCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_TeamStartList_OneCourt]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_SCB_JU_TeamStartList_OneCourt]
----功		  能：获取一个场地的团体赛比赛对阵
----作		  者：宁顺泽
----日		  期: 2011-4--6
/*
		 修改人				修改日期				修改内容

*/

CREATE PROCEDURE [dbo].[Proc_SCB_JU_TeamStartList_OneCourt]
		@SessionID			INT,
		@CourtCode			NVARCHAR(20)
AS
BEGIN
	
SET NOCOUNT ON

select 
	cd.F_CourtShortName AS CourtName
	,[dbo].Func_SCB_JU_GetDateTime(M.F_StartTime,4,N'ENG') AS StartTime
	,N'Match '+convert(Nvarchar(10),M.F_MatchID)+N'--RaceNum:'+M.F_RaceNum AS [MatchNumber]
	,ED.F_EventLongName+N'-'+PD.F_PhaseLongName AS EventName
	,RD1.F_ShortName AS CountryBlue 
	,RD2.F_ShortName AS CountryWhite,
	N'Blue' AS BLue,
	N'[Image]Card_Blue' AS Image_Blue,
	N'White' AS White,
	N'[Image]Card_White' AS Image_White
	,RD_A1.F_LongName AS BlueName_1
	,RD_A2.F_LongName AS BlueName_2
	,RD_A3.F_LongName AS BlueName_3
	,RD_A4.F_LongName AS BlueName_4
	,RD_A5.F_LongName AS BlueName_5
	,RD_B1.F_LongName AS WhiteName_1
	,RD_B2.F_LongName AS WhiteName_2
	,RD_B3.F_LongName AS WhiteName_3
	,RD_B4.F_LongName AS WhiteName_4
	,RD_B5.F_LongName AS WhiteName_5
	,N'[Image]'+D.F_DelegationCode AS [Image_Noc_Blue]
	,N'[Image]'+D2.F_DelegationCode AS [Image_Noc_White]
	,case when LEFT(MSI1.F_Memo,1)=N'-' then Right(MSI1.F_Memo,LEN(MSI1.F_Memo)-1)  
		else MSI1.F_Memo end as Weigh1
	,case when LEFT(MSI2.F_Memo,1)=N'-' then Right(MSI2.F_Memo,LEN(MSI2.F_Memo)-1)  
		else MSI2.F_Memo end as Weigh2
	,case when LEFT(MSI3.F_Memo,1)=N'-' then Right(MSI3.F_Memo,LEN(MSI3.F_Memo)-1)  
		else MSI3.F_Memo end as Weigh3
	,case when LEFT(MSI4.F_Memo,1)=N'-' then Right(MSI4.F_Memo,LEN(MSI4.F_Memo)-1)  
		else MSI4.F_Memo end as Weigh4
	,case when LEFT(MSI5.F_Memo,1)=N'-' then Right(MSI5.F_Memo,LEN(MSI5.F_Memo)-1)  
		else MSI5.F_Memo end as Weigh5,
	CD_CHN.F_CourtShortName AS CourtName_CHN,
	Cd.F_CourtShortName+N'（'+CD_CHN.F_CourtShortName+N'）' AS CourtName_CHN_ENG
from  TC_Court AS C
LEFT JOIN TC_Court_Des AS Cd
	on C.F_CourtID=Cd.F_CourtID AND Cd.F_LanguageCode=N'ENG'
LEFT JOIN TC_Court_Des AS CD_CHN
	ON C.F_CourtID=CD_CHN.F_CourtID AND CD_CHN.F_LanguageCode=N'CHN'
LEFT JOIN TS_Match AS M
	ON C.F_CourtID =M.F_CourtID AND M.F_SessionID=@SessionID
LEFT JOIN TS_Phase AS P
	ON P.F_PhaseID=M.F_PhaseID
LEFT JOIN TS_Phase_Des AS PD
	ON PD.F_PhaseID=M.F_PhaseID AND PD.F_LanguageCode=N'ENG'
LEFT JOIN TS_Event_Des AS ED
	ON P.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
	
Left JOIn TS_Match_Result AS MR1
	On M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPosition=1
LEFT JOIN TR_Register AS R1 
	ON MR1.F_RegisterID=R1.F_RegisterID
LEFT JOIN TC_Delegation AS D
	ON R1.F_DelegationID=D.F_DelegationID
LEFT JOIN TR_Register_Des AS RD1
	ON MR1.F_RegisterID=RD1.F_RegisterID AND RD1.F_LanguageCode=N'ENG'
		
LEFT JOIN TS_Match_Split_Result AS MSR_A1
	ON MR1.F_MatchID=MSR_A1.F_MatchID AND MSR_A1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A1.F_MatchSplitID=1
LEFT JOIN TR_Register_Des AS RD_A1 
	ON MSR_A1.F_RegisterID=RD_A1.F_RegisterID AND RD_A1.F_LanguageCode=N'ENG'
LEFT JOIN TS_Match_Split_Info AS MSI1
	ON MSR_A1.F_MatchID=MSI1.F_MatchID AND MSI1.F_MatchSplitID=1
	
LEFT JOIN TS_Match_Split_Result AS MSR_A2
	ON MR1.F_MatchID=MSR_A2.F_MatchID AND MSR_A2.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A2.F_MatchSplitID=2
LEFT JOIN TR_Register_Des AS RD_A2 
	ON MSR_A2.F_RegisterID=RD_A2.F_RegisterID AND RD_A2.F_LanguageCode=N'ENG'
LEFT JOIN TS_Match_Split_Info AS MSI2
	ON MSR_A2.F_MatchID=MSI2.F_MatchID AND MSI2.F_MatchSplitID=2

LEFT JOIN TS_Match_Split_Result AS MSR_A3
	ON MR1.F_MatchID=MSR_A3.F_MatchID AND MSR_A3.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A3.F_MatchSplitID=3
LEFT JOIN TR_Register_Des AS RD_A3 
	ON MSR_A3.F_RegisterID=RD_A3.F_RegisterID AND RD_A3.F_LanguageCode=N'ENG'
LEFT JOIN TS_Match_Split_Info AS MSI3
	ON MSR_A3.F_MatchID=MSI3.F_MatchID AND MSI3.F_MatchSplitID=3

LEFT JOIN TS_Match_Split_Result AS MSR_A4
	ON MR1.F_MatchID=MSR_A4.F_MatchID AND MSR_A4.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A4.F_MatchSplitID=4
LEFT JOIN TR_Register_Des AS RD_A4 
	ON MSR_A4.F_RegisterID=RD_A4.F_RegisterID AND RD_A4.F_LanguageCode=N'ENG'
LEFT JOIN TS_Match_Split_Info AS MSI4
	ON MSR_A2.F_MatchID=MSI4.F_MatchID AND MSI4.F_MatchSplitID=4
	
LEFT JOIN TS_Match_Split_Result AS MSR_A5
	ON MR1.F_MatchID=MSR_A5.F_MatchID AND MSR_A5.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A5.F_MatchSplitID=5
LEFT JOIN TR_Register_Des AS RD_A5 
	ON MSR_A5.F_RegisterID=RD_A5.F_RegisterID AND RD_A5.F_LanguageCode=N'ENG'
LEFT JOIN TS_Match_Split_Info AS MSI5
	ON MSR_A2.F_MatchID=MSI5.F_MatchID AND MSI5.F_MatchSplitID=5	
LEFT JOIN TS_Match_Result AS MR2
	ON M.F_MatchID=MR2.F_MatchID and MR2.F_CompetitionPosition=2
LEFT JOIN TR_Register AS R2
	ON R2.F_RegisterID=MR2.F_RegisterID
LEFT JOIN TC_Delegation AS D2
	ON D2.F_DelegationID=R2.F_DelegationID
LEFT JOIN TR_Register_Des AS RD2
	ON MR2.F_RegisterID=RD2.F_RegisterID AND RD2.F_LanguageCode=N'ENG'	
LEFT JOIN TS_Match_Split_Result AS MSR_B1
	ON MR2.F_MatchID=MSR_B1.F_MatchID AND MSR_B1.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR_B1.F_MatchSplitID=1
LEFT JOIN TR_Register_Des AS RD_B1 
	ON MSR_B1.F_RegisterID=RD_B1.F_RegisterID AND RD_B1.F_LanguageCode=N'ENG'
	
LEFT JOIN TS_Match_Split_Result AS MSR_B2
	ON MR2.F_MatchID=MSR_B2.F_MatchID AND MSR_B2.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR_B2.F_MatchSplitID=2
LEFT JOIN TR_Register_Des AS RD_B2 
	ON MSR_B2.F_RegisterID=RD_B2.F_RegisterID AND RD_B2.F_LanguageCode=N'ENG'

LEFT JOIN TS_Match_Split_Result AS MSR_B3
	ON MR2.F_MatchID=MSR_B3.F_MatchID AND MSR_B3.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR_B3.F_MatchSplitID=3
LEFT JOIN TR_Register_Des AS RD_B3 
	ON MSR_B3.F_RegisterID=RD_B3.F_RegisterID AND RD_B3.F_LanguageCode=N'ENG'

LEFT JOIN TS_Match_Split_Result AS MSR_B4
	ON MR2.F_MatchID=MSR_B4.F_MatchID AND MSR_B4.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR_B4.F_MatchSplitID=4
LEFT JOIN TR_Register_Des AS RD_B4 
	ON MSR_B4.F_RegisterID=RD_B4.F_RegisterID AND RD_B4.F_LanguageCode=N'ENG'
	
LEFT JOIN TS_Match_Split_Result AS MSR_B5
	ON MR2.F_MatchID=MSR_B5.F_MatchID AND MSR_B5.F_CompetitionPosition=MR2.F_CompetitionPosition AND MSR_B5.F_MatchSplitID=5
LEFT JOIN TR_Register_Des AS RD_B5 
	ON MSR_B5.F_RegisterID=RD_B5.F_RegisterID AND RD_B5.F_LanguageCode=N'ENG'

where C.F_CourtCode=@CourtCode

SET NOCOUNT OFF
END

GO

/*



*/

