IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchResultandRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchResultandRank]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_UpdateMatchResultandRank]
--描    述: 摔跤项目
--创 建 人: ningshunze
--日    期: 2010年11月5日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchResultandRank]
	@MatchID						INT,
	@Compos							INT,
	@ResultID						INT,
	@Rank							INT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END
	
	update TS_Match_Result set F_ResultID=@ResultID,F_Rank=@Rank where F_MatchID=@MatchID and F_CompetitionPosition=@Compos
	
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatch_Individual] 2

*/