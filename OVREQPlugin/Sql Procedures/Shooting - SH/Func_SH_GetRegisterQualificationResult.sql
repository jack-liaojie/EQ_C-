IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetRegisterQualificationResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetRegisterQualificationResult]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Func_SH_GetRegisterQualificationResult]
								(
									@FinalMatchID	INT,
									@RegID	INT
								)
RETURNS INT
AS
BEGIN

		DECLARE @Score	INT

		DECLARE @EventCode	NVARCHAR(10)
		DECLARE @PhaseCode	NVARCHAR(10)
		SELECT	@EventCode = Event_Code, @PhaseCode = PHASE_CODE FROM  dbo.Func_SH_GetEventCommonCodeInfo(@FinalMatchID)
		IF @PhaseCode <> '1'
		RETURN	@Score

		DECLARE @QMatchID	INT
		SELECT @QMatchID = M.F_MatchID
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
		WHERE E.F_EventCode = @EventCode AND P.F_PhaseCode IN ('9','A') AND M.F_MatchCode = '01'
		
		
		SELECT @Score = F_PhasePoints FROM TS_Phase_Result
		WHERE F_PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @QMatchID) AND F_RegisterID = @RegID
		
		
		RETURN @Score

END

GO


-- SELECT DBO.Func_SH_GetRegisterQualificationResult(1, 15)
		
				
