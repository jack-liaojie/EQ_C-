IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_Advance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_Advance]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [[Proc_TVG_WR_Advance]]
--描    述: 每场比赛胜者从这轮晋级到第几轮
--创 建 人: 宁顺泽
--日    期: 2011年05月9日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_Advance]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON
		
		select 
				top 1 N'[Image]'+ C.F_DelegationCode AS [Flag]
				,Rd.F_TvLongName AS [Name]
				,PD.F_PhaseLongName +N' to '+PD1.F_PhaseLongName AS [CruToNextPhase]
				,RD.F_TvShortName as [Name_Short]
		from TS_Match as M
		LEFT JOIN TS_Phase_Des AS PD
			ON M.F_PhaseID=PD.F_PhaseID AND PD.F_LanguageCode=@LanguageCode
		LEFT JOIN TS_Match_Result AS MR
			ON M.F_MatchID=MR.F_MatchID AND MR.F_ResultID=1
		LEFT JOIN TR_Register AS R
			ON MR.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
		LEFT JOIN TC_Delegation AS C
			ON C.F_DelegationID=R.F_DelegationID
		
		LEFT JOIN TS_Match_Result AS MR1
			ON MR1.F_RegisterID=MR.F_RegisterID AND MR1.F_MatchID>@MatchID	
		LEFT JOIN TS_Match AS M1
			ON MR1.F_MatchID=M1.F_MatchID
		LEFT JOIN TS_Phase_Des AS PD1
			ON M1.F_PhaseID=PD1.F_PhaseID AND PD1.F_LanguageCode=@LanguageCode 
		where M.F_MatchID=@MatchID 
		Order by M1.F_MatchID
		
		
SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_Advance] 1
*/