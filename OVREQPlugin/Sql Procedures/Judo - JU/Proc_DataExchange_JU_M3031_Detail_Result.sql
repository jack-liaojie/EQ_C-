IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_JU_M3031_Detail_Result]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_JU_M3031_Detail_Result]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_DataExchange_JU_M3031_Detail_Result]
--描    述: 柔道项目数据交换中 过程成绩(M3031).
--创 建 人: 邓年彩
--日    期: 2010年12月30日 星期四
--修改记录：
/*			
	日期					修改人		修改内容
	20100330				宁顺泽		当内容体为空时不发送消息
*/



CREATE PROCEDURE [dbo].[Proc_DataExchange_JU_M3031_Detail_Result]
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
	
	SET @Code = 'M3031'
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
	DECLARE @Detail_Result			NVARCHAR(MAX)
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
		SELECT @Detail_Result = (
			SELECT Detail_Result.Match_No AS Match_No
				, Detail_Result.Registration
				, Detail_Result.BW
				, Detail_Result.ContestTime
				, Detail_Result.IPP
				, Detail_Result.WAZ
				, Detail_Result.YUK
				, Detail_Result.KOK
				, Detail_Result.S
				, Detail_Result.H
				, Detail_Result.X
				, Detail_Result.GoldenScore
			FROM (
				SELECT 1 AS Match_No
					, CASE R.F_RegisterID WHEN -1 THEN N'NULL' ELSE ISNULL(R.F_RegisterCode, N'') END AS Registration
					, ISNULL(R.F_Bib, N'') AS Bib
					, CASE MR.F_CompetitionPositionDes1 WHEN 1 THEN N'B' ELSE N'W' END AS BW
					, ISNULL(M.F_MatchComment4, N'') AS ContestTime					
					, ISNULL(MR.F_PointsNumDes1, 0) AS IPP
					, ISNULL(MR.F_PointsNumDes2, 0) AS WAZ
					, ISNULL(MR.F_PointsNumDes3, 0) AS YUK
					, 0 AS KOK
					, ISNULL(MR.F_PointsNumDes4, 0) AS S
					, CASE MR.F_PointsCharDes4 WHEN N'H' THEN 1 ELSE 0 END AS H
					, CASE MR.F_PointsCharDes4 WHEN N'X' THEN 1 ELSE 0 END AS X
					, CASE M.F_MatchComment3 WHEN N'1' THEN 1 ELSE 0 END AS GoldenScore
				FROM TS_Match_Result AS MR
				LEFT JOIN TR_Register AS R
					ON MR.F_RegisterID = R.F_RegisterID
				INNER JOIN TS_Match AS M
					ON MR.F_MatchID = M.F_MatchID
				WHERE MR.F_MatchID = @MatchID
					AND MR.F_RegisterID IS NOT NULL AND MR.F_RegisterID <> -1
			) AS Detail_Result
			ORDER BY Detail_Result.BW
				, Detail_Result.Match_No
			FOR XML AUTO
		)
	END
	ELSE
	BEGIN
		SELECT @Detail_Result = (
			SELECT Detail_Result.Match_No
				, Detail_Result.Registration
				, Detail_Result.BW
				, Detail_Result.ContestTime
				, Detail_Result.IPP
				, Detail_Result.WAZ
				, Detail_Result.YUK
				, Detail_Result.KOK
				, Detail_Result.S
				, Detail_Result.H
				, Detail_Result.X
				, Detail_Result.GoldenScore
			FROM (
				SELECT MSR.F_MatchSplitID AS Match_No
					, CASE R.F_RegisterID WHEN -1 THEN N'NULL' ELSE ISNULL(R.F_RegisterCode, N'') END AS Registration
					, ISNULL(R.F_Bib, N'') AS Bib
					, CASE MR.F_CompetitionPositionDes1 WHEN 1 THEN N'B' ELSE N'W' END AS BW
					, ISNULL(MSI.F_MatchSplitComment2, N'') AS ContestTime
					, ISNULL(MSR.F_PointsNumDes1, 0) AS IPP
					, ISNULL(MSR.F_PointsNumDes2, 0) AS WAZ
					, ISNULL(MSR.F_PointsNumDes3, 0) AS YUK
					, 0 AS KOK
					, ISNULL(MSR.F_SplitPointsNumDes3, 0) AS S
					, CASE MSR.F_PointsCharDes3 WHEN N'H' THEN 1 ELSE 0 END AS H
					, CASE MSR.F_PointsCharDes3 WHEN N'X' THEN 1 ELSE 0 END AS X
					, CASE MSR.F_MatchSplitID WHEN 6 THEN 1 ELSE 0 END AS GoldenScore
				FROM TS_Match_Split_Result AS MSR
				LEFT JOIN TR_Register AS R
					ON MSR.F_RegisterID = R.F_RegisterID
				INNER JOIN TS_Match_Split_Info AS MSI
					ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
				INNER JOIN TS_Match_Result AS MR
					ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition
				WHERE MSR.F_MatchID = @MatchID
					AND MSR.F_RegisterID IS NOT NULL AND MSR.F_RegisterID <> -1
			) AS Detail_Result
			ORDER BY Detail_Result.BW
				, Detail_Result.Match_No
			FOR XML AUTO
		)		
	END
	
	SET @Content = ISNULL(@Detail_Result, N'')
	if @Content=N'' return
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
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 23
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 45
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 25
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 26
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 27
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 28
EXEC [Proc_DataExchange_JU_M3031_Detail_Result] 29

*/