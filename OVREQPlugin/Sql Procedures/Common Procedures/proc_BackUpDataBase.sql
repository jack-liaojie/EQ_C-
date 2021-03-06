IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_BackUpDataBase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_BackUpDataBase]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----存储过程名称：[proc_BackUpDataBase]
----功		  能：备份数据库
----作		  者：郑金勇 
----日		  期: 2009-06-16 

CREATE PROCEDURE [dbo].[proc_BackUpDataBase] 
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DataBaseName		AS NVARCHAR(2000)
	DECLARE @DateTimePart		AS NVARCHAR(2000)
	DECLARE @SQL				AS NVARCHAR(2000)
	
	SELECT @DataBaseName = db_name(dbid) FROM master.dbo.sysprocesses WHERE spid = @@spid
	SELECT @DateTimePart = CONVERT (NVARCHAR(2000), GETDATE() , 120 )

	SET @DateTimePart = REPLACE(@DateTimePart,' ','=');
	SET @DateTimePart = REPLACE(@DateTimePart,':','_');

	DECLARE @FilePath AS NVARCHAR(2000)
	SELECT @FilePath = F_ItemValue FROM TC_SysConfig WHERE F_ItemName = 'Path'
	
	DECLARE @Extension AS NVARCHAR(2000)
	SET @Extension = ''
	SELECT @Extension = F_ItemValue FROM TC_SysConfig WHERE F_ItemName = 'Extension'
	
	IF @FilePath IS NULL OR @Extension IS NULL 
	BEGIN
		RETURN
	END

	SET @SQL = 'BACKUP DATABASE [' + @DataBaseName + '] TO DISK = N'+''''+ @FilePath + N'\' + @DataBaseName + @DateTimePart + @Extension +''''+    
        'WITH NOFORMAT, NOINIT, NAME = N'+'''' + @DataBaseName + '-FullBackup, SKIP, NOREWIND, NOUNLOAD, STATS = 10'+''''

	EXEC (@SQL)
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO