
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TE_ExportAthleteXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_TE_ExportAthleteXML]
GO


/****** Object:  StoredProcedure [dbo].[proc_TE_ExportAthleteXML]    Script Date: 02/10/2011 16:13:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_TE_ExportAthleteXML]
----功		  能：为T&S导出运动员信息
----作		  者：李燕
----日		  期: 2011-04-11
----修改	记录:



CREATE PROCEDURE [dbo].[proc_TE_ExportAthleteXML]
		   @AthleteXML        NVARCHAR(MAX)  OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	INT
	SELECT @DisciplineID = F_DisciplineID  FROM TS_Discipline WHERE F_Active = 1

	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT
			Athlete.F_RegisterCode AS RegCode
			, ISNULL(Athlete.F_ShortName, '') AS Name
			, ISNULL(Athlete.F_ShortName_CHN, '')AS Name_CHN
			, ISNULL(Athlete.F_DelegationCode, '') AS NOC
			, Athlete.F_GenderCode AS Gender
			FROM (SELECT A.F_RegisterCode
			    , B.F_SBShortName AS F_ShortName
				, E.F_ShortName AS F_ShortName_CHN
				,ISNULL(D.F_DelegationCode, '') AS F_DelegationCode 
				,ISNULL(C.F_GenderCode, '') AS F_GenderCode
				FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'ENG'
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID 
				LEFT JOIN TR_Register_Des AS E ON A.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = 'CHN'
				 WHERE A.F_RegisterID > 0 AND A.F_RegTypeID = 1 AND A.F_DisciplineID = @DisciplineID) AS Athlete
			FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
	END

	SET @AthleteXML = N'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
					   <AthleteList>'
					+ @Content
					+ N'
					</AthleteList>'


    
	RETURN

SET NOCOUNT OFF
END


GO


