IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_UpdatePlayerEnd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_UpdatePlayerEnd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_UpdatePlayerEnd]
--描    述: 射箭项目,更新某人一次箭靶信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月11日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_UpdatePlayerEnd]
	@MatchID				INT,
	@CompetitionPosition	INT,
	@MathcSplitID			INT,
	@EndIndex				NVARCHAR(10),
	@Ring					NVARCHAR(10),
	@Score					NVARCHAR(10),
	@10Num					NVARCHAR(10),
	@XNum					NVARCHAR(10),
	@Auto					INT,
	@Result  			    AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SET @Result=0;  -- @Result=0; 	更新Match失败，标示没有做任何操作！
					-- @Result=1; 	更新Match成功，返回！
					-- @Result=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @EndDistince INT
	
	SELECT @EndDistince = ISNULL(F_MatchSplitPrecision,1) FROM TS_Match_Split_Info
		WHERE F_MatchID= @MatchID 
			AND F_MatchSplitID = @MathcSplitID 
			AND F_MatchSplitType = 0
			AND F_MatchSplitCode = @EndIndex
			
	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	DECLARE @SQL NVARCHAR(MAX)
	SET @SQL = ''
    SET @SQL = @SQL + ' UPDATE TS_Match_Split_Result SET '
    
    IF @Ring IS NULL OR @Ring = ''
	BEGIN  
		SET @SQL = @SQL + ' F_Points = NULL ' 
	END 
    ELSE IF @Ring <> '-1'
	BEGIN  
		SET @SQL = @SQL + ' F_Points = ''' + cast(@Ring as nvarchar(10)) + ''' ' 
	END
    
    IF @Score IS NULL OR @Score = ''
	BEGIN  
		SET @SQL = @SQL + ' ,F_SplitPoints = NULL ' 
	END 
    ELSE IF @Score <> '-1'
	BEGIN  
		SET @SQL = @SQL + ' ,F_SplitPoints = ''' + cast(@Score as nvarchar(10)) + ''' ' 
	END
	
    IF @10Num IS NULL OR @10Num = ''
	BEGIN  
		SET @SQL = @SQL + ' ,F_Comment1 = NULL ' 
	END 
    ELSE IF @10Num <> '-1'
	BEGIN  
		SET @SQL = @SQL + ' ,F_Comment1 = ''' + cast(@10Num as nvarchar(10)) + ''' ' 
	END
	
    IF @XNum IS NULL OR @XNum = ''
	BEGIN  
		SET @SQL = @SQL + ' ,F_Comment2 = NULL ' 
	END 
    ELSE IF @XNum <> '-1'
	BEGIN  
		SET @SQL = @SQL + ' ,F_Comment2 = ''' + cast(@XNum as nvarchar(10)) + ''' ' 
	END
	    
	SET @SQL = @SQL + ' FROM TS_Match_Split_Result AS MSR'
	SET @SQL = @SQL + ' LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID AND MSI.F_MatchID = MSR.F_MatchID'
	SET @SQL = @SQL + ' where MSR.F_MatchID=''' + cast(@MatchID as nvarchar(10)) + ''' ' 
	SET @SQL = @SQL + ' AND MSI.F_MatchSplitID =''' + cast(@MathcSplitID as nvarchar(10)) + ''' '  
	SET @SQL = @SQL + ' AND MSR.F_CompetitionPosition =''' + cast(@CompetitionPosition as nvarchar(10)) + ''' ' 
	SET @SQL = @SQL + ' AND MSI.F_MatchSplitType = 0'
	SET @SQL = @SQL + ' AND MSI.F_MatchSplitCode =''' + cast(@EndIndex as nvarchar(10)) + ''' ' 
	
	EXEC (@SQL)
	--select @SQL
	
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END
	
	
	if(@Auto =1)
	begin
		DECLARE @Total int
		
		SET @Total = (SELECT SUM(F_Points)t FROM TS_Match_Split_Result AS MSR
		LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID AND MSI.F_MatchID=@MatchID
		WHERE MSR.F_MatchID= @MatchID 
		AND MSI.F_MatchSplitPrecision =@EndDistince
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0)
		
		DECLARE @SQL2 NVARCHAR(MAX) 
		SET @SQL2 =' '
		SET @SQL2 =@SQL2 + 'UPDATE TS_Match_Result SET '
		IF(@EndDistince = 1) 
		BEGIN
			SET @SQL = @SQL2 + ' F_PointsNumDes1=''' + cast(@Total as nvarchar(10)) + ''''
		end
		IF(@EndDistince = 2) 
		BEGIN
			SET @SQL = @SQL2 + ' F_PointsNumDes2=''' + cast(@Total as nvarchar(10)) + ''''
		end
		IF(@EndDistince = 3) 
		BEGIN
			SET @SQL =@SQL2 +  ' F_PointsNumDes3=''' + cast(@Total as nvarchar(10)) + ''''
		end
		IF(@EndDistince = 4) 
		BEGIN
			SET @SQL =@SQL2 +  ' F_PointsNumDes4=''' + cast(@Total as nvarchar(10)) + ''''
		end 
		SET @SQL = @SQL + ' where F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
		SET @SQL = @SQL + ' AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
		
		EXEC (@SQL)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		
		UPDATE TS_Match_Result
		 SET F_WinPoints =  (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
		    ,F_LosePoints =  (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
		FROM TS_Match_Result AS MSR
		LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchID = MSR.F_MatchID
		WHERE MSR.F_MatchID= @MatchID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0
		
	end
	
	COMMIT TRANSACTION --成功提交事务


	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

/*
declare @reslut int
exec Proc_AR_UpdatePlayerEnd 34,1,5,'2','','','','',0,@reslut OUTPUT
select @reslut
*/
