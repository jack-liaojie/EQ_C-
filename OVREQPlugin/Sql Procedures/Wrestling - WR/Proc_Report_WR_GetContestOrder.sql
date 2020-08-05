IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetContestOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetContestOrder]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetContestOrder]
--描    述: 获取 C58 Contest Order 的主要信息.
--创 建 人: 宁顺泽
--日    期: 2011年10月17日 星期1
--修改记录：
/*			
	日期					修改人		修改内容
	2011年3月30号			宁顺泽		为C58报表添加裁判数据，修改比赛时间
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetContestOrder]
	@SessionID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT S.F_SessionNumber AS [Session]
		, CD.F_CourtLongName AS [Court]
		, [Status] = CASE WHEN M.F_MatchStatusID IN (100, 110) THEN N'F' END
		, M.F_RaceNum AS [ContestOrder]
		, SD.F_SexLongName AS [Gender]
		, REPLACE(REPLACE(REPLACE(ED.F_EventLongName, N'Men''s GRECO-ROMAN', N'GR'), N'Women''s FREESTYLE', N'FW'),N'Men''s FREESTYLE',N'FS') AS [WeightCategory]
		, dbo.[Func_Report_JU_GetDateTime](M.F_StartTime, 4, 'ENG') AS [Time]
		, PD.F_PhaseLongName AS [Round]
		, MR1.[Name] AS [Name_A]
		, MR1.F_DelegationCode AS [NOCCode_A]
		, MR2.[Name] AS [Name_B]
		, MR2.F_DelegationCode AS [NOCCode_B]
		,MR1.F1 AS F_Function1
		,MR1.F2 AS F_Function2
		,MR1.F3 AS F_Function3
		,MR1.IP AS I1
		,MR2.IP AS I2
		,MR1.Points AS Pt1
		,Mr2.Points as Pt2
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	LEFT JOIN TC_Sex_Des AS SD
		ON E.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID = S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON M.F_CourtID = C.F_CourtID
	LEFT JOIN TC_Court_Des AS CD
		ON C.F_CourtID = CD.F_CourtID AND CD.F_LanguageCode = @LanguageCode
	LEFT JOIN
		(
			SELECT MR.F_MatchID
				,case when M.F_MatchStatusID<99 then N'' else convert(nvarchar(10),isnull(MR.F_Points,N''))end  as Points
				, [Name] = CASE 
					WHEN R.F_RegisterID IS NOT NULL THEN RD.F_PrintLongName 
					WHEN MR.F_SourceMatchID IS NOT NULL AND MR.F_SourceMatchRank IS NOT NULL
						THEN CASE @LanguageCode
							WHEN 'CHN' THEN CASE MR.F_SourceMatchRank 
								WHEN 1 THEN N'场次' + SM.F_RaceNum + N'胜者'
								WHEN 2 THEN N'场次' + SM.F_RaceNum + N'负者'
							END
							ELSE CASE MR.F_SourceMatchRank 
								WHEN 1 THEN N'WINNER OF Bout ' + SM.F_RaceNum
								WHEN 2 THEN N'LOSER OF Bout ' + SM.F_RaceNum
							END
						END
					ELSE MRD.F_CompetitorSourceDes
				END
				, MR.F_RegisterID
				, D.F_DelegationCode
				,ISNULL(case when FD1.F_FunctionShortName=N'Referee' then TRD1.F_Bib
			when FD2.F_FunctionShortName=N'Referee' then TRD2.F_Bib
			when FD3.F_FunctionShortName=N'Referee' then TRD3.F_Bib
		END,N''	) as F1
				,ISNULL(case when FD1.F_FunctionShortName=N'Judge' then TRD1.F_Bib
			when FD2.F_FunctionShortName=N'Judge' then TRD2.F_Bib
			when FD3.F_FunctionShortName=N'Judge' then TRD3.F_Bib
		END,N'') as F2
				,ISNULL(case when Lower(FD1.F_FunctionShortName)=N'mat chairman' then TRD1.F_Bib
			when Lower(FD2.F_FunctionShortName)=N'mat chairman' then TRD2.F_Bib
			when Lower(FD3.F_FunctionShortName)=N'mat chairman' then TRD3.F_Bib
		END,N'') as F3
				,ISNULL(I.F_InscriptionComment2,N'') as IP
			FROM TS_Match_Result AS MR
			LEFT JOIN TS_Match_Result_Des AS MRD
				ON MR.F_MatchID = MRD.F_MatchID AND MR.F_CompetitionPosition = MRD.F_CompetitionPosition
					AND MRD.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			LEFT JOIN TS_Match AS SM
				ON MR.F_SourceMatchID = SM.F_MatchID
			LEFT JOIN TS_Match AS M
				ON M.F_MatchID=MR.F_MatchID
			LEFT JOIN TS_Phase AS  P
				ON P.F_PhaseID=M.F_PhaseID
			LEFT JOIN TR_Inscription AS I
				ON I.F_RegisterID=R.F_RegisterID  AND I.F_EventID=P.F_EventID
			LEFT JOIN TS_Match_Servant AS TMS1
				ON MR.F_MatchID=TMS1.F_MatchID and TMS1.F_Order=1
			LEFT JOIN TR_Register AS TRD1
				ON TMS1.F_RegisterID=TRD1.F_RegisterID
			LEFT JOIN TD_Function_Des AS FD1
				ON FD1.F_FunctionID = TMS1.F_FunctionID AND FD1.F_LanguageCode = N'ENG' 
			LEFT JOIN TS_Match_Servant AS TMS2
				ON MR.F_MatchID=TMS2.F_MatchID and TMS2.F_Order=2
			LEFT JOIN TR_Register AS TRD2
				ON TMS2.F_RegisterID=TRD2.F_RegisterID 
			LEFT JOIN TD_Function_Des AS FD2
				ON FD2.F_FunctionID = TMS2.F_FunctionID AND FD2.F_LanguageCode = N'ENG' 
			LEFT JOIN TS_Match_Servant AS TMS3
				ON MR.F_MatchID=TMS3.F_MatchID and TMS3.F_Order=3
			LEFT JOIN TR_Register AS TRD3
				ON TMS3.F_RegisterID=TRD3.F_RegisterID 
			LEFT JOIN TD_Function_Des AS FD3
				ON FD3.F_FunctionID = TMS3.F_FunctionID AND FD3.F_LanguageCode = N'ENG' 
			WHERE MR.F_CompetitionPositionDes1 = 1
		) AS MR1
		ON M.F_MatchID = MR1.F_MatchID
	LEFT JOIN
		(
			SELECT MR.F_MatchID
				,case when M.F_MatchStatusID<99 then N'' else convert(nvarchar(10),isnull(MR.F_Points,N''))end  as Points
				,MR.F_Points
				, [Name] = CASE 
					WHEN R.F_RegisterID IS NOT NULL THEN RD.F_PrintLongName 
					WHEN MR.F_SourceMatchID IS NOT NULL AND MR.F_SourceMatchRank IS NOT NULL
						THEN CASE @LanguageCode
							WHEN 'CHN' THEN CASE MR.F_SourceMatchRank 
								WHEN 1 THEN N'场次' + SM.F_RaceNum + N'胜者'
								WHEN 2 THEN N'场次' + SM.F_RaceNum + N'负者'
							END
							ELSE CASE MR.F_SourceMatchRank 
								WHEN 1 THEN N'WINNER OF Bout ' + SM.F_RaceNum
								WHEN 2 THEN N'LOSER OF Bout ' + SM.F_RaceNum
							END
						END
					ELSE MRD.F_CompetitorSourceDes
				END
				, D.F_DelegationCode
				, MR.F_RegisterID
				,ISNULL(I.F_InscriptionComment2,N'') AS IP
			FROM TS_Match_Result AS MR
			LEFT JOIN TS_Match_Result_Des AS MRD
				ON MR.F_MatchID = MRD.F_MatchID AND MR.F_CompetitionPosition = MRD.F_CompetitionPosition
					AND MRD.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			LEFT JOIN TS_Match AS SM
				ON MR.F_SourceMatchID = SM.F_MatchID
			LEFT JOIN TS_Match AS M
				ON M.F_MatchID=MR.F_MatchID
			LEFT JOIN TS_Phase AS  P
				ON P.F_PhaseID=M.F_PhaseID
			LEFT JOIN TR_Inscription AS I
				ON I.F_RegisterID=R.F_RegisterID  AND I.F_EventID=P.F_EventID
			WHERE MR.F_CompetitionPositionDes1 = 2
		) AS MR2
		ON M.F_MatchID = MR2.F_MatchID
	WHERE (@SessionID = -1 OR M.F_SessionID = @SessionID)
		AND ISNULL(M.F_RaceNum,N'')<>N''
		ORDER BY S.F_SessionNumber, C.F_CourtCode,Convert(int,ISNULL(M.F_RaceNum,N'0'))

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetContestOrder] 927, 'ENG'
EXEC [Proc_Report_JU_GetContestOrder] 927, 'CHN'

*/