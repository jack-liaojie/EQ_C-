/****** Object:  StoredProcedure [dbo].[Proc_GetColorList]    Script Date: 01/05/2010 11:50:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPictureInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPictureInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPictureInfo]    Script Date: 01/05/2010 11:41:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetPictureInfo]
----功		  能：得到所有的图片列表
----作		  者：李燕
----日		  期: 2010-01-05

CREATE PROCEDURE [dbo].[Proc_GetPictureInfo]
                                      	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT F_FileCode AS [FileCode]
		, F_FileComment AS [FileComment]
		, F_FileType AS [FileType]
		, F_FileID AS [ID]
	FROM TC_PicFile_Info 

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

