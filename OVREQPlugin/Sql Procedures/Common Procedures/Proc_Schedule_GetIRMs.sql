IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetIRMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetIRMs]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetIRMs]
--描    述: 获取 IRM 的所有类型, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetIRMs]
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT F_IRMID,F_IRMLongName 
	FROM TC_IRM_Des
	WHERE F_LanguageCode = @LanguageCode
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetIRMs] 'CHN'