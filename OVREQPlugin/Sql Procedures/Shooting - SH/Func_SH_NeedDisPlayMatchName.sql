IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_NeedDisPlayMatchName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_NeedDisPlayMatchName]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



CREATE FUNCTION [Func_SH_NeedDisPlayMatchName]
(
		@MatchID			INT
)
RETURNS INT

AS
BEGIN

		DECLARE @EventCode CHAR(3)
		DECLARE @PhaseCode CHAR(1)
		DECLARE @MatchCode INT
		DECLARE @COUNT INT

		SELECT	@EventCode = Event_Code,
				@PhaseCode = Phase_Code,
				@MatchCode = Match_Code
		 FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

		SELECT @COUNT = COUNT(*) FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
		WHERE E.F_EventCode = @EventCode AND P.F_PhaseCode = @PhaseCode AND M.F_MatchCode IN('01','02')		

		IF  @PhaseCode = '9' SET @COUNT = 1
			
		RETURN @COUNT

END

GO


-- SELECT * FROM dbo.[Func_SH_NeedDisPlayMatchName] (102)
-- SELECT * FROM dbo.[Func_SH_NeedDisPlayMatchName] (26)

--SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 