IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetMatchFinalResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetMatchFinalResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2011-1-14 
----修改	记录:


CREATE FUNCTION [Func_SH_GetMatchFinalResult]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							REG_ID INT,
							CP INT,
							S1 INT,
							S2 INT,
							S3 INT,
							S4 INT,
							S5 INT,
							S6 INT,
							S7 INT,
							S8 INT,
							S9 INT,
							S10 INT,
							S11 INT,
							S12 INT,
							S13 INT,
							S14 INT,
							S15 INT,
							S16 INT,
							S17 INT,
							S18 INT,
							S19 INT,
							S20 INT,
							S21 INT,
							S22 INT,
							S23 INT,
							S24 INT,
							S25 INT,
							S26 INT,
							S27 INT,
							S28 INT,
							S29 INT,
							S30 INT,
							S31 INT,
							S32 INT,
							S33 INT,
							S34 INT,
							S35 INT,
							S36 INT,
							S37 INT,
							S38 INT,
							S39 INT,
							S40 INT,
							ST INT,
							SR INT,
							Total INT,
							[Rank] INT
							)
AS
BEGIN

		DECLARE @PhaseCode NVARCHAR(10)
		SELECT @PhaseCode = PHASE_CODE FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
		IF @PhaseCode <> '1' 
		RETURN
		
		INSERT INTO @retTable(CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20,
								S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, S32, S33, S34, S35, S36, S37, S38, S39, S40)
		SELECT F_CompetitionPosition,'','','','','','','','','','','','','','','','','','','','',
										'','','','','','','','','','','','','','','','','','','',''
		FROM TS_Match_Result WHERE F_MatchID = @MatchID

		
		DECLARE @T1		 TABLE(
							REG_ID INT,
							CP INT,
							S1 INT,
							S2 INT,
							S3 INT,
							S4 INT,
							S5 INT,
							S6 INT,
							S7 INT,
							S8 INT,
							S9 INT,
							S10 INT,
							S11 INT,
							S12 INT,
							S13 INT,
							S14 INT,
							S15 INT,
							S16 INT,
							S17 INT,
							S18 INT,
							S19 INT,
							S20 INT,
							S21 INT,
							S22 INT,
							S23 INT,
							S24 INT,
							S25 INT,
							S26 INT,
							S27 INT,
							S28 INT,
							S29 INT,
							S30 INT,
							S31 INT,
							S32 INT,
							S33 INT,
							S34 INT,
							S35 INT,
							S36 INT,
							S37 INT,
							S38 INT,
							S39 INT,
							S40 INT,
							ST INT,
							SR INT,
							Total INT,
							[Rank] INT
							)
							
		INSERT INTO @T1(CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20,
							S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, S32, S33, S34, S35, S36, S37, S38, S39, S40)
		SELECT F_CompetitionPosition,
		[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],
		[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40]
		FROM (SELECT F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID) AS SourceTable
		PIVOT 
		(
			MAX(F_ActionDetail1) FOR F_MatchSplitID
			IN (
				[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],
				[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40]
			)
		)
		AS
		PivotTable

		UPDATE @retTable SET S1 = B.S1, S2 = B.S2, S3 = B.S3, S4 = B.S4, S5 = B.S5, S6 = B.S6, S7 = B.S7, S8 = B.S8, S9 = B.S9, S10 = B.S10,
				S11 = B.S11, S12 = B.S12, S13 = B.S13, S14 = B.S14, S15 = B.S15, S16 = B.S16, S17 = B.S17, S18 = B.S18, S19 = B.S19, S20 = B.S20,
				S21 = B.S21, S22 = B.S22, S23 = B.S23, S24 = B.S24, S25 = B.S25, S26 = B.S26, S27 = B.S27, S28 = B.S28, S29 = B.S29, S30 = B.S30,
				S31 = B.S31, S32 = B.S32, S33 = B.S33, S34 = B.S34, S35 = B.S35, S36 = B.S36, S37 = B.S37, S38 = B.S38, S39 = B.S39, S40 = B.S40			
		FROM @retTable A
		LEFT JOIN @T1 B ON A.CP = B.CP
		
		--UPDATE ST,SR
		UPDATE @retTable SET ST = ISNULL(S1,0) + ISNULL(S2,0) + ISNULL(S3,0) + ISNULL(S4,0) + ISNULL(S5,0) 
								 + ISNULL(S6,0) + ISNULL(S7,0)+ ISNULL(S8,0)+ ISNULL(S9,0)+ ISNULL(S10,0)
								 + ISNULL(S11,0)+ ISNULL(S12,0)+ ISNULL(S13,0)+ ISNULL(S14,0)+ ISNULL(S15,0)
								 + ISNULL(S16,0)+ ISNULL(S17,0)+ ISNULL(S18,0)+ ISNULL(S19,0)+ ISNULL(S20,0)
								 + ISNULL(S21,0) + ISNULL(S22,0) + ISNULL(S23,0) + ISNULL(S24,0) + ISNULL(S25,0) 
								 + ISNULL(S26,0) + ISNULL(S27,0)+ ISNULL(S28,0)+ ISNULL(S29,0)+ ISNULL(S30,0)
								 + ISNULL(S31,0)+ ISNULL(S32,0)+ ISNULL(S33,0)+ ISNULL(S34,0)+ ISNULL(S35,0)
								 + ISNULL(S36,0)+ ISNULL(S37,0)+ ISNULL(S38,0)+ ISNULL(S39,0)+ ISNULL(S40,0)								 

		UPDATE @retTable 
		SET SR = B.Rk
		FROM @retTable A
		LEFT JOIN (SELECT CP, RANK() OVER (ORDER BY ST DESC) AS Rk FROM @retTable)	B ON A.CP = B.CP
		
		UPDATE @retTable SET REG_ID = B.F_RegisterID
		FROM @retTable A LEFT JOIN TS_Match_Result B ON A.CP = B.F_CompetitionPosition
		WHERE B.F_MatchID = @MatchID
		
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetMatchFinalResult] (6)
-- SELECT * FROM dbo.[Func_SH_GetMatchFinalResult] (27)
-- SELECT * FROM dbo.[Func_SH_GetMatchFinalResult] (3)
--SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 