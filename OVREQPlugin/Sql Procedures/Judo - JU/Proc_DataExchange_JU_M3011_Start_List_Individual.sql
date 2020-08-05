IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_JU_M3011_Start_List_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_JU_M3011_Start_List_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_DataExchange_JU_M3011_Start_List_Individual]
--��    ��: �����Ŀ���ݽ����� ���򵥣�����/�޲��(M3011).
--�� �� ��: �����
--��    ��: 2010��12��29�� ������
--�޸ļ�¼��
/*			
	����				�޸���	�޸����� ---- 
	
	2011��3��26��	    ��˳��     ���������ڲ�����û��ȷ��ʱ, ����
	2011��3��30��		��˳��		��������Ϊ��ʱ������
*/


CREATE PROCEDURE [dbo].[Proc_DataExchange_JU_M3011_Start_List_Individual]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	-----------------------------------------------------------------------------------------------
	-- ��������Ϊ Individual ʱ, ����
	-----------------------------------------------------------------------------------------------	
	IF NOT EXISTS (
		SELECT E.F_EventID
		FROM TS_Match AS M
		INNER JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		INNER JOIN TS_Event AS E
			ON P.F_EventID = E.F_EventID
		WHERE M.F_MatchID = @MatchID
			AND E.F_PlayerRegTypeID = 1 
	)
		RETURN
		
	-----------------------------------------------------------------------------------------------
	-- ���������ڲ�����û��ȷ��ʱ, ����
	-----------------------------------------------------------------------------------------------		
	IF EXISTS (
		SELECT MR.F_CompetitionPosition
		FROM TS_Match_Result AS MR
		WHERE MR.F_MatchID = @MatchID
			AND MR.F_RegisterID IS NULL
	)
		RETURN

	-----------------------------------------------------------------------------------------------
	-- �������
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
	
	SET @Code = 'M3011'
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
		SELECT Start_List.Registration
			, Start_List.Bib
			, Start_List.BW
		FROM (
			SELECT CASE R.F_RegisterID WHEN -1 THEN N'NULL' ELSE ISNULL(R.F_RegisterCode, N'') END AS Registration
				, ISNULL(R.F_Bib, N'') AS Bib
				, BW = CASE MR.F_CompetitionPositionDes1 WHEN 1 THEN N'B' ELSE N'W' END
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_RegisterID IS NOT NULL AND MR.F_RegisterID <> -1 
		) AS Start_List where Start_List.Bib<>N''
		ORDER BY Start_List.BW
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
		) AS Referee where Referee.RJ_NO<>N'' AND Referee.[Function]<>N''
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
GO
/*

-- Just for test
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 23
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 24
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 25
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 26
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 27
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 28
EXEC [Proc_DataExchange_JU_M3011_Start_List_Individual] 29

*/