IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_GetEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_GetEvents]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_TVG_WR_GetEvents]
--描    述: S宁顺泽
--日    期: 2011年5月20日 星期3
--修改记录：
/*			
			日期					修改人		修改内容

*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_GetEvents]
	@DisciplineCode						CHAR(2),
	@SessionID							INT = -1,
	@CourtCode							NVARCHAR(10)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ProcName			NVARCHAR(100)
	
	SET @ProcName = N'[dbo].[Proc_SCB_' + @DisciplineCode + '_GetEvents]'
	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@ProcName) AND type in (N'P', N'PC'))
	BEGIN
		DECLARE @SQL			NVARCHAR(4000)
		SET @SQL = N'EXEC ' + @ProcName + N' ' + @DisciplineCode + N', ' + CONVERT(NVARCHAR(10), @SessionID)
		EXEC(@SQL)
		RETURN
	END

	IF @SessionID = -1
	BEGIN
		SELECT ED1.F_EventShortName AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, E.F_EventID
		FROM TS_Event AS E
		LEFT JOIN TS_Event_Des AS ED1
			ON E.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2
			ON E.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		INNER JOIN TS_Discipline AS D
			ON E.F_DisciplineID = D.F_DisciplineID
		WHERE D.F_DisciplineCode = @DisciplineCode
		ORDER BY ED1.F_EventShortName
	END
	ELSE
	BEGIN
		SELECT DISTINCT ED1.F_EventShortName AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, P.F_EventID
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event_Des AS ED1
			ON P.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2
			ON P.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		LEFT JOIN TC_Court AS C
			ON M.F_CourtID=C.F_CourtID
		LEFT JOIN TC_Court_Des AS CD 
			ON CD.F_CourtID=C.F_CourtID AND CD.F_LanguageCode=N'ENG'
		WHERE M.F_SessionID = @SessionID AND C.F_CourtCode=@CourtCode
		ORDER BY ED1.F_EventShortName
	END

SET NOCOUNT OFF
END

/*


*/