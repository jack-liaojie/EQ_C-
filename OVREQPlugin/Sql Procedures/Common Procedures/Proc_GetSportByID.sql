/****** Object:  StoredProcedure [dbo].[Proc_GetSportByID]    Script Date: 11/19/2009 08:21:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetSportByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetSportByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetSportByID]    Script Date: 11/19/2009 08:18:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetSportByID]
--描    述: 根据SportID得到一个Sport
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月18日



CREATE PROCEDURE [dbo].[Proc_GetSportByID]
	@SportID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT * FROM TS_Sport AS A 
               LEFT JOIN TS_Sport_Des AS B ON A.F_SportID = B.F_SportID AND B.F_LanguageCode=@LanguageCode
               LEFT JOIN TS_Sport_Config AS C ON A.F_SportID = C.F_SportID AND C.F_ConfigType = 1
			   WHERE A.F_SportID = @SportID

SET NOCOUNT OFF
END

