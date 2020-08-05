IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetMatchSplitInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetMatchSplitInfo]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_SCB_BDTT_GetMatchSplitInfo]
----功		  能：获取团体赛盘信息
----作		  者：王强
----日		  期: 2011-5-5

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetMatchSplitInfo]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	IF @MatchType != 3
		RETURN
	
	SELECT ('Set ' + CONVERT( NVARCHAR(10), F_Order ) +
			(CASE F_MatchSplitComment
			WHEN '1' THEN ''-- (Will Start)'
			WHEN '2' THEN ''-- (Running)'
			WHEN '3' THEN ''-- (Finished)'
			ELSE '' END) )
			 AS SetName, F_MatchSplitID AS MatchSetID
	 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
	
SET NOCOUNT OFF
END

GO





 
