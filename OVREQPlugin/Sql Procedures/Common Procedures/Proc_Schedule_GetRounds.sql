IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetRounds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetRounds]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Schedule_GetRounds]
--描    述：得到Event下所有的Round
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月14日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年11月12日		邓年彩		将存储过程名称由 Proc_GetRounds->Proc_Schedule_GetRounds
			2009年11月13日		邓年彩		使用构造 SQL, 简化存储过程; 取消 RoundComment 的显示;
											修改显示名称, 使之可理解.
*/


CREATE PROCEDURE [dbo].[Proc_Schedule_GetRounds](
				 @DisciplineID		INT,
				 @EventID			INT,
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @SQL NVARCHAR(1000)

	SET @SQL = ' 
		SELECT C.F_EventLongName AS [Event]
			, A.F_Order AS [Order]
			, A.F_RoundCode AS [Code]
			, B.F_RoundLongName AS [LongName]
			, B.F_RoundShortName AS [ShortName]
			, A.F_Comment AS [Comment]
			, A.F_RoundID
			, A.F_EventID
		FROM TS_Round AS A 
		LEFT JOIN TS_Round_Des AS B 
			ON A.F_RoundID = B.F_RoundID AND B.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Event_Des AS C 
			ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Event AS D
			ON A.F_EventID = D.F_EventID
		WHERE D.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10))

	IF ((@EventID IS NOT NULL) AND (@EventID <> 0))
	BEGIN
		SET @SQL = @SQL + ' AND A.F_EventID = ' + CAST(@EventID AS NVARCHAR(10))
	END

	SET @SQL = @SQL + 'ORDER BY D.F_Order, A.F_Order'

	EXEC (@SQL)
						
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
	-- Just from test
	DECLARE @DisciplineID	INT
	DECLARE @EventID		INT
	DECLARE @LanguageCode	CHAR(3)
	
	SET @DisciplineID = 1
	SET @EventID = NULL
	SET @LanguageCode = 'CHN'

	EXEC [Proc_Schedule_GetRounds] @DisciplineID, @EventID, @LanguageCode
*/

