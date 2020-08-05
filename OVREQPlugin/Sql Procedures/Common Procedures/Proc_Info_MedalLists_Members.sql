IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_MedalLists_Members]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_MedalLists_Members]
GO

/****** 对象:  StoredProcedure [dbo].[Proc_Info_MedalLists_Members]    脚本日期: 11/10/2009 15:23:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Info_MedalLists_Members]
----功		  能：为Info系统服务，获取 [112]ZZ_MEDALLISTS_MEMBERS
----作		  者：邓年彩 
----日		  期: 2009-11-10  
----修 改 记 录：
/*			
			时间				修改人		修改内容	
			2010-07-29			郑金勇		过滤掉队中的教练等非运动员。	
*/

CREATE PROCEDURE [dbo].[Proc_Info_MedalLists_Members]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #Temp_Table(
		[KEY] [nchar](30) COLLATE Chinese_PRC_CI_AS NULL,
		[DISCIPLINE] [nchar](2) COLLATE Chinese_PRC_CI_AS NULL,
		[SEX] [nchar](1) COLLATE Chinese_PRC_CI_AS NULL,
		[EVENT] [nchar](3) COLLATE Chinese_PRC_CI_AS NULL,
		[EVENT_PARENT] [nchar](3) COLLATE Chinese_PRC_CI_AS NULL,
		[REGISTER] [nchar](10) COLLATE Chinese_PRC_CI_AS NULL,
		[MEDAL] [nchar](1) NULL,
		[REGISTER_MEMBER] [nchar](10) COLLATE Chinese_PRC_CI_AS NULL,
		[NORDER] SMALLINT NULL
	)

	INSERT INTO #Temp_Table
	SELECT C.F_DisciplineCode + D.F_GenderCode + B.F_EventCode + B.F_EventCode 
			+	CASE 
					WHEN E.F_RegisterCode IS NOT NULL THEN Right('0000000000' + CAST( E.F_RegisterCode AS NVARCHAR(10)), 10)
					ELSE N'0000000000'
				END
			+ CONVERT(NVARCHAR(1), A.F_MedalID)
			+	CASE 
					WHEN G.F_RegisterCode IS NOT NULL THEN Right('0000000000' + CAST( G.F_RegisterCode AS NVARCHAR(10)), 10)
					ELSE N'0000000000'
				END
			AS [KEY]
		, C.F_DisciplineCode AS [DISCIPLINE]
		, CAST(D.F_GenderCode AS NVARCHAR(1)) AS [SEX]
		, CAST(B.F_EventCode AS NVARCHAR(3)) AS [EVENT]
		, CAST(B.F_EventCode AS NVARCHAR(3)) AS [EVENT_PARENT]
		, E.F_RegisterCode AS [REGISTER]
		, CAST(A.F_MedalID AS CHAR(1)) AS [MEDAL]
		,G.F_RegisterCode AS [REGISTER_MEMBER]
		,	CASE 
				WHEN F.F_Order IS NOT NULL THEN F.F_Order 
				ELSE 1
			END
			AS [NORDER]
	FROM TS_Event_Result AS A
	LEFT JOIN TS_Event AS B
		ON A.F_EventID = B.F_EventID
	LEFT JOIN TS_Discipline AS C
		ON B.F_DisciplineID = C.F_DisciplineID
	LEFT JOIN TC_Sex AS D
		ON B.F_SexCode = D.F_SexCode
	LEFT JOIN TR_Register AS E
		ON A.F_RegisterID = E.F_RegisterID
	LEFT JOIN TR_Register_Member AS F
		ON A.F_RegisterID = F.F_RegisterID
	LEFT JOIN TR_Register AS G
		ON F.F_MemberRegisterID = G.F_RegisterID
	WHERE C.F_DisciplineCode = @DisciplineCode 
		AND A.F_EventRank <= 3 AND A.F_RegisterID IS NOT NULL AND F.F_RegisterID IS NOT NULL AND G.F_RegTypeID = 1 AND A.F_MedalID IS NOT NULL
	
	SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END
GO

/*

EXEC [Proc_Info_MedalLists_Members] 'SP'

*/
