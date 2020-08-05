IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetMedalListsByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetMedalListsByEvent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_GF_GetMedalListsByEvent]
--描    述：得到有奖牌榜信息的Event
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年09月15日


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetMedalListsByEvent](
												@DisciplineID		    INT,
												@LanguageCode		    CHAR(3)
)
AS
BEGIN
SET NOCOUNT ON

	SELECT ER.F_EventID
		, ER.F_EventDisplayPosition
		, ER.F_RegisterID
		, UPPER(MD.F_MedalLongName) AS [Medal]
		, D.F_DelegationCode AS [NOC]
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event AS E
		ON ER.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R
		ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Medal_Des AS MD
		ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = @LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID
		AND ER.F_MedalID IS NOT NULL

SET NOCOUNT OFF
END


GO


