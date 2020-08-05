

/****** Object:  StoredProcedure [dbo].[proc_HB_AddMatchSplit]    Script Date: 08/30/2012 08:31:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_HB_AddMatchSplit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_HB_AddMatchSplit]
GO



/****** Object:  StoredProcedure [dbo].[proc_HB_AddMatchSplit]    Script Date: 08/30/2012 08:31:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_HB_AddMatchSplit]
----功		  能：
----作		  者：李燕 
----日		  期: 2009-05-05 
--修改记录
/*    
    2010-10-07   李燕       根据WP的项目，添加SplitDes
*/


CREATE PROCEDURE [dbo].[proc_HB_AddMatchSplit] 
	@MatchID			           INT,
	@FatherMatchSplitID			   INT,----0，不存在FatherMatchSplit
	@MatchSplitCode          	   NVARCHAR(20),
	@MatchType          		   INT,
	@Result 			           AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	创建MatchSplit失败，标示没有做任何操作！
					-- @Result=1; 	创建MatchSplit成功，返回MatchSplitID！
					-- @Result=-1; 	创建MatchSplit失败， @MatchID无效
					-- @Result=-2; 	创建MatchSplits失败，@FatherMatchSplitID无效
                    -- @Result=-3;  创建MatchSplits失败，@MatchSplitOrder无效


	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @FatherMatchSplitID IS NULL OR @FatherMatchSplitID = '' OR @FatherMatchSplitID = 0
    BEGIN
        SET @FatherMatchSplitID = 0
    END
    ELSE
    BEGIN
		IF NOT EXISTS(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @FatherMatchSplitID)
		BEGIN
			SET @Result = -2
			RETURN
		END
     END
    
    IF EXISTS (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_MatchSplitCode = @MatchSplitCode)
    BEGIN
		SET @Result = -3
		RETURN
	END
  
    DECLARE @HomeID INT
    DECLARE @AwayID INT
    DECLARE @MatchSplitOrder  AS INT
    DECLARE @MatchSplitID  AS INT
    DECLARE @MatchSplieDES AS NVARCHAR(50)

    SET @HomeID = -1
    SET @AwayID = -1
    
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
   
  
    SELECT @MatchSplitOrder = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID


   
    SELECT @MatchSplitID = (CASE WHEN MAX(F_MatchSplitID) IS NULL THEN 0 ELSE MAX(F_MatchSplitID) END) + 1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID


   ------添加 TS_Match_Split_Info, TS_Match_Split_Result
    INSERT INTO TS_Match_Split_Info (F_MatchID,F_MatchSplitID,F_FatherMatchSplitID,F_Order,F_MatchSplitStatusID,F_MatchSplitType, F_MatchSplitCode) 
                VALUES (@MatchID,@MatchSplitID,@FatherMatchSplitID,@MatchSplitOrder,NULL,@MatchType, @MatchSplitCode)
    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
   
    INSERT INTO TS_Match_Split_Result (F_MatchID,F_MatchSplitID,F_CompetitionPosition) VALUES(@MatchID, @MatchSplitID,1)
    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
    INSERT INTO TS_Match_Split_Result (F_MatchID,F_MatchSplitID,F_CompetitionPosition) VALUES(@MatchID, @MatchSplitID,2)
    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

   

    SELECT @HomeID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
    SELECT @AwayID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

    UPDATE TS_Match_Split_Result SET F_RegisterID = @HomeID WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 1

    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END

    UPDATE TS_Match_Split_Result SET F_RegisterID = @AwayID WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 2

    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END
	
	------添加TS_Match_Split_Des
	IF(CAST( @MatchSplitCode AS INT) > 2 AND CAST( @MatchSplitCode AS INT) < 5)
	BEGIN
	   SET @MatchSplieDES = 'Extra Time ' + CAST((CAST( @MatchSplitCode AS INT) - 2) AS NVARCHAR(50))
	   
	   INSERT INTO TS_Match_Split_Des(F_MatchID, F_MatchSplitID, F_LanguageCode,F_MatchSplitShortName, F_MatchSplitLongName) 
			     VALUES(@MatchID, @MatchSplitID, 'ENG', @MatchSplieDES, @MatchSplieDES)

            IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
	END
	ELSE IF(CAST( @MatchSplitCode AS INT) = 51)
	BEGIN
	   SET @MatchSplieDES = 'PSO' 
	   	   
	   INSERT INTO TS_Match_Split_Des(F_MatchID, F_MatchSplitID, F_LanguageCode,F_MatchSplitShortName, F_MatchSplitLongName) 
			     VALUES(@MatchID, @MatchSplitID, 'ENG', @MatchSplieDES, @MatchSplieDES)

            IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
	END
	
	
   COMMIT TRANSACTION --成功提交事务

	SET @Result = @MatchSplitID
	RETURN

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


