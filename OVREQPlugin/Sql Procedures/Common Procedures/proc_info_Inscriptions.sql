IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Inscriptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Inscriptions]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_info_Inscriptions]
----功		  能：为Info系统服务，获取DISCIPLINE中的报项人员
----作		  者：穆学峰 
----日		  期: 2009-11-10 
/*			
	时间				修改人		修改内容
	2010-07-02			郑金勇		报项的仅仅是运动员和双打组合和队，官员不在此中展现
*/
CREATE PROCEDURE [dbo].[proc_info_Inscriptions]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #table_tmp(
							[KEY]	NCHAR(19),
							DISCIPLINE	NCHAR(2),
							SEX	NCHAR(1),
							[EVENT]	NCHAR(3),
							EVENT_PARENT	NCHAR(3),
							REGISTER	INT,
							ENTRY_MARK	Nvarchar(10),
							ENTRY_VALID	Nchar(1),
							ENTRY_SOURCE	Nvarchar(50),
							ENTRY_DATE	DATETIME,
							ENTRY_LOCATION	Nvarchar(50),
							BIB	Nvarchar(10),
							SHOW_INSCRIPTION	TINYINT,
							MEDICAL_CLASS	Nvarchar(30)
							)

	INSERT #table_tmp(DISCIPLINE, SEX, [EVENT], EVENT_PARENT, REGISTER, ENTRY_SOURCE, BIB)

	SELECT 	A.F_DisciplineCode, 
		E.F_GenderCode,
		B.F_EventCode,
		B.F_EventCode,
		D.F_RegisterCode,
		C.F_InscriptionResult,
		C.F_InscriptionNum  
	FROM TS_Discipline AS A 
		RIGHT JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID
		RIGHT JOIN TR_Inscription AS C ON C.F_EventID = B.F_EventID
		LEFT JOIN TR_Register AS D 	ON C.F_RegisterID = D.F_RegisterID
		LEFT JOIN TC_SEX AS E ON E.F_SexCode = B.F_SexCode 
			WHERE A.F_DisciplineCode = @DisciplineCode
				AND D.F_RegTypeID IN (1, 2, 3)
	UPDATE #table_tmp SET SHOW_INSCRIPTION = 1
	UPDATE #table_tmp SET [KEY] = DISCIPLINE + SEX + [EVENT] + EVENT_PARENT + Right('0000000000' + CAST( REGISTER AS NVARCHAR(10)), 10)

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END


GO

--EXEC [proc_info_Inscriptions] 'SP'