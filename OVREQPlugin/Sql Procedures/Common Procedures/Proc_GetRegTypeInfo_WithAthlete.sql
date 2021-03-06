/****** Object:  StoredProcedure [dbo].[Proc_GetRegTypeInfo_WithAthlete]    Script Date: 09/18/2009 16:39:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeInfo_WithAthlete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeInfo_WithAthlete]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRegTypeInfo_WithAthlete]    Script Date: 09/18/2009 15:30:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetRegTypeInfo_WithAthlete]
----功		  能：得到所有的注册类型信息,根据是否为运动员
----作		  者：李燕
----日		  期: 2009-09-18 


CREATE PROCEDURE [dbo].[Proc_GetRegTypeInfo_WithAthlete](
                                         @LanguageCode    Char(3),
                                         @AthleteFliterID  INT   ---- 0:所有人员，1：运动员，2：非运动员
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

    IF (@AthleteFliterID = 0)
    BEGIN
		SELECT B.F_RegTypeLongDescription, A.F_RegTypeID 
		FROM TC_RegType AS A 
		LEFT JOIN TC_RegType_Des AS B 
			ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode= @LanguageCode
    END
    ELSE IF(@AthleteFliterID = 1)
    BEGIN
        SELECT B.F_RegTypeLongDescription, A.F_RegTypeID 
		FROM TC_RegType AS A 
		LEFT JOIN TC_RegType_Des AS B 
			ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode= @LanguageCode
        WHERE A.F_RegTypeID IN (1,2,3)
    END
    ELSE IF(@AthleteFliterID = 2)
    BEGIN
        SELECT B.F_RegTypeLongDescription, A.F_RegTypeID 
		FROM TC_RegType AS A 
		LEFT JOIN TC_RegType_Des AS B 
			ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode= @LanguageCode
        WHERE A.F_RegTypeID NOT IN (1,2,3)
    END

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

