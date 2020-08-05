IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetEventList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_BD_GetEventList]
--描    述: 获取 Event 列表, 主要用于 C32C (Entry By NOC) 报表
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年09月09日
--修改记录：
/*			
			时间				修改人		修改内容	
			2009年11月12日		邓年彩		添加参数 @DisciplineID, 使之不受 Active 的影响;
											使用构造 SQL 的方法简化存储过程.
			2010年1月12日		邓年彩		去除参数 @LanguageCode, 添加一些参数.
			2010年1月28日		邓年彩		日期取大写.
			2010年2月4日		邓年彩		取日期使用统一的函数 [Func_Report_KR_GetDateTime], 日期不以 0 开头.
			2010年5月12日		邓年彩		获取小项的 MatchType: 1-组手单人, 2-组手团体, 3-型单人, 4-型团体.
*/



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetEventList]
	@DisciplineID				INT,
	@EventID					INT		-- <= 0 获取所有小项列表
AS
BEGIN
SET NOCOUNT ON

	DECLARE @LanguageCode_ENG	CHAR(3)
	DECLARE @LanguageCode_CHN	CHAR(3)
	SET @LanguageCode_ENG = 'ENG'
	SET @LanguageCode_CHN = 'CHN'

	DECLARE @SQL	NVARCHAR(4000)
	
	SET LANGUAGE 'us_english'

	SET @SQL = '
		SELECT A.F_EventID AS [EventID]
			, UPPER(B.F_EventLongName) AS [Event_ENG]
			, UPPER(C.F_EventLongName) AS [Event_CHN]
			, A.F_Order AS [Order]
			, A.F_EventCode AS [EventCode]
			, dbo.Fun_GetWeekdayName(A.F_OpenDate, ''' + @LanguageCode_ENG + ''') AS [Weekday_ENG]
			, dbo.Fun_GetWeekdayName(A.F_OpenDate, ''' + @LanguageCode_CHN + ''') AS [Weekday_CHN]
			, dbo.[Func_Report_TE_GetDateTime](A.F_OpenDate, 1, ''' + @LanguageCode_ENG + ''') AS [Date]
			, LEFT(CONVERT(NVARCHAR(20), A.F_OpenDate, 114), 5) AS [StartTime]
			, D.F_GenderCode AS [Gender]
			, MatchType = CASE UPPER(B.F_EventComment)
				WHEN ''KUMITE'' THEN CASE A.F_PlayerRegTypeID WHEN 1 THEN 1 ELSE 2 END
				WHEN ''KATA'' THEN CASE A.F_PlayerRegTypeID WHEN 1 THEN 3 ELSE 4 END
			END
		FROM TS_Event AS A
		LEFT JOIN TS_Event_Des AS B
			ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = ''' + @LanguageCode_ENG + ''' 
		LEFT JOIN TS_Event_Des AS C
			ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = ''' + @LanguageCode_CHN + ''' 
		LEFT JOIN TC_Sex AS D
			ON A.F_SexCode = D.F_SexCode
	'
	
	IF @EventID <= 0
	BEGIN
		SET @SQL = @SQL + ' 
			WHERE A.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10)) + '
		'
	END
	ELSE
	BEGIN
		SET @SQL = @SQL + ' 
			WHERE A.F_EventID = ' + CAST(@EventID AS NVARCHAR(10)) + '
		'
	END

	EXEC (@SQL)

SET NOCOUNT OFF
END

GO


