/****** Object:  StoredProcedure [dbo].[Proc_GetStatus]    Script Date: 11/20/2009 10:52:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetStatus]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetStatus]    Script Date: 11/20/2009 10:52:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetStatus]
--描    述: 获取比赛状态
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年11月20日



CREATE PROCEDURE [dbo].[Proc_GetStatus]
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT b.F_StatusLongName
		, b.F_StatusShortName 
		, a.F_StatusID 
	FROM TC_Status AS a
	LEFT JOIN TC_Status_Des b
		ON a.F_StatusID = b.F_StatusID AND b.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
