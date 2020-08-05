IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetEventMedalLists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetEventMedalLists]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_HO_GetEventMedalLists]
--描    述：得到当前Event下的排名信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年09月05日


CREATE PROCEDURE [dbo].[Proc_Report_HO_GetEventMedalLists](
												@EventID		    INT,
												@LanguageCode		    CHAR(3)
)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventID
	    , ER.F_EventRank
		, ER.F_EventDisplayPosition
		, ER.F_RegisterID
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, DD.F_DelegationLongName AS [TeamName]
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Medal_Des AS MD
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	WHERE E.F_EventID = @EventID

SET NOCOUNT OFF
END


GO
/*EXEC Proc_Report_HO_GetEventMedalLists 16, 'CHN'*/


