IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetMatchPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetMatchPlayers]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_GetMatchPlayers]
--描    述: 柔道项目获取一场 Match 的对阵双方  
--创 建 人: 宁顺泽
--日    期: 2011年05月9日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetMatchPlayers]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

	SELECT
			ED.F_EventLongName AS [EventName]
			,PD.F_PhaseLongName AS [PhaseName]
			,N'[Image]'+D.F_DelegationCode AS [NOC_Blue]
			,RD1.F_TvLongName AS [Name_Blue]
			,N'[Image]Card_Blue' AS [Color_Blue]
			,N'[Image]'+D2.F_DelegationCode AS [Noc_White]
			,RD2.F_TvLongName as [Name_White]
			,N'[Image]Card_White' AS [Color_white]
			,RD1.F_TvShortName AS [Name_Blue_Short]
			,RD2.F_TvShortName AS [Name_White_Short]
	from TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID=PD.F_PhaseID AND PD.F_LanguageCode=@LanguageCode
	LEFT JOIN TS_Event_Des AS ED
		ON P.F_EventID=ED.F_EventID AND ED.F_LanguageCode=@LanguageCode
	LEFT JOIN TS_Match_Result AS MR1
		ON M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPosition=1
	LEFT JOIN TR_Register AS R1
		ON MR1.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON D.F_DelegationID=R1.F_DelegationID
	LEFT JOIN TR_Register_Des AS RD1
		ON RD1.F_RegisterID=R1.F_RegisterID AND RD1.F_LanguageCode=@LanguageCode 
		
	LEFT JOIN TS_Match_Result AS MR2
		ON M.F_MatchID=MR2.F_MatchID AND MR2.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TC_Delegation AS D2
		ON D2.F_DelegationID=R2.F_DelegationID
	LEFT JOIN TR_Register_Des AS RD2
		ON RD2.F_RegisterID=R2.F_RegisterID AND RD2.F_LanguageCode=@LanguageCode
	where M.F_MatchID=@MatchID
	

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_GetMatchPlayers] 86
*/