IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdatePhaseResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdatePhaseResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_SL_UpdatePhaseResult]
--描    述: 激流回旋项目,更新比赛成绩
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月08日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SL_UpdatePhaseResult]
	@MatchID				INT,
	@CompetitionPosition	INT,
    @PhaseResult            NVARCHAR(50),
    @PhaseBehind            NVARCHAR(50),
    @PhaseRank              INT,
	@PhaseDisplayPosition	INT,
	@IRMCode		        NVARCHAR(10),
	@Return  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @PhaseID	        INT
	DECLARE @RegisterID	        INT
	DECLARE @PhaseResultNumber	INT
	
	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END

	SELECT @PhaseID = F_PhaseID	FROM TS_Match WHERE F_MatchID = @MatchID

    SELECT @RegisterID = F_RegisterID FROM TS_Match_Result 
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 

    IF @RegisterID IS NULL
	BEGIN
		SET @Return = -1
		RETURN
	END


	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	--清除冗余数据
	DELETE TS_Phase_Result WHERE F_PhaseID = @PhaseID
	AND F_RegisterID IS NULL
	
	DELETE TS_Phase_Result WHERE F_PhaseID = @PhaseID
	AND F_RegisterID NOT IN(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID)

    SET @PhaseResultNumber = null
	SELECT @PhaseResultNumber = F_PhaseResultNumber FROM TS_Phase_Result 
	WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID
    
    IF @PhaseResultNumber IS NULL
    BEGIN
		SELECT @PhaseResultNumber = max(F_PhaseResultNumber)+1 FROM TS_Phase_Result 
		WHERE F_PhaseID = @PhaseID
	  
		IF @PhaseResultNumber IS NULL
		BEGIN
			SET @PhaseResultNumber = 1
		END

		INSERT INTO TS_Phase_Result(F_PhaseID,F_PhaseResultNumber,F_RegisterID) 
		VALUES( @PhaseID,@PhaseResultNumber,@RegisterID )
    END

    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Phase_Result SET '
    SET @SQL = @SQL + 'F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''' ' 
    IF @PhaseResult IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhasePointsCharDes2 = NULL ' 
    END
    ELSE IF @PhaseResult <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_PhasePointsCharDes2 = ''' + cast(@PhaseResult as nvarchar(50)) + ''' ' 
	END
    IF @PhaseBehind IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhasePointsCharDes4 = NULL ' 
    END
	ELSE IF @PhaseBehind <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_PhasePointsCharDes4 = ''' + cast(@PhaseBehind as nvarchar(50)) + ''' ' 
	END
    IF @PhaseRank IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhaseRank = NULL ' 
    END
	ELSE IF @PhaseRank <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@PhaseRank as nvarchar(10)) + ''' ' 
	END
    IF @PhaseDisplayPosition IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL ' 
    END
	ELSE IF @PhaseDisplayPosition <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@PhaseDisplayPosition as nvarchar(50)) + ''' ' 
	END
    IF @IRMCode IS NULL 
    BEGIN
		SET @SQL = @SQL + ',F_IRMID = NULL ' 
    END
	ELSE IF @IRMCode <> '-1'
    BEGIN
		DECLARE @DisciplineID   INT
		DECLARE @IRMID		    INT
		SELECT  @DisciplineID = E.F_DisciplineID FROM TS_Match AS M  
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
        WHERE M.F_MatchID = @MatchID
		SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IrmCode = @IRMCode AND F_DisciplineID = @DisciplineID
		SET @SQL = @SQL + ',F_IRMID = ''' + cast(@IRMID as nvarchar(10)) + ''' '
    END
    SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_PhaseResultNumber = ''' + cast(@PhaseResultNumber as nvarchar(10)) + ''''
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




