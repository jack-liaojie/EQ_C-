
GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetDisciplineID]    Script Date: 01/21/2010 11:18:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetDisciplineID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetDisciplineID]

GO
/****** Object:  StoredProcedure [dbo].[Proc_TV_APP_GetDisciplineID]    Script Date: 01/21/2010 11:19:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TV_APP_GetDisciplineID]
----功		  能：为TV 应用程序服务, 得到一个Discipline的ID
----作		  者：管仁良
----日		  期: 2009-1-21 


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetDisciplineID]
	                        @DisciplineCode     NVARCHAR(10)
AS
BEGIN
	
SET NOCOUNT ON

	SELECT F_DisciplineID FROM TS_Discipline 
						WHERE F_DisciplineCode=@DisciplineCode

SET NOCOUNT OFF
END

--EXEC [Proc_TV_APP_GetDisciplineID] 'CR'
