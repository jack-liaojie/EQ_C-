if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetEventHeaderByDate_XML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetEventHeaderByDate_XML]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



--创 建 人：郑金勇
--日    期：2009年06月09日

Create Procedure Proc_GetEventHeaderByDate_XML(
						@CURRENTDATE		NVARCHAR(50)
)
As
Begin
Set Nocount On 

	DECLARE @CurLanguage AS CHAR(3)
	SELECT TOP 1 @CurLanguage =  F_LanguageCode FROM TC_Language where F_ACTIVE= 1
	
	CREATE TABLE #Temp_Table (
					[CHAMPIONSHIPNAME] 			[nvarchar] (50)  	NULL,
					[EVENTNAME] 				[nvarchar] (50)   	NULL,
					[VENUENAME] 				[nvarchar] (50) 	NULL, 
					[CURRENTDATEDES] 			[nvarchar] (50) 	NULL,
					[CURRENTDATETEXTDES]		[nvarchar] (50) 	NULL
				)
	
	DECLARE @CHAMPIONSHIPNAME AS NVARCHAR(50)
	SELECT top 1 @CHAMPIONSHIPNAME = F_SportLongName FROM TS_Sport_Des WHERE F_LanguageCode = @CurLanguage

	DECLARE @EVENTNAME AS NVARCHAR(50)
	SELECT @EVENTNAME =F_DisciplineLongName FROM TS_Discipline_Des WHERE F_LanguageCode = @CurLanguage AND F_DisciplineID = 5

	DECLARE @VENUENAME AS NVARCHAR(50)
	SELECT @VENUENAME = F_VenueLongName FROM TC_Venue_Des WHERE F_LanguageCode = @CurLanguage AND F_VenueID = 9
				            
	DECLARE @CurDate AS DATETIME
	SET @CurDate = CAST (@CURRENTDATE AS DATETIME)
	
	INSERT INTO #Temp_Table (CHAMPIONSHIPNAME, EVENTNAME, VENUENAME, CURRENTDATEDES, CURRENTDATETEXTDES) 
		VALUES (@CHAMPIONSHIPNAME, @EVENTNAME, @VENUENAME, LEFT(CONVERT(NVARCHAR(50), @CurDate, 120), 10), LEFT(CONVERT(NVARCHAR(50), @CurDate, 120), 10))

	SELECT * FROM #Temp_Table
Set Nocount Off
End 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
/*
exec Proc_GetEventHeaderByDate_XML '20090608'
*/
