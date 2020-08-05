IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetCourts]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetCourts]
--描    述: 获取指定场馆的所有场地, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetCourts]
	@LanguageCode			CHAR(3),
	@VenueID				INT
AS
BEGIN
SET NOCOUNT ON
	SELECT * FROM TC_Court_Des
	WHERE F_LanguageCode = @LanguageCode
	AND F_CourtID IN ( SELECT F_CourtID FROM TC_Court WHERE F_VenueID = @VenueID )
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetCourts] 'CHN', 9