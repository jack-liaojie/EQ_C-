IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_TE_GetMatchDate]
--描    述：得到比赛日期
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年04月12日


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchDate]
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Table(
                                F_Date                  NVARCHAR(10),
                                F_DateID                INT
							)

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

	INSERT INTO #Tmp_Table (F_Date, F_DateID)
    SELECT CONVERT(NVARCHAR(10), F_Date, 120), F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineID = @DisciplineID

	SELECT F_Date, F_DateID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


