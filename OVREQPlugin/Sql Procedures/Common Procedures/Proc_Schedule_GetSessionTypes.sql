IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetSessionTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetSessionTypes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetSessionTypes]
--描    述: 获取赛段(session) 所有类型, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetSessionTypes]
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT F_SessionTypeID, F_SessionTypeLongName 
	FROM TC_SessionType_Des
	WHERE F_LanguageCode = @LanguageCode
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetSessionTypes] 'CHN'