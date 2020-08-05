IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetCompetitionOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetCompetitionOfficials]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetCompetitionOfficials](
												@DisciplineID		INT,
                                                @DelegationID       INT,
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
                                F_Height        INT,
                                F_Weight        INT,
                                F_RegisterCode  NVARCHAR(20),
                                F_UCICode       NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(50),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(50),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(50),
                                F_WNPALN        NVARCHAR(100),
                                F_WNPASN        NVARCHAR(50),
                                F_HeightDes     NVARCHAR(20),
                                F_WeightDes     NVARCHAR(20),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100)
							)

    IF @DelegationID = -1
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, A.F_Bib, A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, [dbo].[Fun_Report_GF_GetDateTime](A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID IN( 4, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY C.F_DelegationCode, A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, A.F_Bib, A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, [dbo].[Fun_Report_GF_GetDateTime](A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_DelegationID = @DelegationID AND A.F_RegTypeID = 4 AND A.F_DisciplineID = @DisciplineID
		ORDER BY A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END

    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode
    UPDATE #Tmp_Table SET F_HeightDes = LEFT(F_Height / 100.0, 4) + ' / ' + CONVERT(NVARCHAR(2), F_Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(2), (F_Height * 100 / 254) % 12) + '"'
    UPDATE #Tmp_Table SET F_WeightDes = CONVERT(NVARCHAR(3), F_Weight) + ' / ' + CONVERT(NVARCHAR(5), F_Weight * 22 / 10)

    --UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName 
    --FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode AND F_RegTypeID = 5
   
    --UPDATE #Tmp_Table SET F_Function = 'Official' WHERE F_RegTypeID IN( 4, 5) AND @LanguageCode = 'ENG'
    --UPDATE #Tmp_Table SET F_Function = '¾ºÈü¹ÙÔ±' WHERE F_RegTypeID IN( 4, 5) AND @LanguageCode = 'CHN'

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName
    FROM #Tmp_Table AS A
    LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
    WHERE A.F_RegTypeID IN( 4, 5)  

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_HeightDes, F_WeightDes, F_RegisterCode, F_UCICode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

