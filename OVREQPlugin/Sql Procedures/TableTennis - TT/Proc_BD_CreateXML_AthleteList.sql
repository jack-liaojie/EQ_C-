IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_CreateXML_AthleteList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_CreateXML_AthleteList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_BD_CreateXML_AthleteList]
----功		  能：得到参加BD项目的所有运动员列表
----作		  者：张翠霞
----日		  期: 2010-06-18



CREATE PROCEDURE [dbo].[Proc_BD_CreateXML_AthleteList] 
                   @DisciplineID			INT,
                   @OutputXML			    NVARCHAR(MAX) OUTPUT
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @AthleteList AS NVARCHAR(MAX)

	SET @AthleteList = (SELECT
			Athlete.F_ENGShortName AS [Name]
			, ISNULL(Athlete.F_CHNShortName,'') AS Name_CHN
			, Athlete.F_DelegationCode AS Noc
			, Athlete.F_DelegationShortName AS Noc_CHN
			, Athlete.F_GenderCode AS Gender
 
			FROM (SELECT B.F_SBShortName AS F_ENGShortName, C.F_GenderCode, D.F_DelegationCode, E.F_SBShortName AS F_CHNShortName, F.F_DelegationShortName
                FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'ENG'
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID
                LEFT JOIN TR_Register_Des AS E ON A.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = 'CHN'
                LEFT JOIN TC_Delegation_Des AS F ON D.F_DelegationID = F.F_DelegationID AND F.F_LanguageCode = 'CHN'
				WHERE A.F_RegisterID > 0 AND A.F_RegTypeID = 1 AND A.F_DisciplineID = @DisciplineID) AS Athlete
			FOR XML AUTO)

	IF @AthleteList IS NULL
	BEGIN
		SET @AthleteList = N''
	END

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
						<AthleteList>'
					+ @AthleteList
					+ N'
                        </AthleteList>'

	RETURN

SET NOCOUNT OFF
END


GO

