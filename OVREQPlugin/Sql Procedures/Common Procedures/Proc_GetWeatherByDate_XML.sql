if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetWeatherByDate_XML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetWeatherByDate_XML]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



--创 建 人：郑金勇
--日    期：2008年08月13日

Create Procedure Proc_GetWeatherByDate_XML(
						@CURRENTDATE		NVARCHAR(50)
)
As
Begin
Set Nocount On 

	DECLARE @CurLanguage AS CHAR(3)
	SELECT TOP 1 @CurLanguage =  F_LanguageCode FROM TC_Language where F_ACTIVE= 1
	
	CREATE TABLE #Temp_Table (
					[Temperature] 			[nvarchar] (50)  	NULL,
					[Humidity] 				[nvarchar] (50)   	NULL,
					[WInd Direction] 		[nvarchar] (50) 	NULL, 
					[Wind Speed] 			[nvarchar] (50) 	NULL
				)
	
		            
	INSERT INTO #Temp_Table (Temperature,[Humidity] ,[WInd Direction],[Wind Speed]) VALUES ('27', '35%', 'NE','12m/s')

	SELECT * FROM #Temp_Table
Set Nocount Off
End 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*

exec Proc_GetWeatherByDate_XML '20090608'
*/

