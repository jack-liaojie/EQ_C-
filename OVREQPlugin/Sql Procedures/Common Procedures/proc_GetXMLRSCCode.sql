IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetXMLRSCCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetXMLRSCCode]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----作		  者：张翠霞 
----日		  期: 2010-01-11 

CREATE PROCEDURE [dbo].[proc_GetXMLRSCCode]
	@DisciplineID	INT,
	@EventID	    INT,
	@PhaseID	    INT,
	@MatchID	    INT
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
							RSCCode            NVARCHAR(9),
							DisciplineCode     NVARCHAR(2),
                            GenderCode         NVARCHAR(1),
							EventCode          NVARCHAR(3),
							PhaseCode          NVARCHAR(1),
							EventUnit          NVARCHAR(2)
				           )

	IF @MatchID <> -1
	BEGIN
        INSERT INTO #table_tmp(DisciplineCode, EventCode, GenderCode, PhaseCode, EventUnit)
          SELECT CAST(E.F_DisciplineCode AS NVARCHAR(2)), CAST(C.F_EventCode AS NVARCHAR(3)), CAST(D.F_GenderCode AS NVARCHAR(1)), CAST(B.F_PhaseCode AS NVARCHAR(1)),
          CAST(A.F_MatchCode AS NVARCHAR(2)) FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
          LEFT JOIN TC_Sex AS D ON C.F_SexCode = D.F_SexCode LEFT JOIN TS_Discipline AS E ON C.F_DisciplineID = E.F_DisciplineID WHERE A.F_MatchID = @MatchID
    END
	ELSE IF @PhaseID <> -1
	BEGIN	
		INSERT INTO #table_tmp(DisciplineCode, EventCode, GenderCode, PhaseCode, EventUnit)
          SELECT CAST(D.F_DisciplineCode AS NVARCHAR(2)), CAST(B.F_EventCode AS NVARCHAR(3)), CAST(C.F_GenderCode AS NVARCHAR(1)), CAST(A.F_PhaseCode AS NVARCHAR(1)),
          '00' AS EventUnit FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode
          LEFT JOIN TS_Discipline AS D ON B.F_DisciplineID = D.F_DisciplineID WHERE A.F_PhaseID = @PhaseID
	END
    ELSE IF @EventID <> -1 
	BEGIN
		INSERT INTO #table_tmp(DisciplineCode, EventCode, GenderCode, PhaseCode, EventUnit)
          SELECT CAST(C.F_DisciplineCode AS NVARCHAR(2)), CAST(A.F_EventCode AS NVARCHAR(3)), CAST(B.F_GenderCode AS NVARCHAR(1)), '0' AS PhaseCode, '00' AS EventUnit FROM TS_Event AS A
          LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode LEFT JOIN TS_Discipline AS C ON A.F_DisciplineID = C.F_DisciplineID
          WHERE A.F_EventID = @EventID
	END
    ELSE IF @DisciplineID <> -1
    BEGIN
        INSERT INTO #table_tmp(DisciplineCode, EventCode, GenderCode, PhaseCode, EventUnit)
          SELECT CAST(F_DisciplineCode AS NVARCHAR(2)), '000' AS EventCode, '0' AS GenderCode, '0' AS PhaseCode, '00' AS EventUnit FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
    END

    UPDATE #table_tmp SET RSCCode = DisciplineCode + GenderCode+ + EventCode + PhaseCode + EventUnit

    SELECT * FROM #table_tmp


SET NOCOUNT OFF
END

GO

