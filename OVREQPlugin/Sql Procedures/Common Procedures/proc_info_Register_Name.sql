IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Register_Names]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Register_Names]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_info_Register_Names]
----功		  能：为Info系统服务，获取DISCIPLINE中的注册人员
----作		  者：穆学峰 
----日		  期: 2009-11-10 
----修 改  记 录：
/*			
			时间				修改人		修改内容
			2010-06-29			郑金勇		降低事务隔离级别
			2010-06-30			郑金勇		排除BYE和RegisterCode为空的
			2010-09-17			郑金勇		LNAME和SNAME分别取F_PrintLongName和F_PrintShortName
			2010-09-19			郑金勇		LANGUAGE的值中文为CHN英文为ENG。
*/
CREATE PROCEDURE [dbo].[proc_info_Register_Names]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	CREATE TABLE #table_tmp(
							[KEY] NCHAR(15),
							DISCIPLINE NCHAR(2),
							REGISTER INT,
							[LANGUAGE] NCHAR(3),
							NAME1	Nvarchar(25),
							NAME2	Nvarchar(35),
							LNAME	Nvarchar(60),
							SNAME	Nvarchar(60),
							NICK	Nvarchar(60)
							)

	INSERT INTO #table_tmp (DISCIPLINE, REGISTER, [LANGUAGE], NAME1, NAME2, LNAME, SNAME)
	SELECT 	CAST(A.F_DisciplineCode AS NCHAR(2)), CAST(B.F_RegisterCode AS NCHAR(10)), C.F_LanguageCode, F_FirstName, F_LastName, F_PrintLongName, F_PrintShortName
	FROM TS_Discipline AS A 
		LEFT JOIN TR_Register AS B 	ON A.F_DisciplineID = B.F_DisciplineID 
		LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID
			WHERE A.F_DisciplineCode = @DisciplineCode
				AND B.F_RegisterID > 0
				AND B.F_RegisterCode IS NOT NULL

	--UPDATE #table_tmp SET [LANGUAGE] = 'CHI' WHERE [LANGUAGE] = 'CHN'
	UPDATE #table_tmp SET [KEY] = DISCIPLINE +Right('0000000000' + CAST( REGISTER AS NVARCHAR(10)), 10) + [LANGUAGE]

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END


