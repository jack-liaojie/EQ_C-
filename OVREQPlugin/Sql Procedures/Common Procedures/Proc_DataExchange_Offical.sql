
/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_Offical]    Script Date: 07/22/2011 15:51:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Offical]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Offical]
GO


/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_Offical]    Script Date: 07/22/2011 15:51:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_DataExchange_Offical]
----功		  能：官员与裁判信息(M0031)。
----作		  者：郑金勇
----日		  期: 2010-02-10 
----修  改 记 录
/*
		 2011-03-09		  郑金勇			对于输入参数@LanguageCode的特殊处理:当 @LanguageCode为'CHN'时要求在消息头里面的显示为 'CHI'.特殊处理！
         2011-03-09		  郑金勇			如果消息体是空的就让整个消息为空,不发送此消息.
         2011-03-18		  郑金勇			增加消息中Competition这一属性.
         2011-03-22		  郑金勇			增加消息中Federation这一属性.
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_Offical]
		@Discipline			AS NVARCHAR(50),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline

	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT
			Offical.F_RegisterCode AS Registration
			, Offical.Operate
			, ISNULL(Offical.F_LongName, '') AS [Name]
			, ISNULL(Offical.F_LastName, '') AS Family_Name
			, ISNULL(Offical.F_FirstName, '') AS Given_Name
			, ISNULL(Offical.F_TvLongName, '') AS TVName
			, ISNULL(Offical.F_ShortName, '') AS TVShortName
			, ISNULL(Offical.F_PrintLongName, '') AS PrintName
			, ISNULL(Offical.F_PrintShortName, '') AS PrintShortName
			, ISNULL(Offical.F_SBLongName, '') AS SCBName
			, ISNULL(Offical.F_SBShortName, '') AS SCBShortName
			, ISNULL(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), Offical.F_Birth_Date, 120 ), 10), '-', ''), '') AS Birthday
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
			, Offical.F_FederationCode AS [Federation]
			, Offical.Competition AS [Competition]
			FROM (SELECT A.F_RegisterCode, A.F_NOC, ISNULL(A.F_RegisterNum, '') AS F_RegisterNum, A.F_Birth_Date
				, ISNULL(CAST(CAST(A.F_Height AS INT) AS NVARCHAR(20)), '') AS F_Height, ISNULL(CAST(CAST(A.F_Weight AS INT) AS NVARCHAR(20)), '') AS F_Weight
				, D.F_DelegationCode, ISNULL(E.F_FunctionCode, '') AS F_FunctionCode, ISNULL(F.F_FederationCode, '') AS F_FederationCode, 'ALL' AS Operate, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName
				, B.F_TvLongName, B.F_TvShortName, B.F_SBLongName, B.F_SBShortName, B.F_PrintLongName, B.F_PrintShortName, C.F_GenderCode
				, ISNULL(A.F_Birth_City, '') AS Birth_City, ISNULL(A.F_Birth_Country, '') AS Birth_Country, ISNULL(A.F_Residence_City, '') AS Residence_City, ISNULL(A.F_Residence_Country, '') AS Residence_Country
				, (CASE WHEN A.F_RegTypeID = 5 THEN 'N' ELSE 'Y' END) AS Competition
			    FROM TR_Register AS A 
				LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID 
				LEFT JOIN TD_Function AS E ON A.F_FunctionID = E.F_FunctionID 
				LEFT JOIN TC_Federation AS F ON A.F_FederationID = F.F_FederationID
					WHERE A.F_RegisterID > 0 AND A.F_RegTypeID IN (4, 5) AND A.F_DisciplineID = @DisciplineID AND (A.F_NOC IS NOT NULL)) AS Offical
			FOR XML AUTO)

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

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
							+N' Code = "M0031"'
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


