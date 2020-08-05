IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetRecordValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetRecordValue]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Func_SH_GetRecordValue]
								(
									@MatchID   INT
								)
RETURNS NVARCHAR(10)
AS
BEGIN

	DECLARE @RETURN NVARCHAR(10)
	
	DECLARE @PhaseCode NVARCHAR(10)
	SELECT @PhaseCode = B.F_PhaseCode  
	FROM TS_Match A
	LEFT JOIN TS_Phase B ON A.F_PhaseID = B.F_PhaseID
	WHERE A.F_MatchID = @MatchID

	DECLARE @RecordTypeID INT
	
	IF @PhaseCode = '9' SET @RecordTypeID = 11
	IF @PhaseCode = '1' SET @RecordTypeID = 12
	
		
	SELECT @RETURN = F_RecordValue  
	FROM TS_Match A
	LEFT JOIN TS_Phase B ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event C ON C.F_EventID = B.F_EventID
	LEFT JOIN TS_Event_Record D ON D.F_EventID = C.F_EventID AND D.F_Equalled = 0
	WHERE A.F_MatchID = @MatchID AND D.F_RecordTypeID = @RecordTypeID AND D.F_Active = 1
	
	RETURN @RETURN

END

GO


-- SELECT DBO.Func_SH_GetRecordValue(1)
