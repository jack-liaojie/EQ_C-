

/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetTeamColours]    Script Date: 08/29/2012 09:55:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetTeamColours]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetTeamColours]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetTeamColours]    Script Date: 08/29/2012 09:55:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_HB_GetTeamColours]
--描    述：得到代表团下各个队的服饰颜色
--参数说明： 
--说    明：
--创 建 人：
--日    期：2010年10月28日


CREATE PROCEDURE [dbo].[Proc_Report_HB_GetTeamColours]
(
               @DelegationID        INT,
			   @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	 
	IF @DelegationID = -1
    BEGIN
			select a.F_RegisterID,b.F_UniformID,b.F_Shirt,b.F_Shorts,b.F_Socks,
				   c.F_ColorLongName as ShirtName,
				   d.F_ColorLongName as ShortsName,
				   e.F_ColorLongName as SocksName,
				   CASE ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ) 
				   WHEN 1 THEN  CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'st'
				   WHEN 2 THEN   CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'nd'
				   WHEN 3 THEN   CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'rd'
				   ELSE   CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'th' END  
				    AS Suite_Order
			from TR_Register as a
			INNER join TR_Uniform as b on a.F_RegisterID=b.F_RegisterID
			left join TC_Color_Des as c on b.F_Shirt=c.F_ColorID and c.F_LanguageCode=@LanguageCode
			left join TC_Color_Des as d on b.F_Shorts=d.F_ColorID and d.F_LanguageCode=@LanguageCode
			left join TC_Color_Des as e on b.F_Socks=e.F_ColorID and e.F_LanguageCode=@LanguageCode
			where a.F_RegTypeID = 3 order by b.F_Order
	END
	ELSE
	BEGIN
	     select a.F_RegisterID,b.F_UniformID,b.F_Shirt,b.F_Shorts,b.F_Socks,
				   c.F_ColorLongName as ShirtName,
				   d.F_ColorLongName as ShortsName,
				   e.F_ColorLongName as SocksName,
				    CASE ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ) 
				   WHEN 1 THEN  CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'st'
				   WHEN 2 THEN   CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'nd'
				   WHEN 3 THEN   CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'rd'
				   ELSE   CONVERT(NVARCHAR(100),ROW_NUMBER() OVER(PARTITION BY a.F_RegisterID ORDER BY b.F_Order ))+'th' END  
				    AS Suite_Order
			from TR_Register as a
			INNER join TR_Uniform as b on a.F_RegisterID=b.F_RegisterID
			left join TC_Color_Des as c on b.F_Shirt=c.F_ColorID and c.F_LanguageCode=@LanguageCode
			left join TC_Color_Des as d on b.F_Shorts=d.F_ColorID and d.F_LanguageCode=@LanguageCode
			left join TC_Color_Des as e on b.F_Socks=e.F_ColorID and e.F_LanguageCode=@LanguageCode
			where a.F_RegTypeID = 3 AND A.F_DelegationID = @DelegationID Order by b.F_Order
	END
	
Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


