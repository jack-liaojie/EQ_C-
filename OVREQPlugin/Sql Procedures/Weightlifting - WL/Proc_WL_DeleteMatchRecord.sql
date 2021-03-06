IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_DeleteMatchRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_DeleteMatchRecord]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_WL_DeleteMatchRecord]
--描    述: 举重项目,删除比赛纪录
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年6月17日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_WL_DeleteMatchRecord]
	@RecordID	INT,
	@Return  		AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @OldRecordID	    INT
	DECLARE @NewRecordID	    INT
	DECLARE @Equalled           INT 
	DECLARE @NewEqualled           INT 
	DECLARE @Active           INT 
	
	SET @Return=0;  -- @Return=0; 	更新失败，标示没有做任何操作！
					-- @Return=1; 	更新成功，返回！
					-- @Return=-1; 	更新失败，@MatchID无效

	--IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	--BEGIN
	--	SET @Return = -1
	--	RETURN
	--END
  
   
 	SELECT  @Active = ER.F_Active, @OldRecordID = RR.F_RecordID,@Equalled = RR.F_Equalled
 	FROM TS_Result_Record AS RR
 	LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = RR.F_NewRecordID
	WHERE  RR.F_NewRecordID = @RecordID
   
	SELECT top 1 @NewRecordID = RR.F_NewRecordID,@NewEqualled = RR.F_Equalled
 	FROM TS_Result_Record AS RR
	WHERE  RR.F_RecordID = @RecordID order by F_NewRecordID
   
    IF @OldRecordID IS NULL 
    BEGIN
		SET @Return = -1
        RETURN 
    END
   
	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	--修改破本记录的相关记录
	IF @NewRecordID IS NOT NULL
		BEGIN
			--激活最近记录
			UPDATE TS_Result_Record SET F_RecordID =@OldRecordID
			WHERE F_NewRecordID = @NewRecordID
		    --其他记录破平该记录
			UPDATE TS_Result_Record SET F_RecordID =@NewRecordID
			WHERE F_RecordID = @RecordID
			
			IF @Equalled = 0 AND @NewEqualled = 1
			begin
			UPDATE TS_Result_Record SET F_Equalled =0
			WHERE F_NewRecordID = @NewRecordID	
			UPDATE TS_Event_Record SET F_Equalled =0 WHERE F_RecordID = @NewRecordID				
			end
		END
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END
	
	
	--删除和比赛关联纪录的信息
	DELETE FROM TS_Result_Record 
	WHERE F_NewRecordID = @RecordID
    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END

	--删除纪录信息
	DELETE FROM TS_Event_Record	WHERE F_RecordID = @RecordID
    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END
	
	
    --恢复旧纪录信息
	IF @Equalled = 0 AND @NewRecordID IS NULL AND @Active=1
		UPDATE TS_Event_Record SET F_Active = 1 WHERE F_RecordID = @OldRecordID
    IF @NewEqualled =1 AND @NewRecordID IS NOT NULL AND @Active=1
		UPDATE TS_Event_Record SET F_Active = 1 WHERE F_RecordID = @NewRecordID

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

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_WL_DeleteMatchRecord] 11,10,106,null
*/



