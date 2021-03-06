IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BD_GetTeamMedallists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BD_GetTeamMedallists]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_SCB_BD_GetTeamMedallists]
--描    述：得到Event的奖牌信息
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2011年02月22日


CREATE PROCEDURE [dbo].[Proc_SCB_BD_GetTeamMedallists](
												@EventID		    INT,
												@MedalType          INT,
												@BronzeOrder        INT = 1
)
As
Begin
SET NOCOUNT ON 
	DECLARE @TeamRegID INT
	
	IF @BronzeOrder = 1
		SELECT @TeamRegID = MIN(F_RegisterID)
		FROM TS_Event_Result WHERE F_EventID = @EventID AND F_MedalID = @MedalType
	ELSE
		SELECT @TeamRegID = MAX(F_RegisterID)
		FROM TS_Event_Result WHERE F_EventID = @EventID AND F_MedalID = @MedalType
	
	SELECT C1.F_MedalLongName AS MedalName_ENG, C2.F_MedalLongName AS MedalName_CHN, 
		D1.F_SBLongName AS TeamName_ENG, D2.F_SBLongName AS TeamName_CHN, 
		B1.F_SBLongName AS PlayerName_ENG, B2.F_SBLongName AS PlayerName_CHN, '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(@TeamRegID) AS FlagLogo
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register_Member AS A ON A.F_RegisterID = ER.F_RegisterID
	LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_MemberRegisterID AND B1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_MemberRegisterID AND B2.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Medal_Des AS C1 ON C1.F_MedalID = @MedalType AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Medal_Des AS C2 ON C2.F_MedalID = @MedalType AND C2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = @TeamRegID AND D1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = @TeamRegID AND D2.F_LanguageCode = 'CHN'
	WHERE ER.F_EventID = @EventID AND ER.F_RegisterID = @TeamRegID AND ER.F_MedalID = @MedalType

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

