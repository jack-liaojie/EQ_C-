IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetSplitPlayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetSplitPlayer]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_GetSplitPlayer]
--描    述: 柔道项目获取一场团体赛中 Match 的result  
--创 建 人: 宁顺泽
--日    期: 2011年05月31日 星期二
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetSplitPlayer]
	@MatchID						INT,
	@MatchSplitID					INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

		select 
			ED.F_EventLongName AS EventName 
			,PD.F_PhaseLongName+N' Match '+Convert(NVARCHAR(10),Convert(INT,M.F_MatchCode))+N'  '+MSI.F_Memo as PhaseName
			,N'[Image]'+R.F_NOC AS falg
			,RD.F_TvLongName aS Name
			,case when MSR.F_CompetitionPosition=1 then N'[Image]Card_Blue' else N'[Image]Card_White' END AS Image_Color
			,case when ISNULL(MSR.F_PointsCharDes3,N'')<>N'' then N'[Image]IRM_DSQ'
				else 
					case when MSR.F_IRMID=1 then N'[Image]IRM_DNF'
						when MSR.F_IRMID=2 then N'[Image]IRM_DNS'
						else N'' end end AS [IRM]
			,RD.F_TvShortName AS Name_Short
		From TS_Match AS M
		LEFT JOIN TS_Phase AS P
			ON P.F_PhaseID=M.F_PhaseID 
		LEFT JOIN TS_Phase_Des AS PD 
			ON P.F_PhaseID=PD.F_PhaseID AND PD.F_LanguageCode=N'ENG'
		LEFT JOIN TS_Event_Des AS ED
			ON P.F_EventID=Ed.F_EventID AND Ed.F_LanguageCode=N'ENG'
		LEFT JOIN TS_Match_Split_Result AS MSR
			ON M.F_MatchID=MSR.F_MatchID AND MSR.F_MatchSplitID=@MatchSplitID
		LEFT JOIN TS_Match_Split_Info AS MSI
			ON MSI.F_MatchID=M.F_MatchID AND MSI.F_MatchSplitID=@MatchSplitID
		LEFT JOIN TR_Register AS R
			ON R.F_RegisterID=MSR.F_RegisterID 
		LEFT JOIN TR_Register_Des aS RD
			ON R.F_RegisterID=Rd.F_RegisterID AND rd.F_LanguageCode=N'ENG'
		where M.F_MatchID=@MatchID
		
SET NOCOUNT OFF	
		
		
END	
/*		
-- Just for tes
EXEC [Proc_TVG_JU_GetSplitPlayer] 2
*/