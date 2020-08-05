IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_MESML_GetMedals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_MESML_GetMedals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_CIS_MESML_GetMedals]
----功		  能：获取奖牌榜
----作		  者：郑金勇
----日		  期: 2011-07-12 
----修改	记录:
/**/


CREATE PROCEDURE [dbo].[Proc_CIS_MESML_GetMedals]
		@DisciplineCode         AS CHAR(2),
		@LanguageCode			AS CHAR(3) = 'ENG'
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	DECLARE @OutputXML AS NVARCHAR(MAX)

 	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	DECLARE @Content AS NVARCHAR(MAX)
	CREATE TABLE #Temp_Medals([ID]						INT,
							  [Event]					NVARCHAR(200),
							  [Type]					NVARCHAR(50),
							  [Competitor]				NVARCHAR(2000),
							  [NOC]						NVARCHAR(50),
							  [Date]					NVARCHAR(100),
							  [F_EventID]				INT,
							  [F_RegisterID]			INT,
							  [F_PlayerRegTypeID]		INT,
							  [F_ID]					INT IDENTITY(1, 1))
							  
	INSERT INTO #Temp_Medals
		SELECT NULL AS [ID], B.F_EventLongName AS [Event], C.F_MedalLongName AS [Type], '' AS [Competitor]
			, F.F_DelegationCode AS [NOC], LEFT(CONVERT(NVARCHAR(MAX), F_ResultCreateDate , 120 ), 10) AS [Date], A.F_EventID, A.F_RegisterID
			, D.F_PlayerRegTypeID FROM TS_Event_Result AS A 
			LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Medal_Des AS C ON A.F_MedalID = C.F_MedalID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS D ON A.F_EventID = D.F_EventID
			LEFT JOIN TR_Register AS E ON A.F_RegisterID = E.F_RegisterID 
			LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
			WHERE D.F_EventStatusID = 110 AND A.F_MedalID IS NOT NULL AND A.F_RegisterID IS NOT NULL AND D.F_DisciplineID = @DisciplineID
			ORDER BY D.F_Order, A.F_MedalID
	UPDATE A SET A.ID = A.F_ID - B.StartID + 1 FROM #Temp_Medals AS A LEFT JOIN
		(SELECT F_EventID, MIN(F_ID) AS StartID FROM #Temp_Medals GROUP BY (F_EventID)) AS B
		ON A.F_EventID = B.F_EventID
	
	UPDATE #Temp_Medals SET [Event] = '' WHERE ID != 1
	
	UPDATE A SET A.Competitor = B.F_ShortName FROM #Temp_Medals AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PlayerRegTypeID = 1
	
	UPDATE A SET A.Competitor = A.Competitor + ';' + C.F_ShortName FROM #Temp_Medals AS A LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON b.F_MemberRegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		WHERE A.F_PlayerRegTypeID IN (2, 3)
	
	
	DECLARE @i			AS INT
	DECLARE @MaxID		AS INT
	DECLARE @CompetitorName		AS NVARCHAR(2000)
	DECLARE @RegisterID			AS INT
	DECLARE @PlayerRegTypeID	AS INT
	SET @i = 1
	SELECT @MaxID = MAX(F_ID) FROM #Temp_Medals
	WHILE (@i <= @MaxID)
	BEGIN
		SELECT @RegisterID = F_RegisterID, @PlayerRegTypeID = F_PlayerRegTypeID FROM #Temp_Medals WHERE F_ID = @i
		IF @PlayerRegTypeID IN (2, 3)
		BEGIN
			SET  @CompetitorName = ''
			SELECT @CompetitorName = @CompetitorName + N';' + ISNULL(B.F_ShortName, C.F_RegisterCode) FROM TR_Register_Member AS A 
				LEFT JOIN TR_Register_Des AS B ON A.F_MemberRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				LEFT JOIN TR_Register AS C ON A.F_MemberRegisterID = C.F_RegisterID
				WHERE A.F_RegisterID = @RegisterID AND C.F_RegTypeID = 1 ORDER BY A.F_Order

			SET @CompetitorName = RIGHT(@CompetitorName, LEN(@CompetitorName) - 1)

			UPDATE #Temp_Medals SET Competitor = @CompetitorName WHERE F_ID = @i
		END
		SET @i = @i + 1
	END
	
	SET @Content = (SELECT ID, [Event], [Type],[Competitor],[NOC],[Date] FROM #Temp_Medals AS Medal
						FOR XML AUTO)


	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Type = "MESML"'
							+N' ID = "' + @DisciplineCode + '0000000"'
							+N' Discipline = "'+ @DisciplineCode + '"'
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'

	--SELECT CAST(@Content AS XML)
	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END

GO


--EXEC Proc_CIS_MESML_GetMedals 'VB','ENG'
--EXEC Proc_CIS_MESML_GetMedals 'VB'