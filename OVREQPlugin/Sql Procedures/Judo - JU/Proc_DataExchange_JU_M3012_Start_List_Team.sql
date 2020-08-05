IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_JU_M3012_Start_List_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_JU_M3012_Start_List_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_DataExchange_JU_M3012_Start_List_Team]
--描    述: 柔道项目数据交换中 秩序单(团体)(M3012).
--创 建 人: 邓年彩
--日    期: 2010年12月29日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
	20110330				宁顺泽		当内容体为空时不发送消息
*/



CREATE PROCEDURE [dbo].[Proc_DataExchange_JU_M3012_Start_List_Team]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	-----------------------------------------------------------------------------------------------
	-- 当比赛不为 Team 时, 返回
	-----------------------------------------------------------------------------------------------
	IF NOT EXISTS (
		SELECT E.F_EventID
		FROM TS_Match AS M
		INNER JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		INNER JOIN TS_Event AS E
			ON P.F_EventID = E.F_EventID
		WHERE M.F_MatchID = @MatchID
			AND E.F_PlayerRegTypeID = 3
	)
		RETURN
	
	-----------------------------------------------------------------------------------------------
	-- 当比赛存在参赛者没有确认时, 返回
	-----------------------------------------------------------------------------------------------		
	IF EXISTS (
		SELECT MR.F_CompetitionPosition
		FROM TS_Match_Result AS MR
		WHERE MR.F_MatchID = @MatchID
			AND MR.F_RegisterID IS NULL
	)
		RETURN
		
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
	
	SET @Code = 'M3012'
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
	DECLARE @Start_List				NVARCHAR(MAX)
	DECLARE @Referee				NVARCHAR(MAX)
		
	SELECT @Start_List = (
		SELECT Start_List.Reg_ID
			, Start_List.BW
			, Athlete.Registration
			, Athlete.Bib
			, Athlete.[Order]
		FROM (
			SELECT 
			MR.F_RegisterID
			,MR.F_CompetitionPosition
				, ISNULL(R.F_RegisterCode, N'') AS Reg_ID
				, BW = CASE MR.F_CompetitionPositionDes1 WHEN 1 THEN N'B' ELSE N'W' END
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_RegisterID IS NOT NULL AND MR.F_RegisterID <> -1
		) AS Start_List
		LEFT JOIN (
			SELECT RM.F_RegisterID
				, ISNULL(R.F_RegisterCode, N'') AS Registration
				, ISNULL(R.F_Bib, N'') AS Bib
				, ISNULL(CONVERT(NVARCHAR(10), RM.F_Order), N'') AS [Order]
			FROM TR_Register_Member AS RM
			INNER JOIN TR_Register AS R
				ON RM.F_MemberRegisterID = R.F_RegisterID
		) AS Athlete
			ON Start_List.F_RegisterID=Athlete.F_RegisterID AND Athlete.Registration<>N''
		ORDER BY Start_List.BW
			, Athlete.[Order]
		FOR XML AUTO
	)
	
	SELECT @Referee = (
		SELECT Referee.Registration
			, Referee.RJ_NO
			, Referee.[Function]
		FROM (
			SELECT ISNULL(R.F_RegisterCode, N'') AS Registration
				, ISNULL(R.F_Bib, N'') AS RJ_NO
				, ISNULL(F.F_FunctionCode, N'') AS [Function]
			FROM TS_Match_Servant AS MS
			LEFT JOIN TR_Register AS R
				ON MS.F_RegisterID = R.F_RegisterID
			LEFT JOIN TD_Function AS F
				ON MS.F_FunctionID = F.F_FunctionID
			LEFT JOIN TD_Function_Des AS FD
				ON MS.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @Language
			WHERE MS.F_MatchID = @MatchID
		) AS Referee
		FOR XML AUTO
	)
	
	SET @Content = ISNULL(@Start_List, N'') + ISNULL(@Referee, N'')
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

/*

-- Just for test
EXEC [Proc_DataExchange_JU_M3012_Start_List_Team] 212
EXEC [Proc_DataExchange_JU_M3012_Start_List_Team] 213
EXEC [Proc_DataExchange_JU_M3012_Start_List_Team] 214
EXEC [Proc_DataExchange_JU_M3012_Start_List_Team] 215

*/