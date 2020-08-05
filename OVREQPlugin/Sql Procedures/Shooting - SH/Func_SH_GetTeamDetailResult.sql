IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetTeamDetailResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetTeamDetailResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2011-1-14 
----修改	记录:


CREATE FUNCTION [Func_SH_GetTeamDetailResult]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							F_RANK INT,
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
							Sx	INT,
							Points INT
							)
AS
BEGIN

		DECLARE @TT TABLE (F_RegisterID INT, F_RegisterMemberID INT, F_Sx INT, F_Points INT, F_MemberIRMID INT)
		INSERT INTO @TT(F_RegisterID, F_RegisterMemberID, F_Points, F_Sx, F_MemberIRMID)
		SELECT TR.F_RegisterID, TM.F_MemberRegisterID, PR.F_Points, PR.F_RealScore, PR.F_IRMID
			FROM TR_Register_Member AS TM
			LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
			LEFT JOIN TS_Match_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
			LEFT JOIN TS_Match AS M ON M.F_MatchID = PR.F_MatchID
			LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
			WHERE TR.F_MatchID = @MatchID AND PR.F_MatchID IN (SELECT  F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
			
		--SELECT * FROM @TT
		--INSERT INTO @retTable(REG_ID)
		--SELECT F_RegisterID FROM @TT
		--GROUP BY F_RegisterID

		DECLARE @playerTable		 TABLE(
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
									SCOUNT INT
									)
		
		INSERT INTO @playerTable(CP, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, REG_ID)
		SELECT F_CompetitionPosition,
			[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],F_RegisterID
		FROM (SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 
				FROM TS_Match_ActionList WHERE F_MatchID IN (SELECT  F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID)) )  AS SourceTable
		PIVOT 
		(
			MAX(F_ActionDetail1) FOR F_MatchSplitID
			IN (
			[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
			)
		)
		AS
		PivotTable

		UPDATE @playerTable SET REG_ID = B.F_RegisterID
		FROM @playerTable A LEFT JOIN TS_Match_Result B ON A.REG_ID = B.F_RegisterID
		WHERE B.F_MatchID IN (SELECT  F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID)) 

	--	SELECT * FROM @playerTable
			
		INSERT INTO @retTable(REG_ID, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, Sx, Points)	
		SELECT B.F_RegisterID, SUM(S1) AS S1,SUM(S2) AS S2,SUM(S3) AS S3,
			SUM(S4) AS S4,SUM(S5) AS S5, SUM(S6) AS S6,
			SUM(S7) AS S7,SUM(S7) AS S8, SUM(S9) AS S9,
			SUM(S10) AS S10, SUM(S11) AS S11,SUM(S12) AS S12,
			SUM(B.F_Sx) AS Sx,
			SUM(B.F_Points) AS Points
			FROM @playerTable AS A
				RIGHT JOIN @TT AS B ON A.REG_ID = B.F_RegisterMemberID
		GROUP BY B.F_RegisterID	
		ORDER BY Points	DESC, Sx DESC, S12 DESC,S11 DESC, S10 DESC, S9 DESC, 
			S8 DESC, S7 DESC, S6 DESC, S5 DESC, S4 DESC, S3 DESC, S2 DESC, S1 DESC
			
		UPDATE @retTable SET F_Rank = B.t
		FROM @retTable AS A
		LEFT JOIN (SELECT *, RANK() OVER (ORDER BY Points	DESC, Sx DESC, S12 DESC,S11 DESC, S10 DESC, S9 DESC, 
			S8 DESC, S7 DESC, S6 DESC, S5 DESC, S4 DESC, S3 DESC, S2 DESC, S1 DESC) t FROM @retTable) 
		AS B ON A.REG_ID = B.REG_ID
		
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetTeamDetailResult] (1)
-- SELECT * FROM dbo.[Func_SH_GetTeamDetailResult] (50)
