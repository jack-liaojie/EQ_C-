
/****** Object:  StoredProcedure [dbo].[Proc_Export_Offical]    Script Date: 02/10/2011 16:40:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Export_Offical]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Export_Offical]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Export_Offical]    Script Date: 02/10/2011 16:40:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Export_Offical]
----功		  能：官员与裁判信息(M0131)。
----作		  者：郑金勇
----日		  期: 2010-11-29 
----修  改 记 录
/*
                 2011 -01-25     李燕    增加Competition属性 
*/

CREATE PROCEDURE [dbo].[Proc_Export_Offical]
		@Discipline			AS NVARCHAR(50),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline

	--SELECT
	--		Offical.F_RegisterCode AS Registration
	--		, Offical.Operate
	--		, Offical.F_LongName AS [Name]
	--		, Offical.F_LastName AS Family_Name
	--		, Offical.F_FirstName AS Given_Name
	--		, Offical.F_TvLongName AS TVName
	--		, Offical.F_ShortName AS TVShortName
	--		, Offical.F_PrintLongName AS PrintName
	--		, Offical.F_PrintShortName AS PrintShortName
	--		, Offical.F_SBLongName AS SCBName
	--		, Offical.F_SBShortName AS SCBShortName
	--		, REPLACE(LEFT(CONVERT(NVARCHAR(MAX), Offical.F_Birth_Date, 120 ), 10), '-', '') AS Birthday
	--		, Offical.F_GenderCode AS Gender
	--		, Offical.Birth_City AS Birth_City
	--		, Offical.Birth_Country AS Birth_Country
	--		, Offical.Residence_City AS Residence_City
	--		, Offical.F_Height AS Height
	--		, Offical.F_Weight AS Weight
	--		, Offical.F_NOC AS Nationality
	--		, Offical.F_DelegationCode AS NOC
	--		, Offical.F_RegisterNum AS IF_Number
	--		, Offical.F_FunctionCode AS [Function]
	--		FROM (SELECT A.*, D.F_DelegationCode, E.F_FunctionCode, 'ALL' AS Operate, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName
	--			,B.F_TvLongName, B.F_TvShortName, B.F_SBLongName, B.F_SBShortName, B.F_PrintLongName, B.F_PrintShortName, C.F_GenderCode
	--			,'Birth_City' AS Birth_City, 'Birth_Country' AS Birth_Country, 'Residence_City' AS Residence_City FROM TR_Register AS A 
	--			LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	--			LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID 
	--			LEFT JOIN TD_Function AS E ON A.F_FunctionID = E.F_FunctionID 
	--				WHERE A.F_RegisterID > 0 AND A.F_RegTypeID IN (4, 5) AND A.F_DisciplineID = @DisciplineID) AS Offical
	--		FOR XML AUTO

	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT
			Offical.F_RegisterCode AS Registration
			, Offical.Operate
			, Offical.F_LongName AS [Name]
			, Offical.F_LastName AS Family_Name
			, Offical.F_FirstName AS Given_Name
			, Offical.F_TvLongName AS TVName
			, Offical.F_ShortName AS TVShortName
			, Offical.F_PrintLongName AS PrintName
			, Offical.F_PrintShortName AS PrintShortName
			, Offical.F_SBLongName AS SCBName
			, Offical.F_SBShortName AS SCBShortName
			, REPLACE(LEFT(CONVERT(NVARCHAR(MAX), Offical.F_Birth_Date, 120 ), 10), '-', '') AS Birthday
			, Offical.F_GenderCode AS Gender
			, Offical.Birth_City AS Birth_City
			, Offical.Birth_Country AS Birth_Country
			, Offical.Residence_City AS Residence_City
			, Offical.Residence_Country AS Residence_Country
			, Offical.F_Height AS Height
			, Offical.F_Weight AS Weight
			, Offical.F_NOC AS Nationality
			, Offical.F_DelegationCode AS NOC
			, Offical.F_RegisterNum AS IF_Number
			, Offical.F_FunctionCode AS [Function]
			, Offical.Competition AS [Competition]
			FROM (SELECT A.*, D.F_DelegationCode, E.F_FunctionCode, 'ALL' AS Operate, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName
				,B.F_TvLongName, B.F_TvShortName, B.F_SBLongName, B.F_SBShortName, B.F_PrintLongName, B.F_PrintShortName, C.F_GenderCode
				,A.F_Birth_City AS Birth_City, A.F_Birth_Country AS Birth_Country, A.F_Residence_City AS Residence_City, A.F_Residence_Country AS Residence_Country
				,(CASE WHEN A.F_RegTypeID = 5 THEN 'N' ELSE 'Y' END) AS Competition
			    FROM TR_Register AS A 
				LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID 
				LEFT JOIN TD_Function AS E ON A.F_FunctionID = E.F_FunctionID 
					WHERE A.F_RegisterID > 0 AND A.F_RegTypeID IN (4, 5) AND A.F_DisciplineID = @DisciplineID) AS Offical
			FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "CRS"' 
							+N' Origin = "CRS"'
							+N' RSC = "' + @Discipline + '0000000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "0"'
							+N' Event = "000"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M0131"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'

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


