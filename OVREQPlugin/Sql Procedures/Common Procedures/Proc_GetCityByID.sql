IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCityByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCityByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetCityByID]
--描    述: 根据 ID 获取一个 City 的信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/



CREATE PROCEDURE [dbo].[Proc_GetCityByID]
	@CityID					INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_City AS A 
	left join TC_City_Des AS B
		ON A.F_CityID = B.F_CityID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_CityID = @CityID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetCityByID] 2, 'CHN'
--exec [Proc_GetCityByID] 2, 'ENG'