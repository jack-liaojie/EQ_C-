IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetPhaseResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetPhaseResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2011-1-14 
----修改	记录:


CREATE FUNCTION [Func_SH_GetPhaseResult]
(
		@MatchID			INT
)
RETURNS @retTable	TABLE
						(F_MatchId INT,
						F_RegisterID INT,
						F_CP INT,
						F_S1 INT,
						F_S2 INT,
						F_S3 INT,
						F_S4 INT,
						F_S5 INT,
						F_S6 INT,
						F_S7 INT,
						F_S8 INT,
						F_S9 INT,
						F_S10 INT,
						F_S11 INT,
						F_S12 INT,
						F_Points INT,
						F_RealScore INT,
						F_IRMID INT)
AS
BEGIN


		DECLARE @TT TABLE (F_MatchID INT)


		INSERT INTO @TT(F_MatchID)
		SELECT F_MatchID FROM dbo.Func_SH_GetQualificationMatchId(@MatchID)

		DECLARE @MMid INT

		DECLARE PHASE_CURSOR CURSOR  FOR
		SELECT F_MatchId FROM @TT

		OPEN PHASE_CURSOR
		FETCH NEXT FROM PHASE_CURSOR INTO @MMid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @retTable(F_MatchId, F_RegisterID, F_CP, 
			F_S1, F_S2, F_S3, F_S4, F_S5, F_S6, F_S7, F_S8, F_S9, F_S10, F_S11, F_S12, F_Points, F_RealScore, F_IRMID)
			SELECT @MMid, REG_ID, CP, 
			S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, Points, RealScore, IRM_ID 
			FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@MMid)
			FETCH NEXT FROM PHASE_CURSOR INTO @MMid
		END
		CLOSE PHASE_CURSOR
		DEALLOCATE PHASE_CURSOR

	
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetPhaseResult] (299)  
