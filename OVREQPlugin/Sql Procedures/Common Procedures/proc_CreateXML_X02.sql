IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateXML_X02]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateXML_X02]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_CreateXML_X02]
----功		  能：X01所有官员的XML
----作		  者：郑金勇
----日		  期: 2010-01-07 

CREATE PROCEDURE [dbo].[proc_CreateXML_X02]
    @DisciplineCode		CHAR(2)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @DisciplineID AS INT

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	DECLARE @AthleteList AS NVARCHAR(MAX)
	SET @AthleteList = (SELECT
			OVRCRS_Official.F_RegisterCode AS Registration_Number
			, OVRCRS_Official.F_GenderCode AS Gender_ID
			, OVRCRS_Official.F_FirstName AS Given_Name
			, OVRCRS_Official.F_LastName AS Family_Name
			, OVRCRS_Official.F_LongName AS TV_Long_Name
			, OVRCRS_Official.F_ShortName AS TV_Short_Name
			, OVRCRS_Official.F_LongName AS Reporting_Name
			, OVRCRS_Official.F_LongName AS Initial_Name
			, OVRCRS_Official.F_NOC AS Nationality
			, OVRCRS_Official.F_DelegationCode AS Organization_ID
			, OVRCRS_Official.F_DelegationCode AS IF_Code
			, (CASE OVRCRS_Official.F_RegTypeID WHEN 4 THEN 'Y' ELSE 'N' END) AS Competition_Official
			FROM (SELECT A.*, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName, C.F_GenderCode, D.F_DelegationCode FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'ENG'
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID WHERE A.F_RegisterID > 0 AND A.F_RegTypeID IN (4, 5) AND A.F_DisciplineID = @DisciplineID) AS OVRCRS_Official
			FOR XML AUTO)

	IF @AthleteList IS NULL
	BEGIN
		SET @AthleteList = N''
	END

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						<!DOCTYPE Message PUBLIC "-//IDS//CRS" "ids/oris+/crs/main.dtd">
						<Message Category="CRS" Origin="TEST-1" Serial="4" RSC="'+ @DisciplineCode +N'0000000" Discipline="'+ @DisciplineCode +N'" Gender="0" Event="000" Phase="0" Unit="00" Venue="" Type="X01" Format="D" Version="1" Correction="0" Language="ENG" Date="" Time="">
						<OVRCRS_Officials>'
					+ @AthleteList
					+ N'
						</OVRCRS_Officials>
					</Message>'

	SELECT @OutputXML
	RETURN

SET NOCOUNT OFF
END

GO

/*
DECLARE @OutputXML AS NVARCHAR(MAX)
EXEC [proc_CreateXML_X02] 'SP'
select @OutputXML
select cast(@OutputXML as xml)
*/