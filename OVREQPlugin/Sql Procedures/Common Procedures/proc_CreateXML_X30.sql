IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateXML_X30]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateXML_X30]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_CreateXML_X30]
----功		  能：X30运动队中运动员的XML
----作		  者：郑金勇
----日		  期: 2010-01-07 

CREATE PROCEDURE [dbo].[proc_CreateXML_X30]
    @DisciplineCode		CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @DisciplineID AS INT

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	DECLARE @TeamList AS NVARCHAR(MAX)
	SET @TeamList = (SELECT 
						OVRCRS_Team_List.F_RegisterCode AS Team_ID
						, OVRCRS_Team_List.F_DelegationCode AS NOC
						, OVRCRS_Team_List.F_DisciplineCode AS Discipline_ID
						, OVRCRS_Team_List.F_GenderCode AS Gender
						, OVRCRS_Team_List.F_EventCode AS [Event]
--						, Athlete_List.F_RegisterCode AS ID
						,(
							SELECT F_RegisterCode AS ID FROM (SELECT A.F_RegisterID, B.F_RegisterCode FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID WHERE A.F_RegisterID = OVRCRS_Team_List.F_RegisterID) 
							AS Athlete_List
							FOR XML AUTO, TYPE
					     ) 
						 FROM
						(SELECT A.F_RegisterID, A.F_RegisterCode, A.F_NOC, B.F_EventID, C.F_EventCode, D.F_GenderCode, E.F_DisciplineCode, F.F_DelegationCode FROM TR_Register AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID 
								LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID LEFT JOIN TC_Sex AS D ON A.F_SexCode = D.F_SexCode 
								LEFT JOIN TS_Discipline AS E ON A.F_DisciplineID = E.F_DisciplineID
								LEFT JOIN TC_Delegation AS F ON A.F_DelegationID = F.F_DelegationID
								WHERE A.F_RegTypeID IN (2,3) AND A.F_DisciplineID = @DisciplineID) AS OVRCRS_Team_List
						FOR  XML AUTO)

	IF @TeamList IS NULL
	BEGIN
		SET @TeamList = N''
	END

	SET @OutputXML = N'<?xml version="1.0" encoding="Unicode"?>
						<!DOCTYPE Message PUBLIC "-//IDS//CRS" "ids/oris+/crs/main.dtd">
						<Message Category="TEM" Origin="TEST-1" Serial="4" RSC="'+ @DisciplineCode +N'0000000" Discipline="'+ @DisciplineCode +N'" Gender="0" Event="000" Phase="0" Unit="00" Venue="" Type="X01" Format="D" Version="1" Correction="0" Language="ENG" Date="" Time="">
						<OVRCRS_Team_Lists>'
					+ @TeamList
					+ N'
						</OVRCRS_Team_Lists>
						</Message>'


	SELECT @OutputXML
	RETURN

SET NOCOUNT OFF
END

GO

/*
EXEC [proc_CreateXML_X30] 'SQ'
*/