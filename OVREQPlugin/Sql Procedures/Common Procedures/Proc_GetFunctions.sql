IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFunctions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFunctions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetFunctions]
--描    述: 获取指定项目所有的Function类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/




CREATE PROCEDURE [dbo].[Proc_GetFunctions]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT a.F_FunctionCode AS [Code], b.F_FunctionLongName AS [Long Name]
		, a.F_FunctionCategoryCode AS [Category Type]
		, a.F_FunctionID AS [ID]
	FROM TD_Function a
	LEFT JOIN TD_Function_Des b
		ON a.F_FunctionID = b.F_FunctionID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_DisciplineID = @DisciplineID

SET NOCOUNT OFF
END
