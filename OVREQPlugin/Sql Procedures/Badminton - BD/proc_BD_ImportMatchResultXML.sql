
GO

/****** Object:  StoredProcedure [dbo].[proc_BD_ImportMatchResultXML]    Script Date: 10/15/2010 11:30:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_BD_ImportMatchResultXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_BD_ImportMatchResultXML]
GO


GO

/****** Object:  StoredProcedure [dbo].[proc_BD_ImportMatchResultXML]    Script Date: 10/15/2010 11:30:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[proc_BD_ImportMatchResultXML]
----功		  能：从XML文件导入比赛信息
----作		  者：张翠霞
----日		  期: 2010-06-23

CREATE PROCEDURE [dbo].[proc_BD_ImportMatchResultXML]
    @ActionXML			NVARCHAR(MAX),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	导入失败，标示没有做任何操作！
					  -- @Result=1; 	导入成功！

	RETURN

SET NOCOUNT OFF
END


GO

