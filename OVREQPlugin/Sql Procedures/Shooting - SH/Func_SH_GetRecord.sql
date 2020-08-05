
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetRecord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetRecord]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



CREATE FUNCTION [Func_SH_GetRecord]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							F_RegisterID	INT,
							F_RecordCode	NVARCHAR(10)
							)

AS
BEGIN

		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @EventInfo NVARCHAR(10)
		DECLARE @SexCode  NVARCHAR(10)
		
		SELECT  @EventCode = Event_Code,
				@PhaseCode = Phase_Code,
				@MatchCode = Match_Code,
				@EventInfo = Event_Info
		FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
		
		IF @SexCode = 'M' AND @EventInfo = '25RF' AND @PhaseCode = '9'
		BEGIN
			INSERT INTO @retTable( F_RegisterID, F_RecordCode)
			SELECT A.F_RegisterID, case when A.F_Equalled = 1 then 'E' + D.F_RecordTypeCode else D.F_RecordTypeCode end
			FROM TS_Result_Record  AS A  
			LEFT JOIN TS_Event_Record AS C ON A.F_RecordID = C.F_RecordID 
			LEFT JOIN TC_RecordType AS D ON D.F_RecordTypeID = C.F_RecordTypeID
			WHERE F_MatchID IN (		
								SELECT F_MatchID FROM TS_Match
									WHERE F_PHASEID = (
														SELECT F_PhaseID 
														FROM TS_Match 
														WHERE F_MatchID =  @MatchID
														)	AND F_MatchCode IN ('00') 
								) 
				
				
		END

		ELSE
		BEGIN
			INSERT INTO @retTable( F_RegisterID, F_RecordCode)
			SELECT A.F_RegisterID, case when A.F_Equalled = 1 then 'E' + D.F_RecordTypeCode else D.F_RecordTypeCode end
			FROM TS_Result_Record  AS A  
			LEFT JOIN TS_Event_Record AS C ON A.F_RecordID = C.F_RecordID 
			LEFT JOIN TC_RecordType AS D ON D.F_RecordTypeID = C.F_RecordTypeID
			WHERE F_MatchID IN (		
								SELECT F_MatchID FROM TS_Match
									WHERE F_PHASEID = (
														SELECT F_PhaseID 
														FROM TS_Match 
														WHERE F_MatchID =  @MatchID
														)	AND F_MatchCode IN ('01','02') 
								) 
				
				
		END
		
			
		RETURN
END

GO


-- SELECT * FROM dbo.[Func_SH_GetRecord] (1711)
-- SELECT * FROM dbo.[Func_SH_GetRecord] (26)


-- SELECT * FROM TS_Match_Result MR
-- LEFT JOIN dbo.Func_SH_GetRecord(1710) AS R ON MR.F_RegisterID = R.F_RegisterID
-- WHERE F_MatchID = 1710

