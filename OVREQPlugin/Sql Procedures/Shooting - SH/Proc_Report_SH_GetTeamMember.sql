IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetTeamMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetTeamMember]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetTeamMember](
												@EventID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_EventID       INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(10),
                                F_Birth_Date    NVARCHAR(20),
                                F_PrintLN       NVARCHAR(100)
							)
	
	INSERT INTO #Tmp_Table(F_EventID, F_NOC, F_NOCDes, F_Bib, F_Birth_Date, F_PrintLN)
	SELECT E.F_EventID, D.F_DelegationCode, DD.F_DelegationLongName, R.F_Bib, [dbo].[Fun_Report_GF_GetDateTime](R.F_Birth_Date, 4), RD.F_PrintLongName
	FROM TR_Register_Member AS RM
	LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID
	LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE E.F_EventID = @EventID AND E.F_PlayerRegTypeID = 3 ORDER BY D.F_DelegationCode, CAST(R.F_Bib AS INT)

    UPDATE #Tmp_Table SET F_Bib = F_NOC + F_Bib
	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


