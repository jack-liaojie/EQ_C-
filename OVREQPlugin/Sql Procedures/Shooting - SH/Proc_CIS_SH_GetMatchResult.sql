
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_SH_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_SH_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----result and rank must select from ts_result f_points,f_pointsdes1,f_rank, it DOESN'T caculate
----Author£ºMU XUEFENG
----Date: 2010-09-19
----Modified by:
----
CREATE PROCEDURE [dbo].[Proc_CIS_SH_GetMatchResult] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
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
		
		
	SET @ID = 'SH' + 	@SEXCODE + @EventCode + @PhaseCode + @MatchCode
	
	CREATE TABLE #TMP(	
						COMPETITION_POS		INT,
						Relay				NVARCHAR(50),
						Bay					NVARCHAR(50),
						RegisterID			INT,
						StartTime			NVARCHAR(50),
						FP					NVARCHAR(10),
						BIB					NVARCHAR(50),
						Name				NVARCHAR(50),
						NOC					NVARCHAR(10),
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

	DECLARE @Result XML
	SELECT @Result = 
	(
		SELECT FP, 
				BAY, 
				BIB,
				Name, 
				NOC,
				DOB,
				(DATEPART(YEAR, GETDATE()) - RIGHT(DOB,4)) AS Age,
				S_T AS Q_T,
				S_R AS Q_R,
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
				ISNULL(F_11, '') F_11,
				ISNULL(F_12, '') F_12,
				ISNULL(F_13, '') F_13,
				ISNULL(F_14, '') F_14,
				ISNULL(F_15, '') F_15,
				ISNULL(F_16, '') F_16,
				ISNULL(F_17, '') F_17,
				ISNULL(F_18, '') F_18,
				ISNULL(F_19, '') F_19,
				ISNULL(F_20, '') F_20,
				F_T,
				F_R,
				Total,
				[Rank],
				ISNULL(F_Of, '') F_Of,
				ISNULL(Remark2, '') IRM
				 
			FROM #TMP 
		AS Result FOR XML AUTO
	)
		
	--SELECT * FROM #TMP
	
	DECLARE @ShoutCount INT
	SELECT @ShoutCount = MAX(F_MatchSplitID)
	FROM TS_Match_ActionList
	WHERE F_MatchID = @MatchID
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SET @OutputXML = (
    SELECT [Message].* ,
    @ShoutCount AS CurrentShot,
	@Result		
	FROM (SELECT 'GBRES' [Type], 'SH' [Discipline], @ID [ID])  AS [Message]
	FOR XML AUTO	
	)
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'	+ @OutputXML

	SELECT @OutputXML AS MessageXML
	
	
SET NOCOUNT OFF
END

GO


-- EXEC Proc_CIS_SH_GetMatchResult 141,'ENG'

-- EXEC Proc_Report_SH_GetMatchResult 1, 'ENG'

