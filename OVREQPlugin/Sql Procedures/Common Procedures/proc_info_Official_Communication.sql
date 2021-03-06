/****** Object:  StoredProcedure [dbo].[proc_info_Official_Communication]    Script Date: 03/31/2010 10:32:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Official_Communication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Official_Communication]
GO
/****** Object:  StoredProcedure [dbo].[proc_info_Official_Communication]    Script Date: 03/31/2010 10:32:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_info_Official_Communication]
----功		  能：为Info系统服务，获取官方通告信息
----作		  者：李燕 
----日		  期: 2010-03-31 

----修 改  记 录：
/*			
			时间				修改人		修改内容
			2010-09-19			郑金勇		MSG_SEX、MSG_EVENT、MSG_EVENT_PARENT、MSG_PHASE、MSG_POOL、MSG_EVENT_UNIT全部置为0。
			2010-09-19			郑金勇		NEWS_ITEM 必须为3位，不足在前面用0补齐！
*/
CREATE PROCEDURE [dbo].[proc_info_Official_Communication]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #table_tmp(
		[KEY]            NCHAR(5),
		DISCIPLINE	     NCHAR(2),
		NEWS_ITEM	     NCHAR(3),
		SUBTITLE         NVARCHAR(100),
		HEADING      	 NVARCHAR(100),
	    [TEXT]	         NVARCHAR(2048),
		ISSUED_BY	     NVARCHAR(100),
		TYPE_OC	         INT,
		DATE_OC	         DATETIME,
		TIME_OC          DATETIME,
		NOTE	         NVARCHAR(200),
		VENUE	         NCHAR(3),
		MSG_SEX          NCHAR(1),
		MSG_EVENT	     NCHAR(3),
		MSG_EVENT_PARENT	 NCHAR(3),
		MSG_PHASE	      NCHAR(1),
		MSG_POOL	      NCHAR(2),
		MSG_EVENT_UNIT	  NCHAR(5)
 	)

	INSERT INTO #table_tmp (DISCIPLINE, NEWS_ITEM, SUBTITLE, HEADING,
				[TEXT], ISSUED_BY, TYPE_OC, DATE_OC,TIME_OC, NOTE, VENUE, MSG_SEX, MSG_EVENT, MSG_EVENT_PARENT, MSG_PHASE, MSG_POOL, MSG_EVENT_UNIT)

	SELECT B.F_DisciplineCode, A.F_NewsItem, A.F_SubTitle, A.F_Heading, A.F_Text, A.F_Issued_by, F_Type,
            A.F_Date, A.F_Date, 
           A.F_Note, NULL, '0', '000','000','0','00','00000'
   
	 FROM TS_Offical_Communication AS A LEFt JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID 
     WHERE B.F_DisciplineCode = @DisciplineCode
		 
	UPDATE #table_tmp SET NEWS_ITEM = RIGHT('000' + (RTRIM(LTRIM(NEWS_ITEM))), 3)
	UPDATE #table_tmp SET [KEY] = DISCIPLINE + CAST(NEWS_ITEM AS NCHAR(3))

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END


