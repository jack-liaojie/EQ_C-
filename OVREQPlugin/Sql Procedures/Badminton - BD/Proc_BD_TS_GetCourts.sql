IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_TS_GetCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_TS_GetCourts]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_BD_TS_GetCourts]
--描    述: 获取场地列表
--创 建 人: 王强
--日    期: 2011-6-28
--修改记录：
/*			
			日期					修改人		修改内容
			2011-
*/



CREATE PROCEDURE [dbo].[Proc_BD_TS_GetCourts]
AS
BEGIN
SET NOCOUNT ON

	SELECT A.F_CourtID AS CourtID,B1.F_CourtShortName AS CourtName, ROW_NUMBER() OVER(ORDER BY A.F_CourtCode) AS CourtNumber
	FROM TC_Court AS A
	LEFT JOIN TC_Court_Des AS B1 ON B1.F_CourtID = A.F_CourtID AND B1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Court_Des AS B2 ON B2.F_CourtID = A.F_CourtID AND B2.F_LanguageCode = 'CHN'
	ORDER BY A.F_CourtCode

SET NOCOUNT OFF
END

