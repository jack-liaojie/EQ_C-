IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Events]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Events]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_info_Events]
----功		  能：为Info系统服务，获取Event列表
----作		  者：郑金勇，MU XUEFENG
----日		  期: 2009-11-10 
----修 改  记 录：
/*
		序号	修改日期	修改者			修改描述
		2		2010-8-12	郑金勇			NORDER置为空NULL。
*/
CREATE PROCEDURE [dbo].[proc_info_Events]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT CAST((A.F_DisciplineCode + C.F_GenderCode + B.F_EventCode + B.F_EventCode) AS NCHAR(9)) AS [KEY]
		,CAST(A.F_DisciplineCode AS NCHAR(2))AS DISCIPLINE, CAST(C.F_GenderCode AS NCHAR(1)) AS SEX, CAST(B.F_EventCode AS NCHAR(3)) AS [EVENT], CAST(B.F_EventCode AS NCHAR(3)) AS EVENT_PARENT
--		,LEFT(CONVERT(NVARCHAR(50), B.F_OpenDate, 120), 10) AS START_DATE, RIGHT(CONVERT(NVARCHAR(50), B.F_OpenDate, 120), 8) AS START_TIME
--		,LEFT(CONVERT(NVARCHAR(50), B.F_CloseDate, 120), 10) AS END_DATE, RIGHT(CONVERT(NVARCHAR(50), B.F_CloseDate, 120), 8) AS END_TIME
		,B.F_OpenDate AS START_DATE, B.F_OpenDate AS START_TIME
		,B.F_CloseDate AS END_DATE, B.F_CloseDate AS END_TIME
		,CAST(B.F_EventStatusID AS TINYINT) AS STATUS, CAST (1 AS TINYINT) AS [ENABLE], CAST (1 AS TINYINT)  AS SHOW_EVENT, CAST (1 AS TINYINT)  AS HAS_MEDALS
		--,CAST (B.F_Order AS SMALLINT)  AS NORDER 
		,NULL AS NORDER 
	FROM TS_Discipline AS A 
				INNER JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID 
				LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode
			WHERE F_DisciplineCode = @DisciplineCode 
	ORDER BY B.F_Order
	RETURN

SET NOCOUNT OFF
END

GO

--EXEC [proc_info_Events] 'CR'