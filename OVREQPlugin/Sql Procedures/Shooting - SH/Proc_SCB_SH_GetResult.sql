IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetResult]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetResult]
             @MatchID         INT,
             @GroupNum        INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @ID NVARCHAR(50)
	DECLARE @PhaseCode CHAR(1)
	DECLARE @EventCode CHAR(3)
	DECLARE @MatchCode CHAR(2)
	DECLARE @SEXCODE CHAR(1)
	

	SELECT @PhaseCode = PHASE_CODE ,
		@EventCode = EVENT_CODE , 
		@MatchCode = Match_CODE ,
		@SEXCODE = GENDER_CODE
	FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
		
	CREATE TABLE #TMP(	
						COMPETITION_POS		INT,
						Relay				NVARCHAR(50),
						Bay					NVARCHAR(50),
						RegisterID			INT,
						StartTime			NVARCHAR(50),
						FP					NVARCHAR(10),
						BIB					NVARCHAR(50),
						Name				NVARCHAR(50),
						NOC					NVARCHAR(50),
						MQS					NVARCHAR(50),
						DOB					NVARCHAR(50),
						S_1					NVARCHAR(10),
						S_2					NVARCHAR(10),
						S_3					NVARCHAR(10),
						S_4					NVARCHAR(10),
						S_5					NVARCHAR(10),
						S_6					NVARCHAR(10),
						S_7					NVARCHAR(10),
						S_8					NVARCHAR(10),
						S_9					NVARCHAR(10),
						S_10				NVARCHAR(10),
						S_11				NVARCHAR(10),
						S_12				NVARCHAR(10),
						S_Of				NVARCHAR(10),
						S_ShotedCount		INT,
						S_1_4				NVARCHAR(10), 
						S_5_8				NVARCHAR(10), 
						S_9_12				NVARCHAR(10), 
						S_1_3				NVARCHAR(10), 
						S_4_6				NVARCHAR(10), 
						S_1_2				NVARCHAR(10), 
						S_3_4				NVARCHAR(10), 
						S_5_6				NVARCHAR(10), 
						S_T					NVARCHAR(10),
						S_A					NVARCHAR(10),
						S_R					INT,
						S_RANK				INT,
						F_1					NVARCHAR(10),
						F_2					NVARCHAR(10),
						F_3					NVARCHAR(10),
						F_4					NVARCHAR(10),
						F_5					NVARCHAR(10),
						F_6					NVARCHAR(10),
						F_7					NVARCHAR(10),
						F_8					NVARCHAR(10),
						F_9					NVARCHAR(10),
						F_10				NVARCHAR(10),
						F_11				NVARCHAR(10),
						F_12				NVARCHAR(10),
						F_13				NVARCHAR(10),
						F_14				NVARCHAR(10),
						F_15				NVARCHAR(10),
						F_16				NVARCHAR(10),
						F_17				NVARCHAR(10),
						F_18				NVARCHAR(10),
						F_19				NVARCHAR(10),
						F_20				NVARCHAR(10),
						F_21				NVARCHAR(10),
						F_22				NVARCHAR(10),
						F_23				NVARCHAR(10),
						F_24				NVARCHAR(10),
						F_25				NVARCHAR(10),
						F_26				NVARCHAR(10),
						F_27				NVARCHAR(10),
						F_28				NVARCHAR(10),
						F_29				NVARCHAR(10),
						F_30				NVARCHAR(10),
						F_31				NVARCHAR(10),
						F_32				NVARCHAR(10),
						F_33				NVARCHAR(10),
						F_34				NVARCHAR(10),
						F_35				NVARCHAR(10),
						F_36				NVARCHAR(10),
						F_37				NVARCHAR(10),
						F_38				NVARCHAR(10),
						F_39				NVARCHAR(10),
						F_40				NVARCHAR(10),
						F_Of				NVARCHAR(10),
						F_T					NVARCHAR(10),
						F_R					INT,
						IRMID				INT,
						[RANK]				INT,
						ORDER_RANK			INT,
						Total				NVARCHAR(50),
						SRank1				INT,
						SRank2				INT,
						Average1			NVARCHAR(50),
						Average2			NVARCHAR(50),
						Remark1				NVARCHAR(50),
						Remark2				NVARCHAR(50),
						Shootoff2			NVARCHAR(50),
						Shootoff3			NVARCHAR(50),
						Shootoff4			NVARCHAR(50),
						Shootoff5			NVARCHAR(50)
	)

	INSERT INTO #TMP EXEC Proc_Report_SH_GetMatchResult @MatchID, 'ENG'

	IF @EventCode = '005'
	BEGIN
		UPDATE #TMP SET Total = F_T
	END


	SELECT 
						Relay,
						Bay,
						RegisterID,
						StartTime,
						BIB,
						Name,
						'[IMAGE]' + NOC AS NOC,
						MQS,
						DOB,
						S_1,
						S_2,
						S_3,
						S_4,
						S_5,
						S_6,
						S_7,
						S_8,
						S_9	,
						S_10,
						S_11,
						S_12,
						S_Of,
						S_ShotedCount,
						S_1_4, 
						S_5_8, 
						S_9_12, 
						S_1_3, 
						S_4_6, 
						S_1_2, 
						S_3_4, 
						S_5_6, 
						S_T,
						S_A,
						S_R,
						S_RANK,
						F_1,
						F_2,
						F_3,
						F_4,
						F_5,
						F_6,
						F_7,
						F_8,
						F_9,
						F_10,
						F_11,
						F_12,
						F_13,
						F_14,
						F_15,
						F_16,
						F_17,
						F_18,
						F_19,
						F_20,
						F_21,
						F_22,
						F_23,
						F_24,
						F_25,
						F_26,
						F_27,
						F_28,
						F_29,
						F_30,
						F_31,
						F_32,
						F_33,
						F_34,
						F_35,
						F_36,
						F_37,
						F_38,
						F_39,
						F_40,
						F_Of,
						F_T,
						F_R,
						IRMID,
						[RANK],
						ORDER_RANK,
						Total,
						SRank1,
						SRank2,
						Average1,
						Average2,
						Remark1,
						Remark2,
						FP

	FROM #TMP
Set NOCOUNT OFF
End

GO


-- Proc_SCB_SH_GetResult 333,0,'ENG'