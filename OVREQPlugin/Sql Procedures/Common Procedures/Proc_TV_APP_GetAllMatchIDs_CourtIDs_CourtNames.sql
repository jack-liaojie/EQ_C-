
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames]    Script Date: 01/21/2010 11:18:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames]

GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames]    Script Date: 01/21/2010 11:19:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames]
----功		  能：为TV 应用程序服务, 得到一个Session下所有的MatchID及对应的CourtID和CourtName
----作		  者：管仁良
----日		  期: 2009-1-21 


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetAllMatchIDs_CourtIDs_CourtNames]
	                        @SessionID     INT
AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_MatchID, A.F_CourtID, B.F_CourtShortName FROM TS_Match AS A 
			LEFT JOIN TC_Court_Des AS B ON A.F_CourtID=B.F_CourtID AND B.F_LanguageCode='ENG' 
			WHERE A.F_SessionID = @SessionID 
			ORDER BY A.F_CourtID, A.F_OrderInSession

SET NOCOUNT OFF
END
