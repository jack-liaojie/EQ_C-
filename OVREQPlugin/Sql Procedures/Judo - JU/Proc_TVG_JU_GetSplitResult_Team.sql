IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetSplitResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetSplitResult_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_GetSplitResult_Team]
--描    述: 柔道项目获取一场团体赛中 每个Match中每局 的result  
--创 建 人: 宁顺泽
--日    期: 2011年05月31日 星期二
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetSplitResult_Team]
	@MatchID						INT,
	@MatchSplitID					INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

	select 
		ED.F_EventLongName AS EventName
		,PD.F_PhaseLongName+N' Match '+Convert(NVARCHAR(10),Convert(INT,M.F_MatchCode))+N'  '+MSI.F_Memo AS PhaseName
		,N'[Image]'+R.F_NOC AS flagBlue
		,N'[Image]'+R1.F_NOC AS flagWhite
		,Rd.F_TvLongName AS NameBlue
		,Rd1.F_TvLongName AS NameWhite
		,CASE 
					WHEN MSR.F_PointsCharDes3 = N'H' OR MSR.F_PointsCharDes3 = N'X' THEN N''
					when MSR.F_IRMID=2 THEN N''
					WHEN MSR.F_IRMID=1	Then N''
					WHEN MSR1.F_PointsCharDes3 = N'H' OR MSR1.F_PointsCharDes3 = N'X' THEN N''
					when MSR1.F_IRMID=2 THEN N''
					WHEN MSR1.F_IRMID=1	Then N''
					ELSE 
						CONVERT(NVARCHAR(10), ISNULL(MSR.F_PointsNumDes1, 0))
						+ CONVERT(NVARCHAR(10), ISNULL(MSR.F_PointsNumDes2, 0))
						+ CONVERT(NVARCHAR(10), ISNULL(MSR.F_PointsNumDes3, 0))
					END	 AS Score_Blue
		,CASE 
					WHEN MSR1.F_PointsCharDes3 = N'H' OR MSR1.F_PointsCharDes3 = N'X' THEN N''
					when MSR1.F_IRMID=2 THEN N''
					WHEN MSR1.F_IRMID=1	Then N''
					WHEN MSR.F_PointsCharDes3 = N'H' OR MSR.F_PointsCharDes3 = N'X' THEN N''
					when MSR.F_IRMID=2 THEN N''
					WHEN MSR.F_IRMID=1	Then N''
					ELSE 
						CONVERT(NVARCHAR(10), ISNULL(MSR1.F_PointsNumDes1, 0))
						+ CONVERT(NVARCHAR(10), ISNULL(MSR1.F_PointsNumDes2, 0))
						+ CONVERT(NVARCHAR(10), ISNULL(MSR1.F_PointsNumDes3, 0))
					END	 AS Score_White
		,N'[Image]Card_Blue' as BlueColor 
		,N'[Image]Card_White' as WhiteColor 
		,case when ISNULL(MSR.F_PointsCharDes3,N'')<>N'' then N'[Image]IRM_DSQ'
				else 
					case when MSR.F_IRMID=1 then N'[Image]IRM_DNF'
						when MSR.F_IRMID=2 then N'[Image]IRM_DNS'
						else N'' end 
				end AS [IRM_Blue]
		,case when ISNULL(MSR1.F_PointsCharDes3,N'')<>N'' then N'[Image]IRM_DSQ'
				else 
					case when MSR1.F_IRMID=1 then N'[Image]IRM_DNF'
						when MSR1.F_IRMID=2 then N'[Image]IRM_DNS'
						else N'' end 
				end AS [IRM_White]
		,CASE 
					WHEN MSR.F_PointsCharDes3 = N'H' OR MSR.F_PointsCharDes3 = N'X' THEN N''
					when MSR.F_IRMID=2 THEN N''
					WHEN MSR.F_IRMID=1	Then N''
					WHEN MSR1.F_PointsCharDes3 = N'H' OR MSR1.F_PointsCharDes3 = N'X' THEN N''
					when MSR1.F_IRMID=2 THEN N''
					WHEN MSR1.F_IRMID=1	Then N''
					WHEN MSR.F_SplitPointsNumDes3 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MSR.F_SplitPointsNumDes3)
					else '' END AS S_Blue
		,CASE 
					WHEN MSR.F_PointsCharDes3 = N'H' OR MSR.F_PointsCharDes3 = N'X' THEN N''
					when MSR.F_IRMID=2 THEN N''
					WHEN MSR.F_IRMID=1	Then N''
					WHEN MSR1.F_PointsCharDes3 = N'H' OR MSR1.F_PointsCharDes3 = N'X' THEN N''
					when MSR1.F_IRMID=2 THEN N''
					WHEN MSR1.F_IRMID=1	Then N''
					WHEN MSR1.F_SplitPointsNumDes3 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MSR1.F_SplitPointsNumDes3)
					else '' END AS S_White
		,RD.F_TvShortName AS NameBlue_Short
		,RD1.F_TvShortName AS NameWhite_Short
	from TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON P.F_PhaseID=M.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD 
		ON P.F_PhaseID=PD.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event_Des AS ED
		ON P.F_EventID=Ed.F_EventID AND Ed.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Match_Split_Info AS MSI
		ON M.F_MatchID=MSI.F_MatchID AND MSI.F_MatchSplitID=@MatchSplitID
	LEFT JOIN TS_Match_Split_Result AS MSR
		ON MSI.F_MatchID=MSR.F_MatchID AND MSR.F_MatchSplitID=MSI.F_MatchSplitID AND MSR.F_CompetitionPosition=1
	LEFT JOIN TR_Register AS R
		ON R.F_RegisterID=MSR.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON Rd.F_RegisterID=R.F_RegisterID AND Rd.F_LanguageCode=N'ENG'

	
	LEFT JOIN TS_Match_Split_Result AS MSR1
		ON MSI.F_MatchID=MSR1.F_MatchID AND MSR1.F_MatchSplitID=MSI.F_MatchSplitID AND MSR1.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS R1
		ON R1.F_RegisterID=MSR1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD1
		ON Rd1.F_RegisterID=R1.F_RegisterID AND Rd1.F_LanguageCode=N'ENG'
	Where M.F_MatchID=@MatchID
	
	
	

SET NOCOUNT OFF
END


/*
					WHEN MSR.F_SplitPointsNumDes3 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MSR.F_SplitPointsNumDes3)

CONVERT(NVARCHAR(10), ISNULL(MSR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSR.F_PointsNumDes3, 0))
				+ 
-- Just for test
EXEC [Proc_TVG_JU_GetTeamMatchResult] 2
*/