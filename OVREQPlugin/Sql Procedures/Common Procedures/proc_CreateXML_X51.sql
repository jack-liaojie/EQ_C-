IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateXML_X51]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateXML_X51]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_CreateXML_X51]
----功		  能：X51所有运动员的XML
----作		  者：郑金勇
----日		  期: 2010-01-07 

CREATE PROCEDURE [dbo].[proc_CreateXML_X51]
    @DisciplineCode		CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @DisciplineID AS INT

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	DECLARE @AthleteList AS NVARCHAR(MAX)
	SET @AthleteList = (SELECT
			AthletesName.F_RegisterCode AS Registration_Number
			, AthletesName.F_GenderCode AS Gender_ID
			, AthletesName.F_FirstName AS Given_Name_Local
			, AthletesName.F_LastName AS Family_Name_Local
			, AthletesName.F_LongName AS TV_Name_Local
			, AthletesName.F_ShortName AS TV_Short_Name_Local
			, AthletesName.F_LongName AS Reporting_Name_Local
			, AthletesName.F_LongName AS Initial_Name
			, AthletesName.F_NOC AS Nationality
			, AthletesName.F_DelegationCode AS Organization_ID
			, AthletesName.F_Height AS Height
			, AthletesName.F_Weight AS Weight
			, Discipline.F_DisciplineCode AS Discipline_ID
--			, Athlete_Event.F_GenderCode AS Gender
--			, Athlete_Event.F_EventCode AS [Event]
			,
			(
			SELECT * FROM (
							SELECT C.F_GenderCode AS Gender_ID, B.F_EventCode AS Event_ID 
												FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode 
													WHERE A.F_RegisterID = AthletesName.F_RegisterID
							) AS Athlete_Event FOR XML AUTO, TYPE
			) 
			FROM (SELECT A.*, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName, C.F_GenderCode, D.F_DelegationCode FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'CHN'
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID
				WHERE A.F_RegisterID > 0 AND A.F_RegTypeID = 1 AND A.F_DisciplineID = @DisciplineID) AS AthletesName
			LEFT JOIN (SELECT A.F_RegisterID, B.F_DisciplineCode FROM TR_Register AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID) AS Discipline 
				ON AthletesName.F_RegisterID = Discipline.F_RegisterID
			FOR XML AUTO)

	IF @AthleteList IS NULL
	BEGIN
		SET @AthleteList = N''
	END

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						<!DOCTYPE Message PUBLIC "-//IDS//CRS" "ids/oris+/crs/main.dtd">
						<Message Category="CRS" Origin="TEST-1" Serial="4" RSC="'+ @DisciplineCode +N'0000000" Discipline="'+ @DisciplineCode +N'" Gender="0" Event="000" Phase="0" Unit="00" Venue="" Type="X51" Format="D" Version="1" Correction="0" Language="CHN" Date="" Time="">
						<AthletesNames>'
					+ @AthleteList
					+ N'
						</AthletesNames>
					</Message>'

	SELECT @OutputXML
	RETURN

SET NOCOUNT OFF
END

GO

/*

EXEC proc_CreateXML_X51 'KR'
*/