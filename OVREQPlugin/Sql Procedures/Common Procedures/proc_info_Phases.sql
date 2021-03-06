IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Phases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Phases]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_info_Phases]
----功		  能：为Info系统服务，获取Phase列表
----作		  者：穆学峰 
----日		  期: 2009-11-10 
----修 改  记 录：
/*
		序号	修改日期	修改者			修改描述
		1		2010-5-12	郑金勇			PhaseCode相同的仅仅出现一次。
		2		2010-8-12	郑金勇			NORDER置为空NULL。
*/
CREATE PROCEDURE [dbo].[proc_info_Phases]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	CREATE TABLE #table_tmp(
		[KEY]		NCHAR(3),
		DISCIPLINE	NCHAR(2),
		PHASE		NCHAR(1),
		IS_POOL		TINYINT,
		NORDER		SMALLINT			
		)

	INSERT INTO #table_tmp(DISCIPLINE, PHASE,  NORDER, IS_POOL)
		SELECT 	CAST(A.F_DisciplineCode AS Nchar(2)), 
				CAST(C.F_PhaseCode AS Nchar(1)),
				--ROW_NUMBER() OVER (ORDER BY C.F_PhaseCode )AS NORDER,
				NULL AS NORDER,
				C.F_PhaseHasPools
		FROM TS_Discipline AS A 
				INNER JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID 
				INNER JOIN TS_PHASE AS C ON B.F_EventID = C.F_EventID
				WHERE F_DisciplineCode = @DisciplineCode AND C.F_PhaseIsPool = 0
			GROUP BY A.F_DisciplineCode + C.F_PhaseCode,A.F_DisciplineCode,C.F_PhaseCode,C.F_PhaseHasPools
				ORDER BY C.F_PhaseCode
	
	DELETE FROM #table_tmp WHERE PHASE IS NULL OR PHASE = '' 

	UPDATE #table_tmp SET [KEY] = DISCIPLINE + PHASE

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END

GO

--EXEC [proc_info_Phases] 'SQ'