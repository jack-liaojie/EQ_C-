
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetQualificaionMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetQualificaionMatchResult]
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
CREATE PROCEDURE [dbo].[Proc_Report_SH_GetQualificaionMatchResult] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3),
	@ShowAll					INT = 0
)	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP(	
						COMPETITION_POS INT,
						Relay NVARCHAR(50),
						Bay NVARCHAR(50),
						RegisterID INT,
						StartTime NVARCHAR(50),
						FP NVARCHAR(10),
						BIB NVARCHAR(50),
						Name NVARCHAR(50),
						NOC NVARCHAR(10),
						MQS NVARCHAR(50),
						DOB NVARCHAR(50),
						S_1 NVARCHAR(10),
						S_2 NVARCHAR(10),
						S_3 NVARCHAR(10),
						S_4 NVARCHAR(10),
						S_5 NVARCHAR(10),
						S_6 NVARCHAR(10),
						S_7 NVARCHAR(10),
						S_8 NVARCHAR(10),
						S_9 NVARCHAR(10),
						S_10 NVARCHAR(10),
						S_11 NVARCHAR(10),
						S_12 NVARCHAR(10),
						S_Of NVARCHAR(10),-- Shoot off Score, 
						S_ShotedCount	INT,
						S_1_4 NVARCHAR(10), --S1+S2+S3+S4, for 3 position
						S_5_8 NVARCHAR(10), 
						S_9_12 NVARCHAR(10), 
						S_1_3 NVARCHAR(10), --S1+S2+S3, for 25 m rapid fire and 25 m pistol
						S_4_6 NVARCHAR(10), --S1+S2+S3, for 25 m
						S_1_2 NVARCHAR(10), --S1+S2, for 25 m standard pistol men
						S_3_4 NVARCHAR(10), 
						S_5_6 NVARCHAR(10), 
						S_T NVARCHAR(10),-- S1+S2...+S12
						S_A NVARCHAR(10),-- Average
						S_R NVARCHAR(10),-- Rank(S_T)
						S_RANK INT,
						F_1 NVARCHAR(10),
						F_2 NVARCHAR(10),
						F_3 NVARCHAR(10),
						F_4 NVARCHAR(10),
						F_5 NVARCHAR(10),
						F_6 NVARCHAR(10),
						F_7 NVARCHAR(10),
						F_8 NVARCHAR(10),
						F_9 NVARCHAR(10),
						F_10 NVARCHAR(10),
						F_11 NVARCHAR(10),
						F_12 NVARCHAR(10),
						F_13 NVARCHAR(10),
						F_14 NVARCHAR(10),
						F_15 NVARCHAR(10),
						F_16 NVARCHAR(10),
						F_17 NVARCHAR(10),
						F_18 NVARCHAR(10),
						F_19 NVARCHAR(10),
						F_20 NVARCHAR(10),
						F_21 NVARCHAR(10),
						F_22 NVARCHAR(10),
						F_23 NVARCHAR(10),
						F_24 NVARCHAR(10),
						F_25 NVARCHAR(10),
						F_26 NVARCHAR(10),
						F_27 NVARCHAR(10),
						F_28 NVARCHAR(10),
						F_29 NVARCHAR(10),
						F_30 NVARCHAR(10),
						F_31 NVARCHAR(10),
						F_32 NVARCHAR(10),
						F_33 NVARCHAR(10),
						F_34 NVARCHAR(10),
						F_35 NVARCHAR(10),
						F_36 NVARCHAR(10),
						F_37 NVARCHAR(10),
						F_38 NVARCHAR(10),
						F_39 NVARCHAR(10),
						F_40 NVARCHAR(10),
						F_Of NVARCHAR(10),
						F_T NVARCHAR(10),
						F_R INT,
						IRMID INT,
						[RANK] NVARCHAR(10),
						ORDER_RANK INT,
						Total NVARCHAR(50),
						SRank1 INT,
						SRank2 INT,
						Average1 NVARCHAR(50),
						Average2 NVARCHAR(50),
						Remark1 NVARCHAR(50),
						Remark2 NVARCHAR(50),
						Shootoff2 NVARCHAR(50),
						Shootoff3 NVARCHAR(50),
						Shootoff4 NVARCHAR(50),
						Shootoff5 NVARCHAR(50)
						
	)


	CREATE TABLE #T_QMatchID(F_MatchID INT)
	CREATE TABLE #T_QResult(
							REG_ID INT,
							CP		INT,
							S1		INT,
							S2		INT,
							S3		INT,
							S4		INT,
							S5		INT,
							S6		INT,
							S7		INT,
							S8		INT,
							S9		INT,
							S10		INT,
							S11		INT,
							S12		INT,
							SCOUNT  INT,
							IRMID	INT
							)
							
	
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = PHASE_CODE,
			 @MatchCode = Match_Code 
		FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

	IF ( @EventCode IN ('002', '004', '006', '008', '010', '012', '014', '102', '104', '106', '108', '110') ) 
	RETURN

	DECLARE @QPhaseID AS INT

	-- For save Qualification MatchID

	--Default is Qualification Match ID					  
		
	IF @PhaseCode = '1'
	BEGIN
		-- save it
		DECLARE @FinalMatchID INT
		SET @FinalMatchID = @MatchID
		
	
		SELECT @QPhaseID = F_SourcePhaseID 
		FROM TS_Match_Result 
		WHERE F_MatchID = @FinalMatchID  
		
		IF @EventCode = '005'
		BEGIN
			INSERT INTO #T_QMatchID(F_MatchID)		
			SELECT F_MatchID FROM TS_Match M
			WHERE M.F_PhaseID = @QPhaseID AND F_MatchCode = '02'
		END
		ELSE IF @EventCode IN( '007' , '109', '009', '011', '013', '107')
		BEGIN	
			INSERT INTO #T_QMatchID(F_MatchID)		
			SELECT F_MatchID FROM TS_Match M
			WHERE M.F_PhaseID = @QPhaseID AND F_MatchCode IN ('01')
		END
		ELSE 
		BEGIN	
			INSERT INTO #T_QMatchID(F_MatchID)		
			SELECT F_MatchID FROM TS_Match M
			WHERE M.F_PhaseID = @QPhaseID AND F_MatchCode IN ('00')
		END
	END	
		
	DECLARE @QMatchid INT	

	SELECT @QMatchid = F_MatchID FROM #T_QMatchID
	INSERT INTO #TMP EXEC Proc_Report_SH_GetMatchResult 	@QMatchid, 'ENG'
	
	
	DECLARE @CCOUNT INT
	SET @CCOUNT = 8
	IF @EventCode = '005'
	BEGIN
		SET @CCOUNT = 6
	END
	
	IF @ShowAll = 1
	BEGIN
		SELECT * FROM #TMP
	END
	ELSE
	BEGIN
		SELECT * FROM #TMP WHERE S_RANK > @CCOUNT
	END
	
END

GO


-- EXEC Proc_Report_SH_GetQualificaionMatchResult 1,'ENG'
-- EXEC Proc_Report_SH_GetQualificaionMatchResult 38,'ENG',1

