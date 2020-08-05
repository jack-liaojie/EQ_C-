IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_DataExchange_GetMessageHeader]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_DataExchange_GetMessageHeader]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID

CREATE FUNCTION [Func_DataExchange_GetMessageHeader]
(
		@DisciplineCode		CHAR(2),
		@Version			CHAR(10),
		@SendSourceCode		CHAR(10),
		@MsgType			CHAR(5),
		@MatchID			INT,
		@LanguageCode		AS CHAR(3)
)
RETURNS @retMessageHeader TABLE
							( MatchID INT PRIMARY KEY NOT NULL,
							[Version] VARCHAR(10),
							Category VARCHAR(10),
							Origin VARCHAR(10),
							RSC VARCHAR(100),
							Discipline VARCHAR(10),
							Gender VARCHAR(10),
							[Event] VARCHAR(10),
							Phase VARCHAR(10),
							Unit VARCHAR(10),
							Venue VARCHAR(10),
							Code VARCHAR(10),
							[Type] VARCHAR(10),
							[Language] VARCHAR(10),
							[Date] VARCHAR(20),
							[Time] VARCHAR(20))

AS
BEGIN

	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @OutputHeader AS NVARCHAR(MAX)

								
	DECLARE @MATCHCODE VARCHAR(10)
	DECLARE @PHASECODE VARCHAR(10)
	DECLARE @EVENTCODE VARCHAR(10)
	DECLARE @VENUECODE VARCHAR(10)
	DECLARE @SEXCODE VARCHAR(1)
	DECLARE @RSCCODE VARCHAR(100)
	
	SELECT @MATCHCODE = A.F_MatchCode, @PHASECODE = B.F_PhaseCode, @EVENTCODE = C.F_EventCode, @VENUECODE = D.F_VenueCode,
			@SEXCODE = E.F_GenderCode FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		LEFT JOIN TC_Venue AS D ON A.F_VenueID = D.F_VenueID
		LEFT JOIN TC_SEX E ON E.F_SexCode = C.F_SexCode
	WHERE A.F_MatchID = @MatchID
	
	SET @RSCCODE = @DisciplineCode + @SEXCODE + @EVENTCODE + @PHASECODE + @MATCHCODE
	
	INSERT @retMessageHeader(MatchID, [Version], Category, Origin, RSC, Discipline, Gender, [Event], Phase, Unit, Venue, Code, [Type], [Language], [Date], [Time])						
	SELECT @MatchID, '1.0', 'VRS', @SendSourceCode, @RSCCODE, @DisciplineCode, @SEXCODE, @EVENTCODE, @PHASECODE, @MATCHCODE, @VENUECODE, @MsgType ,'DATA', @LanguageCode, 
	CONVERT(VARCHAR(20), GETDATE(), 112), REPLACE(CONVERT(VARCHAR(20), GETDATE(), 114),':','')
	 
	SET @OutputHeader = (SELECT * FROM @retMessageHeader AS [Message] FOR XML AUTO)
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader


	RETURN
	
END

GO

/*

SELECT * FROM dbo.[Func_DataExchange_GetMessageHeader] ('SH', '1.0', 'VRS-001', 'M3011', 1, 'ENG')

*/

 
