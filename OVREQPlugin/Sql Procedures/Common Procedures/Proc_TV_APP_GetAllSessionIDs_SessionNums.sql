
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetAllSessionIDs_SessionNums]    Script Date: 01/21/2010 11:18:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetAllSessionIDs_SessionNums]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetAllSessionIDs_SessionNums]


GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetAllSessionIDs_SessionNums]    Script Date: 01/21/2010 11:19:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TV_APP_GetAllSessionIDs_SessionNums]
----功		  能：为TV 应用程序服务, 得到一个Discipline下所有的SessionID及对应的SessionNumber
----作		  者：管仁良
----日		  期: 2009-1-21 


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetAllSessionIDs_SessionNums]
	                        @DisciplineCode     NVARCHAR(10)
AS
BEGIN
	
SET NOCOUNT ON

	SELECT  A.F_SessionID, A.F_SessionNumber FROM TS_Session AS A 
		LEFT JOIN TS_Discipline AS B ON B.F_DisciplineID=A.F_DisciplineID 
		WHERE F_DisciplineCode= @DisciplineCode 
		ORDER BY A.F_SessionNumber

SET NOCOUNT OFF
END



