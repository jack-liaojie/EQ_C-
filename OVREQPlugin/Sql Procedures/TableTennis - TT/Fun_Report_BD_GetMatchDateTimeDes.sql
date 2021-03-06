IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetMatchDateTimeDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetMatchDateTimeDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		王强
-- Create date: 2012-09-12
-- Description:	获取比赛时间字符串，用于分段排名报表上展示时间信息
-- =============================================

CREATE FUNCTION [dbo].[Fun_Report_BD_GetMatchDateTimeDes]
								(
									@MatchID INT
								)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @TimeStr NVARCHAR(30)
	SELECT @TimeStr = dbo.Fun_Report_BD_GetDateTime(F_MatchDate, 13) + ' ' + dbo.Fun_Report_BD_GetDateTime(F_StartTime, 3)
	 FROM TS_Match WHERE F_MatchID = @MatchID
	 
	 RETURN @TimeStr
   
END

GO

