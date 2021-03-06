
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetSessionIDAndCourtID]    Script Date: 02/01/2010 10:06:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetSessionIDAndCourtID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetSessionIDAndCourtID]

GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetSessionIDAndCourtID]    Script Date: 02/01/2010 10:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TV_APP_GetSessionIDAndCourtID]
----功		  能：为TV 应用程序服务, 得到一个Court的CourtName
----作		  者：管仁良
----日		  期: 2009-1-29 


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetSessionIDAndCourtID]
	                        @MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON

	SELECT F_SessionID, F_CourtID
		FROM TS_Match
		WHERE F_MatchID = @MatchID

SET NOCOUNT OFF
END

--EXEC [Proc_TV_APP_GetSessionIDAndCourtID] 2003
