IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdateMatchTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdateMatchTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----存储过程名称：[Proc_SL_UpdateMatchTime]
----功		  能：
----作		  者：吴定昉 
----日		  期: 2010-01-12 

Create PROCEDURE [dbo].[Proc_SL_UpdateMatchTime] 
	@MatchID				INT,
	@CompetitionPosition	INT,
    @StartTime              NVARCHAR(50),
    @SplitTime1             NVARCHAR(50),
    @SplitTime2             NVARCHAR(50),
    @SplitTime3             NVARCHAR(50),
    @SplitTime4             NVARCHAR(50),
    @FinishTime             NVARCHAR(50),
	@Return  			    AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON
	
 	DECLARE @SQL		    NVARCHAR(max)

	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END


	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''' '
    IF @StartTime IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_StartTimeCharDes = NULL ' 
	END 
    ELSE IF @StartTime <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_StartTimeCharDes = ''' + cast(@StartTime as nvarchar(50)) + ''' ' 
	END
    IF @SplitTime1 IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes1 = NULL ' 
	END 
    ELSE IF @SplitTime1 <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes1 = ''' + cast(@SplitTime1 as nvarchar(50)) + ''' ' 
	END
    IF @SplitTime2 IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes2 = NULL ' 
	END 
    ELSE IF @SplitTime2 <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes2 = ''' + cast(@SplitTime2 as nvarchar(50)) + ''' ' 
	END
    IF @SplitTime3 IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes3 = NULL ' 
	END 
    ELSE IF @SplitTime3 <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes3 = ''' + cast(@SplitTime3 as nvarchar(50)) + ''' ' 
	END
    IF @SplitTime4 IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes4 = NULL ' 
	END 
    ELSE IF @SplitTime4 <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_PointsNumDes4 = ''' + cast(@SplitTime4 as nvarchar(50)) + ''' ' 
	END
    IF @FinishTime IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_FinishTimeCharDes = NULL ' 
    END
    ELSE IF @FinishTime <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_FinishTimeCharDes = ''' + cast(@FinishTime as nvarchar(50)) + ''' ' 
	END
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
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


SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
