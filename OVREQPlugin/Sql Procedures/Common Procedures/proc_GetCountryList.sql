IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetCountryList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetCountryList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_GetCountryList]
----功		  能：得到Country链表
----作		  者：张翠霞 
----日		  期: 2009-10-10 

CREATE PROCEDURE [dbo].[proc_GetCountryList]
    @LanguageCode			CHAR(3)
	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_NOC AS [NOC], B.F_CountryLongName AS [Long Name], B.F_CountryShortName AS [Short Name]
				FROM TC_Country AS A LEFT JOIN TC_Country_Des AS B
					ON A.F_NOC = B.F_NOC AND B.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END

GO

