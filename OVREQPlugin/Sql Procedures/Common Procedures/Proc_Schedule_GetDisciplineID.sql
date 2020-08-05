IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetDisciplineID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetDisciplineID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_GetDisciplineID]
--描    述: 获取当前有效大项的ID, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月17日



CREATE PROCEDURE [dbo].[Proc_Schedule_GetDisciplineID]
AS
BEGIN
SET NOCOUNT ON
	SELECT F_DisciplineID 
	FROM TS_Discipline 
	WHERE F_Active = 1 
		AND F_SportID IN (SELECT F_SportID FROM TS_Sport WHERE F_Active = 1 )
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetDisciplineID]