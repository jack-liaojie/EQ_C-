IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_MatchsHasData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_MatchsHasData]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_GetMatchType]    Script Date: 12/27/2010 13:57:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [[Proc_JU_MatchsHasData]]
--描    述: 柔道项目Split中是否有数据.
--创 建 人: 宁顺泽
--日    期: 2010年12月26日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_MatchsHasData]
	@MatchID						INT,
	@ResultID						INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SELECT @ResultID=MAX(F_MatchID)
	FROM TS_Match_Split_Info
	WHERE F_MatchID=@MatchID;
	
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/


GO


