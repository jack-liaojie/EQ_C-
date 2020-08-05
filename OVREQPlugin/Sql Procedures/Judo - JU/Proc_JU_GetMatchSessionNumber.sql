IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchSessionNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchSessionNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_JU_GetMatchSessionNumber]
--描    述: 获取柔道项目单元号 .
--创 建 人: 宁顺泽
--日    期: 2011年7月4日 星期1
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchSessionNumber]
	@MatchID						INT,
	@MatchSessionNumber				INT OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	
	SELECT @MatchSessionNumber=ISNULL(s.F_SessionNumber,0)
	FROM TS_Match AS M
	LEFT JOIN TS_Session AS S
		ON S.F_SessionID=M.F_SessionID
	where m.F_MatchID=@MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 
select * from TS_Session
*/


GO


