
/****** Object:  StoredProcedure [dbo].[proc_AddEventRecord]    Script Date: 05/05/2010 10:30:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddEventRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddEventRecord]
/****** Object:  StoredProcedure [dbo].[proc_AddEventRecord]    Script Date: 05/05/2010 10:30:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_AddEventRecord
----功		  能：为一个Event添加纪录信息或修改一条纪录
----作		  者：张翠霞 
----日		  期: 2009-11-10 
----修        改：管仁良 2009-12-14
---               李  燕 2010-5-5

CREATE PROCEDURE [dbo].[proc_AddEventRecord]
    @EventID                INT,	
	@bAddNew				BIT = 1,				-- 1: 添加新纪录，0：修改纪录
	@RecordID				INT = NULL,				-- 如果 @bAddNew = 0，此参数必须不为空
    @EventCode              NVARCHAR(50) = NULL,
	@RecordType			    NVARCHAR(50) = NULL,
	@Equalled               NVARCHAR(50) = 0,
    @Location               NVARCHAR(50) = NULL,
    @LocationNOC            CHAR(3) = NULL,
    @RecordSport            NVARCHAR(50) = NULL,
    @RecordDate             DATETIME = NULL,
    @RecordValue            NVARCHAR(50) = NULL,
    @CompetitorCode         NVARCHAR(50) = NULL,
    @CompetitorNOC          CHAR(3) = NULL,
    @CompetitorGender       NVARCHAR(50) = NULL,
    @CompetitorFamilyName   NVARCHAR(50) = NULL,
    @CompetitorGivenName    NVARCHAR(50) = NULL,
    @CompetitorBirthDate    DATETIME = NULL,
    @RecordWind             NVARCHAR(50) = NULL,
    @RecordComment          NVARCHAR(50) = NULL,
    @CompetitorReportName   NVARCHAR(50) = NULL,
    @Active                 Int = 1,
	@Result 			    AS INT = 0 OUTPUT 
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加EventRecord失败，标示没有做任何操作！
					-- @Result>=1; 	添加EventRecord成功！如果是添加新纪录，此值即为NewRecordID
					-- @Result=-1; 	添加EventRecord失败，@EventID无效
					-- @Result=-2;	修改纪录失败，@RecordID无效

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	-- 添加新纪录
	IF @bAddNew = 1
	BEGIN
		DECLARE @NewRecordID AS INT	

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			INSERT INTO TS_Event_Record (F_RecordType, F_Equalled, F_EventCode, F_EventID, F_Location, F_LocationNOC, F_RecordSport, F_RecordDate, F_RecordValue,
				F_CompetitorCode, F_CompetitorNOC, F_CompetitorGender, F_CompetitorFamilyName, F_CompetitorGivenName, F_CompetitorBirthDate, F_RecordWind, F_RecordComment, F_CompetitorReportingName, F_Active, F_IsNewCreated)
					VALUES (@RecordType, @Equalled, @EventCode, @EventID, @Location, @LocationNOC, @RecordSport, @RecordDate, @RecordValue, @CompetitorCode,
						 @CompetitorNOC, @CompetitorGender, @CompetitorFamilyName, @CompetitorGivenName, @CompetitorBirthDate, @RecordWind, @RecordComment, @CompetitorReportName, @Active, 0)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			SET @NewRecordID = @@IDENTITY

		COMMIT TRANSACTION --成功提交事务

		SET @Result = @NewRecordID
		RETURN
	END
	
	-- 修改已有纪录信息
	ELSE
	BEGIN

		IF NOT EXISTS(SELECT F_RecordID FROM TS_Event_Record WHERE F_EventID = @EventID AND F_RecordID = @RecordID)
		BEGIN
			SET @Result = -2
			RETURN
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			UPDATE TS_Event_Record SET 
					F_EventCode = @EventCode,
					F_RecordType = @RecordType, 
					F_Equalled = @Equalled, 
					F_Location = @Location, 
					F_LocationNOC = @LocationNOC, 
					F_RecordSport = @RecordSport, 
					F_RecordDate = @RecordDate, 
					F_RecordValue = @RecordValue,
									
					F_CompetitorCode = @CompetitorCode, 
					F_CompetitorNOC = @CompetitorNOC, 
					F_CompetitorGender = @CompetitorGender, 
					F_CompetitorFamilyName = @CompetitorFamilyName, 
					F_CompetitorGivenName = @CompetitorGivenName, 
					F_CompetitorBirthDate = @CompetitorBirthDate, 
					F_RecordWind = @RecordWind, 
					F_RecordComment = @RecordComment, 
					F_CompetitorReportingName = @CompetitorReportName,
                    F_Active  =  @Active
			WHERE F_EventID = @EventID AND F_RecordID = @RecordID

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务

		SET @Result = 1
		RETURN	

	END	


SET NOCOUNT OFF
END








