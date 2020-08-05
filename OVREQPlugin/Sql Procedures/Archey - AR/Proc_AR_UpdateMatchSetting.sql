IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_UpdateMatchSetting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_UpdateMatchSetting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_AR_UpdateMatchSetting]
----功		  能：
----作		  者：崔凯 
----日		  期: 2011-10-16 

CREATE PROCEDURE [dbo].[Proc_AR_UpdateMatchSetting] 
	@MatchID			           INT,
	@EndCount				       INT,
	@ArrowCount			           INT,
	@IsSetPoints			       INT,
	@WinPoints			           INT,
	@Distince				       INT,
	@CompetitionRuleID	           INT,
	@MatchStatusID			       INT,
	@Result 			           AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
 	DECLARE @Order		    NVARCHAR(50)

	SET @Result=0;  -- @Result=0; 	更新Match失败，标示没有做任何操作！
					-- @Result=1; 	更新Match成功，返回！
					-- @Result=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    SELECT @Order = F_Order FROM TS_Match WHERE F_MatchID = @MatchID 

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
   
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match SET '
    SET @SQL = @SQL + 'F_Order = ''' + cast(@Order as nvarchar(50)) + ''' ' 
    IF @EndCount IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment1 = NULL ' 
	END 
    ELSE IF @EndCount <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment1 = ''' + cast(@EndCount as nvarchar(10)) + ''' ' 
	END 
    IF @ArrowCount IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment2 = NULL ' 
	END 
    ELSE IF @ArrowCount <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment2 = ''' + cast(@ArrowCount as nvarchar(10)) + ''' ' 
	END 
    IF @IsSetPoints IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment3 = NULL ' 
	END 
    ELSE IF @IsSetPoints <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment3 = ''' + cast(@IsSetPoints as nvarchar(10)) + ''' ' 
	END 
    IF @WinPoints IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment4 = NULL ' 
	END 
    ELSE IF @WinPoints <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment4 = ''' + cast(@WinPoints as nvarchar(10)) + ''' ' 
	END 
    IF @Distince IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment5 = NULL ' 
	END 
    ELSE IF @Distince <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchComment5 = ''' + cast(@Distince as nvarchar(10)) + ''' ' 
	END 
	IF @CompetitionRuleID IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_CompetitionRuleID = NULL ' 
	END 
    ELSE IF @CompetitionRuleID <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_CompetitionRuleID = ''' + cast(@CompetitionRuleID as nvarchar(10)) + ''' ' 
	END 
    IF @MatchStatusID IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_MatchStatusID = NULL ' 
	END 
    ELSE IF @MatchStatusID <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_MatchStatusID = ''' + cast(@MatchStatusID as nvarchar(10)) + ''' ' 
	END 
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
	EXEC (@SQL)

    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END

   COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

GO


