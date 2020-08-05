IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_UpdateRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_UpdateRecord]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_AR_UpdateRecord]
--描    述: 射箭项目,更新比赛纪录
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月19日
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_AR_UpdateRecord]
	@MatchID				INT,
	@CompetitionPosition	INT,
	@IsEqual				INT,
	@SubEventCode			NVARCHAR(10),
    @RecordValue			NVARCHAR(10),
    @RecordTypeID			INT,
	@Return  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT 	
	DECLARE @EventID	        INT
	DECLARE @RegisterID	        INT
	DECLARE @PhaseResultNumber	INT
	DECLARE @OldRecordID	    INT
	DECLARE @NewRecordID	    INT
	DECLARE @RecordType		NVARCHAR(10)
	DECLARE @LocationCity	NVARCHAR(50)
	DECLARE @LocationNOC	NVARCHAR(50)
	DECLARE @RecordID	    INT
	
	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END
    
	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode,
    @LocationCity = CD.F_CityLongName,
    @EventID = E.F_EventID
     FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V ON V.F_VenueID = M.F_VenueID
	LEFT JOIN TC_City_Des AS CD ON CD.F_CityID = V.F_CityID AND CD.F_LanguageCode='ENG'
    WHERE F_MatchID = @MatchID

    SELECT @RegisterID = F_RegisterID
    FROM TS_Match_Result 
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 

    IF @RegisterID IS NULL
	BEGIN
		SET @Return = -1
		RETURN
	END
        
	SELECT @RecordType = F_RecordTypeLongName
		FROM TC_RecordType_Des WHERE F_RecordTypeID = @RecordTypeID AND F_LanguageCode = 'ENG'
    
    SET @SubEventCode = ISNULL(@SubEventCode,0)

		SELECT @NewRecordID = F_RecordID FROM TS_Event_Record 
		WHERE F_EventID = @EventID AND F_RecordTypeID = @RecordTypeID
		AND F_SubEventCode = @SubEventCode AND F_RegisterID = @RegisterID
		AND F_RecordValue = @RecordValue
		--如何纪录已经存在，则直接返回
        IF @NewRecordID IS NOT NULL 
        BEGIN
           SET @Return = 1 
           RETURN
        END
		
		SELECT @OldRecordID = F_RecordID FROM TS_Event_Record
		WHERE F_EventID = @EventID AND F_RecordTypeID = @RecordTypeID 
		AND F_SubEventCode = @SubEventCode AND F_Active = 1
		
		SELECT @RecordID = F_RecordID FROM TS_Event_Record 
				WHERE F_EventID = @EventID AND F_RecordType = @RecordType
				AND F_SubEventCode = @SubEventCode AND F_RegisterID = @RegisterID AND F_IsNewCreated = 1
	
	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	IF @IsEqual =0
	BEGIN
		
		Update TS_Event_Record SET F_Active = 0 WHERE ISNULL(F_SubEventCode,'0')=@SubEventCode
		
		IF @RecordID IS NULL
		BEGIN        
				INSERT INTO TS_Event_Record
				(F_EventID,F_RecordType,F_SubEventCode,F_RegisterID,F_RecordValue, F_Active,F_RecordTypeID
					,F_CompetitorReportingName,F_CompetitorGender,F_CompetitorNOC,F_Location,F_RecordDate,F_Equalled,F_IsNewCreated
					,F_CompetitorBirthDate,F_LocationNOC
				)
				Select 
					@EventID, @RecordType, @SubEventCode, @RegisterID, @RecordValue, 1,@RecordTypeID
					,RD.F_LongName, @SexCode,R.F_NOC,@LocationCity,GETDATE(),0,1,R.F_Birth_Date,@LocationNOC
					 FROM TR_Register AS R 
						LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID= R.F_RegisterID AND F_LanguageCode ='ENG'
						 WHERE R.F_RegisterID = @RegisterID 
			
				SELECT @NewRecordID = F_RecordID FROM TS_Event_Record 
				WHERE F_EventID = @EventID AND F_RecordType = @RecordType
				AND ISNULL(F_SubEventCode,'0') = @SubEventCode AND F_RegisterID = @RegisterID
				AND F_RecordValue = @RecordValue		
			
		END
		ELSE
		BEGIN
			update TS_Event_Record
				set F_RecordValue =@RecordValue, F_Active =1, F_Equalled = @IsEqual,F_RecordDate=GETDATE()
				FROM TS_Event_Record 
				WHERE F_EventID = @EventID AND F_RecordType = @RecordType AND F_RecordTypeID = @RecordTypeID
				AND  ISNULL(F_SubEventCode,'0') = @SubEventCode AND F_RegisterID = @RegisterID
				AND F_RecordID = @RecordID AND F_IsNewCreated=1
		END
	END
	ELSE
	BEGIN
	IF @RecordID IS NULL
		BEGIN        
				INSERT INTO TS_Event_Record
				(F_EventID,F_RecordType,F_SubEventCode,F_RegisterID,F_RecordValue, F_Active,F_RecordTypeID
					,F_CompetitorReportingName,F_CompetitorGender,F_CompetitorNOC,F_Location,F_RecordDate,F_Equalled,F_IsNewCreated
					,F_CompetitorBirthDate,F_LocationNOC
				)
				Select 
					@EventID, @RecordType, @SubEventCode, @RegisterID, @RecordValue, 0,@RecordTypeID
					,RD.F_LongName, @SexCode,R.F_NOC,@LocationCity,GETDATE(),1,1,R.F_Birth_Date,@LocationNOC
					 FROM TR_Register AS R 
						LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID= R.F_RegisterID AND F_LanguageCode ='ENG'
						 WHERE R.F_RegisterID = @RegisterID 
			
				SELECT @NewRecordID = F_RecordID FROM TS_Event_Record 
				WHERE F_EventID = @EventID AND F_RecordType = @RecordType
				AND  ISNULL(F_SubEventCode,'0') = @SubEventCode AND F_RegisterID = @RegisterID
				AND F_RecordValue = @RecordValue	
							
		END
		
		ELSE
		BEGIN
			update TS_Event_Record
				set F_RecordValue =@RecordValue, F_Active =0,F_RecordDate=GETDATE(), F_Equalled = @IsEqual
				FROM TS_Event_Record 
				WHERE F_EventID = @EventID AND F_RecordType = @RecordType AND F_RecordTypeID = @RecordTypeID
				AND  ISNULL(F_SubEventCode,'0') = @SubEventCode AND F_RegisterID = @RegisterID
				AND F_RecordID = @RecordID AND F_IsNewCreated=1
		END
	END

 --   --纪录关联
 --	IF @OldRecordID IS NULL 
	--    SET @OldRecordID = @NewRecordID
 
	--IF NOT EXISTS(SELECT * FROM TS_Result_Record WHERE F_MatchID = @MatchID
	--AND F_CompetitionPosition = @CompetitionPosition AND F_RegisterID = @RegisterID
	--AND F_RecordID = @OldRecordID AND F_NewRecordID = @NewRecordID)
	--BEGIN
	--	INSERT INTO TS_Result_Record(F_MatchID,F_CompetitionPosition, F_RegisterID,
	--	 F_RecordID, F_NewRecordID, F_Equalled, F_SubEventCode,F_RecordDate,F_RecordTime) 
	--	VALUES(@MatchID,@CompetitionPosition,@RegisterID, @OldRecordID, @NewRecordID,@IsEqual,@SubEventCode,GETDATE(), GETDATE() )	
	--END
	
    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END

	COMMIT TRANSACTION --成功提交事务


	SET @Return = 1
	RETURN


SET NOCOUNT OFF
END

GO


