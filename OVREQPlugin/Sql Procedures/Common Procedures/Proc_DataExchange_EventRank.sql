IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_EventRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_EventRank]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[Proc_DataExchange_EventRank]
----��		  �ܣ����ι���(����)(M4011)��
----��		  �ߣ�֣����
----��		  ��: 2010-04-19 
/*

		 2011-03-05		  ֣����			�޸�Bug,��֤���Ʋ�����ʱ��Time�ĸ�ʽ��:HHMM��
		 2011-03-06		  ֣����			�޸�Bug,��֤Date��Time�Ľڵ�������:ISNULL(Date, '')��ISNULL(Time, '')��
		 2011-03-09		  ֣����			����Э��������β���ʱ��Ϊ���ǲ������͵ģ�Ҫ���˵�û�гɼ�����ʱ���������Ŀ��
		 2011-03-09		  ֣����			�����Ϣ���ǿյľ���������ϢΪ��,�����ʹ���Ϣ.
		 2011-03-10		  ֣����			���EventPointsΪ�գ�Ӧ����䡰����������0.
		 2011-03-24		  ֣����			���Athlete�ڵ�.
		 2011-07-25		  �����			���������еĹ�Աȥ��
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

