IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetVenues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetVenues]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetVenues]
--描    述: 获取某个大项所使用的场馆, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetVenues]
	@DisciplineID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT A.F_VenueID, B.F_VenueLongName
	FROM TD_Discipline_Venue AS A
	LEFT JOIN TC_Venue_Des AS B 
		ON A.F_VenueID = B.F_VenueID 
			AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetVenues] 5, 'CHN'