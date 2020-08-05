IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GeTeamTtile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GeTeamTtile]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_GeTeamTtile]
--描    述: 获取团体赛的队名.
--创 建 人: 宁顺泽
--日    期: 2010年12月29日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GeTeamTtile]
	@MatchID						INT,
	@CompPos						INT,
	@Title							NVARCHAR(100) OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	SELECT @Title=RD.F_LongName 
	FROM TS_Match_Result AS MR
		LEFT JOIN TR_Register_Des AS RD
			ON MR.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
	WHERE MR.F_MatchID=@MatchID AND MR.F_CompetitionPosition=@CompPos
	
SET NOCOUNT OFF
END