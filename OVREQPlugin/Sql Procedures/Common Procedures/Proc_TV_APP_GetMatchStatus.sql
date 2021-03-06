
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetMatchStatus]    Script Date: 01/21/2010 11:18:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetMatchStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetMatchStatus]


GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetMatchStatus]    Script Date: 01/21/2010 11:19:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TV_APP_GetMatchStatus]
----功		  能：为TV 应用程序服务, 得到一个Match的StatusShortName
----作		  者：管仁良
----日		  期: 2009-1-21 


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetMatchStatus]
	                        @MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON

SELECT B.F_StatusShortName FROM TS_Match AS A 
		LEFT JOIN TC_Status_Des AS B ON A.F_MatchStatusID = B.F_StatusID AND B.F_LanguageCode = 'ENG' 
		WHERE F_MatchID=@MatchID

SET NOCOUNT OFF
END

--EXEC [Proc_TV_APP_GetMatchStatus] 1