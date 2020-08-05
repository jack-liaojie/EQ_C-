IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPositionByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPositionByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetPositionByID]
--描    述: 根据 PositionID 获取一个 Position 类型的信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/



CREATE PROCEDURE [dbo].[Proc_GetPositionByID]
	@LanguageCode				CHAR(3),
	@PositionID					INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TD_Position a
	LEFT JOIN TD_Position_Des b
		ON a.F_PositionID = b.F_PositionID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_PositionID = @PositionID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetPositionByID] 'CHN', 3001
--exec [Proc_GetPositionByID] 'GRE', 3001