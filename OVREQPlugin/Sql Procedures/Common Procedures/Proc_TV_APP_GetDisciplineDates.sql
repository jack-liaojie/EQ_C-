IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetDisciplineDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetDisciplineDates]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TV_APP_GetDisciplineDates]
----功		  能：为TV 应用程序服务, 得到一个Discipline下所有的比赛日期
----作		  者：郑金勇
----日		  期: 2009-2-2  


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetDisciplineDates]
							@DisciplineCode     CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	CREATE TABLE #Temp_Dates(F_DateID		INT,
							 F_Date			NVARCHAR(100))
	INSERT INTO #Temp_Dates (F_DateID, F_Date) VALUES (-1, 'ALL')
	INSERT INTO #Temp_Dates (F_DateID, F_Date) SELECT F_DisciplineDateID AS F_DateID, LEFT(LTRIM(CONVERT(NVARCHAR(100), F_Date , 120)), 10) AS  F_Date 
			FROM TS_DisciplineDate WHERE F_DisciplineID = @DisciplineID ORDER BY F_DateOrder

	SELECT * FROM #Temp_Dates

	RETURN

SET NOCOUNT OFF
END

GO

--EXEC [Proc_TV_APP_GetDisciplineDates] 'CR'
--select * from TS_DisciplineDate