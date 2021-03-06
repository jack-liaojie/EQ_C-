IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_HO_GetMatchResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_HO_GetMatchResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[Fun_Report_HO_GetMatchResult]
								(
									@MatchID					INT,
                                    @PlayerID                   INT,
                                    @OppID                      INT,
                                    @Type                       INT --1:Match比分
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @ResultDes AS NVARCHAR(100)
	DECLARE @HomePoint AS INT
	DECLARE @AwayPoint AS INT
    DECLARE @AIRM AS NVARCHAR(50)
    DECLARE @BIRM AS NVARCHAR(50)
    DECLARE @EventType AS INT
    DECLARE @Apos AS INT
    DECLARE @Bpos AS INT

	SET @ResultDes = ''
	SELECT @Apos = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @PlayerID
    SELECT @Bpos = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @OppID
    SELECT @EventType = C.F_PlayerRegTypeID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID
   
    IF (@Type = 1)
    BEGIN
		SELECT @HomePoint = A.F_Points, @AIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @Apos
		SELECT @AwayPoint = A.F_Points, @BIRM = B.F_IRMCODE FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B
		ON A.F_IRMID = B.F_IRMID WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @Bpos
		
		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
	    BEGIN
		    SET @ResultDes = CAST(@HomePoint AS NVARCHAR(100)) + (CASE WHEN @AIRM IS NULL THEN '' ELSE '(' + @AIRM + ')' END) + ':' + CAST(@AwayPoint AS NVARCHAR(100)) + (CASE WHEN @BIRM IS NULL THEN '' ELSE '(' + @BIRM + ')' END)
	    END
    END

	RETURN @ResultDes

END

GO


