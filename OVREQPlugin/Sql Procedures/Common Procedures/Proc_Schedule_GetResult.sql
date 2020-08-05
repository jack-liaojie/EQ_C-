IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetResult]
--描    述: 获取指定一场比赛一个参赛者的成绩情况, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetResult]
	@LanguageCode			CHAR(3),
	@MatchID				INT,
	@RegisterID				INT
AS
BEGIN
SET NOCOUNT ON

	SELECT A.F_MatchID, A.F_RegisterID, B.F_LongName, A.F_ResultID, A.F_Rank, A.F_Points, A.F_IRMID
	FROM TS_Match_Result AS A 
	LEFT JOIN TR_Register_Des AS B 
		ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_matchID = @MatchID
		AND A.F_RegisterID = @RegisterID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec Proc_Schedule_GetResult 'CHN', 594, 269