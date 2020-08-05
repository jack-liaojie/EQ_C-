IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_HO_GetIndividualStatistic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_HO_GetIndividualStatistic]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		张翠霞
-- Create date: 2012/09/07
-- Description:	统计个人的单项技术统计
-- =============================================

CREATE FUNCTION [dbo].[Fun_Report_HO_GetIndividualStatistic]
								(
									@EventID					INT,
									@RegisterID					INT,
									@Par1                       INT
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    SET @ResultNum = 0

    IF @Par1 = 1 --MatchNum
    BEGIN
		SELECT @ResultNum = COUNT(X.F_MatchID) FROM TS_Match_Member AS X
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
    ELSE IF @Par1 = 2
    BEGIN
		SELECT @ResultNum = COUNT(X.F_ActionNumberID)
		FROM TS_Match_ActionList AS X
		LEFT JOIN TD_ActionType AS A ON X.F_ActionTypeID = A.F_ActionTypeID
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE A.F_ActionCode = 'FGGoal' AND P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
    ELSE IF @Par1 = 3
    BEGIN
		SELECT @ResultNum = COUNT(X.F_ActionNumberID)
		FROM TS_Match_ActionList AS X
		LEFT JOIN TD_ActionType AS A ON X.F_ActionTypeID = A.F_ActionTypeID
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE A.F_ActionCode = 'PCGoal' AND P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
    ELSE IF @Par1 = 4
    BEGIN
		SELECT @ResultNum = COUNT(X.F_ActionNumberID)
		FROM TS_Match_ActionList AS X
		LEFT JOIN TD_ActionType AS A ON X.F_ActionTypeID = A.F_ActionTypeID
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE A.F_ActionCode = 'PSGoal' AND P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
    ELSE IF @Par1 = 5
    BEGIN
		SELECT @ResultNum = COUNT(X.F_ActionNumberID)
		FROM TS_Match_ActionList AS X
		LEFT JOIN TD_ActionType AS A ON X.F_ActionTypeID = A.F_ActionTypeID
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE A.F_ActionCode = 'GCard' AND P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
    ELSE IF @Par1 = 6
    BEGIN
		SELECT @ResultNum = COUNT(X.F_ActionNumberID)
		FROM TS_Match_ActionList AS X
		LEFT JOIN TD_ActionType AS A ON X.F_ActionTypeID = A.F_ActionTypeID
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE A.F_ActionCode = 'YCard' AND P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
    ELSE IF @Par1 = 7
    BEGIN
		SELECT @ResultNum = COUNT(X.F_ActionNumberID)
		FROM TS_Match_ActionList AS X
		LEFT JOIN TD_ActionType AS A ON X.F_ActionTypeID = A.F_ActionTypeID
		LEFT JOIN TS_Match AS M ON X.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		WHERE A.F_ActionCode = 'RCard' AND P.F_EventID = @EventID AND M.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
    END
	
	IF @ResultNum IS NULL
	SET @ResultNum = 0
	RETURN @ResultNum

END

GO


