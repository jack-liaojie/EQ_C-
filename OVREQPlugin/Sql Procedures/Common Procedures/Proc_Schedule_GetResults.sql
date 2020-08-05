IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetResults]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetResults]
--描    述: 获取所有结果类型, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetResults]
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT F_ResultID, F_ResultLongName 
	FROM TC_Result_Des 
	WHERE F_LanguageCode = @LanguageCode
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetResults] 'CHN'