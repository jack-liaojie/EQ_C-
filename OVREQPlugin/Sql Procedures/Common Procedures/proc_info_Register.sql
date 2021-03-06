IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Register]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Register]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_info_Register]
----功		  能：为Info系统服务，获取DISCIPLINE中的注册人员
----作		  者：穆学峰 
----日		  期: 2009-11-10 
----修 改  记 录：
/*			
			时间				修改人		修改内容
			2010-06-29			郑金勇		降低事务隔离级别
			2010-06-30			郑金勇		排除BYE和RegisterCode为空的
			2010-06-30			郑金勇		Country为DelegationCode
			2010-07-27			郑金勇		应该将ACCREDITATION与REGISTER保持一致。
			2010-08-03			郑金勇		将FLG_RECORD，FLG_TOP置为0。
*/
CREATE PROCEDURE [dbo].[proc_info_Register]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	CREATE TABLE #table_tmp(
		[KEY] NCHAR(12),
		DISCIPLINE	NCHAR(2),
		REGISTER	INT,
		REG_TYPE	TINYINT,
		SEX		NCHAR(1),
		COUNTRY	nchar(3),
		CLUB	nvarchar(5),
		FEDERATION	nvarchar(5),
		CATEGORY	nchar(1),
		ACCREDITATION	nvarchar(15),
		BIRTH_DATE	Datetime,
		HEIGHT_CM	INT,
		HEIGHT_FT	nchar(8),
		WEIGHT_GR	INT,
		WEIGHT_LB	nchar(8),
		FLG_RECORD	Tinyint,
		FLG_TOP		Tinyint,
		FLG_COMP	Tinyint,
		IF_NUMBER	nvarchar(16)
		
 	)

	INSERT INTO #table_tmp (DISCIPLINE, REGISTER, ACCREDITATION, REG_TYPE, SEX, COUNTRY, CLUB, FEDERATION,
				BIRTH_DATE, HEIGHT_CM, HEIGHT_FT, WEIGHT_GR, WEIGHT_LB, FLG_RECORD, FLG_TOP, FLG_COMP, IF_NUMBER)
	SELECT A.F_DisciplineCode , B.F_RegisterCode, B.F_RegisterCode,	F.F_RegTypeCode , E.F_GenderCode 
--		 , CASE G.F_DelegationType WHEN 'N' THEN G.F_DelegationCode WHEN 'C' THEN B.F_NOC ELSE '' END 
		 , CASE LEN(G.F_DelegationCode) WHEN 3 THEN G.F_DelegationCode ELSE '' END 
		 , C.F_ClubCode ,D.F_FederationCode ,
		 B.F_Birth_Date,F_Height ,	CAST(CAST(F_Height/30.5 AS NVARCHAR(100)) AS NCHAR(8)) ,F_Weight*1000 , CAST(CAST(F_Weight*1000.0/453.59 AS NVARCHAR(100)) AS NCHAR(8)),
		 0 AS FLG_RECORD, 0 AS FLG_TOP,
		 CASE WHEN B.F_RegTypeID=1 THEN 1 ELSE 0 END,
		 LEFT(LTRIM(RTRIM(B.F_RegisterNum)), 16)
	FROM TS_Discipline AS A 
		LEFT JOIN TR_Register AS B 	ON A.F_DisciplineID = B.F_DisciplineID 
		LEFT JOIN TC_Club AS C ON B.F_ClubID = C.F_ClubID
		LEFT JOIN TC_Federation AS D ON D.F_FederationID = B.F_FederationID
		LEFT JOIN TC_SEX AS E ON E.F_SexCode = B.F_SexCode 
		LEFT JOIN TC_RegType AS F ON F.F_RegTypeID = B.F_RegTypeID
		LEFT JOIN TC_Delegation AS G ON B.F_DelegationID = G.F_DelegationID
			WHERE A.F_DisciplineCode = @DisciplineCode
				AND B.F_RegisterID > 0
				AND B.F_RegisterCode IS NOT NULL
	
	UPDATE #table_tmp SET [KEY] = DISCIPLINE + Right('0000000000' + CAST( REGISTER AS NVARCHAR(50)), 10)
	UPDATE #table_tmp SET CATEGORY = 0

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END

GO
/*

EXEC proc_info_Register 'SL'

*/

