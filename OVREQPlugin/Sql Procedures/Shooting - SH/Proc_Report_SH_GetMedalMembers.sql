IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetMedalMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetMedalMembers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetMedalMembers]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventID,
		ED.F_EventLongName,
		DBO.Func_Report_GetDateTime(E.F_CloseDate,4) AS Close_Date,
		ER.F_EventDisplayPosition,
		ER.F_RegisterID,
		RD.F_PrintLongName,
		UPPER(MD.F_MedalLongName) AS [Medal],
		D.F_DelegationCode AS [NOC]
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = E.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Medal_Des AS MD
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = R.F_RegisterID	AND RD.F_LanguageCode = @LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID
		AND ER.F_MedalID IS NOT NULL
	ORDER BY E.F_CloseDate, F_EventID, F_EventDisplayPosition
	
SET NOCOUNT OFF
END




GO


