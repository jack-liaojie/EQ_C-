IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetMatchCourtDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetMatchCourtDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		王强
-- Create date: 2012-09-12
-- Description:	获取比赛场地字符串，用于分段排名报表上展示时间信息
-- =============================================

CREATE FUNCTION [dbo].[Fun_Report_BD_GetMatchCourtDes]
								(
									@MatchID INT,
									@LanguageCode NVARCHAR(10)
								)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @CourtStr NVARCHAR(30)
	SELECT @CourtStr = B.F_CourtShortName FROM TS_Match AS A 
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID
	 
	 RETURN @CourtStr
   
END

GO

