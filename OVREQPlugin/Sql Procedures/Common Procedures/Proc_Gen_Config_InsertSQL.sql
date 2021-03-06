IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Gen_Config_InsertSQL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Gen_Config_InsertSQL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Gen_Config_InsertSQL]
----功		  能：根据表明生成Insert语句
----作		  者：郑金勇
----日		  期: 2010-01-27

CREATE PROCEDURE [dbo].[Proc_Gen_Config_InsertSQL] (
												@tablename			NVARCHAR(256),
												@DisciplineCode		NVARCHAR(10)
											)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @sql NVARCHAR(MAX)
	DECLARE @sqlValues NVARCHAR(MAX)

	set @sql =' ('

	set @sqlValues = 'values (''+'

	select @sqlValues = @sqlValues + cols + ' + '','' + ' ,@sql = @sql + '[' + name + '],' 

	  from 

		  (select case 

					when xtype in (48,52,56,59,60,62,104,106,108,122,127)                                

						 then 'case when '+ name +' is null then ''NULL'' else ' + 'cast('+ name + ' as varchar)'+' end'

					when xtype in (58,61)

						 then 'case when '+ name +' is null then ''NULL'' else '+''''''''' + ' + 'cast('+ name +' as varchar)'+ '+'''''''''+' end'

				   when xtype in (167)

						 then 'case when '+ name +' is null then ''NULL'' else '+''''''''' + ' + 'replace('+ name+','''''''','''''''''''')' + '+'''''''''+' end'

					when xtype in (231)

						 then 'case when '+ name +' is null then ''NULL'' else '+'''N'''''' + ' + 'replace('+ name+','''''''','''''''''''')' + '+'''''''''+' end'

					when xtype in (175)

						 then 'case when '+ name +' is null then ''NULL'' else '+''''''''' + ' + 'cast(replace('+ name+','''''''','''''''''''') as Char(' + cast(length as varchar)  + '))+'''''''''+' end'

					when xtype in (239)

						 then 'case when '+ name +' is null then ''NULL'' else '+'''N'''''' + ' + 'cast(replace('+ name+','''''''','''''''''''') as Char(' + cast(length as varchar)  + '))+'''''''''+' end'

					else '''NULL'''

				  end as Cols,name

			 from syscolumns  

			where id = object_id(@tablename) 

		  ) T 

	SET @sqlValues = RTRIM(@sqlValues)
	IF EXISTS(SELECT * FROM SYS.COLUMNS WHERE [OBJECT_ID] = OBJECT_ID(@tablename) AND IS_IDENTITY = 1)
	BEGIN
			set @sql =N'SELECT ''DELETE FROM [' + @tablename + '] WHERE F_DisciplineCode = '''''+ @DisciplineCode +''''''' '
					 +N'UNION ALL SELECT ''SET IDENTITY_INSERT [' + @tablename + '] ON''
						UNION ALL SELECT ''INSERT INTO ['+ @tablename + ']' + left(@sql,len(@sql)-1)+') ' + left(@sqlValues,len(@sqlValues)-4) + ')'' from ' + @tablename + 
					 +N' WHERE F_DisciplineCode = '''+ @DisciplineCode +''''
					 +N'
						UNION ALL SELECT ''SET IDENTITY_INSERT ['+ @tablename + '] OFF'' '
	END
	ELSE
	BEGIN
			set @sql =N'SELECT ''DELETE FROM [' + @tablename + '] WHERE F_DisciplineCode = '''''+ @DisciplineCode +''''''' '
					 +N'UNION ALL SELECT ''INSERT INTO ['+ @tablename + ']' + left(@sql,len(@sql)-1)+') ' + left(@sqlValues,len(@sqlValues)-4) + ')'' from ' + @tablename + 
					 +N' WHERE F_DisciplineCode = '''+ @DisciplineCode +''''
	END
--	print @sql

	EXEC (@sql)

SET NOCOUNT OFF
END
GO 

--exec [Proc_Gen_Config_InsertSQL] 'TI_InfoTopic', 'SQ'
--
--exec [Proc_Gen_Config_InsertSQL] 'TI_TVResultTable', 'CR'
