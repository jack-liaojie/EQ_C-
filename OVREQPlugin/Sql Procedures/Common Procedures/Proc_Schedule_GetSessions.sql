IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetSessions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetSessions]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_Schedule_GetSessions]
--描    述：根据查询条件查询符合的Session列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月11日
--修改记录：
/*			
			时间				修改人		修改内容	
			2009年11月10日		邓年彩		修改输出格式, F_SessionDate(只显示日期格式); F_SessionTime(只显示时间格式);
											F_SessionEndTime(只显示时间格式); F_SessionType(未显示);
											使用构造 SQL, 简化存储过程.	
			2009年11月12日		邓年彩		修改存储过程名称, Proc_SearchSessions->Proc_Schedule_GetSessions
			2009年11月13日		邓年彩		修改显示名称, 使之可理解.		
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_GetSessions](
				 @DisciplineID		INT,
				 @DateTime			NVARCHAR(50),
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @SQL NVARCHAR(1000)
	
	SET @SQL = ' 
		SELECT A.F_SessionID
			, A.F_DisciplineID
			, LEFT(CONVERT(NVARCHAR(30), A.F_SessionDate, 120), 10) AS [Date]
			, A.F_SessionNumber AS [Number]
			, LEFT(CONVERT(NVARCHAR(30), A.F_SessionTime, 108), 5) AS [StartTime]
			, LEFT(CONVERT(NVARCHAR(30), A.F_SessionEndTime, 108), 5) AS [EndTime]
			, A.F_SessionTypeID
			, B.F_SessionTypeLongName AS [Type]
		FROM TS_Session AS A 
		LEFT JOIN TC_SessionType_Des AS B
			ON A.F_SessionTypeID = B.F_SessionTypeID AND B.F_LanguageCode = ''' + @LanguageCode + '''
		WHERE A.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10))

	-- 添加条件
	IF ((@DateTime IS NOT NULL) AND (@DateTime <> ''))
	BEGIN
		SET @SQL = @SQL + 
			' AND LEFT(CONVERT (NVARCHAR(100), A.F_SessionDate, 120), 10) = LTRIM(RTRIM(''' + @DateTime + '''))'
	END

	SET @SQL = @SQL + ' ORDER BY A.F_SessionDate, A.F_SessionNumber ' 

	EXEC (@SQL)	

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
GO

/*

EXEC [Proc_Schedule_GetSessions] 1, '2009-09-26', ENG
EXEC [Proc_Schedule_GetSessions] 1, NULL, ENG

*/

