
/****** Object:  StoredProcedure [dbo].[proc_AddEventRecord_InitialDownLoad]    Script Date: 05/05/2010 10:30:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddEventRecord_InitialDownLoad]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddEventRecord_InitialDownLoad]
/****** Object:  StoredProcedure [dbo].[proc_AddEventRecord_InitialDownLoad]    Script Date: 05/05/2010 10:30:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_AddEventRecord_InitialDownLoad
----功		  能：为一个Event添加纪录信息
----作		  者：李燕
----日		  期: 2010-12-28 

CREATE PROCEDURE [dbo].[proc_AddEventRecord_InitialDownLoad]
    @EventID                INT,	
	@RecordTypeID           INT,
	@RegisterID             Int = NULL,
    @Location               NVARCHAR(50) = NULL,
    @RecordSport            NVARCHAR(50) = NULL,
    @RecordDate             DATETIME = NULL,
    @RecordValue            NVARCHAR(50) = NULL,
    @LocationNOC            CHAR(50) = NULL,
    @Active                 Int = 1,
    @Order                  Int = NULL,
    @Equal                  Int = 0,
    @IsNew                  Int = 0,
    @SubEventCode           NVARCHAR(20),
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

   
   IF(@Order IS NULL)
   BEGIN
      SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) +1 FROM TS_Event_Record
   END
	
		DECLARE @NewRecordID AS INT	

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			INSERT INTO TS_Event_Record (F_RecordTypeID, F_RegisterID, F_EventID, F_RecordValue, F_RecordSport, F_Location, F_RecordDate, F_Active, F_Order, F_Equalled, F_IsNewCreated,F_SubEventCode)
					VALUES (@RecordTypeID, @RegisterID, @EventID, @RecordValue, @RecordSport, @Location, @RecordDate, @Active, @Order, @Equal, @IsNew, @SubEventCode)

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


SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO









