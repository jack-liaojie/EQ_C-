IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetMatchJudges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetMatchJudges]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_GetMatchJudges]
--描    述: 柔道项目获取一场 Match 的裁判  
--创 建 人: 宁顺泽
--日    期: 2011年05月9日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetMatchJudges]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		N'[Image]'+B.F_NOC AS [NOC]
		,C.F_TvLongName AS [Name]
		,D.F_FunctionLongName AS [Function]
		,C.F_TvShortName AS [Name_Short]
	FROM TS_Match_Servant AS A
	LEFT JOIN TR_Register AS B
		ON A.F_RegisterID = B.F_RegisterID
	LEFT JOIN TR_Register_Des AS C
		ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function_Des AS D
		ON A.F_FunctionID = D.F_FunctionID AND D.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID
	ORDER BY D.F_FunctionLongName DESC

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_GetMatchJudges] 2
*/