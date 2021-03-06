IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetMatchIDFromRsc]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetMatchIDFromRsc]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--作者：王强  2011-5-17 
--功能：从RSC获取MatchID
CREATE FUNCTION [dbo].[Fun_BDTT_GetMatchIDFromRsc]
								(
									@MatchRsc NVARCHAR(20)
								)
RETURNS INT
AS
BEGIN
	
	DECLARE @Res INT
	SELECT @Res = D.F_MatchID FROM TS_Discipline AS A
	LEFT JOIN TS_Event AS B ON B.F_DisciplineID = A.F_DisciplineID
	LEFT JOIN TS_Phase AS C ON C.F_EventID = B.F_EventID
	LEFT JOIN TS_Match AS D ON D.F_PhaseID = C.F_PhaseID
	WHERE A.F_DisciplineCode = SUBSTRING( @MatchRsc, 1, 2) AND B.F_EventCode = SUBSTRING( @MatchRsc, 4, 3)
			AND C.F_PhaseCode = SUBSTRING( @MatchRsc, 7, 1) AND D.F_MatchCode = SUBSTRING( @MatchRsc, 8, 2)
			
	RETURN @Res
END


GO

