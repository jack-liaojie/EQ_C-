IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_StartList_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_StartList_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_StartList_Team]
--描    述: 获取 StartList 团体屏幕数据集 
--创 建 人: 宁顺泽
--日    期: 2011年2月28日 星期一
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_StartList_Team]
	@MatchID							INT
AS
BEGIN
SET NOCOUNT ON
	select 
			TEDE.F_EventLongName,
			TPDE.F_PhaseLongName,
			TCDE.F_CourtShortName,	
			RA.F_NOC AS NOC_A,
			RB.F_NOC AS NOC_B,
			N'Blue' AS BLue,
			N'[Image]Card_Blue' AS Image_Blue,
			N'White' AS White,
			N'[Image]Card_White' AS Image_White,
			RDA1.F_PrintLongName AS Name_A1,
			RDA2.F_PrintLongName AS Name_A2,
			RDA3.F_PrintLongName AS Name_A3,
			RDA4.F_PrintLongName AS Name_A4,
			RDA5.F_PrintLongName AS Name_A5,
			RDB1.F_PrintLongName AS Name_B1,
			RDB2.F_PrintLongName AS Name_B2,
			RDB3.F_PrintLongName AS Name_B3,
			RDB4.F_PrintLongName AS Name_B4,
			RDB5.F_PrintLongName AS Name_B5
			,N'[Image]'+RA.F_NOC AS [Image_Noc_A]
			,N'[Image]'+RB.F_NOC as [Image_Noc_B]
			,TCDC.F_CourtShortName AS CourtName_CHN
		,TCDE.F_CourtShortName +N'（'+TCDC.F_CourtShortName +N'）' AS CourtName_ENG_CHN
		,TEDC.F_EventLongName AS EVentName_CHN
		,TEDE.F_EventLongName+N'（'+TEDC.F_EventLongName+N'）' AS EventName_ENG_CHN
		,TPDC.F_PhaseLongName AS PhaseName_CHN
		,TPDE.F_PhaseLongName+N'（'+TPDC.F_PhaseLongName+N'）' AS PhaseName_CHN_ENG 
	from TS_Match AS M
	LEFT JOIN TS_Phase AS TP
		ON M.F_PhaseID=TP.F_PhaseID
	LEFT JOIN TS_Phase_Des AS TPDE
		ON M.F_PhaseID=TPDE.F_PhaseID AND TPDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Phase_Des AS TPDC
		ON M.F_PhaseID=TPDC.F_PhaseID AND TPDC.F_LanguageCode='CHN'
	LEFT JOIN TS_Event AS TE
		ON TP.F_EventID=TE.F_EventID
	LEFT JOIN TS_Event_Des AS TEDE
		ON TE.F_EventID=TEDE.F_EventID AND TEDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Event_Des AS TEDC
		ON TE.F_EventID=TEDC.F_EventID AND TEDC.F_LanguageCode='CHN'
	LEFT JOIN TC_Court_Des AS TCDE
		ON M.F_CourtID=TCDE.F_CourtID AND TCDE.F_LanguageCode='ENG'
	LEFT JOIN TC_Court_Des AS TCDC
		ON M.F_CourtID=TCDC.F_CourtID AND TCDC.F_LanguageCode='CHN'
	Left Join TS_Match_Result AS MSRA
		ON M.F_MatchID= MSRA.F_MatchID AND MSRA.F_CompetitionPosition=1
	Left Join TR_Register_Member AS RMA1
		On MSRA.F_RegisterID=RMA1.F_RegisterID AND RMA1.F_Order=1
	LEFT JOIN TR_Register AS RA
		ON RMA1.F_MemberRegisterID=RA.F_RegisterID
	LEFT Join TR_Register_Des AS RDA1
		ON RMA1.F_MemberRegisterID=RDA1.F_RegisterID AND RDA1.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMA2
		On MSRA.F_RegisterID=RMA2.F_RegisterID AND RMA2.F_Order=2
	LEFT Join TR_Register_Des AS RDA2
		ON RMA2.F_MemberRegisterID=RDA2.F_RegisterID AND RDA2.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMA3
		On MSRA.F_RegisterID=RMA3.F_RegisterID AND RMA3.F_Order=3
	LEFT Join TR_Register_Des AS RDA3
		ON RMA3.F_MemberRegisterID=RDA3.F_RegisterID AND RDA3.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMA4
		On MSRA.F_RegisterID=RMA4.F_RegisterID AND RMA4.F_Order=4
	LEFT Join TR_Register_Des AS RDA4
		ON RMA4.F_MemberRegisterID=RDA4.F_RegisterID AND RDA4.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMA5
		On MSRA.F_RegisterID=RMA5.F_RegisterID AND RMA5.F_Order=5
	LEFT Join TR_Register_Des AS RDA5
		ON RMA5.F_MemberRegisterID=RDA5.F_RegisterID AND RDA5.F_LanguageCode='ENG'
					
	Left Join TS_Match_Result AS MSRB
		ON M.F_MatchID=MSRB.F_MatchID AND MSRB.F_CompetitionPosition=2
	Left Join TR_Register_Member AS RMB1
		On MSRB.F_RegisterID=RMB1.F_RegisterID AND RMB1.F_Order=1
	LEFT JOIN TR_Register AS RB
		ON RMB1.F_MemberRegisterID=RB.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDB1
		ON RMB1.F_MemberRegisterID=RDB1.F_RegisterID AND RDB1.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMB2
		On MSRB.F_RegisterID=RMB2.F_RegisterID AND RMB2.F_Order=2
	LEFT JOIN TR_Register_Des AS RDB2
		ON RMB2.F_MemberRegisterID=RDB2.F_RegisterID AND RDB2.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMB3
		On MSRB.F_RegisterID=RMB3.F_RegisterID AND RMB3.F_Order=3
	LEFT JOIN TR_Register_Des AS RDB3
		ON RMB3.F_MemberRegisterID=RDB3.F_RegisterID AND RDB3.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMB4
		On MSRB.F_RegisterID=RMB4.F_RegisterID AND RMB4.F_Order=4
	LEFT JOIN TR_Register_Des AS RDB4
		ON RMB4.F_MemberRegisterID=RDB4.F_RegisterID AND RDB4.F_LanguageCode='ENG'
	Left Join TR_Register_Member AS RMB5
		On MSRB.F_RegisterID=RMB5.F_RegisterID AND RMB5.F_Order=5
	LEFT JOIN TR_Register_Des AS RDB5
		ON RMB5.F_MemberRegisterID=RDB5.F_RegisterID AND RDB5.F_LanguageCode='ENG'
	WHERE M.F_MatchID=@MatchID
	
SET NOCOUNT OFF
END