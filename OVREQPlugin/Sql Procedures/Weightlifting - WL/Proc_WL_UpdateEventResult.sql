IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateEventResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_WL_UpdateEventResult]
--描    述: 举重项目,更新比赛阶段成绩
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月16日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_WL_UpdateEventResult]
	@MatchID				INT,
	@RegisterID	            INT,
	@SnatchResult            NVARCHAR(10),
	@CleanJerkResult         NVARCHAR(10),
    @TotalResult             NVARCHAR(10),
    @TotalRank              INT,
	@TotalDisplayPosition	INT,
    @TotalIRMCode           NVARCHAR(10),
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
	DECLARE @PhaseID	        INT
	DECLARE @EventResultNumber	INT
	
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
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

	SELECT @EventID = F_EventID,
		   @PhaseID = M.F_PhaseID
	FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	WHERE M.F_MatchID = @MatchID

    IF @RegisterID IS NULL
	BEGIN
		SET @Return = -1
		RETURN
	END

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	--清除冗余数据
	DELETE TS_Event_Result
		WHERE F_EventID = @EventID AND F_RegisterID IS NULL
	
	--DELETE TS_Event_Result 	
	--	FROM TS_Event_Result AS ER
	--	WHERE ER.F_EventID = @EventID AND F_RegisterID IN 
	--		(SELECT PR.F_RegisterID FROM TS_Phase_Result AS PR				
	--				WHERE PR.F_PhaseID = @PhaseID)
	--		AND F_RegisterID IN(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID) 

    SET @EventResultNumber = null
	SELECT @EventResultNumber = F_EventResultNumber FROM TS_Event_Result 
	WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID
    
    IF @EventResultNumber IS NULL
    BEGIN
		SELECT @EventResultNumber = max(F_EventResultNumber)+1 FROM TS_Event_Result 
		WHERE F_EventID = @EventID
	  
		IF @EventResultNumber IS NULL
		BEGIN
			SET @EventResultNumber = 1
		END

		INSERT INTO TS_Event_Result(F_EventID,F_EventResultNumber,F_RegisterID) 
		VALUES( @EventID,@EventResultNumber,@RegisterID )
    END

    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Event_Result SET '
    SET @SQL = @SQL + 'F_EventResultNumber = ''' + cast(@EventResultNumber as nvarchar(10)) + ''' ' 
    IF @SnatchResult IS NULL
		SET @SQL = @SQL + ',F_EventPointsCharDes2 = NULL ' 
	ELSE IF @SnatchResult <> '-1' 
		SET @SQL = @SQL + ',F_EventPointsCharDes2 = ''' + cast(@SnatchResult as nvarchar(10)) + ''' ' 
    IF @CleanJerkResult IS NULL
		SET @SQL = @SQL + ',F_EventPointsCharDes3 = NULL ' 
	ELSE IF @CleanJerkResult <> '-1' 
		SET @SQL = @SQL + ',F_EventPointsCharDes3 = ''' + cast(@CleanJerkResult as nvarchar(10)) + ''' '     
    IF @TotalResult IS NULL
		SET @SQL = @SQL + ',F_EventPointsCharDes4 = NULL ' 
	ELSE IF @TotalResult <> '-1' 
		SET @SQL = @SQL + ',F_EventPointsCharDes4 = ''' + cast(@TotalResult as nvarchar(10)) + ''' ' 
    IF @TotalRank IS NULL
		SET @SQL = @SQL + ',F_EventRank = NULL ' 
	ELSE IF @TotalRank <> -1 
		SET @SQL = @SQL + ',F_EventRank = ''' + cast(@TotalRank as nvarchar(10)) + ''' ' 
    IF @TotalDisplayPosition IS NULL
		SET @SQL = @SQL + ',F_EventDisplayPosition = NULL ' 
	ELSE IF @TotalDisplayPosition <> -1 
		SET @SQL = @SQL + ',F_EventDisplayPosition = ''' + cast(@TotalDisplayPosition as nvarchar(50)) + ''' '
    IF @TotalIRMCode IS NULL 
    BEGIN
		SET @SQL = @SQL + ',F_IRMID = NULL ' 
    END
	ELSE IF @TotalIRMCode <> '-1'
    BEGIN
		DECLARE @DisciplineID   INT
		DECLARE @IRMID		    INT
		SELECT  @DisciplineID = E.F_DisciplineID FROM TS_Match AS M  
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
        WHERE M.F_MatchID = @MatchID
		SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IrmCode = @TotalIRMCode AND F_DisciplineID = @DisciplineID
		SET @SQL = @SQL + ',F_IRMID = ''' + cast(@IRMID as nvarchar(10)) + ''' '
    END		 
    SET @SQL = @SQL + 'WHERE F_EventID = ''' + cast(@EventID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_EventResultNumber = ''' + cast(@EventResultNumber as nvarchar(10)) + ''''
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

/*

-- Just for test
EXEC [Proc_WL_UpdateEventResult] 8,12,1,1,null

*/



