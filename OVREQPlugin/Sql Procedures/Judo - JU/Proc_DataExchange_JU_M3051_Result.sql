IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_JU_M3051_Result]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_JU_M3051_Result]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_DataExchange_JU_M3051_Result]
--描    述: 柔道项目数据交换中 阶段成绩(M3051).
--创 建 人: 邓年彩
--日    期: 2010年12月30日 星期四
--修改记录：
/*			
	日期					修改人		修改内容
	2011年3月30号			宁顺泽		当内容体为空时不应该发送
*/



CREATE PROCEDURE [dbo].[Proc_DataExchange_JU_M3051_Result]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON
	
	-----------------------------------------------------------------------------------------------
	-- 定义变量
	-----------------------------------------------------------------------------------------------	
	DECLARE @OutputXML				NVARCHAR(MAX)
	
	DECLARE @Version				VARCHAR(10)
	DECLARE @Category				VARCHAR(3)
	DECLARE @Origin					VARCHAR(3)
	
	DECLARE @RSC					VARCHAR(9)
	DECLARE @Discipline				VARCHAR(2)
	DECLARE @Gender					VARCHAR(1)
	DECLARE @Event					VARCHAR(3)
	DECLARE @Phase					VARCHAR(1)
	DECLARE @Unit					VARCHAR(2)
	DECLARE @Venue					VARCHAR(3)
	
	DECLARE @Code					VARCHAR(5)
	DECLARE @Type					VARCHAR(10)
	DECLARE @Language				VARCHAR(3)
	DECLARE @Date					VARCHAR(8)
	DECLARE @Time					VARCHAR(9)
	
	DECLARE @MessageProperty		NVARCHAR(MAX)
	DECLARE @Content				NVARCHAR(MAX)
	
	-----------------------------------------------------------------------------------------------
	-- Message Header
	-----------------------------------------------------------------------------------------------
	SET @Version = '1.0'
	SET @Category = 'VRS'
	SET @Origin = 'VRS'
	
	SELECT @Discipline = RIGHT(D.F_DisciplineCode, 2)
		, @Gender = RIGHT(S.F_GenderCode, 1)
		, @Event = RIGHT(E.F_EventCode, 3)
		, @Phase = RIGHT(P.F_PhaseCode, 1)
		, @Unit = RIGHT(M.F_MatchCode, 2)
		, @Venue = ISNULL(RIGHT(V.F_VenueCode, 3), '000')
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	INNER JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V
		ON M.F_VenueID = V.F_VenueID
	WHERE M.F_MatchID = @MatchID
	
	SET @RSC = @Discipline + @Gender + @Event + @Phase + @Unit
	
	SET @Code = 'M3051'
	SET @Type = 'DATA'
	SET @Language = ISNULL(@Language, 'ENG')
	SET @Date = REPLACE(CONVERT(NVARCHAR(30), GETDATE(), 112), '-', '')
	SET @Time = REPLACE(CONVERT(NVARCHAR(30), GETDATE(), 114), ':', '')
	
	SET @MessageProperty 
		= N' Version = "' + @Version + '"'
		+ N' Category = "' + @Category + '"' 
		+ N' Origin = "' + @Origin + '"'
		+ N' RSC = "' + @RSC + '"'
		+ N' Discipline = "'+ @Discipline +'"'
		+ N' Gender = "' + @Gender + '"'
		+ N' Event = "' + @Event + '"'
		+ N' Phase = "' + @Phase + '"'
		+ N' Unit = "' + @Unit + '"'
		+ N' Venue ="' + @Venue + '"'
		+ N' Code = "' + @Code + '"'
		+ N' Type = "' + @Type + '"'
		+ N' Language = "' + @Language + '"'
		+ N' Date ="' + @Date + '"'
		+ N' Time= "' + @Time + '"'	
		
	-----------------------------------------------------------------------------------------------
	-- Content
	-----------------------------------------------------------------------------------------------
	DECLARE @Result			NVARCHAR(MAX)
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
		SELECT @Result = (
			SELECT Duel.Reg_IDA
				, Duel.Reg_IDB
				, Duel.WinsA
				, Duel.WinsB
				, Duel.T_Mark
				, Duel.WLA
				, Duel.WLB
				, Duel.StatusA
				, Duel.StatusB
				, Duel.[Status]
				, Duel.PointsA
				, Duel.PointsB
				, Match.Match_No
				, Match.T_Mark
				, Match.WLA
				, Match.WLB
				, Match.StatusA
				, Match.StatusB
				, Match.[Status]
				, Match.Technique
				, Match.GoldenScore
				, Match.PointsA
				, Match.PointsB
			FROM (
				SELECT M.F_MatchID
					, ISNULL(RA.F_RegisterCode, N'') AS Reg_IDA
					, ISNULL(RB.F_RegisterCode, N'') AS Reg_IDB
					, CASE MRA.F_ResultID WHEN 1 THEN 1 ELSE 0 END AS WinsA
					, CASE MRB.F_ResultID WHEN 1 THEN 1 ELSE 0 END AS WinsB
					, CASE WHEN MRA.F_PointsCharDes1 = N'1' OR MRB.F_PointsCharDes1 = N'1' THEN N'T' ELSE N'' END AS T_Mark
					, CASE MRA.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLA
					, CASE MRB.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLB
					, ISNULL(IA.F_IRMCode, N'') AS StatusA
					, ISNULL(IB.F_IRMCode, N'') AS StatusB
					, dbo.[Func_DataExchage_ConvertScheduleStatus](M.F_MatchStatusID) AS [Status]
					, 0 AS PointsA
					, 0 AS PointsB
				FROM TS_Match AS M
				LEFT JOIN TS_Match_Result AS MRA
					ON M.F_MatchID = MRA.F_MatchID AND MRA.F_CompetitionPositionDes1 = 1 AND MRA.F_RegisterID <> -1
				LEFT JOIN TR_Register AS RA
					ON MRA.F_RegisterID = RA.F_RegisterID
				LEFT JOIN TC_IRM AS IA
					ON MRA.F_IRMID = IA.F_IRMID
				LEFT JOIN TS_Match_Result AS MRB
					ON M.F_MatchID = MRB.F_MatchID AND MRB.F_CompetitionPositionDes1 = 2 AND MRB.F_RegisterID <> -1
				LEFT JOIN TR_Register AS RB
					ON MRB.F_RegisterID = RB.F_RegisterID
				LEFT JOIN TC_IRM AS IB
					ON MRB.F_IRMID = IB.F_IRMID
				WHERE M.F_MatchID = @MatchID AND M.F_MatchStatusID in(100,110)
			) AS Duel
			LEFT JOIN (
				SELECT M.F_MatchID
					, 1 AS Match_No
					, CASE WHEN MRA.F_PointsCharDes1 = N'1' OR MRB.F_PointsCharDes1 = N'1' THEN N'T' ELSE N'' END AS T_Mark
					, CASE MRA.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLA
					, CASE MRB.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLB
					, ISNULL(IA.F_IRMCode, N'') AS StatusA
					, ISNULL(IB.F_IRMCode, N'') AS StatusB
					, dbo.[Func_DataExchage_ConvertScheduleStatus](M.F_MatchStatusID) AS [Status]
					, ISNULL(M.F_MatchComment5, N'') AS Technique
					, CASE M.F_MatchComment3 WHEN N'1' THEN 1 ELSE 0 END AS GoldenScore
					, 0 AS PointsA
					, 0 AS PointsB
				FROM TS_Match AS M
				LEFT JOIN TS_Match_Result AS MRA
					ON M.F_MatchID = MRA.F_MatchID AND MRA.F_CompetitionPositionDes1 = 1 AND MRA.F_RegisterID <> -1
				LEFT JOIN TR_Register AS RA
					ON MRA.F_RegisterID = RA.F_RegisterID
				LEFT JOIN TC_IRM AS IA
					ON MRA.F_IRMID = IA.F_IRMID
				LEFT JOIN TS_Match_Result AS MRB
					ON M.F_MatchID = MRB.F_MatchID AND MRB.F_CompetitionPositionDes1 = 2 AND MRB.F_RegisterID <> -1
				LEFT JOIN TR_Register AS RB
					ON MRB.F_RegisterID = RB.F_RegisterID
				LEFT JOIN TC_IRM AS IB
					ON MRB.F_IRMID = IB.F_IRMID
				WHERE M.F_MatchID = @MatchID AND M.F_MatchStatusID =110
			) AS Match
				ON Duel.F_MatchID = Match.F_MatchID
			ORDER BY Match.Match_No
			FOR XML AUTO
		)
	END
	ELSE
	BEGIN
		SELECT @Result = (
			SELECT Duel.Reg_IDA
				, Duel.Reg_IDB
				, Duel.WinsA
				, Duel.WinsB
				, Duel.T_Mark
				, Duel.WLA
				, Duel.WLB
				, Duel.StatusA
				, Duel.StatusB
				, Duel.[Status]
				, Duel.PointsA
				, Duel.PointsB
				, Match.Match_No
				, Match.T_Mark
				, Match.WLA
				, Match.WLB
				, Match.StatusA
				, Match.StatusB
				, Match.[Status]
				, Match.Technique
				, Match.GoldenScore
				, Match.PointsA
				, Match.PointsB
			FROM (
				SELECT M.F_MatchID
					, ISNULL(RA.F_RegisterCode, N'') AS Reg_IDA
					, ISNULL(RB.F_RegisterCode, N'') AS Reg_IDB
					, MRA.F_WinSets AS WinsA
					, MRB.F_WinSets AS WinsB
					, CASE WHEN MRA.F_PointsCharDes1 = N'1' OR MRB.F_PointsCharDes1 = N'1' THEN N'T' ELSE N'' END AS T_Mark					
					, CASE MRA.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLA
					, CASE MRB.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLB
					, ISNULL(IA.F_IRMCode, N'') AS StatusA
					, ISNULL(IB.F_IRMCode, N'') AS StatusB
					, dbo.[Func_DataExchage_ConvertScheduleStatus](M.F_MatchStatusID) AS [Status]
					, MRA.F_Points AS PointsA
					, MRB.F_Points AS PointsB
				FROM TS_Match AS M
				LEFT JOIN TS_Match_Result AS MRA
					ON M.F_MatchID = MRA.F_MatchID AND MRA.F_CompetitionPositionDes1 = 1 AND MRA.F_RegisterID <> -1
				LEFT JOIN TR_Register AS RA
					ON MRA.F_RegisterID = RA.F_RegisterID
				LEFT JOIN TC_IRM AS IA
					ON MRA.F_IRMID = IA.F_IRMID
				LEFT JOIN TS_Match_Result AS MRB
					ON M.F_MatchID = MRB.F_MatchID AND MRB.F_CompetitionPositionDes1 = 2 AND MRB.F_RegisterID <> -1
				LEFT JOIN TR_Register AS RB
					ON MRB.F_RegisterID = RB.F_RegisterID
				LEFT JOIN TC_IRM AS IB
					ON MRB.F_IRMID = IB.F_IRMID
				WHERE M.F_MatchID = @MatchID 
			) AS Duel
			LEFT JOIN (
				SELECT MSI.F_MatchID
					, MSI.F_MatchSplitID AS Match_No
					, CASE WHEN MSRA.F_PointsCharDes1 = N'1' OR MRB.F_PointsCharDes1 = N'1' THEN N'T' ELSE N'' END AS T_Mark	
					, CASE MSRA.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLA
					, CASE MSRB.F_ResultID WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END AS WLB
					, ISNULL(IA.F_IRMCode, N'') AS StatusA
					, ISNULL(IB.F_IRMCode, N'') AS StatusB
					, dbo.[Func_DataExchage_ConvertScheduleStatus](MSI.F_MatchSplitStatusID) AS [Status]
					, ISNULL(MSI.F_MatchSplitComment3, N'') AS Technique
					, CASE MSI.F_MatchSplitComment1 WHEN 1 THEN 1 ELSE 0 END AS GoldenScore
					, ISNULL(MSRA.F_Points, 0) AS PointsA
					, ISNULL(MSRB.F_Points, 0) AS PointsB
				FROM TS_Match_Split_Info AS MSI
				LEFT JOIN TS_Match_Result AS MRA
					ON MSI.F_MatchID = MRA.F_MatchID AND MRA.F_CompetitionPositionDes1 = 1
				LEFT JOIN TS_Match_Split_Result AS MSRA
					ON MRA.F_MatchID = MSRA.F_MatchID AND MRA.F_CompetitionPosition = MSRA.F_CompetitionPosition
						AND MSI.F_MatchSplitID = MSRA.F_MatchSplitID
				LEFT JOIN TR_Register AS RA
					ON MSRA.F_RegisterID = RA.F_RegisterID
				LEFT JOIN TC_IRM AS IA
					ON MSRA.F_IRMID = IA.F_IRMID
				LEFT JOIN TS_Match_Result AS MRB
					ON MSI.F_MatchID = MRB.F_MatchID AND MRB.F_CompetitionPositionDes1 = 2
				LEFT JOIN TS_Match_Split_Result AS MSRB
					ON MRB.F_MatchID = MSRB.F_MatchID AND MRB.F_CompetitionPosition = MSRB.F_CompetitionPosition
						AND MSI.F_MatchSplitID = MSRB.F_MatchSplitID
				LEFT JOIN TR_Register AS RB
					ON MSRB.F_RegisterID = RB.F_RegisterID
				LEFT JOIN TC_IRM AS IB
					ON MSRB.F_IRMID = IB.F_IRMID
				WHERE  MSI.F_MatchID = @MatchID AND dbo.[Func_DataExchage_ConvertScheduleStatus](MSI.F_MatchSplitStatusID) <> 0
			) AS Match
				ON Duel.F_MatchID = Match.F_MatchID
			ORDER BY Match.Match_No
			FOR XML AUTO
		)
	END
	
	SET @Content = ISNULL(@Result, N'')
	if @Content=N'' return
	if CHARINDEX('<Match/>',@Content)<>0 return
	if CHARINDEX('Reg_IDA=""',@Content)<>0 return
	if CHARINDEX('Reg_IDB=""',@Content)<>0 return
	-----------------------------------------------------------------------------------------------
	-- XML
	-----------------------------------------------------------------------------------------------
	SET @OutputXML 
		= N'<?xml version="1.0" encoding="UTF-8"?>' 
		+ '<Message' + @MessageProperty +'>'
		+ @Content
		+ N'</Message>'

	SELECT @OutputXML AS OutputXML

SET NOCOUNT OFF
END
GO
/*

-- Just for test
EXEC [Proc_DataExchange_JU_M3051_Result] 45
EXEC [Proc_DataExchange_JU_M3051_Result] 62
EXEC [Proc_DataExchange_JU_M3051_Result] 25
EXEC [Proc_DataExchange_JU_M3051_Result] 26
EXEC [Proc_DataExchange_JU_M3051_Result] 27
EXEC [Proc_DataExchange_JU_M3051_Result] 28
EXEC [Proc_DataExchange_JU_M3051_Result] 29

*/