if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetSessionsByDate_XML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetSessionsByDate_XML]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



--创 建 人：郑金勇
--日    期：2009年06月09日

Create Procedure Proc_GetSessionsByDate_XML(
						@CURRENTDATE		NVARCHAR(50)
)
As
Begin
Set Nocount On 

	DECLARE @CurLanguage AS CHAR(3)
	SELECT TOP 1 @CurLanguage =  F_LanguageCode FROM TC_Language where F_ACTIVE= 1
	
	CREATE TABLE #Temp_Table (
					[F_SessionID]			INT			NULL,
					[IDSESSION]				INT 		NULL,
					[CURRENTDATE]			DATETIME 	NULL,
					[SESSIONNAME] 			[nvarchar] (50)  	NULL,
					[MATCHCOUNT] 			INT   		NULL,
				        )
		
	INSERT INTO #Temp_Table (F_SessionID, IDSESSION, CURRENTDATE) SELECT F_SessionID, F_SessionNumber, F_SessionDate FROM TS_Session WHERE F_SessionDate = @CURRENTDATE
	UPDATE #Temp_Table SET SESSIONNAME = 'Session' + CAST (IDSESSION AS NVARCHAR(10)) 

	UPDATE #Temp_Table SET MATCHCOUNT = B.MATCHCOUNT FROM #Temp_Table AS A LEFT JOIN 
			(SELECT COUNT(F_MatchID) AS MATCHCOUNT, F_SessionID FROM TS_Match GROUP BY F_SessionID) AS B 
				ON A.F_SessionID = B.F_SessionID

	SELECT * FROM #Temp_Table
Set Nocount Off
End 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
/*
exec Proc_GetSessionsByDate_XML '20091016'
exec Proc_GetSessionsByDate_XML '20091017'
exec Proc_GetSessionsByDate_XML '20091018'
*/