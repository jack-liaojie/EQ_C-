IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetCourt]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_GetCourt]
--描    述: 
--创 建 人: 宁顺泽
--日    期: 2011年05月20日 星期5
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetCourt]

AS
BEGIN
SET NOCOUNT ON
		
	select CD.F_CourtShortName,C.F_CourtCode from TC_Court AS C
LEFT JOIN TC_Court_Des AS CD
	on C.F_CourtID=CD.F_CourtID AND CD.F_LanguageCode=N'ENG'	
where C.F_CourtCode like 'F25JU%'
		
SET NOCOUNT OFF
END


/*
exec Proc_TVG_JU_GetCourt
*/