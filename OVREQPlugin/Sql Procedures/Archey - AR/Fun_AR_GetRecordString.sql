IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetRecordString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetRecordString]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_AR_GetRecordString]
								(
									@MatchID					INT,
									@CompetitionPosition		INT,
									@SubEventCode               NVARCHAR
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @RecordSecString NVARCHAR(100)
	DECLARE @RecordType NVARCHAR(100)
	DECLARE @PhaseID INT
	DECLARE @EventID INT
	SET @PhaseID = (SELECT F_PhaseID FROM TS_Match 
						WHERE F_MatchID = @MatchID)
	SET @EventID = (SELECT F_EventID FROM TS_Phase 
						WHERE F_PhaseID = @PhaseID)

	SET @RecordSecString = ''

    IF @SubEventCode IS NULL
	DECLARE One_Cursor CURSOR FOR 
			SELECT RT.F_RecordTypeCode  AS RecordType
				FROM TS_Result_Record AS RR LEFT JOIN TS_Event_Record AS ER ON RR.F_NewRecordID = ER.F_RecordID 
				LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
				WHERE RR.F_MatchID IN (	SELECT M.F_MatchID FROM TS_Match AS M
														 LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
														 LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
									    WHERE E.F_EventID =@EventID
									    ) 
				AND RR.F_RegisterID = @CompetitionPosition AND F_Active = 1 AND (ER.F_SubEventCode = NULL OR ER.F_SubEventCode =0)
	ELSE				
	DECLARE One_Cursor CURSOR FOR 
			SELECT RT.F_RecordTypeCode
				FROM TS_Result_Record AS RR LEFT JOIN TS_Event_Record AS ER ON RR.F_NewRecordID = ER.F_RecordID 
				LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
				WHERE RR.F_MatchID = @MatchID AND RR.F_RegisterID = @CompetitionPosition AND ER.F_SubEventCode = @SubEventCode
				AND F_Active = 1

	OPEN One_Cursor
	FETCH NEXT FROM One_Cursor INTO @RecordType

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF @RecordType IS NOT NULL
	        IF @RecordSecString = ''
	            SET @RecordSecString = @RecordType
	        ELSE    
				SET @RecordSecString = @RecordSecString + ';' + @RecordType
		FETCH NEXT FROM One_Cursor INTO @RecordType

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	
	RETURN @RecordSecString

END


GO


