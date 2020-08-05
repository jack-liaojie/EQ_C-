IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchModels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchModels]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_GetMatchModels]
--描    述：得到Match晋级方案模型列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年12月10日



CREATE PROCEDURE [dbo].[Proc_GetMatchModels](
				@MatchID			INT
)
AS
Begin
SET NOCOUNT ON 

	SELECT F_Order, F_MatchModelName, F_MatchModelComment, F_MatchID, F_MatchModelID FROM TS_Match_Model WHERE F_MatchID = @MatchID
		ORDER BY F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

