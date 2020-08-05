IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetRegTypes]
--描    述: 获取所有的注册类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/



CREATE PROCEDURE [dbo].[Proc_GetRegTypes]
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT b.F_RegTypeLongDescription AS [Long Description]
		, b.F_RegTypeShortDescription AS [Short Description]
		, a.F_RegTypeID AS [ID]
	FROM TC_RegType a
	LEFT JOIN TC_RegType_Des b
		ON a.F_RegTypeID = b.F_RegTypeID AND b.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetRegTypes] 'CHN'
--exec [Proc_GetRegTypes] 'GRE'