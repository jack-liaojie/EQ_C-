IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetStatus]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_Schedule_GetStatus]
--描    述: 获取状态, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日
--修改记录：
/*			
			2009年11月13日		邓年彩		显示全部的状态, 而不是显示 >= 30 的状态		
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_GetStatus]
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT F_StatusID, F_StatusLongName FROM TC_Status_Des
	WHERE F_LanguageCode = @LanguageCode
		AND F_StatusID <> 0
SET NOCOUNT OFF
END

