IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdateMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdateMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_SL_UpdateMatchInfo]
----功		  能：
----作		  者：吴定昉 
----日		  期: 2010-01-07 

CREATE PROCEDURE [dbo].[Proc_SL_UpdateMatchInfo] 
	@MatchID			           INT,
	@SplitCount				       NVARCHAR(50),
	@GateCount			           NVARCHAR(50),
	@SplitGate			           NVARCHAR(50),
	@WaterSpeed			           NVARCHAR(50),
	@Return 			           AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
 	DECLARE @Order		    NVARCHAR(50)

	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END

    SELECT @Order = F_Order FROM TS_Match WHERE F_MatchID = @MatchID 

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
   
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match SET '
    SET @SQL = @SQL + 'F_Order = ''' + cast(@Order as nvarchar(50)) + ''' ' 
    IF @SplitCount IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment1 = NULL ' 
	END 
    ELSE IF @SplitCount <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment1 = ''' + cast(@SplitCount as nvarchar(10)) + ''' ' 
	END 
    IF @GateCount IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment2 = NULL ' 
	END 
    ELSE IF @GateCount <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment2 = ''' + cast(@GateCount as nvarchar(10)) + ''' ' 
	END
    IF @SplitGate IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment3 = NULL ' 
	END 
    ELSE IF @SplitGate <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment3 = ''' + cast(@SplitGate as nvarchar(10)) + ''' ' 
	END
    IF @WaterSpeed IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment4 = NULL ' 
	END 	 
    ELSE IF @WaterSpeed <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment4 = ''' + cast(@WaterSpeed as nvarchar(10)) + ''' ' 
	END 
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
	EXEC (@SQL)

    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END

   COMMIT TRANSACTION --成功提交事务

	SET @Return = 1
	RETURN

Set NOCOUNT OFF
End	
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





