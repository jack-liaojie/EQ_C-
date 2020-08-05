
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetMatchResult_Check]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetMatchResult_Check]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----result and rank must select from ts_result f_points,f_pointsdes1,f_rank, it DOESN'T caculate
----Author：MU XUEFENG
----Date: 2010-09-19
----Modified by:
----
CREATE PROCEDURE [dbo].[Proc_Report_SH_GetMatchResult_Check] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
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
						S_1_6 NVARCHAR(10), 
						S_7_12 NVARCHAR(10), 
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
						Shootoff5 NVARCHAR(50),
						x_1 NVARCHAR(10),
						x_2 NVARCHAR(10),
						x_3 NVARCHAR(10),
						x_4 NVARCHAR(10),
						x_5 NVARCHAR(10),
						x_6 NVARCHAR(10),
						x_7 NVARCHAR(10),
						x_8 NVARCHAR(10),
						x_9 NVARCHAR(10),
						x_10 NVARCHAR(10),
						x_11 NVARCHAR(10),
						x_12 NVARCHAR(10)
	)

	CREATE TABLE #RECORD(F_RegisterID INT, F_RecordType NVARCHAR(10))
	INSERT INTO #RECORD(F_RegisterID, F_RecordType)
	SELECT F_RegisterID, F_RecordCode FROM dbo.[Func_SH_GetRecord] (@MatchID)

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
							x1		INT,
							x2		INT,
							x3		INT,
							x4		INT,
							x5		INT,
							x6		INT,
							x7		INT,
							x8		INT,
							x9		INT,
							x10		INT,
							x11		INT,
							x12		INT,
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
		
		INSERT INTO #TMP(COMPETITION_POS, RegisterID, FP, BIB, NAME, NOC, DOB, IRMID, Total, ORDER_RANK, Bay)
		SELECT A.F_CompetitionPosition, A.F_RegisterID,  
				F_CompetitionPositionDes1, F_Bib, F_PrintLongName, D.F_DelegationCode, 
				dbo.Func_Report_GetDateTime(E.F_Birth_Date, 4), F_IRMID,
				CAST(CAST(A.F_Points/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)), A.F_Rank, [dbo].[Func_SH_GetBay](F_CompetitionPositionDes1)
		FROM  TS_Match_Result AS A 
			LEFT JOIN TR_Register AS E ON E.F_RegisterID = A.F_RegisterID
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation D ON D.F_DelegationID = E.F_DelegationID
		WHERE A.F_MatchID = @FinalMatchID 
		
		-- 25m 速射决赛 用整型表示			  
		IF @EventCode = '005'
		BEGIN
			UPDATE  #TMP SET 
					F_1 = CAST(CAST(B.S1/10 AS INT ) AS NVARCHAR(10)),  
					F_2 = CAST(CAST(B.S2/10 AS INT ) AS NVARCHAR(10)),  
					F_3 = CAST(CAST(B.S3/10 AS INT ) AS NVARCHAR(10)),  
					F_4 = CAST(CAST(B.S4/10 AS INT ) AS NVARCHAR(10)),  
					F_5 = CAST(CAST(B.S5/10 AS INT ) AS NVARCHAR(10)),  
					F_6 = CAST(CAST(B.S6/10 AS INT ) AS NVARCHAR(10)),  
					F_7 = CAST(CAST(B.S7/10 AS INT ) AS NVARCHAR(10)),  
					F_8 = CAST(CAST(B.S8/10 AS INT ) AS NVARCHAR(10)),  
					F_9 = CAST(CAST(B.S9/10 AS INT ) AS NVARCHAR(10)),  
					F_10 = CAST(CAST(B.S10/10 AS INT ) AS NVARCHAR(10)),  
					F_11 = CAST(CAST(B.S11/10 AS INT ) AS NVARCHAR(10)),  
					F_12 = CAST(CAST(B.S12/10 AS INT ) AS NVARCHAR(10)),  
					F_13 = CAST(CAST(B.S13/10 AS INT ) AS NVARCHAR(10)),  
					F_14 = CAST(CAST(B.S14/10 AS INT ) AS NVARCHAR(10)),  
					F_15 = CAST(CAST(B.S15/10 AS INT ) AS NVARCHAR(10)),  
					F_16 = CAST(CAST(B.S16/10 AS INT ) AS NVARCHAR(10)),  
					F_17 = CAST(CAST(B.S17/10 AS INT ) AS NVARCHAR(10)),  
					F_18 = CAST(CAST(B.S18/10 AS INT ) AS NVARCHAR(10)),  
					F_19 = CAST(CAST(B.S19/10 AS INT ) AS NVARCHAR(10)),  
					F_20 = CAST(CAST(B.S20/10 AS INT ) AS NVARCHAR(10)),
					F_21 = CAST(CAST(B.S21/10 AS INT ) AS NVARCHAR(10)),  
					F_22 = CAST(CAST(B.S22/10 AS INT ) AS NVARCHAR(10)),  
					F_23 = CAST(CAST(B.S23/10 AS INT ) AS NVARCHAR(10)),  
					F_24 = CAST(CAST(B.S24/10 AS INT ) AS NVARCHAR(10)),  
					F_25 = CAST(CAST(B.S25/10 AS INT ) AS NVARCHAR(10)),  
					F_26 = CAST(CAST(B.S26/10 AS INT ) AS NVARCHAR(10)),  
					F_27 = CAST(CAST(B.S27/10 AS INT ) AS NVARCHAR(10)),  
					F_28 = CAST(CAST(B.S28/10 AS INT ) AS NVARCHAR(10)),  
					F_29 = CAST(CAST(B.S29/10 AS INT ) AS NVARCHAR(10)),  
					F_30 = CAST(CAST(B.S30/10 AS INT ) AS NVARCHAR(10)),  
					F_31 = CAST(CAST(B.S31/10 AS INT ) AS NVARCHAR(10)),  
					F_32 = CAST(CAST(B.S32/10 AS INT ) AS NVARCHAR(10)),  
					F_33 = CAST(CAST(B.S33/10 AS INT ) AS NVARCHAR(10)),  
					F_34 = CAST(CAST(B.S34/10 AS INT ) AS NVARCHAR(10)),  
					F_35 = CAST(CAST(B.S35/10 AS INT ) AS NVARCHAR(10)),  
					F_36 = CAST(CAST(B.S36/10 AS INT ) AS NVARCHAR(10)),  
					F_37 = CAST(CAST(B.S37/10 AS INT ) AS NVARCHAR(10)),  
					F_38 = CAST(CAST(B.S38/10 AS INT ) AS NVARCHAR(10)),  
					F_39 = CAST(CAST(B.S39/10 AS INT ) AS NVARCHAR(10)),  
					F_40 = CAST(CAST(B.S40/10 AS INT ) AS NVARCHAR(10)),
					F_T = CAST(CAST(B.ST/10 AS INT ) AS NVARCHAR(10)),
					F_R = B.SR
			FROM #TMP A
			LEFT JOIN dbo.[Func_SH_GetMatchFinalResult] (@FinalMatchID) B ON A.RegisterID = B.REG_ID
		END
		
		ELSE
		BEGIN

			UPDATE  #TMP SET 
					F_1 = CAST(CAST(B.S1/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_2 = CAST(CAST(B.S2/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_3 = CAST(CAST(B.S3/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_4 = CAST(CAST(B.S4/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_5 = CAST(CAST(B.S5/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_6 = CAST(CAST(B.S6/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_7 = CAST(CAST(B.S7/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_8 = CAST(CAST(B.S8/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_9 = CAST(CAST(B.S9/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_10 = CAST(CAST(B.S10/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_11 = CAST(CAST(B.S11/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_12 = CAST(CAST(B.S12/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_13 = CAST(CAST(B.S13/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_14 = CAST(CAST(B.S14/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_15 = CAST(CAST(B.S15/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_16 = CAST(CAST(B.S16/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_17 = CAST(CAST(B.S17/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_18 = CAST(CAST(B.S18/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_19 = CAST(CAST(B.S19/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_20 = CAST(CAST(B.S20/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),
					F_21 = CAST(CAST(B.S21/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_22 = CAST(CAST(B.S22/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_23 = CAST(CAST(B.S23/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_24 = CAST(CAST(B.S24/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_25 = CAST(CAST(B.S25/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_26 = CAST(CAST(B.S26/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_27 = CAST(CAST(B.S27/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_28 = CAST(CAST(B.S28/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_29 = CAST(CAST(B.S29/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_30 = CAST(CAST(B.S30/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_31 = CAST(CAST(B.S31/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_32 = CAST(CAST(B.S32/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_33 = CAST(CAST(B.S33/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_34 = CAST(CAST(B.S34/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_35 = CAST(CAST(B.S35/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_36 = CAST(CAST(B.S36/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_37 = CAST(CAST(B.S37/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_38 = CAST(CAST(B.S38/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_39 = CAST(CAST(B.S39/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),  
					F_40 = CAST(CAST(B.S40/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),
					F_T = CAST(CAST(B.ST/10.0 AS Decimal(10,1) ) AS NVARCHAR(10)),
					F_R = B.SR
			FROM #TMP A
			LEFT JOIN dbo.[Func_SH_GetMatchFinalResult] (@FinalMatchID) B ON A.RegisterID = B.REG_ID
		END
						
		SELECT @QPhaseID = F_SourcePhaseID 
		FROM TS_Match_Result 
		WHERE F_MatchID = @FinalMatchID  
		
		INSERT INTO #T_QMatchID(F_MatchID)	
		SELECT F_MatchID FROM dbo.Func_SH_GetQualificationMatchId(@FinalMatchID)	
							
		DECLARE ONE_CURSOR CURSOR FOR
		SELECT F_MatchID FROM #T_QMatchID
		
		OPEN ONE_CURSOR
		FETCH NEXT FROM ONE_CURSOR INTO @MatchID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT #T_QResult(REG_ID, CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12,  SCOUNT, IRMID)
			SELECT REG_ID ,	CP ,S1 ,S2 ,S3 ,S4 ,S5 ,S6 ,S7 ,S8 ,S9 ,S10 ,S11 ,S12 ,	SCOUNT ,IRMID
			FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@MatchID)
			FETCH NEXT FROM ONE_CURSOR INTO @MatchID			
		END
		CLOSE ONE_CURSOR
		DEALLOCATE ONE_CURSOR			

		UPDATE #TMP SET S_1 = B.S1/10, 
						S_2 = B.S2/10, 
						S_3 = B.S3/10, 
						S_4 = B.S4/10, 
						S_5 = B.S5/10, 
						S_6 = B.S6/10, 
						S_7 = B.S7/10, 
						S_8 = B.S8/10, 
						S_9 = B.S9/10, 
						S_10 = B.S10/10, 
						S_11 = B.S11/10, 
						S_12 = B.S12/10,
						S_ShotedCount = B.SCOUNT
		FROM #TMP A
		LEFT JOIN #T_QResult B ON A.RegisterID = B.REG_ID

							
		UPDATE #TMP SET S_1_4 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0) + ISNULL(CAST(S_3 AS INT),0) + ISNULL(CAST(S_4 AS INT),0),0),
						S_5_8 = NULLIF(ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0) + ISNULL(CAST(S_7 AS INT),0) + ISNULL(CAST(S_8 AS INT),0),0),
						S_9_12 = NULLIF(ISNULL(CAST(S_9 AS INT),0) + ISNULL(CAST(S_10 AS INT),0) + ISNULL(CAST(S_11 AS INT),0) + ISNULL(CAST(S_12 AS INT),0),0),
						S_1_3 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0) + ISNULL(CAST(S_3 AS INT),0),0),
						S_4_6 = NULLIF(ISNULL(CAST(S_4 AS INT),0) + ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0),0),
						S_1_2 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0),0),
						S_3_4 = NULLIF(ISNULL(CAST(S_3 AS INT),0) + ISNULL(CAST(S_4 AS INT),0),0),
						S_5_6 = NULLIF(ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0),0)

		UPDATE  #TMP SET S_T = B.F_PhasePoints/10,
						 S_RANK = B.F_PhaseRank
		FROM #TMP A
		LEFT JOIN (SELECT * FROM TS_Phase_Result WHERE F_PhaseID = @QPhaseID) B ON A.RegisterID = B.F_RegisterID

		UPDATE #TMP SET Total = CAST(S_T AS DECIMAL(10,1)) + CAST(F_T AS DECIMAL(10,1))
		
		UPDATE #TMP SET Remark1 = B.F_IRMCODE
		FROM  #TMP AS A
		LEFT JOIN #T_QResult AS C ON C.REG_ID = A.RegisterID
		LEFT JOIN TC_IRM AS B ON C.IRMID = B.F_IRMID
		WHERE C.IRMID IN(1,2,3)
		
		--DECLARE @MM INT
		--SELECT @MM = FROM dbo.Func_SH_GetQualificationMatchId(@FinalMatchID)
		
		DECLARE @ShootOff INT
		SELECT @ShootOff = dbo.Func_SH_GetShootOffMatchID(@MatchID)
		UPDATE #TMP SET Remark1 = 'QS-off: ' + CAST(B.F_Points/10 AS NVARCHAR(10))
		FROM #TMP A
		LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @ShootOff) B ON A.RegisterID = B.F_RegisterID
		WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @ShootOff)
		
		
	END
	
	
	
	----------------------------------------------------------------------------------------------------------
	
	
	
	
	ELSE IF @PhaseCode = '9'
	BEGIN
	
	
		DECLARE @QMatchID INT
		SET @QMatchID = @MatchID
		
		SELECT @QPhaseID = F_PhaseID 
		FROM TS_Match
		WHERE F_MatchID = @QMatchID  

		--  OR (@MatchCode = '01' AND @EventCode IN('007', '009', '011', '013', '105', '107', '109') )
		IF @MatchCode = '00' 
		BEGIN

			INSERT INTO #TMP(RegisterID, BIB, NAME, NOC, IRMID,S_T, S_RANK)
			SELECT  PR.F_RegisterID, R.F_Bib, TR.F_PrintLongName, DD.F_DelegationCode, PR.F_IRMID,CAST(PR.F_PhasePoints/10  AS NVARCHAR(10)), PR.F_PhaseRank
			FROM TS_Phase_Result AS PR
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS TR ON PR.F_RegisterID = TR.F_RegisterId AND TR.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS DD ON DD.F_DelegationID = R.F_DelegationID
			WHERE F_PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @QMatchID)
				AND PR.F_RegisterID IS NOT NULL
			ORDER BY PR.F_PhaseRank, PR.F_RegisterID

			INSERT INTO #T_QMatchID(F_MatchID)	
			SELECT F_MatchID FROM dbo.Func_SH_GetQualificationMatchId(@QMatchID)	

										
			DECLARE ONE_CURSOR CURSOR FOR
			SELECT F_MatchID FROM #T_QMatchID
			
			OPEN ONE_CURSOR
			FETCH NEXT FROM ONE_CURSOR INTO @MatchID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT #T_QResult(REG_ID, CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, 
				x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, SCOUNT)
				SELECT REG_ID ,	CP ,S1 ,S2 ,S3 ,S4 ,S5 ,S6 ,S7 ,S8 ,S9 ,S10 ,S11 ,S12 ,	
				x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, SCOUNT 
				FROM dbo.[Func_SH_GetMatchQualifiedlResult_Check] (@MatchID)

				FETCH NEXT FROM ONE_CURSOR INTO @MatchID			
			END
			CLOSE ONE_CURSOR
			DEALLOCATE ONE_CURSOR			

		END
		

		ELSE
		BEGIN
		
			INSERT INTO #T_QMatchID(F_MatchID)		
			SELECT @QMatchID

			INSERT INTO #TMP(COMPETITION_POS, RegisterID, FP, BIB, NAME, NOC, DOB, IRMID, S_T, S_RANK)
			SELECT A.F_CompetitionPosition, A.F_RegisterID,  
					F_CompetitionPositionDes1, F_Bib, F_PrintLongName, D.F_DelegationCode, 
					dbo.Func_Report_GetDateTime(E.F_Birth_Date, 4), F_IRMID,
					CAST(A.F_Points/10  AS NVARCHAR(10)), A.F_Rank
			FROM  TS_Match_Result AS A 
				LEFT JOIN TR_Register AS E ON E.F_RegisterID = A.F_RegisterID
				LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Delegation D ON D.F_DelegationID = E.F_DelegationID
			WHERE A.F_MatchID = @MatchID 

			

			INSERT #T_QResult(REG_ID, CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12,
			x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, SCOUNT)
			SELECT REG_ID ,	CP ,S1 ,S2 ,S3 ,S4 ,S5 ,S6 ,S7 ,S8 ,S9 ,S10 ,S11 ,S12 ,	
			x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, SCOUNT 
			FROM dbo.[Func_SH_GetMatchQualifiedlResult_Check] (@MatchID)

		
		END
				

		UPDATE #TMP SET S_1 = B.S1/10, 
						S_2 = B.S2/10, 
						S_3 = B.S3/10, 
						S_4 = B.S4/10, 
						S_5 = B.S5/10, 
						S_6 = B.S6/10, 
						S_7 = B.S7/10, 
						S_8 = B.S8/10, 
						S_9 = B.S9/10, 
						S_10 = B.S10/10, 
						S_11 = B.S11/10, 
						S_12 = B.S12/10,
						x_1 =  B.x1,
						x_2 =  B.x2,
						x_3 =  B.x3,
						x_4 =  B.x4,
						x_5 =  B.x5,
						x_6 =  B.x6,
						x_7 =  B.x7,
						x_8 =  B.x8,
						x_9 =  B.x9,
						x_10 =  B.x10,
						x_11 =  B.x11,
						x_12 =  B.x12,
						S_ShotedCount = B.SCOUNT
		FROM #TMP A
		LEFT JOIN #T_QResult B ON A.RegisterID = B.REG_ID

							
		UPDATE #TMP SET S_1_4 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0) + ISNULL(CAST(S_3 AS INT),0) + ISNULL(CAST(S_4 AS INT),0),0),
						S_5_8 = NULLIF(ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0) + ISNULL(CAST(S_7 AS INT),0) + ISNULL(CAST(S_8 AS INT),0),0),
						S_9_12 = NULLIF(ISNULL(CAST(S_9 AS INT),0) + ISNULL(CAST(S_10 AS INT),0) + ISNULL(CAST(S_11 AS INT),0) + ISNULL(CAST(S_12 AS INT),0),0),
						S_1_3 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0) + ISNULL(CAST(S_3 AS INT),0),0),
						S_4_6 = NULLIF(ISNULL(CAST(S_4 AS INT),0) + ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0),0),
						S_1_2 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0),0),
						S_3_4 = NULLIF(ISNULL(CAST(S_3 AS INT),0) + ISNULL(CAST(S_4 AS INT),0),0),
						S_5_6 = NULLIF(ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0),0)

--		OR (@MatchCode = '01' AND @EventCode IN('007', '009', '011', '013', '105', '107', '109') )
		IF @MatchCode = '00'  
		BEGIN
			UPDATE  #TMP SET S_T = B.F_PhasePoints/10,
							 S_RANK = B.F_PhaseRank
			FROM #TMP A
			LEFT JOIN (SELECT * FROM TS_Phase_Result WHERE F_PhaseID = @QPhaseID) B ON A.RegisterID = B.F_RegisterID
		END
		
		UPDATE #TMP SET Total = CAST(S_T AS DECIMAL(10,1)) + CAST(F_T AS DECIMAL(10,1))
		
		IF @EventCode IN ('005','105')
		BEGIN
			UPDATE #TMP SET FP = R.F_CompetitionPositionDes2, 
				Bay = R.F_CompetitionPositionDes1,
				Relay = R.F_CompetitionPositionDes2
			FROM #TMP AS A
			LEFT JOIN TS_Match_Result AS R ON A.RegisterID = R.F_RegisterID
			WHERE F_MatchID IN (SELECT * FROM dbo.Func_SH_GetQualificationMatchId(@QMatchID) )
		END
		ELSE
		BEGIN
			UPDATE #TMP SET FP = R.F_CompetitionPositionDes1,
				Bay = R.F_CompetitionPositionDes2,
				Relay = R.F_CompetitionPositionDes1
			FROM #TMP AS A
			LEFT JOIN TS_Match_Result AS R ON A.RegisterID = R.F_RegisterID
			WHERE F_MatchID IN (SELECT * FROM dbo.Func_SH_GetQualificationMatchId(@QMatchID) )
		END		
	
	END
	

	ELSE IF @PhaseCode = 'A'
	BEGIN
		SET @QMatchID = @MatchID
		
		INSERT INTO #TMP(COMPETITION_POS, RegisterID, FP, BIB, NAME, NOC, DOB, IRMID, S_T, S_RANK)
		SELECT A.F_CompetitionPosition, A.F_RegisterID,  
				F_CompetitionPositionDes1, F_Bib, F_PrintLongName, D.F_DelegationCode, 
				dbo.Func_Report_GetDateTime(E.F_Birth_Date, 4), F_IRMID,
				CAST(A.F_Points/10  AS NVARCHAR(10)), A.F_Rank
		FROM  TS_Match_Result AS A 
			LEFT JOIN TR_Register AS E ON E.F_RegisterID = A.F_RegisterID
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation D ON D.F_DelegationID = E.F_DelegationID
		WHERE A.F_MatchID = @MatchID 


		INSERT #T_QResult(REG_ID, CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, 
		x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12,SCOUNT)
		SELECT REG_ID ,	CP ,S1 ,S2 ,S3 ,S4 ,S5 ,S6 ,S7 ,S8 ,S9 ,S10 ,S11 ,S12 ,	
		x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12,SCOUNT 
		FROM dbo.[Func_SH_GetMatchQualifiedlResult_Check] (@MatchID)

		UPDATE #TMP SET S_1 = B.S1/10, 
						S_2 = B.S2/10, 
						S_3 = B.S3/10, 
						S_4 = B.S4/10, 
						S_5 = B.S5/10, 
						S_6 = B.S6/10, 
						S_7 = B.S7/10, 
						S_8 = B.S8/10, 
						S_9 = B.S9/10, 
						S_10 = B.S10/10, 
						S_11 = B.S11/10, 
						S_12 = B.S12/10,
						x_1 =  B.x1,
						x_2 =  B.x2,
						x_3 =  B.x3,
						x_4 =  B.x4,
						x_5 =  B.x5,
						x_6 =  B.x6,
						x_7 =  B.x7,
						x_8 =  B.x8,
						x_9 =  B.x9,
						x_10 =  B.x10,
						x_11 =  B.x11,
						x_12 =  B.x12,
						S_ShotedCount = B.SCOUNT
		FROM #TMP A
		LEFT JOIN #T_QResult B ON A.RegisterID = B.REG_ID

							
		UPDATE #TMP SET S_1_4 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0) + ISNULL(CAST(S_3 AS INT),0) + ISNULL(CAST(S_4 AS INT),0),0),
						S_5_8 = NULLIF(ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0) + ISNULL(CAST(S_7 AS INT),0) + ISNULL(CAST(S_8 AS INT),0),0),
						S_9_12 = NULLIF(ISNULL(CAST(S_9 AS INT),0) + ISNULL(CAST(S_10 AS INT),0) + ISNULL(CAST(S_11 AS INT),0) + ISNULL(CAST(S_12 AS INT),0),0),
						S_1_3 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0) + ISNULL(CAST(S_3 AS INT),0),0),
						S_4_6 = NULLIF(ISNULL(CAST(S_4 AS INT),0) + ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0),0),
						S_1_2 = NULLIF(ISNULL(CAST(S_1 AS INT),0) + ISNULL(CAST(S_2 AS INT),0),0),
						S_3_4 = NULLIF(ISNULL(CAST(S_3 AS INT),0) + ISNULL(CAST(S_4 AS INT),0),0),
						S_5_6 = NULLIF(ISNULL(CAST(S_5 AS INT),0) + ISNULL(CAST(S_6 AS INT),0),0)
	
	END
	
	
		
	
	-- format report
	UPDATE #TMP SET S_A = NULLIF(CAST(CAST(1.0*CAST(S_T AS INT)/(10*S_ShotedCount) AS DECIMAL(10,3)) AS NVARCHAR(10)),'0.000')
	UPDATE #TMP SET S_T = NULL WHERE S_T = '0'
	UPDATE #TMP SET F_T = NULL WHERE F_T = '0.0'
	
	
	IF @PhaseCode IN ( '9', 'A')
	BEGIN
		UPDATE #TMP SET [RANK] = ORDER_RANK 
		FROM #TMP AS A
		LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
		WHERE (B.F_IRMCODE NOT IN('DNS','DSQ') OR A.IRMID IS NULL)
		
		UPDATE #TMP SET S_R = S_RANK 
		FROM #TMP AS A
		LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
		WHERE (B.F_IRMCODE NOT IN('DNS','DSQ') OR A.IRMID IS NULL)
	END
	ELSE
	BEGIN
		UPDATE #TMP SET [RANK] = ORDER_RANK 
		FROM #TMP AS A
		--LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
		--WHERE (B.F_IRMCODE NOT IN('DSQ') OR A.IRMID IS NULL)
		
		UPDATE #TMP SET S_R = S_RANK 
		FROM #TMP AS A
		--LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
		--WHERE (B.F_IRMCODE NOT IN('DSQ') OR A.IRMID IS NULL)
	END
		
	--set Remark	
	IF @PhaseCode = '1'
	BEGIN
		UPDATE #TMP SET Remark2 = B.F_IRMCODE
		FROM #TMP AS A
		LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
		WHERE IRMID IN(1,2,3)
	END
	
	IF @PhaseCode IN ( '9', 'A' )
	BEGIN
		UPDATE #TMP SET Remark1 = B.F_IRMCODE
		FROM #TMP AS A
		LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
		WHERE IRMID IN(1,2,3)
	END


	--Update Shoot-Off
	DECLARE @ShootOff_MatchID INT
	IF @PhaseCode = '9'
		SELECT @ShootOff_MatchID = dbo.Func_SH_GetShootOffMatchID(@QMatchID)
	IF @PhaseCode = '1'
		SELECT @ShootOff_MatchID = dbo.Func_SH_GetShootOffMatchID(@FinalMatchID)
	

	IF @ShootOff_MatchID IS NOT NULL
	BEGIN
		IF @EventCode IN('001','003','101','103') AND @PhaseCode = '9' AND @MatchCode = '00'
		BEGIN
			UPDATE #TMP SET Remark1 = 'QS-off: ' + CAST(B.F_Points/10 AS NVARCHAR(10))
			FROM #TMP A
			LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID) B ON A.RegisterID = B.F_RegisterID
			WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID)
		END

		IF @EventCode IN('105') AND @PhaseCode = '9' AND @MatchCode = '00'
		BEGIN
			UPDATE #TMP SET Remark1 = 'QS-off: ' + CAST(B.F_Points/10 AS NVARCHAR(10))
			FROM #TMP A
			LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID) B ON A.RegisterID = B.F_RegisterID
			WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID)
		END
				
		IF @EventCode IN('007','105','009','011','013','107','109') AND @PhaseCode = '9' AND @MatchCode = '01'
		BEGIN
			UPDATE #TMP SET Remark1 = 'QS-off: ' + CAST(B.F_Points/10 AS NVARCHAR(10))
			FROM #TMP A
			LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID) B ON A.RegisterID = B.F_RegisterID
			WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID)
		END

		IF @EventCode IN('005') AND @PhaseCode = '9' AND @MatchCode = '02'
		BEGIN
			UPDATE #TMP SET Remark1 = 'QS-off: ' + CAST(B.F_Points/10 AS NVARCHAR(10))
			FROM #TMP A
			LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID) B ON A.RegisterID = B.F_RegisterID
			WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID)
		END
		
		IF @PhaseCode = '1'
		BEGIN
			IF @EventCode = '005'
			BEGIN
				UPDATE #TMP SET Remark2 = 'S-off: ' + CAST(CAST(B.F_Points/10 AS INT) AS NVARCHAR(10))
				FROM #TMP A
				RIGHT JOIN (SELECT F_RegisterID, F_Points 
								FROM TS_Match_Result
								WHERE F_MatchID IN (
									SELECT F_MatchID FROM TS_Match
									WHERE F_PhaseID = 
									(
										SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @FinalMatchID)
										AND F_MatchCode IN ('50') AND F_RaceNum = '51'
									) AND F_RegisterID IS NOT NULL
								) AS B ON A.RegisterID = B.F_RegisterID


				UPDATE #TMP SET Shootoff2 = CAST(CAST(B.F_Points/10 AS INT) AS NVARCHAR(10))
				FROM #TMP A
				RIGHT JOIN (SELECT F_RegisterID, F_Points 
								FROM TS_Match_Result
								WHERE F_MatchID IN (
									SELECT F_MatchID FROM TS_Match
									WHERE F_PhaseID = 
									(
										SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @FinalMatchID)
										AND F_MatchCode IN ('50') AND F_RaceNum = '52'
									) AND F_RegisterID IS NOT NULL
								) AS B ON A.RegisterID = B.F_RegisterID

				UPDATE #TMP SET Shootoff3 = CAST(CAST(B.F_Points/10 AS INT) AS NVARCHAR(10))
				FROM #TMP A
				RIGHT JOIN (SELECT F_RegisterID, F_Points 
								FROM TS_Match_Result
								WHERE F_MatchID IN (
									SELECT F_MatchID FROM TS_Match
									WHERE F_PhaseID = 
									(
										SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @FinalMatchID)
										AND F_MatchCode IN ('50') AND F_RaceNum = '53'
									) AND F_RegisterID IS NOT NULL
								) AS B ON A.RegisterID = B.F_RegisterID

				UPDATE #TMP SET Shootoff4 =  CAST(CAST(B.F_Points/10 AS INT) AS NVARCHAR(10))
				FROM #TMP A
				RIGHT JOIN (SELECT F_RegisterID, F_Points 
								FROM TS_Match_Result
								WHERE F_MatchID IN (
									SELECT F_MatchID FROM TS_Match
									WHERE F_PhaseID = 
									(
										SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @FinalMatchID)
										AND F_MatchCode IN ('50') AND F_RaceNum = '54'
									) AND F_RegisterID IS NOT NULL
								) AS B ON A.RegisterID = B.F_RegisterID

				UPDATE #TMP SET Shootoff5 =  CAST(CAST(B.F_Points/10 AS INT) AS NVARCHAR(10))
				FROM #TMP A
				RIGHT JOIN (SELECT F_RegisterID, F_Points 
								FROM TS_Match_Result
								WHERE F_MatchID IN (
									SELECT F_MatchID FROM TS_Match
									WHERE F_PhaseID = 
									(
										SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @FinalMatchID)
										AND F_MatchCode IN ('50') AND F_RaceNum = '55'
									) AND F_RegisterID IS NOT NULL
								) AS B ON A.RegisterID = B.F_RegisterID



			END

			ELSE
			BEGIN
				UPDATE #TMP SET Remark2 = 'S-off: ' + CAST(CAST(B.F_Points/10.0 AS DECIMAL(10,1)) AS NVARCHAR(10))
				FROM #TMP A
				LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID) B ON A.RegisterID = B.F_RegisterID
				WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @ShootOff_MatchID)
			END
		END	
	END
	
	UPDATE #TMP SET Remark2  = 'S-off:' WHERE Remark2 IS NULL AND Shootoff2 IS NOT NULL 
	UPDATE #TMP SET Remark2  = 'S-off:' WHERE Remark2 IS NULL AND Shootoff3 IS NOT NULL
	UPDATE #TMP SET Remark2  = 'S-off:' WHERE Remark2 IS NULL AND Shootoff4 IS NOT NULL
	UPDATE #TMP SET Remark2  = 'S-off:' WHERE Remark2 IS NULL AND Shootoff5 IS NOT NULL
	
	-------------------end shoot off remark

	--	 set record
	IF @PhaseCode IN ( '9', 'A' )
	UPDATE #TMP SET Remark1 = B.F_RecordType
	FROM #TMP AS A 
	RIGHT JOIN #RECORD AS B ON A.RegisterID = B.F_RegisterID 
	
	IF @PhaseCode = '1'	
	UPDATE #TMP SET Remark2 = case when B.F_Equalled = 1 then 'E' + B.F_RecordTypeCode else B.F_RecordTypeCode end
	FROM #TMP AS A 
	LEFT JOIN
	(	
		SELECT A.F_RegisterID, D.F_RecordTypeCode, A.F_Equalled 
		FROM TS_Result_Record  AS A  
		LEFT JOIN TS_Event_Record AS C ON A.F_RecordID = C.F_RecordID 
		LEFT JOIN TC_RecordType AS D ON D.F_RecordTypeID = C.F_RecordTypeID
		WHERE F_MatchID = @FinalMatchID
	) 	 B ON A.RegisterID = B.F_RegisterID
	
	WHERE A.RegisterID IN (SELECT F_RegisterID FROM TS_Result_Record WHERE F_MatchID = @FinalMatchID)

--	Test	
--	SELECT * FROM #T_QMatchID
	
	--FORMAT INNER X
	--SELECT * FROM TC_Status_Des
	IF @PhaseCode = '9'
	BEGIN
		IF @EventCode = '005'
		BEGIN
			DECLARE @MS INT
			SELECT @MS = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @QMatchID
			
			IF @MS = 40
			BEGIN
				UPDATE #TMP SET S_T = S_T + '-' + space(4-2*len(CAST(B.F_RealScore as nvarchar(10)))) +  isnull(CAST(B.F_RealScore as nvarchar(10)),'0') + 'x'
				FROM #TMP AS A
				LEFT JOIN TS_MATCH_Result AS B ON A.RegisterID = B.F_RegisterID
				WHERE B.F_MatchID IN(
									SELECT F_MatchID FROM TS_Match M
										WHERE M.F_PhaseID = @QPhaseID AND F_MatchCode = '01'
						 ) 
			END
			ELSE
			BEGIN
				UPDATE #TMP SET S_T = S_T + '-' + space(4-2*len(CAST(B.F_RealScore as nvarchar(10)))) +  isnull(CAST(B.F_RealScore as nvarchar(10)),'0') + 'x'
				FROM #TMP AS A
				LEFT JOIN TS_MATCH_Result AS B ON A.RegisterID = B.F_RegisterID
				WHERE B.F_MatchID IN(SELECT F_MatchID FROM #T_QMatchID ) 
			END
		END
		
		ELSE
		BEGIN
			UPDATE #TMP SET S_T = S_T + '-' + space(4-2*len(CAST(B.F_RealScore as nvarchar(10)))) + isnull(CAST(B.F_RealScore as nvarchar(10)),'0') + 'x'
			FROM #TMP AS A
			LEFT JOIN TS_MATCH_Result AS B ON A.RegisterID = B.F_RegisterID
			WHERE B.F_MatchID IN(SELECT F_MatchID FROM #T_QMatchID ) 
		END
	END
	
	IF @PhaseCode = 'A'
	BEGIN
		UPDATE #TMP SET S_T = S_T + '-' + space(4-2*len(CAST(B.F_RealScore as nvarchar(10)))) + ISNULL(CAST(B.F_RealScore as nvarchar(10)) ,'0') + 'x'
		FROM #TMP AS A
		LEFT JOIN TS_MATCH_Result AS B ON A.RegisterID = B.F_RegisterID
		WHERE B.F_MatchID = @MatchID 
	END
	
	IF @PhaseCode = '1'
	BEGIN
		UPDATE  #TMP SET S_T = S_T  + '-' + space(4-2*len(CAST(R.F_RealScore as nvarchar(10)))) + ISNULL(CAST(R.F_RealScore AS NVARCHAR(10) ),'0') + 'x'
		FROM #TMP A
		LEFT JOIN TS_Match_Result AS R ON R.F_RegisterID = A.RegisterID
		WHERE R.F_MatchID IN ( SELECT F_MatchID FROM #T_QMatchID )
	END
	
	UPDATE #TMP SET S_1_6 = NULLIF(
								ISNULL(CAST(S_1 AS INT),0) 
								+ ISNULL(CAST(S_2 AS INT),0) 
								+ ISNULL(CAST(S_3 AS INT),0) 
								+ ISNULL(CAST(S_4 AS INT),0)
								+ ISNULL(CAST(S_5 AS INT),0) 
								+ ISNULL(CAST(S_6 AS INT),0),0 ),
							
					S_7_12 = NULLIF(
								ISNULL(CAST(S_7 AS INT),0) 
								+ ISNULL(CAST(S_8 AS INT),0) 
								+ ISNULL(CAST(S_9 AS INT),0) 
								+ ISNULL(CAST(S_10 AS INT),0)
								+ ISNULL(CAST(S_11 AS INT),0) 
								+ ISNULL(CAST(S_12 AS INT),0),0)
	
	IF @PhaseCode IN ( '9' , 'A' )
		SELECT * FROM #TMP ORDER BY S_RANK
	ELSE
		SELECT * FROM #TMP ORDER BY ORDER_RANK

	
SET NOCOUNT OFF
END

GO


-- EXEC Proc_Report_SH_GetMatchResult_Check 338,'ENG'
-- EXEC Proc_Report_SH_GetMatchResult_Check 1,'ENG'

