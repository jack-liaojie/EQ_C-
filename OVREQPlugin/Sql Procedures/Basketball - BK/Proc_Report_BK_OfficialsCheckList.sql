IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_OfficialsCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_OfficialsCheckList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BK_OfficialsCheckList]
--描    述：得到Discipline下得裁判列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月21日


CREATE PROCEDURE [dbo].[Proc_Report_BK_OfficialsCheckList](
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
                                F_NOC           CHAR(10) collate database_default,
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
                                F_ISTAFCode     NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(50),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(50),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(50),
                                F_WNPAFN        NVARCHAR(100),
                                F_WNPAGN        NVARCHAR(50),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100)
							)

    INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_RegisterCode, F_ISTAFCode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPAFN, F_WNPAGN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, A.F_NOC, D.F_CountryLongName, A.F_Bib, A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, UPPER(LEFT(CONVERT (NVARCHAR(100), A.F_Birth_Date, 113), 11)), A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Country_Des AS D ON A.F_NOC = D.F_NOC AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID = 4 AND A.F_DisciplineID = @DisciplineID
		

    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode

    UPDATE #Tmp_Table SET F_Birth_Date = RIGHT(F_Birth_Date, 10) WHERE LEFT(F_Birth_Date, 1) = '0' 

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_RegisterCode, F_ISTAFCode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPAFN, F_WNPAGN 
    FROM #Tmp_Table AS A LEFT JOIN TD_Function AS B ON A.F_FunctionID = B.F_FunctionID
    ORDER BY F_NOC, F_SexCode,CASE B.F_FunctionCode
									WHEN 'RE' THEN 1
									WHEN 'UM' THEN 2
									END,
		F_PrintLN
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


