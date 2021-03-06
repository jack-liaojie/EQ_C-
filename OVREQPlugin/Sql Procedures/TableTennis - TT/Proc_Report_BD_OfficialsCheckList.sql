
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_OfficialsCheckList]    Script Date: 10/15/2010 11:38:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_OfficialsCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_OfficialsCheckList]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_OfficialsCheckList]    Script Date: 10/15/2010 11:38:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









--名    称：[Proc_Report_BD_OfficialsCheckList]
--描    述：得到Discipline下得裁判列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年06月25日


CREATE PROCEDURE [dbo].[Proc_Report_BD_OfficialsCheckList](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_DelegationID  INT,
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(20),
                                F_RegTypeID     INT,
                                F_RegDes        NVARCHAR(50),
                                F_FimalyName    NVARCHAR(50),
                                F_GivenName     NVARCHAR(50),
								F_SexCode	    INT,
								F_Gender		NVARCHAR(50),
                                F_Birth_Date    NVARCHAR(11),
                                F_RegisterCode  NVARCHAR(20),
                                F_WSFCode       NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(50),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(50),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(50),
                                F_WNPALN        NVARCHAR(100),
                                F_WNPASN        NVARCHAR(50),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100)
							)

    INSERT INTO #Tmp_Table (F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_RegisterCode, F_WSFCode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_RegisterID, A.F_NOC, D.F_CountryLongName, A.F_Bib, A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, [dbo].[Fun_Report_BD_GetDateTime](A.F_Birth_Date, 4), A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Country_Des AS D ON A.F_NOC = D.F_NOC AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID = 4 AND A.F_DisciplineID = @DisciplineID
		ORDER BY A.F_NOC, A.F_SexCode, A.F_RegTypeID

    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode AND F_RegTypeID = 4

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_RegisterCode, F_WSFCode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

