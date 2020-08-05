IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetVenueByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetVenueByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetVenueByID]
--描    述: 根据 VenueID 获取 Venue 的信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月18日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/



CREATE PROCEDURE [dbo].[Proc_GetVenueByID]
	@VenueID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	select * from TC_Venue as A 
	left join TC_Venue_Des as B 
		on A.F_VenueID = B.F_VenueID  AND B.F_LanguageCode = @LanguageCode 
	where A.F_VenueID = @VenueID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetVenueByID] 9, 'CHN'
--exec [Proc_GetVenueByID] 9, 'ENG'