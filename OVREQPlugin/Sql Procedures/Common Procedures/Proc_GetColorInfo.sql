IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetColorInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetColorInfo]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GetColorInfo]
----功		  能：得到所有的颜色信息
----作		  者：李燕
----日		  期: 2009-08-17 

CREATE PROCEDURE [dbo].[Proc_GetColorInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_ColorLongName,A.F_ColorID FROM TC_Color as A LEFT JOIN TC_Color_Des as B ON A.F_ColorID = B.F_ColorID WHERE B.F_LanguageCode= @LanguageCode


Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS OFF
GO


