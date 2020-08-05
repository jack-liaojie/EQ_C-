IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetFinalResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetFinalResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--用于决赛中含有DNS的倒数规则

CREATE FUNCTION [Func_SH_GetFinalResult]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							F_RegisterID	INT,
							F_Points INT, 
							F_QResult INT,
							F_QRealScore	INT,
							F_Q12 INT,
							F_Q11 INT,
							F_Q10 INT,
							F_Q9 INT,
							F_Q8 INT,
							F_Q7 INT,
							F_Q6 INT,
							F_Q5 INT,
							F_Q4 INT,
							F_Q3 INT,
							F_Q2 INT,
							F_Q1 INT
							)
AS
BEGIN

		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)

		SELECT @EventCode = Event_Code,
				@PhaseCode = Phase_Code
		FROM dbo.Func_SH_GetEventCommonCodeInfo (@MatchID)
	
		
		DECLARE @T_QResult TABLE (
									F_MatchID	INT,
									F_RegisterID INT, 
									F_T INT, 
									F_X INT, 
									F_Q12 INT,
									F_Q11 INT,
									F_Q10 INT,
									F_Q9 INT,
									F_Q8 INT,
									F_Q7 INT,
									F_Q6 INT,
									F_Q5 INT,
									F_Q4 INT,
									F_Q3 INT,
									F_Q2 INT,
									F_Q1 INT
								)
							
		IF @PhaseCode = '1'
		BEGIN
		
			INSERT INTO @retTable(F_RegisterID, F_Points)
			SELECT F_RegisterID, F_Points
			FROM TS_Match_Result
			WHERE F_MatchID = @MatchID 
			ORDER BY F_Points DESC
			
			
			DECLARE @TT_MatchID INT
			DECLARE @TT_RealScore INT
			
			DECLARE FF_CURSOR CURSOR FOR
			SELECT F_MatchId FROM dbo.[Func_SH_GetQualificationMatchId] (@MatchID)			
			OPEN FF_CURSOR
			FETCH NEXT FROM FF_CURSOR INTO @TT_MatchID
			WHILE @@FETCH_STATUS = 0
			BEGIN
			
				INSERT INTO @T_QResult(F_MatchID, F_RegisterID, F_Q12, F_Q11, F_Q10, F_Q9, F_Q8, F_Q7,
				F_Q6, F_Q5, F_Q4, F_Q3, F_Q2, F_Q1, F_X)
				SELECT @TT_MatchID, REG_ID,S12,S11,S10,S9,S8,S7,S6,S5,S4,S3,S2,S1, @TT_RealScore
				FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@TT_MatchID)

				FETCH NEXT FROM FF_CURSOR INTO @TT_MatchID
			END
			CLOSE FF_CURSOR
			DEALLOCATE FF_CURSOR
			
			
			
			UPDATE @retTable SET F_Q12 = B.F_Q12,F_Q11 = B.F_Q11,F_Q10 = B.F_Q10,F_Q9 = B.F_Q9,F_Q8 = B.F_Q8,
			F_Q7 = B.F_Q7,F_Q6 = B.F_Q6,F_Q5 = B.F_Q5,F_Q4 = B.F_Q4,F_Q3 = B.F_Q3,F_Q2 = B.F_Q2,F_Q1 = B.F_Q1
			FROM @retTable A
			LEFT JOIN @T_QResult AS B
			ON A.F_RegisterID = B.F_RegisterID

			UPDATE @retTable SET F_QResult = ISNULL(F_Q12,0) + ISNULL(F_Q11,0) + ISNULL(F_Q10,0)
			 + ISNULL(F_Q9,0) + ISNULL(F_Q8,0) 
			+ ISNULL(F_Q7,0) + ISNULL(F_Q6,0) +  ISNULL(F_Q5,0) + ISNULL(F_Q4,0) 
			+ ISNULL(F_Q3,0) + ISNULL(F_Q2,0) + ISNULL(F_Q1,0)
			
			
			UPDATE @retTable SET F_QRealScore = B.F_RealScore
			FROM @retTable AS A
			LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID IN(SELECT F_MatchID FROM @T_QResult ) ) AS B
			ON A.F_RegisterID = B.F_RegisterID
		
		END
		
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetFinalResult] (38)
-- SELECT * FROM dbo.[Func_SH_GetFinalResult] (762)

-- SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 