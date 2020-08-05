/****** Object:  StoredProcedure [dbo].[Proc_GetNationByID]    Script Date: 11/20/2009 15:44:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNationByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNationByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNationByID]    Script Date: 11/20/2009 15:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetNationByID]
--描    述: 根据 ID 获取一个 Nation 的信息
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年11月20日



CREATE PROCEDURE [dbo].[Proc_GetNationByID]
	@NationID					INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Nation AS A 
	left join TC_Nation_Des AS B
		ON A.F_NationID = B.F_NationID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_NationID = @NationID

SET NOCOUNT OFF
END
