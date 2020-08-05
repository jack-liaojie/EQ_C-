IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCities]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_GetCities]
--描    述：得到所有的City
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年08月13日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetCities](
				 @LanguageCode	CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_CityCode AS [Code],
		B.F_CityLongName AS [Long Name],B.F_CityShortName AS [Short Name],
			A.F_CityID AS [ID]
				FROM TC_City AS A left join TC_City_Des AS B
					ON A.F_CityID = B.F_CityID AND B.F_LanguageCode=@LanguageCode

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_GetCities] 'ENG'
