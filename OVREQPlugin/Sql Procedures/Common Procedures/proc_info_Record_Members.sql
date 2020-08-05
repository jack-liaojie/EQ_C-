IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Record_Members]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Record_Members]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_info_Record_Members]
----功		  能：为Info系统服务，获取运动会破纪录信息
----作		  者：穆学峰 
----日		  期: 2009-11-11 

CREATE PROCEDURE [dbo].[proc_info_Record_Members]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #table_tmp(
		[KEY] NCHAR(20),
		DISCIPLINE	NCHAR(2),
		SEX		NCHAR(1),
		[EVENT]	NCHAR(3),
		EVENT_PARENT	NCHAR(3),
		AREA	Nchar(3),
		RECORD_TYPE	Nchar(1),
		CATEGORY	Nchar(1),
		RLEVEL	Nchar(2),
		LEVEL_ORD	Nchar(2),
		IDD	Nchar(2),
		ORDER_MEMBER	smallint,
		REG_MEMBER	Int,
		MARK_MEMBER	Nvarchar(100)

 	)

/*	INSERT INTO #table_tmp (DISCIPLINE, SEX, [EVENT], EVENT_PARENT, AREA,
				RECORD_TYPE, CATEGORY, RLEVEL, LEVEL_ORD)

	SELECT A.F_DisciplineCode , B.F_RegisterCode ,	F.F_RegTypeCode , E.F_GenderCode ,B.F_NOC , C.F_ClubCode ,D.F_FederationCode ,
		 B.F_Birth_Date,F_Height ,	CAST(F_Height/30.5 AS NCHAR(8)) ,F_Weight , CAST(F_Weight/454 AS NCHAR(8))
	FROM TS_Discipline AS A 
		LEFT JOIN TR_Register AS B 	ON A.F_DisciplineID = B.F_DisciplineID 
		LEFT JOIN TC_Club AS C ON B.F_ClubID = C.F_ClubID
		LEFT JOIN TC_Federation AS D ON D.F_FederationID = B.F_FederationID
		LEFT JOIN TC_SEX AS E ON E.F_SexCode = B.F_SexCode 
		LEFT JOIN TC_RegType AS F ON F.F_RegTypeID = B.F_RegTypeID
			WHERE A.F_DisciplineCode = @DisciplineCode
				--AND B.F_RegisterCode IS NOT NULL
	
	UPDATE #table_tmp SET [KEY] = DISCIPLINE + CAST(REGISTER AS NCHAR(10))
*/
	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END


