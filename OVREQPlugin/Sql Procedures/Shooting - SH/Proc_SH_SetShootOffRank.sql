
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_SetShootOffRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_SetShootOffRank]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_SH_SetShootOffRank] (	
	@MatchID					INT
)	

AS
BEGIN

			DECLARE @PhaseCode NVARCHAR(10)
			DECLARE @EventCode NVARCHAR(10)
			DECLARE @MatchCode NVARCHAR(10)
			SELECT @EventCode = Event_Code,
				 @PhaseCode = Phase_Code,
				 @MatchCode = Match_Code
			FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

			IF @MatchCode <> '50'
			RETURN 
			
			
			UPDATE TS_Match_Result SET F_Rank = B.RK
			FROM TS_Match_Result AS A
			LEFT JOIN
			(	
				SELECT F_MatchID, 
					R.F_RegisterID, 
					RANK() OVER (ORDER BY 
								P.[1] DESC,
								P.[2] DESC,
								P.[3] DESC,
								P.[4] DESC,
								P.[5] DESC,
								P.[6] DESC,
								P.[7] DESC,
								P.[8] DESC,
								P.[9] DESC,
								P.[10] DESC,
								P.[11] DESC,
								P.[12] DESC) 
					AS RK 
					FROM TS_Match_Result AS R
					LEFT JOIN (		
					SELECT F_RegisterID,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
				FROM (
						SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 
						FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
					 ) 	AS SourceTable
				PIVOT 
				(
					MAX(F_ActionDetail1) FOR F_MatchSplitID
					IN (
					[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
					)
				) AS PivotTable) AS P 
				ON P.F_RegisterID = R.F_RegisterID
				LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL
				
				) 
 ) 
				AS B ON A.F_RegisterID = B.F_RegisterID
			WHERE A.F_MatchID = @MatchID 



			

			DECLARE @WHO_NEED_SHOTOFF_RANK INT

			SELECT @WHO_NEED_SHOTOFF_RANK = MAX(F_Rank)
			FROM TS_Match_Result
			WHERE F_MatchID = @MatchID
			GROUP BY F_Rank
			HAVING COUNT(*) >= 2
			
	
			DECLARE @QMatchId INT
			SELECT @QMatchId = F_MatchID FROM dbo.Func_SH_GetQualificationMatchId(@MatchID)
			
			UPDATE TS_Match_Result SET F_Rank = F_Rank + B.RK -1
			FROM TS_Match_Result AS A
			LEFT JOIN
			(SELECT *,RANK() OVER(ORDER BY P.Points DESC, 
									P.RealScore DESC, 
									P.S12 DESC, P.S11 DESC, P.S10 DESC, P.S9 DESC, P.S8 DESC, P.S7 DESC, P.S6 DESC, 
									P.S5 DESC, P.S4 DESC, P.S3 DESC, P.S2 DESC, P.S1 DESC) AS RK
			 FROM 
			(SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@QMatchId)
			 WHERE REG_ID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_Rank = @WHO_NEED_SHOTOFF_RANK)
				) AS P 
				LEFT JOIN TC_IRM I ON P.IRMID = I.F_IRMID
				WHERE (I.F_IRMCODE NOT IN('DNS','DSQ') OR P.IRMID IS NULL) ) 
				AS B ON A.F_RegisterID = B.REG_ID
			WHERE F_MatchID = @MatchID AND A.F_Rank = @WHO_NEED_SHOTOFF_RANK






SET NOCOUNT OFF
END


GO


--			Proc_SH_SetShootOffRank 74