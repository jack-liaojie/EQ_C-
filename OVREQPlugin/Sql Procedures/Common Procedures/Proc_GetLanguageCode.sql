IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLanguageCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLanguageCode]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GetLanguageCode]
----功		  能：得到所有的语言信息
----作		  者：李燕
----日		  期: 2009-08-17 

CREATE PROCEDURE [dbo].Proc_GetLanguageCode 	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT F_LanguageDescription,F_LanguageCode FROM TC_Language Order By F_Order

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS OFF
GO


