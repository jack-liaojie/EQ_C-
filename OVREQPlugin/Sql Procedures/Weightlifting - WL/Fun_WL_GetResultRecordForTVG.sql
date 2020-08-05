IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_WL_GetResultRecordForTVG]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_WL_GetResultRecordForTVG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_WL_GetResultRecordForTVG]
								(
									@EventID					INT,
									@CompetitionPosition		INT,
									@SubEventCode				NVARCHAR(10),
									@Result		                NVARCHAR(10)
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @RecordSecString NVARCHAR(100)
	DECLARE @RecordType NVARCHAR(100)

	SET @RecordType = 
	(SELECT top 1 
		case when RR.F_NewRecordID is null then '' 
			when RR.F_NewRecordID is not null and RR.F_Equalled = 0 then ISNULL(RT.F_RecordTypeCode,'') 
			when RR.F_NewRecordID is not null and RR.F_Equalled = 1 then ('E' + ISNULL(RT.F_RecordTypeCode,''))
			else NULL end AS [Type]
				FROM TS_Result_Record AS RR 
				LEFT JOIN TS_Event_Record AS ER ON RR.F_NewRecordID = ER.F_RecordID 
				LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
				WHERE ER.F_EventID =@EventID AND ER.F_RegisterID = @CompetitionPosition 
				AND ER.F_SubEventCode = @SubEventCode AND ER.F_RecordValue=@Result 
				AND  RR.F_Equalled !=1 --AND F_Active = 1 
				)


	    IF @RecordType IS NOT NULL AND @RecordType !=''
	            SET @RecordSecString = N'[Image]Record_' + @RecordType
	
	RETURN @RecordSecString

END


GO


/*
select dbo.Fun_WL_GetResultRecordForTVG (2,54,'1',154)

*/