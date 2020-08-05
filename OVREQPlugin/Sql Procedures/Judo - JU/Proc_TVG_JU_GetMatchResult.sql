IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetMatchResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_GetMatchResult]
--描    述: 柔道项目获取一场 Match 的result  
--创 建 人: 宁顺泽
--日    期: 2011年05月9日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetMatchResult]
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
	
	IF @PlayerRegTypeID = 1
	BEGIN
	SeLect 
			ED.F_EventLongName AS [EventName]
			,N'Result - '+PD.F_PhaseLongName AS [PhaseName]
			,N'[Image]'+R.F_NOC AS [Noc_Blue]
			,RD1.F_TvLongName AS [Name_Blue]
			,Score_Blue=
				case
					WHEN MR1.F_PointsCharDes4 = N'H' OR MR1.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR1.F_IRMID=1 then N''
					WHEN MR1.F_IRMID=2 then N''
					WHEN MR2.F_PointsCharDes4 = N'H' OR MR2.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR2.F_IRMID=1 then N''
					WHEN MR2.F_IRMID=2 then N''  
					else 
				CONVERT(NVARCHAR(10), ISNULL(MR1.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR1.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR1.F_PointsNumDes3, 0))
				END
			,P_Blue=
				case
					WHEN MR1.F_PointsCharDes4 = N'H' OR MR1.F_PointsCharDes4 = N'X' THEN N'[Image]IRM_DSQ'
					WHEN MR1.F_IRMID=1 then N'[Image]IRM_DNF'
					WHEN MR1.F_IRMID=2 then N'[Image]IRM_DNS' 					

					ELSE N''
				END
			,S_Blue 
				=case 
				WHEN MR1.F_PointsCharDes4 = N'H' OR MR1.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR1.F_IRMID=1 then N''
					WHEN MR1.F_IRMID=2 then N''
					WHEN MR2.F_PointsCharDes4 = N'H' OR MR2.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR2.F_IRMID=1 then N''
					WHEN MR2.F_IRMID=2 then N'' 
					WHEN MR1.F_PointsNumDes4 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MR1.F_PointsNumDes4)
				else N'' end
			,N'[Image]Card_Blue' AS [Color_Blue]
			,N'[Image]'+R2.F_NOC AS [Noc_White] 
			,RD2.F_TvLongName AS [Name_White] 
			,Score_White=
			case 
					WHEN MR2.F_PointsCharDes4 = N'H' OR MR2.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR2.F_IRMID=1 then N''
					WHEN MR2.F_IRMID=2 then N'' 
					WHEN MR1.F_PointsCharDes4 = N'H' OR MR1.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR1.F_IRMID=1 then N''
					WHEN MR1.F_IRMID=2 then N''
					else CONVERT(NVARCHAR(10), ISNULL(MR2.F_PointsNumDes1, 0))
					+ CONVERT(NVARCHAR(10), ISNULL(MR2.F_PointsNumDes2, 0))
					+ CONVERT(NVARCHAR(10), ISNULL(MR2.F_PointsNumDes3, 0))
					END
			,P_White= CASE 
					WHEN MR2.F_PointsCharDes4 = N'H' OR MR2.F_PointsCharDes4 = N'X' THEN N'[Image]IRM_DSQ'
					WHEN MR2.F_IRMID=1 then N'[Image]IRM_DNF'
					WHEN MR2.F_IRMID=2 then N'[Image]IRM_DNS' 
					
					ELSE N''
				END
			,S_White= case 
					WHEN MR2.F_PointsCharDes4 = N'H' OR MR2.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR2.F_IRMID=1 then N''
					WHEN MR2.F_IRMID=2 then N'' 
					WHEN MR1.F_PointsCharDes4 = N'H' OR MR1.F_PointsCharDes4 = N'X' THEN N''
					WHEN MR1.F_IRMID=1 then N''
					WHEN MR1.F_IRMID=2 then N''
					WHEN MR2.F_PointsNumDes4 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MR2.F_PointsNumDes4)
					else N'' END
			,N'[Image]Card_White' AS [Color_White]
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
		
		LEFT JOIN TS_Match_Result AS MR2
		ON M.F_MatchID=MR2.F_MatchID AND MR2.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD2 
		ON R2.F_RegisterID=RD2.F_RegisterID AND RD2.F_LanguageCode=@LanguageCode
	Where M.F_MatchID=@MatchID	
	END

	

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_GetMatchResult] 2
*/