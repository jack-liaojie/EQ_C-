IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetEntryListByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetEntryListByNOC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_GF_GetEntryListByNOC]
--描    述：得到各个代表团下报项信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年09月15日


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetEntryListByNOC](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
	                            F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Birth_Date    NVARCHAR(20),
                                F_PrintLN       NVARCHAR(100),
                                F_Gender        NVARCHAR(10),
                                F_MI            NVARCHAR(1),
                                F_WI            NVARCHAR(1),
                                F_MT            NVARCHAR(1),
                                F_WT            NVARCHAR(1)    
							)  
    					
	INSERT INTO #Tmp_Table(F_RegisterID, F_NOC, F_NOCDes, F_Birth_Date, F_PrintLN, F_Gender)
	SELECT R.F_RegisterID, D.F_DelegationCode, DD.F_DelegationLongName, [dbo].[Fun_Report_GF_GetDateTime](R.F_Birth_Date, 4), RD.F_PrintLongName, S.F_GenderCode
	FROM TR_Register AS R
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex AS S ON R.F_SexCode = S.F_SexCode
	WHERE R.F_DisciplineID = @DisciplineID AND R.F_RegTypeID = 1
	ORDER BY D.F_DelegationCode, R.F_SexCode, RD.F_LastName, RD.F_FirstName
	
	UPDATE #Tmp_Table SET F_MI = 'X' FROM #Tmp_Table AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    WHERE C.F_DisciplineID = @DisciplineID AND C.F_EventCode = '001' AND C.F_SexCode = 1
    
    UPDATE #Tmp_Table SET F_WI = 'X' FROM #Tmp_Table AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    WHERE C.F_DisciplineID = @DisciplineID AND C.F_EventCode = '101' AND C.F_SexCode = 2
    
    UPDATE #Tmp_Table SET F_MT = 'X' FROM #Tmp_Table AS A LEFT JOIN TR_Register_Member AS RM ON A.F_RegisterID = RM.F_MemberRegisterID LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
    WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = '002' AND E.F_SexCode = 1
    
    UPDATE #Tmp_Table SET F_WT = 'X' FROM #Tmp_Table AS A LEFT JOIN TR_Register_Member AS RM ON A.F_RegisterID = RM.F_MemberRegisterID LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
    WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = '102' AND E.F_SexCode = 2
    
    DELETE FROM #Tmp_Table WHERE F_MI IS NULL AND F_MT IS NULL AND F_WI IS NULL AND F_WT IS NULL

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


