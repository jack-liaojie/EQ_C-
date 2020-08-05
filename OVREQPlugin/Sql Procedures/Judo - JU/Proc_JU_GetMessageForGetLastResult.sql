IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMessageForGetLastResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMessageForGetLastResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_JU_GetMessageForGetLastResult]
--描    述: 获取柔道比赛获取最后一次给分的消息字符串.
--创 建 人: 宁顺泽
--日    期: 2011年07月24日 星期日
--修改记录：
/*			
	日期					修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_JU_GetMessageForGetLastResult]
	@MatchID						INT,
	@MatchSplitID					INT ,
	@strResult						NVARCHAR(20) OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	
	set @strResult=N''
	
	select @strResult= N'JU,'+
			CASE WHEN S.F_SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),S.F_SessionNumber)
			else CONVERT(NVARCHAR(10),S.F_SessionNumber) end +N','+
			RIGHT(C.F_CourtCode,1)+N','+
			M.F_RaceNum+N','+Convert(nvarchar(2),@MatchSplitID)
	from TS_Match AS M
	LEFT JOIN TS_Session as S
		ON M.F_SessionID=S.F_SessionID
	LEFT JOIN TC_Court AS C
		ON M.F_CourtID=C.F_CourtID
	where M.F_MatchID=@MatchID and M.F_SessionID is not null and m.F_CourtID is not null
	
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/


GO


