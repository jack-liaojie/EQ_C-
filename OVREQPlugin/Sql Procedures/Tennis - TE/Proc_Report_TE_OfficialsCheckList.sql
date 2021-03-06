IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_OfficialsCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_OfficialsCheckList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_Report_TE_OfficialsCheckList]
--描    述：网球项目得到Discipline下得裁判列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2010年10月19日


CREATE PROCEDURE [dbo].[Proc_Report_TE_OfficialsCheckList](
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
                                F_FimalyName    NVARCHAR(50),
                                F_GivenName     NVARCHAR(50),
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
                                F_Function      NVARCHAR(100),
                                F_FunctionOrder INT
							)

    INSERT INTO #Tmp_Table (F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_RegisterCode, F_ISTAFCode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_Function) 
		SELECT A.F_RegisterID, A.F_NOC, D.F_CountryLongName, A.F_Bib, B.F_LastName, B.F_FirstName, E.F_GenderCode, [dbo].[Func_Report_TE_GetDateTime](A.F_Birth_Date, 1, @LanguageCode), A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName
		, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName, B.F_SBLongName, B.F_SBShortName, F.F_FunctionShortName
		FROM TR_Register AS A
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Country_Des AS D ON A.F_NOC = D.F_NOC AND D.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Sex AS E ON A.F_SexCode = E.F_SexCode
		LEFT JOIN TD_Function_Des AS F ON A.F_FunctionID = F.F_FunctionID AND F.F_LanguageCode = @LanguageCode
		LEFT JOIN TD_Function AS G ON A.F_FunctionID = G.F_FunctionID
		WHERE A.F_RegTypeID = 4 AND A.F_DisciplineID = @DisciplineID
		ORDER BY A.F_NOC, A.F_SexCode, A.F_FunctionID, B.F_LastName, B.F_FirstName

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_RegisterCode, F_ISTAFCode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


