IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetTeamIRM]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetTeamIRM]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----author£ºMU XUEFENG
----date: 2010-12-22 
----modifed by:


CREATE FUNCTION [Func_SH_GetTeamIRM]
(
		@MatchID			INT --TEAM'S matchid
)
RETURNS @retTable TABLE	(
							F_MatchID			INT,
							F_RegisterID		INT,
							F_IRMID				INT
							)
AS
BEGIN

	DECLARE @EventCode NVARCHAR(10)
	SELECT @EventCode = Event_Code FROM DBO.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	IF ( @EventCode NOT IN('002', '004', '006', '008', '010', '012', '014', '102', '104', '106', '108', '110') )
	RETURN

	INSERT INTO @retTable(F_MatchID, F_RegisterID)
	SELECT F_MatchID, F_RegisterID FROM TS_Match_Result 
	WHERE F_MatchID = @MatchID
	
	DECLARE @TT_DNS TABLE (F_RegisterID INT, F_IRMID INT)
	DECLARE @TT_DNF TABLE (F_RegisterID INT, F_IRMID INT)
	DECLARE @TT_DSQ TABLE (F_RegisterID INT, F_IRMID INT)

	INSERT INTO @TT_DNS(F_RegisterID, F_IRMID)
	SELECT T.F_RegisterID, R.F_IRMID 
	FROM TS_Match_Result AS R
	LEFT JOIN TR_Register_Member AS M ON R.F_RegisterID = M.F_MemberRegisterID
	LEFT JOIN TS_Match_Result AS T ON T.F_RegisterID = M.F_RegisterID
	WHERE R.F_MatchID IN (SELECT F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
	AND R.F_IRMID = 1 --DNS
	AND T.F_MatchID = @MatchID

	INSERT INTO @TT_DNF(F_RegisterID, F_IRMID)
	SELECT T.F_RegisterID, R.F_IRMID 
	FROM TS_Match_Result AS R
	LEFT JOIN TR_Register_Member AS M ON R.F_RegisterID = M.F_MemberRegisterID
	LEFT JOIN TS_Match_Result AS T ON T.F_RegisterID = M.F_RegisterID
	WHERE R.F_MatchID IN (SELECT F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
	AND R.F_IRMID = 2 --DNF
	AND T.F_MatchID = @MatchID

	INSERT INTO @TT_DSQ(F_RegisterID, F_IRMID)
	SELECT T.F_RegisterID, R.F_IRMID 
	FROM TS_Match_Result AS R
	LEFT JOIN TR_Register_Member AS M ON R.F_RegisterID = M.F_MemberRegisterID
	LEFT JOIN TS_Match_Result AS T ON T.F_RegisterID = M.F_RegisterID
	WHERE R.F_MatchID IN (SELECT F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
	AND R.F_IRMID = 3 --DSQ
	AND T.F_MatchID = @MatchID

	UPDATE @retTable SET F_IRMID = T.F_IRMID
	FROM @retTable AS R
	RIGHT JOIN @TT_DNS AS T ON R.F_RegisterID = T.F_RegisterID
	WHERE R.F_MatchID = @MatchID

	UPDATE @retTable SET F_IRMID = T.F_IRMID
	FROM @retTable AS R
	RIGHT JOIN @TT_DNF AS T ON R.F_RegisterID = T.F_RegisterID
	WHERE R.F_MatchID = @MatchID

	UPDATE @retTable SET F_IRMID = T.F_IRMID
	FROM @retTable AS R
	RIGHT JOIN @TT_DSQ AS T ON R.F_RegisterID = T.F_RegisterID
	WHERE R.F_MatchID = @MatchID

		
	RETURN
	
END

GO

/*

SELECT F_RegisterID, F_IRMID FROM dbo.[Func_SH_GetTeamIRM] (62) 

*/










