IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetWeighInList_OtherInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetWeighInList_OtherInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetWeighInList_OtherInfo]
--描    述: 获取体重称量表的其他信息.
--创 建 人: 邓年彩
--日    期: 2010年11月8日 星期一
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetWeighInList_OtherInfo]
	@EventID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT REPLACE(REPLACE(ED.F_EventLongName, N'Women''s ', N''), N'Men''s ', N'') AS [WeightCategory]
		, UPPER(SD.F_SexLongName) AS [Gender]
		, dbo.Func_Report_JU_GetDateTime(E.F_OpenDate, 6, 'ENG') AS [Date]
		, N'7:00' AS [Time]
		, (
			SELECT COUNT(I.F_RegisterID)
			FROM TR_Inscription AS I
			WHERE I.F_EventID = @EventID
		) AS [NumberEntered]
		, (
			SELECT COUNT(I.F_RegisterID)
			FROM TR_Inscription AS I
			WHERE I.F_EventID = @EventID AND ISNULL(F_InscriptionComment2,N'')=N''
		) AS [Eligible]
		,E.F_EventID AS EventID
	FROM TS_Event AS E
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Sex_Des AS SD
		ON E.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = @LanguageCode
	WHERE @EventID IN (E.F_EventID, -1) and E.F_EventID<17

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetWeighInList_OtherInfo] 

*/