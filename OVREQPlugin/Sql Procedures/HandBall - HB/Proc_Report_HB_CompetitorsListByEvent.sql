

/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_CompetitorsListByEvent]    Script Date: 08/29/2012 09:54:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_CompetitorsListByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_CompetitorsListByEvent]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_CompetitorsListByEvent]    Script Date: 08/29/2012 09:54:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_HB_CompetitorsListByEvent]
--描    述：得到代表团下各个队的运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年10月28日
  --1   翟广鹏 2011-03-02
  --    增加队员是否在场标志F_Active


CREATE PROCEDURE [dbo].[Proc_Report_HB_CompetitorsListByEvent](
												@DisciplineID		INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_EventID          INT,
                                F_RegisterID       INT,
                                F_MemberRegisterID INT,
                                F_FunctionID       INT,
                                F_Bib              INT,
                                F_Birth_Date       NVARCHAR(20),
                                F_Height           INT,
                                F_Weight           INT,
                                F_PrintLN          NVARCHAR(150),
                                F_PrintSN          NVARCHAR(100),
                                F_HeightDes        NVARCHAR(20),
                                F_WeightDes        NVARCHAR(20),
                                F_Function         NVARCHAR(20),
                                F_Position1        NVARCHAR(20),
                                F_ClubName         NVARCHAR(50),
                                F_FamilyName       NVARCHAR(50),
                                F_Comment          NVARCHAR(50),
                                F_ShirtNumber      NVARCHAR(20),
                                F_Active           INT
                                )

    IF @DelegationID = -1
    BEGIN
        INSERT INTO #Tmp_Table(F_EventID, F_RegisterID, F_MemberRegisterID, F_Bib, F_Birth_Date, F_Height, F_Weight, F_PrintLN, F_PrintSN, F_Position1, F_ClubName, F_FamilyName, F_Comment, F_FunctionID)
        SELECT A.F_EventID, A.F_RegisterID, B.F_MemberRegisterID, B.F_ShirtNumber, dbo.Func_HB_GetChineseDate(d.F_Birth_Date), D.F_Height, 
        D.F_Weight, E.F_PrintLongName, E.F_PrintShortName, F.F_PositionCode, J.F_ClubLongName, E.F_LastName, B.F_Comment, B.F_FunctionID
        FROM TR_Inscription AS A RIGHT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID
        LEFT JOIN TR_Register AS D ON B.F_MemberRegisterID = D.F_RegisterID
        LEFT JOIN TR_Register_Des AS E ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TD_Position AS F ON B.F_PositionID = F.F_PositionID 
        LEFT JOIN TC_Club_Des AS J ON D.F_ClubID = J.F_ClubID AND J.F_LanguageCode = @LanguageCode
        WHERE C.F_DisciplineID = @DisciplineID AND D.F_DisciplineID = @DisciplineID AND D.F_RegTypeID = 1
    END
    ELSE
    BEGIN
        INSERT INTO #Tmp_Table(F_EventID, F_RegisterID, F_MemberRegisterID, F_Bib, F_Birth_Date, F_Height, F_Weight, F_PrintLN, F_PrintSN, F_Position1, F_ClubName, F_FamilyName, F_Comment, F_FunctionID)
        SELECT A.F_EventID, A.F_RegisterID, B.F_MemberRegisterID, B.F_ShirtNumber, dbo.Func_HB_GetChineseDate(d.F_Birth_Date), D.F_Height,
        D.F_Weight, E.F_PrintLongName, E.F_PrintShortName, F.F_PositionCode, J.F_ClubLongName, E.F_LastName, B.F_Comment,  B.F_FunctionID
        FROM TR_Inscription AS A RIGHT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
        
        LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID
        LEFT JOIN TR_Register AS D ON B.F_MemberRegisterID = D.F_RegisterID
        LEFT JOIN TR_Register_Des AS E ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TD_Position AS F ON B.F_PositionID = F.F_PositionID 
        LEFT JOIN TC_Club_Des AS J ON D.F_ClubID = J.F_ClubID AND J.F_LanguageCode = @LanguageCode
        --LEFT JOIN TS_Match_Member as TMM ON TMM.F_RegisterID=B.F_MemberRegisterID
        WHERE C.F_DisciplineID = @DisciplineID AND D.F_DisciplineID = @DisciplineID AND D.F_RegTypeID = 1 AND D.F_DelegationID = @DelegationID
    END

--    UPDATE #Tmp_Table SET F_HeightDes = LEFT(F_Height / 100.0, 4) + ' / ' + CONVERT(NVARCHAR(2), F_Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(2), (F_Height * 100 / 254) % 12) + '"'
--    UPDATE #Tmp_Table SET F_WeightDes = CONVERT(NVARCHAR(3), F_Weight) + ' / ' + CONVERT(NVARCHAR(5), F_Weight * 22 / 10)

    UPDATE #Tmp_Table SET F_HeightDes = CAST(F_Height AS INT)
    UPDATE #Tmp_Table SET F_WeightDes = CAST(F_Weight AS INT)
    UPDATE #Tmp_Table SET F_Birth_Date = RIGHT(F_Birth_Date, 10) WHERE LEFT(F_Birth_Date, 1) = '0'

                   
                       
    UPDATE #Tmp_Table SET F_ShirtNumber = CAST( F_Bib AS NVARCHAR(20))
    
    UPDATE #Tmp_Table SET F_ShirtNumber = B.F_IRMCode FROM #Tmp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_Comment = CAST(B.F_IRMID AS NVARCHAR(50)) WHERE A.F_Comment IS NOT NULL

	UPDATE #Tmp_Table SET F_Active=TMM.F_Active FROM #Tmp_Table AS TT LEFT JOIN TS_Match_Member AS TMM ON TT.F_MemberRegisterID=TMM.F_RegisterID

	SELECT * FROM #Tmp_Table ORDER BY (CASE WHEN F_Comment IS NULL THEN 0 ELSE 1 END), F_Bib, F_FamilyName 

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


