IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_Medallist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_Medallist]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_Medallist]
----功		  能：获取TVG需要的奖牌榜
----作		  者：王强
----日		  期: 2011-04-26

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_Medallist]
		@EventID INT
AS
BEGIN
	
SET NOCOUNT ON

	SELECT MD.F_MedalLongName + ' Medal' AS [MedalName], 
			CASE ER.F_MedalID
			WHEN 1 THEN '[Image]Gold'
			WHEN 2 THEN '[Image]Silver'
			WHEN 3 THEN '[Image]Bronze'
			ELSE ''
			END AS MedalLogo,
	REPLACE(A.F_TvShortName,'/',' / ') AS PlayerName, '[Image]' + D.F_DelegationCode AS [NOC],
	Md.F_MedalLongName + ' Medal - ' + ED.F_EventLongName AS MedalEventName
	FROM TS_Event_Result AS ER
	LEFT JOIN TS_Event AS E ON ER.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS A ON A.F_RegisterID = R.F_RegisterID AND A.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Medal_Des AS MD ON ER.F_MedalID = MD.F_MedalID AND MD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = ER.F_EventID AND ED.F_LanguageCode = 'ENG'
	WHERE ER.F_EventID = @EventID AND ER.F_MedalID IS NOT NULL
	
SET NOCOUNT OFF
END


GO


