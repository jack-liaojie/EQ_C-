IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_GetStartList_OneCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_GetStartList_OneCourt]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_GetStartList_OneCourt]
--描    述: SCB 获取所有一个场馆的比赛秩序.
--创 建 人: 宁顺泽
--日    期: 2011年4月1日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_GetStartList_OneCourt]
	@SessionID						INT,
	@CourtCode						NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID			INT	
	SELECT @DisciplineID = F_DisciplineID FROM TS_Session WHERE F_SessionID = @SessionID
	
	select 
		[dbo].Func_SCB_JU_GetDateTime(M.F_StartTime,4,N'ENG') AS StartTime
		,N'Match '+convert(Nvarchar(10),M.F_MatchID)+N'--RaceNum:'+M.F_RaceNum AS [MatchNumber]
		,ED.F_EventShortName+N'-'+PD.F_PhaseShortName AS EventName
		,CD_ENG.F_CourtShortName AS CourtName_ENG
		,CD_CHN.F_CourtShortName AS CourtName_CHN
		,N'Blue' AS [Blue]
		,N'[Image]Card_Blue' AS [Image_Blue]
		,N'White' AS [White]
		,N'[Image]Card_White' AS [Image_White]
		, RD1.F_LongName AS BlueName
		,R1.F_NOC AS Blue_Noc
		,RD2.F_LongName AS WhiteName
		,R2.F_NOC AS White_Noc
		,M.F_RaceNum
		,N'[Image]'+D1.F_DelegationCode AS [Image_Blue_Noc]
		,N'[Image]'+D2.F_DelegationCode AS [Image_White_Noc]
		,CD_ENG.F_CourtShortName+N'（'+CD_CHN.F_CourtShortName+N'）' AS CourtName_ENG_CHN
	from TC_Court AS C
	LEFT JOIN TC_Court_Des AS CD_ENG
		on C.F_CourtID=CD_ENG.F_CourtID AND CD_ENG.F_LanguageCode=N'ENG'
	LEFT JOIN TC_Court_Des AS CD_CHN
		ON C.F_CourtID=CD_CHN.F_CourtID AND CD_CHN.F_LanguageCode=N'CHN'
	Left JOIN TS_Match AS M
		on C.F_CourtID=M.F_CourtID AND M.F_SessionID=@SessionID
	LEFT JOIN TS_Phase AS P
		on P.F_PhaseID=M.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON PD.F_LanguageCode=N'ENG' AND PD.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Event_Des AS ED 
		ON p.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
	LEft Join TS_Match_Result AS MR1
		on M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPosition=1
	LEFT JOIN TR_Register AS R1
		ON R1.F_RegisterID=MR1.F_RegisterID
	LEFT JOIN TC_Delegation AS D1
		ON D1.F_DelegationID=R1.F_DelegationID 
	LEFT JOIN TR_Register_Des AS RD1
		ON RD1.F_RegisterID=MR1.F_RegisterID AND RD1.F_LanguageCode=N'ENG'
	Left Join TS_Match_Result AS MR2
		ON m.F_MatchID=MR2.F_MatchID AND  MR2.F_CompetitionPosition=2	
	LEFT JOIN TR_Register AS R2
		ON R2.F_RegisterID=MR2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID 
	LEFT JOIN TR_Register_Des AS RD2
		ON RD2.F_RegisterID=MR2.F_RegisterID AND RD2.F_LanguageCode=N'ENG'
	Where c.F_CourtCode=@CourtCode
	order by M.F_RaceNum

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_SCB_JU_GetResult_AllCourt] 

*/