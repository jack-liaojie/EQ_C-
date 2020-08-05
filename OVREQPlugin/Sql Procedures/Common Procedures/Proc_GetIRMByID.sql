IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetIRMByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetIRMByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetIRMByID]
--描    述: 根据 IRMID 获取一种 IRM 类型的信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题, 增加 Order			
*/



CREATE PROCEDURE [dbo].[Proc_GetIRMByID]
	@LanguageCode				CHAR(3),
	@IRMID						INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_IRM a
	LEFT JOIN TC_IRM_Des b
		ON a.F_IRMID = b.F_IRMID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_IRMID = @IRMID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetIRMByID] 'CHN', 1
--exec [Proc_GetIRMByID] 'ENG', 1