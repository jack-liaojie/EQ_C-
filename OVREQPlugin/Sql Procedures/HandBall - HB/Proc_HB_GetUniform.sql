
/****** Object:  StoredProcedure [dbo].[Proc_HB_GetUniform]    Script Date: 08/30/2012 08:43:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetUniform]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetUniform]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_GetUniform]    Script Date: 08/30/2012 08:43:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_HB_GetUniform]
----功		  能：得到一个队的服装信息
----作		  者：李燕
----日		  期: 2010-03-15

CREATE PROCEDURE [dbo].[Proc_HB_GetUniform](
                            @TeamID	        INT,
                            @LanguageCode   NVARCHAR(3)					  
)
	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_Uniform(
                                 F_UniformID        INT,
                                 F_RegisterID       INT,
                                 F_Shirt            INT,
                                 F_Shorts           INT,
                                 F_Socks            INT,
                                 F_ShirtName        NVARCHAR(50),
                                 F_ShortsName       NVARCHAR(50),
                                 F_SocksName        NVARCHAR(50),
                                 F_Order            INT,
                                 F_UiformName       NVARCHAR(200)
                                )

    INSERT INTO #table_Uniform (F_UniformID, F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order)
      SELECT F_UniformID, F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order FROM TR_Uniform
        WHERE F_RegisterID = @TeamID

    UPDATE #table_Uniform SET F_ShirtName = B.F_ColorLongName FROM #table_Uniform AS A LEFT JOIN
    TC_Color_Des AS B ON A.F_Shirt = B.F_ColorID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Uniform SET F_ShortsName = B.F_ColorLongName FROM #table_Uniform AS A LEFT JOIN
    TC_Color_Des AS B ON A.F_Shorts = B.F_ColorID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Uniform SET F_SocksName = B.F_ColorLongName FROM #table_Uniform AS A LEFT JOIN
    TC_Color_Des AS B ON A.F_Socks = B.F_ColorID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Uniform SET F_UiformName = (CASE WHEN F_ShirtName IS NULL THEN '' ELSE F_ShirtName END) + ', ' + (CASE WHEN F_ShortsName IS NULL THEN '' ELSE F_ShortsName END) + ', ' + (CASE WHEN F_SocksName IS NULL THEN '' ELSE F_SocksName END)

    SELECT F_UniformID AS UniformID, F_UiformName AS UniformName FROM #table_Uniform ORDER BY F_Order

SET NOCOUNT OFF
END


GO


