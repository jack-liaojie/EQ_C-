
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetMatchFullName]    Script Date: 01/21/2010 11:18:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetMatchFullName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetMatchFullName]

GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetMatchFullName]    Script Date: 01/29/2010 13:17:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TV_APP_GetMatchFullName]
----功		  能：为TV 应用程序服务, 得到一个Match的TV显示名字，包括 "Event + FatherPhase + Phase + Match" 的ShortName
----作		  者：管仁良
----日		  期: 2009-1-21 
----修 改  记 录：
/*			
	日期					修改人		修改内容
	2011年6月23日 星期四	邓年彩		改变 Match Full Name 以适应给跆拳道对抗赛计时记分.
	2011年10月31日 星期一	邓年彩		场次号不转化, 考虑品势赛的阶段名称.
*/


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetMatchFullName]
	                        @MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON

	SELECT  ISNULL(RIGHT(H.F_CourtCode, 1) + N' ', N' ') +
			ISNULL('Match ' + B.F_RaceNum + N' ', N' ') +
			ISNULL(E.F_EventShortName + N' ', N' ') +
			CASE I.F_CompetitionTypeID
				WHEN 1 THEN CASE D.F_PhaseCode 
					WHEN 1 THEN N'Final' 
					WHEN 2 THEN N'Semifinal'
					WHEN 3 THEN N'Quaterfinal'
					WHEN 4 THEN N'1_8'
					WHEN 5 THEN N'1_16'
					WHEN 6 THEN N'1_32'
					WHEN 7 THEN N'1_64'
				END
				ELSE CASE D.F_PhaseCode
					WHEN 1 THEN 'Final'
					WHEN 2 THEN 'Semifinal'
					ELSE 'Preliminary'
				END
			END
			as F_MatchFullName
			
			FROM TS_Match_Des AS A 
			LEFT JOIN TS_Match		AS B ON B.F_MatchID = A.F_MatchID 
			LEFT JOIN TS_Phase_Des	AS C ON C.F_PhaseID = B.F_PhaseID AND C.F_LanguageCode = 'ENG' 
			LEFT JOIN TS_Phase		AS D ON D.F_PhaseID = B.F_PhaseID 
			LEFT JOIN TS_Event_Des	AS E ON E.F_EventID = D.F_EventID AND E.F_LanguageCode = 'ENG' 
			LEFT JOIN TS_Phase_Des	AS G ON d.F_FatherPhaseID = G.F_PhaseID AND G.F_LanguageCode = 'ENG' 
			LEFT JOIN TC_Court		AS H ON B.F_CourtID = H.F_CourtID
			LEFT JOIN TS_Event		AS I ON D.F_EventID = I.F_EventID
			WHERE A.F_LanguageCode='ENG' AND A.F_MatchID = @MatchID 



SET NOCOUNT OFF
END

--EXEC [Proc_TV_APP_GetMatchFullName] 2003

