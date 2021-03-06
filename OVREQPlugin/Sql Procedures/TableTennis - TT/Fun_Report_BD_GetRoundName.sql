IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetRoundName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetRoundName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_Report_BD_GetRoundName]
								(
									@Day					INT,
                                    @DisciplineID           INT,
                                    @LanguageCode           CHAR(3)
								)

RETURNS NVARCHAR(1000)
AS
BEGIN

    DECLARE @DayRoundName NVARCHAR(1000)
    SET @DayRoundName = ''

    DECLARE  @Table_Tmp AS TABLE
                          (
                           F_MatchID       INT,
                           F_RoundName     NVARCHAR(100),
                           F_PhaseID       INT,
                           F_FatherPhaseID INT,
                           F_PhaseIsPool   INT,
                           F_UsePhaseID    INT
						  )

    DECLARE  @Table_Round AS TABLE
                          (
                           F_RoundName   NVARCHAR(100),
                           F_PhaseID     INT
						  )

   INSERT INTO @Table_Tmp(F_MatchID, F_PhaseID, F_FatherPhaseID, F_PhaseIsPool)
   SELECT A.F_MatchID, B.F_PhaseID, B.F_FatherPhaseID, B.F_PhaseIsPool
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_DisciplineDate AS C ON A.F_MatchDate = C.F_Date
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        WHERE C.F_DisciplineID = @DisciplineID AND D.F_DisciplineID = @DisciplineID AND C.F_DateOrder = @Day AND A.F_MatchID NOT IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
        ORDER BY CONVERT( INT,A.F_RaceNum)
   
   UPDATE @Table_Tmp SET F_UsePhaseID = (CASE WHEN F_PhaseIsPool = 1 THEN F_FatherPhaseID ELSE F_PhaseID END)

    INSERT INTO @Table_Round(F_PhaseID)
    SELECT F_UsePhaseID FROM @Table_Tmp GROUP BY F_UsePhaseID
    
     UPDATE @Table_Round SET F_RoundName = B.F_PhaseLongName FROM @Table_Round AS A LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID
        WHERE B.F_LanguageCode = @LanguageCode
    
    SELECT @DayRoundName = @DayRoundName + F_RoundName + + CHAR(10) FROM @Table_Round
	RETURN @DayRoundName
   
END


GO

