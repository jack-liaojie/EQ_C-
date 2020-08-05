IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetDisciplineDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetDisciplineDates]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Schedule_GetDisciplineDates]
--描    述：得到一个大项的比赛日列表 
--参数说明： 
--说    明：
--创 建 人：邓年彩
--日    期：2009年11月09日
--修改记录：
/*			
			时间				修改人		修改内容		
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_GetDisciplineDates](
				 @DisciplineID		INT,
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SELECT A.F_DisciplineDateID
		, A.F_DateOrder AS [Order]
		, LEFT(CONVERT (NVARCHAR(100), A.F_Date, 120), 10) AS [Date]
		, B.F_DateLongDescription AS [Long Description]
		, B.F_DateShortDescription AS [Short Description]
		, B.F_DateComment AS [Comment]
	FROM TS_DisciplineDate AS A
	LEFT JOIN TS_DisciplineDate_Des AS B
		ON A.F_DisciplineDateID = B.F_DisciplineDateID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID
	ORDER BY A.F_DateOrder

Set NOCOUNT OFF
End	
GO

--exec [Proc_Schedule_GetDisciplineDates] 1, 'ENG'