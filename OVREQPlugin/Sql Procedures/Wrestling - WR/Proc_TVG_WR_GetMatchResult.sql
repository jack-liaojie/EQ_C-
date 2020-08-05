IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_GetMatchResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_WR_GetMatchResult]
--描    述: 柔道项目获取一场 Match 的result  
--创 建 人: 宁顺泽
--日    期: 2011年05月9日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_GetMatchResult]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

	DECLARE @PlayerRegTypeID		INT
		
	SELECT @PlayerRegTypeID = E.F_PlayerRegTypeID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE M.F_MatchID = @MatchID
	
	SeLect 
			ED.F_EventLongName AS [EventName]
			,CASE WHEN m.F_MatchStatusID>99 then N'Result - ' else N'' end+upper(PD.F_PhaseLongName) +N' BOUT' AS [PhaseName]
			,N'[Image]'+R.F_NOC AS [Noc_Red]
			,RD1.F_TvLongName AS [Name_Red]			
			,N'[Image]Card_Red' AS [Color_Red]
			,N'[Image]'+R2.F_NOC AS [Noc_Blue] 
			,RD2.F_TvLongName AS [Name_Blue] 			
			,N'[Image]Card_Blue' AS [Color_Blue]
			,case when isnull(IA.F_IRMCODE,N'')<>N'' OR ISNULL(IB.F_IRMCODE,N'')<>N'' then N'' else convert(nvarchar(10),MSR_A_1.F_Points+isnull(MSR_A_1.F_PointsNumDes3,0)) end AS P1_Red
			,case when isnull(IA.F_IRMCODE,N'')<>N'' OR ISNULL(IB.F_IRMCODE,N'')<>N'' then N'' when isnull(MSI_2.F_MatchSplitStatusID,0)<90 then N'' else  convert(nvarchar(10),isnull(MSR_A_2.F_Points,0)+isnull(MSR_A_2.F_PointsNumDes3,0)) end AS P2_Red
			,case when isnull(MSI_3.F_MatchSplitStatusID,0)<100 then N'' else  convert(nvarchar(10),isnull(MSR_A_3.F_Points,0)+isnull(MSR_A_3.F_PointsNumDes3,0)) end AS P3_Red
			
			,case when isnull(IA.F_IRMCODE,N'')<>N'' OR ISNULL(IB.F_IRMCODE,N'')<>N'' then N'' else convert(nvarchar(10),isnull(MSR_B_1.F_Points,0)+isnull(MSR_B_1.F_PointsNumDes3,0)) end AS P1_Blue
			,case when isnull(IA.F_IRMCODE,N'')<>N'' OR ISNULL(IB.F_IRMCODE,N'')<>N'' then N'' when isnull(MSI_2.F_MatchSplitStatusID,0)<90 then N'' else  convert(nvarchar(10),isnull(MSR_B_2.F_Points,0)+isnull(MSR_B_2.F_PointsNumDes3,0)) end As P2_Blue
			,case  when isnull(MSI_3.F_MatchSplitStatusID,0)<100 then N'' else  convert(nvarchar(10),isnull(MSR_B_3.F_Points,0)+isnull(MSR_B_3.F_PointsNumDes3,0)) end AS P3_Blue
			,N'[Image]IRM'+IA.F_IRMCODE as IRM_Red
			,N'[Image]IRM'+IB.F_IRMCODE as IRM_Blue
			,RD1.F_TvShortName as [Name_Blue_Short]
			,RD2.F_TvShortName AS [Name_White_Short]
	from TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Phase_Des as PD
		ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=@LanguageCode
	LEFT JOIN TS_Event_Des AS ED
		ON ED.F_EventID=P.F_EventID AND ED.F_LanguageCode=@LanguageCode
	
	LEFT JOIN TS_Match_Result AS MR1
		ON M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPosition=1
	LEFT JOIN TR_Register AS R
		ON MR1.F_RegisterID=R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD1 
		ON R.F_RegisterID=RD1.F_RegisterID AND RD1.F_LanguageCode=@LanguageCode
		
	LEFT JOIN TC_IRM AS IA
		on Ia.F_IRMID=MR1.F_IRMID
		
	LEFT JOIN TS_Match_Split_Info AS MSI_1
		ON MSI_1.F_MatchID=MR1.F_MatchID and MSI_1.F_MatchSplitID=1
	LEFT JOIN TS_Match_Split_Info AS MSI_2
		ON MSI_2.F_MatchID=MR1.F_MatchID and MSI_2.F_MatchSplitID=2
	LEFT JOIN TS_Match_Split_Info AS MSI_3
		ON MSI_3.F_MatchID=MR1.F_MatchID and MSI_3.F_MatchSplitID=3
		
	LEFT JOIN TS_Match_Split_Result as MSR_A_1
		ON MR1.F_MatchID=MSR_A_1.F_MatchID and MSR_A_1.F_MatchSplitID=1 and MSR_A_1.F_CompetitionPosition=1
	LEFT JOIN TS_Match_Split_Result as MSR_A_2
		ON MR1.F_MatchID=MSR_A_2.F_MatchID and MSR_A_2.F_MatchSplitID=2 and MSR_A_2.F_CompetitionPosition=1	
	LEFT JOIN TS_Match_Split_Result as MSR_A_3
		ON MR1.F_MatchID=MSR_A_3.F_MatchID and MSR_A_3.F_MatchSplitID=3 and MSR_A_3.F_CompetitionPosition=1
		
		LEFT JOIN TS_Match_Result AS MR2
		ON M.F_MatchID=MR2.F_MatchID AND MR2.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD2 
		ON R2.F_RegisterID=RD2.F_RegisterID AND RD2.F_LanguageCode=@LanguageCode
		
	LEFT JOIN TC_IRM AS IB
		ON IB.F_IRMID=MR2.F_IRMID
		
	LEFT JOIN TS_Match_Split_Result as MSR_B_1
		ON MR2.F_MatchID=MSR_B_1.F_MatchID and MSR_B_1.F_MatchSplitID=1 and MSR_B_1.F_CompetitionPosition=2
	LEFT JOIN TS_Match_Split_Result as MSR_B_2
		ON MR2.F_MatchID=MSR_B_2.F_MatchID and MSR_B_2.F_MatchSplitID=2 and MSR_B_2.F_CompetitionPosition=2	
	LEFT JOIN TS_Match_Split_Result as MSR_B_3
		ON MR2.F_MatchID=MSR_B_3.F_MatchID and MSR_B_3.F_MatchSplitID=3 and MSR_B_3.F_CompetitionPosition=2
		
	Where M.F_MatchID=@MatchID	


	

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_GetMatchResult] 2
*/