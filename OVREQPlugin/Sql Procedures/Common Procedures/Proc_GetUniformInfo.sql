IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetUniformInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetUniformInfo]
Go
/****** Object:  StoredProcedure [dbo].[Proc_GetUniformInfo]    Script Date: 08/17/2009 16:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GetUniformInfo]
----功		  能：得到当前队服信息
----作		  者：李燕
----日		  期: 2009-08-17 

CREATE PROCEDURE [dbo].[Proc_GetUniformInfo](
                                         @RegisterID      int,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON
          SELECT A.F_Order AS [Order],B.F_ColorLongName AS [Shirt Color],C.F_ColorLongName AS [Shorts Color],D.F_ColorLongName AS [Socks Color], A.F_UniformID AS [ID]
					FROM TR_Uniform AS A LEFT JOIN TC_Color_Des AS B ON A.F_Shirt = B.F_ColorID AND B.F_LanguageCode = @LanguageCode
					 LEFT JOIN TC_Color_Des AS C ON A.F_Shorts = C.F_ColorID AND C.F_LanguageCode = @LanguageCode
					 LEFT JOIN TC_Color_Des AS D ON A.F_Socks = D.F_ColorID AND D.F_LanguageCode = @LanguageCode
					 WHERE A.F_RegisterID = @RegisterID

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
Go
SET ANSI_NULLS OFF
GO
