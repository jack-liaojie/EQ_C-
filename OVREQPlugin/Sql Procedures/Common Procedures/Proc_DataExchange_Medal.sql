IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Medal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Medal]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_Medal]
----功		  能：奖牌统计(M4031)。
----作		  者：郑金勇
----日		  期: 2010-11-29 
----修 改  记 录:
/*			
	日期					修改人			修改内容
	2010-12-29  			邓年彩			根据 CSIC Protocol  1.7.3 -- Global 添加属性 Sport.
	2011-01-19  			郑金勇			Rank的排名按照金、银、铜牌的数量进行排序。Total_Rank仅按照Total数量排序。
	2011-01-20  			郑金勇			Rank和Total_Rank的取值方式由DENSE_RANK改为RANK。
	2011-03-09				郑金勇			如果消息体是空的就让整个消息为空,不发送此消息.
*/


CREATE PROCEDURE [dbo].[Proc_DataExchange_Medal]
		@Discipline			AS NVARCHAR(50)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID		AS NVARCHAR(50)
	DECLARE @LanguageCode		AS CHAR(3)
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline

	CREATE TABLE #Temp_Medal(	F_DelegationCode	NVARCHAR(10),
								Gold				INT DEFAULT (0) NOT NULL,
								Silver				INT DEFAULT (0) NOT NULL,
								Bronze				INT DEFAULT (0) NOT NULL,
								Total				INT DEFAULT (0) NOT NULL,
								Rank				INT,
								Rank_Order			INT,
								Total_Rank			INT,
								Total_Order			INT,
								Gold_M				INT DEFAULT (0) NOT NULL,
								Silver_M			INT DEFAULT (0) NOT NULL,
								Bronze_M			INT DEFAULT (0) NOT NULL,
								Gold_W				INT DEFAULT (0) NOT NULL,
								Silver_W			INT DEFAULT (0) NOT NULL,
								Bronze_W			INT DEFAULT (0) NOT NULL,
								Gold_X				INT DEFAULT (0) NOT NULL,
								Silver_X			INT DEFAULT (0) NOT NULL,
								Bronze_X			INT DEFAULT (0) NOT NULL)
	
	INSERT INTO #Temp_Medal (F_DelegationCode)
		SELECT DISTINCT D.F_DelegationCode FROM TS_Event_Result AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
				WHERE A.F_RegisterID IS NOT NULL AND A.F_MedalID IS NOT NULL AND B.F_DisciplineID = @DisciplineID AND C.F_DelegationID IS NOT NULL


	CREATE TABLE #Temp_MedalList(F_DelegationID			INT,
								 F_DelegationCode		NVARCHAR(10),
								 F_RegisterID			INT,
								 F_EventID				INT, 
								 F_SexCode				INT,
								 F_MedalID				INT)

	INSERT INTO #Temp_MedalList (F_DelegationID, F_DelegationCode, F_RegisterID, F_EventID, F_SexCode, F_MedalID)
		SELECT DISTINCT D.F_DelegationID, D.F_DelegationCode, A.F_RegisterID, A.F_EventID, B.F_SexCode, A.F_MedalID FROM TS_Event_Result AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
				WHERE A.F_RegisterID IS NOT NULL AND A.F_MedalID IS NOT NULL AND B.F_DisciplineID = @DisciplineID AND C.F_DelegationID IS NOT NULL

	UPDATE #Temp_Medal SET Gold = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 1 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Silver = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 2 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Bronze = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 3 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode

	UPDATE #Temp_Medal SET Gold_M = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 1 AND F_SexCode = 1 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Silver_M = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 2 AND F_SexCode = 1 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Bronze_M = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 3 AND F_SexCode = 1 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode

	UPDATE #Temp_Medal SET Gold_W = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 1 AND F_SexCode = 2 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Silver_W = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 2 AND F_SexCode = 2 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Bronze_W = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 3 AND F_SexCode = 2 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode

	UPDATE #Temp_Medal SET Gold_X = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 1 AND F_SexCode = 3 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Silver_X = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 2 AND F_SexCode = 3 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode
	UPDATE #Temp_Medal SET Bronze_X = B.MedalNum FROM #Temp_Medal AS A INNER JOIN
		(SELECT F_DelegationCode, COUNT(F_RegisterID) AS MedalNum FROM #Temp_MedalList  WHERE F_MedalID = 3 AND F_SexCode = 3 GROUP BY F_DelegationCode) AS B
			ON A.F_DelegationCode = B.F_DelegationCode

--									Total				INT,
--								Rank				INT,
--								Rank_Order			INT,
--								Total_Rank			INT,
--								Total_Order			INT,

	UPDATE #Temp_Medal SET Total = Gold + Silver + Bronze

	UPDATE #Temp_Medal SET [Rank] = B.[Rank], [Rank_Order] = B.[Rank_Order], [Total_Rank] = B.[Total_Rank], [Total_Order] = B.[Total_Order]
		FROM #Temp_Medal AS A LEFT JOIN 
		(SELECT RANK() OVER(ORDER BY Gold DESC, Silver DESC, Bronze DESC) AS [Rank],
		   ROW_NUMBER() OVER(ORDER BY Gold DESC, Silver DESC, Bronze DESC, F_DelegationCode ASC) AS [Rank_Order], 
		   RANK() OVER(ORDER BY Total DESC) AS [Total_Rank],
		   ROW_NUMBER() OVER(ORDER BY Total DESC, Gold DESC, Silver DESC, Bronze DESC, F_DelegationCode ASC) AS [Total_Order], 
		   F_DelegationCode FROM #Temp_Medal) AS B
		ON A.F_DelegationCode = B.F_DelegationCode


	DECLARE @Sport AS NVARCHAR(50)
	IF @Discipline = N'TS'
	BEGIN
		SET @Sport = N'SH'
	END
	ELSE
	BEGIN
		SET @Sport = @Discipline
	END
	
	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT  Medal_Stat.F_DelegationCode AS NOC,
						Medal_Stat.Gold,
						Medal_Stat.Silver,
						Medal_Stat.Bronze,
						Medal_Stat.Total,
						Medal_Stat.Rank,
						Medal_Stat.Rank_Order,
						Medal_Stat.Total_Rank,
						Medal_Stat.Total_Order,
						Medal_Stat.Gold_M,
						Medal_Stat.Silver_M,
						Medal_Stat.Bronze_M,
						Medal_Stat.Gold_W,
						Medal_Stat.Silver_W,
						Medal_Stat.Bronze_W,
						Medal_Stat.Gold_X,
						Medal_Stat.Silver_X,
						Medal_Stat.Bronze_X,
						@Sport AS Sport
					FROM #Temp_Medal AS Medal_Stat ORDER BY Rank_Order ASC
						FOR XML AUTO)

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "VRS"' 
							+N' Origin = "VRS"'
							+N' RSC = "' + @Discipline + '0000000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "0"'
							+N' Event = "000"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M4031"'
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

EXEC Proc_DataExchange_Medal 'TE' 

*/

