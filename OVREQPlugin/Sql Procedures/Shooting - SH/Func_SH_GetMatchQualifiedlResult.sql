IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetMatchQualifiedlResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetMatchQualifiedlResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2011-1-14 
----修改	记录:


CREATE FUNCTION [Func_SH_GetMatchQualifiedlResult]
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
							SCOUNT INT,
							IRM_ID INT,
							Points INT,
							RealScore INT,
							IRMID	INT
							)
AS
BEGIN

		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @EventInfo NVARCHAR(10)
		
		SELECT @EventCode = EVENT_CODE,
				@PhaseCode = PHASE_CODE,
				@EventInfo = Event_Info
		FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
		
		IF @PhaseCode NOT IN ('9' , 'A')
		RETURN
		
		INSERT INTO @retTable(CP)
		SELECT F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID


DECLARE @TT		 TABLE(
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
							SCOUNT INT,
							IRM_ID INT,
							Points INT,
							RealScore INT,
							IRMID	INT
							)

		INSERT INTO @TT(CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12)
		SELECT F_CompetitionPosition,
			[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
		FROM (SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID) AS SourceTable
		PIVOT 
		(
			MAX(F_ActionDetail1) FOR F_MatchSplitID
			IN (
			[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
			)
		)
		AS
		PivotTable
	
		UPDATE @retTable SET S1= B.S1,
		S2= B.S2,
		S3= B.S3,
		S4= B.S4,
		S5= B.S5,
		S6= B.S6,
		S7= B.S7,
		S8= B.S8,
		S9= B.S9,
		S10= B.S10,
		S11= B.S11,
		S12= B.S12
		FROM @retTable A
		LEFT JOIN @TT AS B
		ON A.CP = B.CP
		
		
		UPDATE @retTable SET SCOUNT = B.SCOUNT
		FROM @retTable A
		LEFT JOIN (
			SELECT F_CompetitionPosition, MAX(F_MatchSplitID) AS SCOUNT 
				FROM TS_Match_ActionList
				WHERE F_MatchID = @MatchID
				GROUP BY F_CompetitionPosition ) B
		ON A.CP = B.F_CompetitionPosition
		
		UPDATE @retTable SET REG_ID = B.F_RegisterID, IRM_ID = B.F_IRMID
		FROM @retTable A 
		LEFT JOIN TS_Match_Result B ON A.CP = B.F_CompetitionPosition
		WHERE B.F_MatchID = @MatchID
		
		
		IF @EventInfo IN ('25P', '25RF')
		BEGIN
			UPDATE @retTable SET S1 = S1 + ISNULL(S2,0),
								 S2 = S3 + ISNULL(S4,0),
								 S3 = S5 + ISNULL(S6,0),
								 S4 = S7 + ISNULL(S8,0),
								 S5 = S9 + ISNULL(S10,0),
								 S6 = S11 + ISNULL(S12,0),
								 S7 = NULL,
								 S8 = NULL,
								 S9 = NULL,
								 S10 = NULL,
								 S11 = NULL,
								 S12 = NULL
		END

		UPDATE @retTable SET Points = B.F_Points,
				RealScore = B.F_RealScore,
				IRMID = F_IRMID
		FROM @retTable A 
		LEFT JOIN TS_Match_Result B ON A.REG_ID = B.F_RegisterID
		WHERE B.F_MatchID = @MatchID

		
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (1)
-- SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (50)

--SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 