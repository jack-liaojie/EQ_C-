/****** Object:  StoredProcedure [dbo].[Proc_GetIRMs]    Script Date: 11/13/2009 10:23:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetIRMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetIRMs]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetIRMs]    Script Date: 11/13/2009 10:20:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetIRMs]
--描    述: 获取所有的IRM类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题, 增加 Order
            2009年11月13日      李燕        IRM与Discipline关联			
*/



CREATE PROCEDURE [dbo].[Proc_GetIRMs]
	@LanguageCode				CHAR(3),
    @DisciplineID               INT
AS
BEGIN
SET NOCOUNT ON

	SELECT a.F_Order AS [Order]
		, a.F_IRMCode AS [Code]
		, b.F_IRMLongName AS [Long Name]
		, b.F_IRMShortName AS [Short Name]
		, a.F_IRMID AS [ID]
	FROM TC_IRM a
	LEFT JOIN TC_IRM_Des b
		ON a.F_IRMID = b.F_IRMID AND b.F_LanguageCode = @LanguageCode
    WHERE a.F_DisciplineID = @DisciplineID
	ORDER BY a.F_Order

SET NOCOUNT OFF
END


SET QUOTED_IDENTIFIER OFF
