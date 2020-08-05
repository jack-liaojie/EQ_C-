IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_UpdateQualificationPhaseResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_UpdateQualificationPhaseResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_AR_UpdateQualificationPhaseResult]
--描    述: 射箭项目,更新比赛成绩
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年04月06日
--修改记录：
/*
		崔凯
*/


CREATE PROCEDURE [dbo].[Proc_AR_UpdateQualificationPhaseResult]
	@MatchID				INT,
	@RegisterID				INT,
	@DisplayPosition		INT,
    @LongDistinceA			NVARCHAR(10),
	@LongDistinceB			NVARCHAR(10),
	@ShortDistinceA			NVARCHAR(10),
	@ShortDistinceB			NVARCHAR(10),
    @Total                  NVARCHAR(10),
    @Rank                   NVARCHAR(10),
	@IRMCode		        NVARCHAR(10),
	@Result  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON
	
 	DECLARE @SQL					NVARCHAR(max)
	declare @PhaseID				int
	declare @PhaseResultNumber		int
	
	SET @Result=0;  -- @Result=0; 	更新Match失败，标示没有做任何操作！
					-- @Result=1; 	更新Match成功，返回！
					-- @Result=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
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
	IF @Total IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_PhasePoints = NULL ' 
	END 
    ELSE IF @Total <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_PhasePoints = ''' + cast(@Total as nvarchar(10)) + ''' ' 
	END
    IF @Rank IS NULL
	BEGIN  
 		SET @SQL = @SQL + ',F_PhaseRank = NULL ' 
	END 
    ELSE IF @Rank <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhaseRank = ''' + cast(@Rank as nvarchar(10)) + ''' ' 
	END
    IF @DisPlayPosition IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhaseDisplayPosition = NULL ' 
    END
    ELSE IF @DisPlayPosition <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhaseDisplayPosition = ''' + cast(@DisplayPosition as nvarchar(50)) + ''' ' 
	END
	 
	 IF @LongDistinceA IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhasePointsIntDes1 = NULL ' 
    END
    ELSE IF @LongDistinceA <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhasePointsIntDes1 = ''' + cast(@LongDistinceA as nvarchar(50)) + ''' ' 
	END
	 
	IF @LongDistinceB IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhasePointsIntDes2 = NULL ' 
    END
    ELSE IF @LongDistinceB <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhasePointsIntDes2 = ''' + cast(@LongDistinceB as nvarchar(50)) + ''' ' 
	END 
	 IF @ShortDistinceA IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhasePointsIntDes3 = NULL ' 
    END
    ELSE IF @ShortDistinceA <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhasePointsIntDes3 = ''' + cast(@ShortDistinceA as nvarchar(50)) + ''' ' 
	END 
	
	 IF @ShortDistinceB IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_PhasePointsIntDes4 = NULL ' 
    END
    ELSE IF @ShortDistinceB <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_PhasePointsIntDes4 = ''' + cast(@ShortDistinceB as nvarchar(50)) + ''' ' 
	END 
		 
    IF @IRMCode IS NULL 
    BEGIN
		SET @SQL = @SQL + ',F_IRMID = NULL ' 
    END
	ELSE IF @IRMCode <> '-1'
    BEGIN
        DECLARE @DisciplineID   INT
		DECLARE @IRMID          INT
		SELECT  @DisciplineID = E.F_DisciplineID FROM TS_Match AS M  
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
        SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IrmCode = @IRMCode AND F_DisciplineID = @DisciplineID
		SET @SQL = @SQL + ',F_IRMID = ''' + cast(@IRMID as nvarchar(10)) + ''' '
    END
    SET @SQL = @SQL + 'WHERE F_PhaseID = ''' + cast(@PhaseID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''''
	EXEC (@SQL)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK
		SET @Result =0	
		RETURN	
	END

	COMMIT TRANSACTION --成功提交事务


	SET @Result = 1
	RETURN


SET NOCOUNT OFF
END

GO


