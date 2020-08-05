IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCityVenues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCityVenues]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_GetCityVenues]
--描    述：得到City下的所有场馆
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年08月13日

CREATE PROCEDURE [dbo].[Proc_GetCityVenues](
				@CityID			INT,
				@LanguageCode	CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_VenueCode AS [Code],
		B.F_VenueLongName AS [Long Name],B.F_VenueShortName AS [Short Name],
			A.F_VenueID AS [ID] 
			FROM TC_Venue AS A left join TC_Venue_Des AS B
				ON A.F_VenueID = B.F_VenueID AND B.F_LanguageCode=@LanguageCode
					WHERE F_CityID = @CityID

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

--exec [Proc_GetCityVenues] 1, 'CHN'
--exec [Proc_GetCityVenues] 1, 'GRE'