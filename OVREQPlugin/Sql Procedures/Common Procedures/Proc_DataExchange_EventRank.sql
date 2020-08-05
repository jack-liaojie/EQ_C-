IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_EventRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_EventRank]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_EventRank]
----功		  能：名次公告(个人)(M4011)。
----作		  者：郑金勇
----日		  期: 2010-04-19 
/*

		 2011-03-05		  郑金勇			修改Bug,保证奖牌产生的时间Time的格式是:HHMM。
		 2011-03-06		  郑金勇			修改Bug,保证Date和Time的节点必须存在:ISNULL(Date, '')、ISNULL(Time, '')。
		 2011-03-09		  郑金勇			按照协议如果名次产生时间为空是不允许发送的，要过滤掉没有成绩产生时间的名次条目。
		 2011-03-09		  郑金勇			如果消息体是空的就让整个消息为空,不发送此消息.
		 2011-03-10		  郑金勇			如果EventPoints为空，应该填充“”，而不是0.
		 2011-03-24		  郑金勇			添加Athlete节点.
		 2011-07-25		  杨佳鹏			将获奖名单中的官员去掉
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_EventRank]
		@EventID			INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID		AS INT
	DECLARE @Discipline			AS NVARCHAR(50)
	DECLARE @Gender				AS NVARCHAR(50)
	DECLARE @Event				AS NVARCHAR(50)
	DECLARE @LanguageCode		AS CHAR(3)
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	SELECT @DisciplineID = B.F_DisciplineID, @Discipline = B.F_DisciplineCode, @Gender = C.F_GenderCode, @Event = A.F_EventCode FROM TS_Event AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID 
		LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode WHERE A.F_EventID = @EventID
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT  Rank.F_RegisterCode AS Reg_ID
					, Rank.F_EventRank AS Rank
					, ISNULL(Rank.F_EventDisplayPosition, '') AS Rank_Order
					, ISNULL(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), F_ResultCreateDate , 120 ), 10), '-', ''), '') AS [Date]
					, ISNULL(LEFT(REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), F_ResultCreateDate , 121 ), 12), ':', ''), '.', ''), 4), '') AS [Time]
					, ISNULL(CAST(Rank.F_EventPoints AS NVARCHAR(20)), '') AS Result
					, (SELECT Registration, ISNULL([Order], 0) AS [Order] FROM (SELECT B.F_RegisterCode AS Registration, ROW_NUMBER() OVER( ORDER BY A.F_Order) AS [Order] FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID WHERE A.F_RegisterID = [Rank].F_RegisterID AND B.F_RegTypeID = 1)  AS [Athlete] ORDER BY [Order] FOR XML AUTO, TYPE)
						FROM (SELECT A.F_RegisterID, A.F_EventRank, A.F_ResultCreateDate, A.F_EventDisplayPosition, B.F_RegisterCode, A.F_EventPoints FROM TS_Event_Result AS A 
								LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
									WHERE A.F_EventID = @EventID AND A.F_RegisterID IS NOT NULL AND F_ResultCreateDate IS NOT NULL) AS Rank
							FOR XML AUTO)

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "VRS"' 
							+N' Origin = "VRS"'
							+N' RSC = "' + @Discipline + @Gender + @Event +'000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "' + @Gender + '"'
							+N' Event = "'+ @Event +'"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M4011"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="' + REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "' + REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '') + '"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END

GO

/*

EXEC Proc_DataExchange_EventRank 1

*/

