

/****** Object:  StoredProcedure [dbo].[Proc_SH_SetRecord]    Script Date: 08/19/2011 13:46:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_SetRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_SetRecord]
GO


/****** Object:  StoredProcedure [dbo].[Proc_SH_SetRecord]    Script Date: 08/19/2011 13:46:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Proc_SH_SetRecord] (	
	@MatchID							INT,
	@CompetitionPosition				INT,
	@RecordType							INT = 0
)	
AS
BEGIN
	
SET NOCOUNT ON

	-- NO USE
	RETURN
	
	DECLARE @DT DATETIME
	SELECT @DT = F_MatchDate FROM TS_Match WHERE F_MatchID = @MatchID
	
	DECLARE @EventID INT
	DECLARE @PhaseCode NVARCHAR(10)
	
	SELECT @EventID = B.F_EventID,
			@PhaseCode = B.F_PhaseCode
	FROM TS_Match A
		LEFT JOIN TS_Phase B ON A.F_PhaseID = B.F_PhaseID
	WHERE A.F_MatchID = @MatchID
	
	DECLARE @RecordTypeID INT
	
	IF @RecordType = 0
	BEGIN
		IF @PhaseCode IN( '9' , 'A')
		BEGIN
			SELECT @RecordTypeID =  F_RecordTypeID FROM TC_RecordType WHERE F_RecordTypeCode = 'WR'
		END
		ELSE IF @PhaseCode = '1'
		BEGIN
			SELECT @RecordTypeID =  F_RecordTypeID FROM TC_RecordType WHERE F_RecordTypeCode = 'FWR'
		END
	END

	IF @RecordType = 1
	BEGIN
		IF @PhaseCode IN( '9' , 'A')
		BEGIN
			SELECT @RecordTypeID =  F_RecordTypeID FROM TC_RecordType WHERE F_RecordTypeCode = 'UR'
		END
		ELSE IF @PhaseCode = '1'
		BEGIN
			SELECT @RecordTypeID =  F_RecordTypeID FROM TC_RecordType WHERE F_RecordTypeCode = 'FUR'
		END
	END

	
	DECLARE @RecordValue NVARCHAR(10)
	DECLARE @OldRecordID INT
	
	SELECT @RecordValue = F_RecordValue, @OldRecordID = F_RecordID FROM TS_Event_Record 
		WHERE F_EventID = @EventID AND F_RecordTypeID = @RecordTypeID AND F_Active = 1
		
	DECLARE @Record INT
	SET @Record = 10*CAST(@RecordValue AS DECIMAL(10,1))
	
	--SELECT @PhaseCode, @RecordTypeID, @Record
	
	DECLARE @DIFF DECIMAL
	DECLARE @REGID INT
	DECLARE @CP INT
	
	-- if not set record, then return
	IF @RecordValue IS NULL RETURN
	
	
	DECLARE @NewRecordValue NVARCHAR(10)

	--DECLARE ONE_CURSOR CURSOR FOR
	SELECT @DIFF = (F_Points - @Record),
		   @REGID = F_RegisterID,
		   @NewRecordValue = F_Points 
	FROM TS_Match_Result
	WHERE F_MatchID = @MatchId AND F_CompetitionPosition = @CompetitionPosition
	
	IF @PhaseCode IN( '9', 'A') SET @NewRecordValue = @NewRecordValue/10
	
	IF @PhaseCode = '1' SET @NewRecordValue = CAST(CAST(@NewRecordValue AS DECIMAL(10,1))/10.0 AS DECIMAL(10,1))

	DECLARE @MAXRECORDID INT
	
	DELETE FROM TS_Result_Record 
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition --AND F_RecordID = @MAXRECORDID
	
	DELETE FROM TS_Result_Record WHERE F_NewRecordID IN (SELECT F_RecordID FROM TS_Event_Record WHERE F_EventID = @EVENTID AND F_RecordTypeID = @RecordTypeID AND F_RegisterID = @REGID AND F_IsNewCreated = 1 )
	
	DELETE FROM TS_Event_Record 
	WHERE F_EventID = @EVENTID AND F_RecordTypeID = @RecordTypeID AND F_RegisterID = @REGID AND F_IsNewCreated = 1

	DECLARE @CREATE INT
	
	IF(@DIFF = 0)--E RECORD
	BEGIN
		SET @CREATE = 1
	END

	IF(@DIFF > 0)--BROKE RECORD
	BEGIN
		SET @CREATE = 0
	END
	
	DECLARE @CityName NVARCHAR(20)
	SELECT @CityName = F_CityLongName FROM TS_Match M
	LEFT JOIN TC_Venue AS V ON V.F_VenueID = M.F_VenueID
	LEFT JOIN TC_City_Des AS CD ON CD.F_CityID = V.F_CityID AND CD.F_LanguageCode = 'ENG'
	WHERE F_MatchID = @MatchID
	
	IF(@DIFF >= 0)
	BEGIN
		INSERT INTO TS_Event_Record(F_EventID, F_RecordValue, F_RegisterID, F_IsNewCreated, F_Active, F_Equalled, F_RecordTypeID, F_RecordDate, F_Location)
		VALUES(@EVENTID, @NewRecordValue, @REGID, 1, 0, @CREATE, @RecordTypeID, @DT, @CityName)
		
		select @MAXRECORDID = @@IDENTITY
		
		INSERT INTO TS_Result_Record(F_MatchID, F_CompetitionPosition, F_RecordID, F_NewRecordID, F_RegisterID, F_Equalled, F_RecordDate, F_RecordTime)
		VALUES(@MatchID, @CompetitionPosition, @OldRecordID, @MAXRECORDID, @REGID, @CREATE, @DT, GETDATE())
	END	 
		 


	-- TEST RUSULT
	--SELECT * FROM TS_Event_Record
	--SELECT * FROM TS_Result_Record


SET NOCOUNT OFF
END

GO


