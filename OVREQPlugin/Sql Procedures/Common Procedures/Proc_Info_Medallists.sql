IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_MedalLists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_MedalLists]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----存储过程名称：[Proc_Info_MedalLists]
----功		  能：为Info系统服务，获取 [111]ZZ_MEDALLISTS
----作		  者：邓年彩, 穆学峰
----日		  期: 2009-11-10 
----修 改 记 录：
/*			
			时间				修改人		修改内容		
*/


CREATE PROCEDURE [dbo].[Proc_Info_MedalLists]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #Temp_Table(
		[KEY] [nchar](20) COLLATE Chinese_PRC_CI_AS NULL,
		[DISCIPLINE] [nchar](2) COLLATE Chinese_PRC_CI_AS NULL,
		[SEX] [nchar](1) COLLATE Chinese_PRC_CI_AS NULL,
		[EVENT] [nchar](3) COLLATE Chinese_PRC_CI_AS NULL,
		[EVENT_PARENT] [nchar](3) COLLATE Chinese_PRC_CI_AS NULL,
		[REGISTER] [nchar](10) COLLATE Chinese_PRC_CI_AS NULL,
		[MEDAL] [nchar](1) NULL,
		[MEDAL_DATE] [datetime] NULL
	)
	INSERT INTO #Temp_Table
	SELECT C.F_DisciplineCode + D.F_GenderCode + B.F_EventCode + B.F_EventCode 
			+	CASE 
					WHEN E.F_RegisterCode IS NOT NULL THEN + Right('0000000000' + CAST( E.F_RegisterCode AS NVARCHAR(10)), 10)
					ELSE N'          '
				END
			+ CONVERT(NVARCHAR(1), A.F_EventRank) AS [KEY],
		C.F_DisciplineCode AS [DISCIPLINE], 
		D.F_GenderCode AS SEX, 
		B.F_EventCode AS [EVENT], 
		B.F_EventCode AS [EVENT_PARENT], 
		E.F_RegisterCode AS [REGISTER], 
		A.F_MedalID AS [MEDAL], 
		B.F_CloseDate AS [MEDAL_DATE]
	FROM TS_Event_Result AS A
	LEFT JOIN TS_Event AS B	ON A.F_EventID = B.F_EventID
	LEFT JOIN TS_Discipline AS C ON B.F_DisciplineID = C.F_DisciplineID
	LEFT JOIN TC_Sex AS D ON B.F_SexCode = D.F_SexCode
	LEFT JOIN TR_Register AS E ON A.F_RegisterID = E.F_RegisterID
	WHERE C.F_DisciplineCode = @DisciplineCode 
		AND A.F_EventRank <= 3 AND A.F_RegisterID IS NOT NULL AND A.F_MedalID IS NOT NULL
	SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END

GO
/*
EXEC Proc_Info_MedalLists 'SP'
*/