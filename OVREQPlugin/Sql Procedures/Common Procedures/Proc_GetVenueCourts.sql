IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetVenueCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetVenueCourts]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_GetVenueCourts]
--描    述：得到Venue下的所有Court
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年08月13日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月04日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题		
			2012年09越14日      王强        增加CourtOrder列	
*/

CREATE PROCEDURE [dbo].[Proc_GetVenueCourts](
				@VenueID			INT,
				@LanguageCode		CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_CourtCode AS [Code],
		A.F_Order AS [Order],
		B.F_CourtLongName AS [Long Name],
		B.F_CourtShortName AS [Short Name],
			A.F_CourtID AS [ID]
				FROM TC_Court AS A left join TC_Court_Des AS B
					ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode=@LanguageCode
						WHERE F_VenueID = @VenueID

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

--exec [Proc_GetVenueCourts] 9, 'CHN'
--exec [Proc_GetVenueCourts] 9, 'GRE'