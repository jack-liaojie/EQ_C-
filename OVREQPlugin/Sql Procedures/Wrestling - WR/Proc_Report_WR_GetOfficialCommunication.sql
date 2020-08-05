IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetOfficialCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetOfficialCommunication]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_WR_GetOfficialCommunication]
--描    述：得到OfficialCommunication
--创 建 人：邓年彩
--日    期：2010年10月28日 星期四
/*			
	时间					修改人		修改内容
*/


CREATE PROCEDURE [dbo].[Proc_Report_WR_GetOfficialCommunication]
(
	@DisciplineID		INT,
	@NewsID				INT,
	@Item				INT = -1
)
As
Begin
SET NOCOUNT ON 

	IF @Item <> -1
	BEGIN
		SELECT @NewsID = F_NewsID
		FROM TS_Offical_Communication
		WHERE F_DisciplineID = @DisciplineID
			AND F_NewsItem = @Item
	END
	
	SELECT F_NewsItem
		, UPPER(F_SubTitle) AS F_SubTitle
		, F_Heading
		, F_Text
		, F_Issued_by
		, dbo.[Func_Report_WR_GetDateTime](F_Date, 1, 'ENG') AS F_Date
		, dbo.Fun_GetWeekdayName(F_Date, 'ENG') AS [Weekday_ENG]
		, dbo.Fun_GetWeekdayName(F_Date, 'CHN') AS [Weekday_CHN]
		, dbo.[Func_Report_WR_GetDateTime](F_Date, 4, 'ENG') AS F_Time
		, F_Schedule = CASE F_Type
			WHEN 2 THEN N'X'
			WHEN 3 THEN N'X'
			WHEN 6 THEN N'X'
			WHEN 7 THEN N'X'
		END
		, F_Results = CASE F_Type
			WHEN 1 THEN N'X'
			WHEN 3 THEN N'X'
			WHEN 5 THEN N'X'
			WHEN 7 THEN N'X'
		END
		, F_Other = CASE F_Type
			WHEN 4 THEN N'X'
			WHEN 5 THEN N'X'
			WHEN 6 THEN N'X'
			WHEN 7 THEN N'X'
		END
		, F_Note
	FROM TS_Offical_Communication 
	WHERE F_NewsID = @NewsID  

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
GO

/*

-- Just for Test
EXEC [Proc_Report_JU_GetOfficialCommunication] 26
EXEC [Proc_Report_JU_GetOfficialCommunication] 27

*/