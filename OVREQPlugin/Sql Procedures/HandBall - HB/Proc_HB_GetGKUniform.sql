
/****** Object:  StoredProcedure [dbo].[Proc_HB_GetGKUniform]    Script Date: 08/30/2012 08:36:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetGKUniform]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetGKUniform]
GO


/****** Object:  StoredProcedure [dbo].[Proc_HB_GetGKUniform]    Script Date: 08/30/2012 08:36:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----�洢�������ƣ�[Proc_FB_GetUniform]
----��		  �ܣ��õ�һ���ӵķ�װ��Ϣ
----��		  �ߣ�����
----��		  ��: 2010-03-15

CREATE PROCEDURE [dbo].[Proc_HB_GetGKUniform](
                            @LanguageCode   NVARCHAR(3)					  
)
	
AS
BEGIN
	
SET NOCOUNT ON

    SELECT A.F_ColorID AS UniformID,A.F_ColorLongName AS UniformName FROM TC_Color_Des AS A WHERE A.F_LanguageCode = @LanguageCode ORDER BY F_ColorLongName

SET NOCOUNT OFF
END


GO


