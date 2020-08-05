IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateXML_X52]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateXML_X52]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_CreateXML_X52]
----功		  能：X52所有官员的XML
----作		  者：郑金勇
----日		  期: 2010-01-07 

CREATE PROCEDURE [dbo].[proc_CreateXML_X52]
    @DisciplineCode		CHAR(2)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @DisciplineID AS INT

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	DECLARE @AthleteList AS NVARCHAR(MAX)
	SET @AthleteList = (SELECT
			OfficialsName.F_RegisterCode AS Registration_Number
			, OfficialsName.F_GenderCode AS Gender_ID
			, OfficialsName.F_FirstName AS Given_Name_Local
			, OfficialsName.F_LastName AS Family_Name_Local
			, OfficialsName.F_LongName AS TV_Name_Local
			, OfficialsName.F_ShortName AS TV_Short_Name_Local
			, OfficialsName.F_LongName AS Reporting_Name_Local
			, OfficialsName.F_LongName AS Initial_Name_Local
			, OfficialsName.F_NOC AS Nationality
			, OfficialsName.F_DelegationCode AS Organization_ID
			, OfficialsName.F_DelegationCode AS IF_Code
			FROM (SELECT A.*, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName, C.F_GenderCode, D.F_DelegationCode FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'CHN'
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID WHERE A.F_RegisterID > 0 AND A.F_RegTypeID IN (4, 5) AND A.F_DisciplineID = @DisciplineID) AS OfficialsName
			FOR XML AUTO)

	IF @AthleteList IS NULL
	BEGIN
		SET @AthleteList = N''
	END

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						<!DOCTYPE Message PUBLIC "-//IDS//CRS" "ids/oris+/crs/main.dtd">
						<Message Category="CRS" Origin="TEST-1" Serial="4" RSC="'+ @DisciplineCode +N'0000000" Discipline="'+ @DisciplineCode +N'" Gender="0" Event="000" Phase="0" Unit="00" Venue="" Type="X01" Format="D" Version="1" Correction="0" Language="CHN" Date="" Time="">
						<OfficialsNames>'
					+ @AthleteList
					+ N'
						</OfficialsNames>
					</Message>'

	SELECT @OutputXML
	RETURN

SET NOCOUNT OFF
END

GO

/*
DECLARE @OutputXML AS NVARCHAR(MAX)
EXEC [proc_CreateXML_X52] 'SP'
select @OutputXML
select cast(@OutputXML as xml)
*/