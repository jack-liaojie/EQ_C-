IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_WL_GetResultRecord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_WL_GetResultRecord]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_WL_GetResultRecord]
								(
									@EventID					INT,
									@CompetitionPosition		INT,
									@SubEventCode				NVARCHAR,
									@Result		                NVARCHAR
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @RecordSecString NVARCHAR(100)
	DECLARE @RecordType NVARCHAR(100)

	SET @RecordSecString = ''
	
	DECLARE One_Cursor CURSOR FOR 
			SELECT RT.F_RecordTypeCode
				FROM TS_Result_Record AS RR 
				LEFT JOIN TS_Event_Record AS ER ON RR.F_NewRecordID = ER.F_RecordID 
				LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
				WHERE ER.F_EventID =@EventID AND ER.F_RegisterID = @CompetitionPosition 
				AND ER.F_SubEventCode = @SubEventCode AND ER.F_RecordValue=@Result AND F_Active = 1 

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


