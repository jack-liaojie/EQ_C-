IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCourtByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCourtByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetCourtByID]
--描    述: 根据 ID 获取 Court 的信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月18日
--修改  王强    2012-09-14   增加F_Order列



CREATE PROCEDURE [dbo].[Proc_GetCourtByID]
	@CourtID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT * 
	FROM TC_Court AS A 
	LEFT JOIN TC_Court_Des AS B
		ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode=@LanguageCode 
	WHERE A.F_CourtID = @CourtID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetCourtByID] 63, 'CHN'
--exec [Proc_GetCourtByID] 63, 'ENG'