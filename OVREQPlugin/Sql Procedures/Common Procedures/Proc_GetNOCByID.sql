/****** Object:  StoredProcedure [dbo].[Proc_GetNOCByID]    Script Date: 11/20/2009 16:07:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNOCByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNOCByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNationByID]    Script Date: 11/20/2009 16:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetNOCByID]
--描    述: 根据 ID 获取一个 NOC 的信息
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年11月20日



CREATE PROCEDURE [dbo].[Proc_GetNOCByID]
	@NOC					NVARCHAR(3),
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Country AS A 
	left join TC_Country_Des AS B
		ON A.F_NOC = B.F_NOC AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_NOC = @NOC

SET NOCOUNT OFF
END
