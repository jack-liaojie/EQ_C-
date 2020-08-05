IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_StartList_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_StartList_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_StartList_Individual]
--描    述: 获取 StartList 屏幕数据集 
--创 建 人: 宁顺泽
--日    期: 2011年2月28日 星期一
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_StartList_Individual]
	@MatchID							INT
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #Temp_Table(
								F_EventName_ENG		NVARCHAR(100),
								F_EventName_CHN		NVARCHAR(100),
								F_PhaseName_ENG		NVARCHAR(100),
								F_PhaseName_CHN		NVARCHAR(100),
								F_CourtName_ENG		NVARCHAR(100),
								F_CourtName_CHN		NVARCHAR(100),
								F_Blue				NVARCHAR(10),
								F_Image_Blue		NVARCHAR(20),
								F_White				NVARCHAR(10),
								F_Image_White		NVARCHAR(20),
								F_BlueName_ENG		NVARCHAR(100),
								F_BlueName_CHN		NVARCHAR(100),
								F_BlueNOC_ENG		NVARCHAR(100),
								F_WhiteName_ENG		NVARCHAR(100),
								F_WhiteName_CHN		NVARCHAR(100),
								F_WhiteNOC_ENG		NVARCHAR(100),
								F_ServentFunction_1	NVARCHAR(100),
								F_ServentName_1		NVARCHAR(100),
								F_Servent_Noc_1		NVARCHAR(100),
								F_Image_Blue_Noc	NVARchar(100),
								F_Image_White_Noc	Nvarchar(100),
								F_Image_servent_Noc_1	Nvarchar(100),
								F_EventName_ENG_CHN NVARCHAR(100),
								F_PhaseName_ENG_CHN		NVARCHAR(100),
								F_CourtName_ENG_CHN		NVARCHAR(100)
							)
	INSERT INTO #Temp_Table(
								F_EventName_ENG,
								F_EventName_CHN,
								F_PhaseName_ENG,
								F_PhaseName_CHN,
								F_CourtName_ENG,
								F_CourtName_CHN,
								F_Blue,
								F_Image_Blue,
								F_White,
								F_Image_White,
								F_BlueName_ENG,
								F_BlueName_CHN,
								F_BlueNOC_ENG,
								F_WhiteName_ENG,
								F_WhiteName_CHN,
								F_WhiteNOC_ENG,
								F_ServentFunction_1,
								F_ServentName_1,
								F_Servent_Noc_1,
								F_Image_Blue_Noc,
								F_Image_White_Noc,
								F_Image_servent_Noc_1,
								F_EventName_ENG_CHN,
								F_PhaseName_ENG_CHN,
								F_CourtName_ENG_CHN

							)
	SELECT TEDE.F_EventShortName,TEDC.F_EventShortName,TPDE.F_PhaseShortName,
			TPDC.F_PhaseShortName,TCDE.F_CourtShortName,TCDC.F_CourtShortName,
			N'Blue',N'[Image]Card_Blue',N'White',N'[Image]Card_White',
			TRD_Blue_ENG.F_PrintShortName,TRD_Blue_CHN.F_PrintShortName,
			TR_Blue.F_NOC,TRD_White_ENG.F_PrintShortName,TRD_White_CHN.F_PrintShortName,
			TR_White.F_NOC,
			TFD1.F_FunctionShortName,TRD_Servent1.F_PrintLongName,TR_Servent1.F_NOC,

			N'[Image]'+TR_Blue.F_NOC,N'[Image]'+TR_White.F_NOC,
			N'[Image]'+TR_Servent1.F_NOC,
			TEDE.F_EventShortName+N'（'+TEDC.F_EventLongName+N'）',
			TPDE.F_PhaseShortName+N'（'+TPDC.F_PhaseShortName+N'）',
			TCDE.F_CourtShortName+N'（'+TCDC.F_CourtShortName+N'）'

	FROM TS_Match AS TM
	LEFT JOIN TS_Phase AS TP
		ON TM.F_PhaseID=TP.F_PhaseID
	LEFT JOIN TS_Phase_Des AS TPDE
		ON TM.F_PhaseID=TPDE.F_PhaseID AND TPDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Phase_Des AS TPDC
		ON TM.F_PhaseID=TPDC.F_PhaseID AND TPDC.F_LanguageCode='CHN'
	LEFT JOIN TS_Event AS TE
		ON TP.F_EventID=TE.F_EventID
	LEFT JOIN TS_Event_Des AS TEDE
		ON TE.F_EventID=TEDE.F_EventID AND TEDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Event_Des AS TEDC
		ON TE.F_EventID=TEDC.F_EventID AND TEDC.F_LanguageCode='CHN'
	LEFT JOIN TC_Court_Des AS TCDE
		ON TM.F_CourtID=TCDE.F_CourtID AND TCDE.F_LanguageCode='ENG'
	LEFT JOIN TC_Court_Des AS TCDC
		ON TM.F_CourtID=TCDC.F_CourtID AND TCDC.F_LanguageCode='CHN'
	LEFT JOIN TS_Match_Result AS TMR_Blue
		ON TM.F_MatchID= TMR_Blue.F_MatchID AND TMR_Blue.F_CompetitionPosition=1
	LEFT JOIN TR_Register AS TR_Blue
		ON TMR_Blue.F_RegisterID=TR_Blue.F_RegisterID
	LEFT JOIN TR_Register_Des AS TRD_Blue_ENG
		ON TMR_Blue.F_RegisterID=TRD_Blue_ENG.F_RegisterID AND TRD_Blue_ENG.F_LanguageCode='ENG'
	LEFT JOIN TR_Register_Des AS TRD_Blue_CHN
		ON TMR_Blue.F_RegisterID=TRD_Blue_CHN.F_RegisterID AND TRD_Blue_CHN.F_LanguageCode='CHN'
	LEFT JOIN TS_Match_Result AS TMR_White
		ON TM.F_MatchID=TMR_White.F_MatchID AND TMR_White.F_CompetitionPosition=2
	LEFT JOIN TR_Register AS TR_White
		ON TMR_White.F_RegisterID=TR_White.F_RegisterID
	LEFT JOIN TR_Register_Des AS TRD_White_ENG
		ON TMR_White.F_RegisterID=TRD_White_ENG.F_RegisterID AND TRD_White_ENG.F_LanguageCode='ENG'
	LEFT JOIN TR_Register_Des AS TRD_White_CHN
		ON TMR_White.F_RegisterID=TRD_White_CHN.F_RegisterID AND TRD_White_CHN.F_LanguageCode='CHN'
	LEFT JOIN TS_Match_Servant AS TMS1
		ON TM.F_MatchID=TMS1.F_MatchID
	LEFT JOIN TR_Register AS TR_Servent1
		ON TMS1.F_RegisterID=TR_Servent1.F_RegisterID
	LEFT JOIN TR_Register_Des AS TRD_Servent1
		ON TMS1.F_RegisterID=TRD_Servent1.F_RegisterID AND TRD_Servent1.F_LanguageCode='ENG'
	LEFT JOIN TD_Function_Des AS TFD1
		ON TMS1.F_FunctionID=TFD1.F_FunctionID AND TFD1.F_LanguageCode='ENG' 
	WHERE TM.F_MatchID=@MatchID 
	order by TFD1.F_FunctionLongName DESC
	
	SELECT * FROM #Temp_Table
	
SET NOCOUNT OFF
END

/*
  exec [Proc_SCB_JU_StartList_Individual] 22
*/