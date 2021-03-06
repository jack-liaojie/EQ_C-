
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetCourtName]    Script Date: 01/29/2010 12:43:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetCourtName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetCourtName]

GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetCourtName]    Script Date: 01/29/2010 12:44:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_TV_APP_GetCourtName]
----功		  能：为TV 应用程序服务, 得到一个Court的CourtName
----作		  者：管仁良
----日		  期: 2009-1-29 


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetCourtName]
	                        @CourtID     INT
AS
BEGIN
	
SET NOCOUNT ON

SELECT B.F_CourtShortName FROM TC_Court_Des AS B
		WHERE B.F_CourtID=@CourtID AND B.F_LanguageCode = 'ENG' 

SET NOCOUNT OFF
END

--EXEC [Proc_TV_APP_GetCourtName]540
