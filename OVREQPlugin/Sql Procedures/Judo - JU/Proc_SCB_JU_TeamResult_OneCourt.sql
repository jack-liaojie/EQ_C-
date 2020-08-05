IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_TeamResult_OneCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_TeamResult_OneCourt]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_SCB_JU_TeamResult_OneCourt]
----功		  能：获取一个场地的团体赛比赛结果
----作		  者：宁顺泽
----日		  期: 2011-4-6
/*
		 修改人				修改日期				修改内容


*/

CREATE PROCEDURE [dbo].[Proc_SCB_JU_TeamResult_OneCourt]
		@SessionID			INT,
		@CourtCode			NVARCHAR(20)
AS
BEGIN
	
SET NOCOUNT ON

select 
	cd.F_CourtShortName AS CourtName
	,ED.F_EventLongName+N'-'+PD.F_PhaseLongName AS EventName
	,N'Match '+convert(Nvarchar(10),M.F_MatchID)+N'--RaceNum:'+M.F_RaceNum AS [MatchNumber]
	,RD1.F_ShortName AS CountryBlue 
	,RD2.F_ShortName AS CountryWhite
	
	,MSR_A1.F_PointsNumDes1 AS IppA1
	,MSR_A1.F_PointsNumDes2 as WazA1
	,MSR_A1.F_PointsNumDes3 AS YukA1
	,CASE when ISNULL(MSR_A1.F_PointsCharDes3,N'')<> N'' then MSR_A1.F_PointsCharDes3
			else 
				CASE when MSR_A1.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_A1.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_A1.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_A1.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_A1
	,CASE when MSR_A1.F_ResultID=1 then 'W' else '' END AS W_A1
			
	,MSR_A2.F_PointsNumDes1 AS IppA2
	,MSR_A2.F_PointsNumDes2 as WazA2
	,MSR_A2.F_PointsNumDes3 AS YukA2
	,CASE when ISNULL(MSR_A2.F_PointsCharDes3,N'')<> N'' then MSR_A2.F_PointsCharDes3
			else 
				CASE when MSR_A2.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_A2.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_A2.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_A2.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_A2
	,CASE when MSR_A2.F_ResultID=1 then 'W' else '' END AS W_A2
			
	,MSR_A3.F_PointsNumDes1 AS IppA3
	,MSR_A3.F_PointsNumDes2 as WazA3
	,MSR_A3.F_PointsNumDes3 AS YukA3
	,CASE when ISNULL(MSR_A3.F_PointsCharDes3,N'')<> N'' then MSR_A3.F_PointsCharDes3
			else 
				CASE when MSR_A3.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_A3.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_A3.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_A3.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_A3
	,CASE when MSR_A3.F_ResultID=1 then 'W' else '' END AS W_A3
	
	,MSR_A4.F_PointsNumDes1 AS IppA4
	,MSR_A4.F_PointsNumDes2 as WazA4
	,MSR_A4.F_PointsNumDes3 AS YukA4
	,CASE when ISNULL(MSR_A4.F_PointsCharDes3,N'')<> N'' then MSR_A4.F_PointsCharDes3
			else 
				CASE when MSR_A4.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_A4.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_A4.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_A4.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_A4
	,CASE when MSR_A4.F_ResultID=1 then 'W' else '' END AS W_A4
			
	,MSR_A5.F_PointsNumDes1 AS IppA5
	,MSR_A5.F_PointsNumDes2 as WazA5
	,MSR_A5.F_PointsNumDes3 AS YukA5
	,CASE when ISNULL(MSR_A5.F_PointsCharDes3,N'')<> N'' then MSR_A5.F_PointsCharDes3
			else 
				CASE when MSR_A5.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_A5.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_A5.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_A5.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_A5
	,CASE when MSR_A5.F_ResultID=1 then 'W' else '' END AS W_A5	
			
	,MSR_B1.F_PointsNumDes1 AS IppB1
	,MSR_B1.F_PointsNumDes2 as WazB1
	,MSR_B1.F_PointsNumDes3 AS YukB1
	,CASE when ISNULL(MSR_B1.F_PointsCharDes3,N'')<> N'' then MSR_B1.F_PointsCharDes3
			else 
				CASE when MSR_B1.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_B1.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_B1.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_B1.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_B1
	,CASE when MSR_B1.F_ResultID=1 then 'W' else '' END AS W_B1
			
	,MSR_B2.F_PointsNumDes1 AS IppB2
	,MSR_B2.F_PointsNumDes2 as WazB2
	,MSR_B2.F_PointsNumDes3 AS YukB2
	,CASE when ISNULL(MSR_B2.F_PointsCharDes3,N'')<> N'' then MSR_B2.F_PointsCharDes3
			else 
				CASE when MSR_B2.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_B2.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_B2.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_B2.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_B2
	,CASE when MSR_B2.F_ResultID=1 then 'W' else '' END AS W_B2
			
	,MSR_B3.F_PointsNumDes1 AS IppB3
	,MSR_B3.F_PointsNumDes2 as WazB3
	,MSR_B3.F_PointsNumDes3 AS YukB3
	,CASE when ISNULL(MSR_B3.F_PointsCharDes3,N'')<> N'' then MSR_B3.F_PointsCharDes3
			else 
				CASE when MSR_B3.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_B3.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_B3.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_B3.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_B3
	,CASE when MSR_B3.F_ResultID=1 then 'W' else '' END AS W_B3
	
	,MSR_B4.F_PointsNumDes1 AS IppB4
	,MSR_B4.F_PointsNumDes2 as WazB4
	,MSR_B4.F_PointsNumDes3 AS YukB4
	,CASE when ISNULL(MSR_B4.F_PointsCharDes3,N'')<> N'' then MSR_B4.F_PointsCharDes3
			else 
				CASE when MSR_B4.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_B4.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_B4.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_B4.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_B4
	,CASE when MSR_B4.F_ResultID=1 then 'Win' else '' END AS W_B4
			
	,MSR_B5.F_PointsNumDes1 AS IppB5
	,MSR_B5.F_PointsNumDes2 as WazB5
	,MSR_B5.F_PointsNumDes3 AS YukB5
	,CASE when ISNULL(MSR_B5.F_PointsCharDes3,N'')<> N'' then MSR_B5.F_PointsCharDes3
			else 
				CASE when MSR_B5.F_SplitPointsNumDes3=1 then 'S1'
					 when MSR_B5.F_SplitPointsNumDes3=2 then 'S2'
					 when MSR_B5.F_SplitPointsNumDes3=3 then 'S3'
					 when MSR_B5.F_SplitPointsNumDes3=4 then 'S4'
					 else '' end
			end AS P_B5
	,CASE when MSR_B5.F_ResultID=1 then 'Win' else '' END AS W_B5
	,convert(nvarchar(10),ISNULL(MR1.F_WinSets,0))+
			case when MR1.F_ResultID=1 then ' (Win)'
			else '' end +
			N'  :  '+
			convert(nvarchar(10),ISNULL(MR2.F_WinSets,0))+
			case when MR2.F_ResultID=1 then ' (Win)'
			else '' end
			 AS TotalScore
	,N'[Image]'+D1.F_DelegationCode AS [Image_Noc_A]
	,N'[Image]'+D2.F_DelegationCode AS [Image_Noc_B]
	,N'Blue' AS BLue,
	N'[Image]Card_Blue' AS Image_Blue,
	N'White' AS White,
	N'[Image]Card_White' AS Image_White,
	N'I' AS I,
	N'W' AS W,
	N'Y' AS Y,
	N'P' AS P,
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
LEFT JOIN TR_Register aS R1
	ON MR1.F_RegisterID=R1.F_RegisterID
LEFT JOIN TC_Delegation as D1
	ON R1.F_DelegationID=D1.F_DelegationID
LEFT JOIN TR_Register_Des AS RD1
	ON MR1.F_RegisterID=RD1.F_RegisterID AND RD1.F_LanguageCode=N'ENG'
		
LEFT JOIN TS_Match_Split_Result AS MSR_A1
	ON MR1.F_MatchID=MSR_A1.F_MatchID AND MSR_A1.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A1.F_MatchSplitID=1
LEFT JOIN TR_Register_Des AS RD_A1 
	ON MSR_A1.F_RegisterID=RD_A1.F_RegisterID AND RD_A1.F_LanguageCode=N'ENG'
	
LEFT JOIN TS_Match_Split_Result AS MSR_A2
	ON MR1.F_MatchID=MSR_A2.F_MatchID AND MSR_A2.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A2.F_MatchSplitID=2
LEFT JOIN TR_Register_Des AS RD_A2 
	ON MSR_A2.F_RegisterID=RD_A2.F_RegisterID AND RD_A2.F_LanguageCode=N'ENG'

LEFT JOIN TS_Match_Split_Result AS MSR_A3
	ON MR1.F_MatchID=MSR_A3.F_MatchID AND MSR_A3.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A3.F_MatchSplitID=3
LEFT JOIN TR_Register_Des AS RD_A3 
	ON MSR_A3.F_RegisterID=RD_A3.F_RegisterID AND RD_A3.F_LanguageCode=N'ENG'

LEFT JOIN TS_Match_Split_Result AS MSR_A4
	ON MR1.F_MatchID=MSR_A4.F_MatchID AND MSR_A4.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A4.F_MatchSplitID=4
LEFT JOIN TR_Register_Des AS RD_A4 
	ON MSR_A4.F_RegisterID=RD_A4.F_RegisterID AND RD_A4.F_LanguageCode=N'ENG'
	
LEFT JOIN TS_Match_Split_Result AS MSR_A5
	ON MR1.F_MatchID=MSR_A5.F_MatchID AND MSR_A5.F_CompetitionPosition=MR1.F_CompetitionPosition AND MSR_A5.F_MatchSplitID=5
LEFT JOIN TR_Register_Des AS RD_A5 
	ON MSR_A5.F_RegisterID=RD_A5.F_RegisterID AND RD_A5.F_LanguageCode=N'ENG'	
LEFT JOIN TS_Match_Result AS MR2
	ON M.F_MatchID=MR2.F_MatchID and MR2.F_CompetitionPosition=2
LEFT JOIN TR_Register aS R2
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

