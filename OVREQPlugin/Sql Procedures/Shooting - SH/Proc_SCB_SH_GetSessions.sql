IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetSessions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetSessions]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_SH_GetSessions]
--描    述: SCB 获取比赛参数列表.
--创 建 人: 吴定昉
--日    期: 2011-03-10
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetSessions]
    @DayID					    INT,
	@LanguageCode				CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

	SELECT case when cast(S.F_SessionNumber as NVARCHAR(100)) is null then '' 
	            else 'Session ' + cast(S.F_SessionNumber as NVARCHAR(100))
	            end  AS SessName
		, S.F_SessionID AS F_SessionID
	FROM TS_Session AS S
	LEFT JOIN TS_DisciplineDate AS DD ON S.F_SessionDate = DD.F_Date AND S.F_DisciplineID = DD.F_DisciplineID
	WHERE DD.F_DisciplineDateID = @DayID
	ORDER BY DD.F_DateOrder

SET NOCOUNT OFF
END

GO

/*
EXEC [Proc_SCB_SH_GetSessions] 1, 'ENG'
*/