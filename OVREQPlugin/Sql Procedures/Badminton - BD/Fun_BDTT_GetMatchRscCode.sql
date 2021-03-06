IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetMatchRscCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetMatchRscCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_BDTT_GetMatchRscCode]
								(
									@MatchID INT
								)
RETURNS NVARCHAR(200)
AS
BEGIN
	DECLARE @RscCode NVARCHAR(50)
	SELECT @RscCode = (D.F_DisciplineCode + E.F_GenderCode + C.F_EventCode + B.F_PhaseCode + A.F_MatchCode)
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID
	LEFT JOIN TC_Sex AS E ON E.F_SexCode = C.F_SexCode
	WHERE A.F_MatchID = @MatchID

	RETURN @RscCode
END


GO

