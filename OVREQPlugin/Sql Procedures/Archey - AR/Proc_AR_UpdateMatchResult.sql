IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_UpdateMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_UpdateMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_AR_UpdateMatchResult]
--描    述: 射箭项目,更新比赛成绩
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年04月06日
--修改记录：
/*
		崔凯
*/


CREATE PROCEDURE [dbo].[Proc_AR_UpdateMatchResult]
	@MatchID				INT,
	@CompetitionPosition	INT,
	@DisplayPosition		INT,
	@10s					NVARCHAR(10),
	@Xs						NVARCHAR(10),
    @Total                  NVARCHAR(10),
    @Point                  NVARCHAR(10),
    @Rank                   NVARCHAR(10),
	@IRMCode		        NVARCHAR(10),
	@Target			        NVARCHAR(10),
	@Result  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON
	
 	DECLARE @SQL		    NVARCHAR(max)


	SET @Result=0;  -- @Result=0; 	更新Match失败，标示没有做任何操作！
					-- @Result=1; 	更新Match成功，返回！
					-- @Result=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''' '
	
    IF @DisPlayPosition IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_DisplayPosition = NULL ' 
    END
    ELSE IF @DisPlayPosition <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_DisplayPosition = ''' + cast(@DisplayPosition as nvarchar(50)) + ''' ' 
	END
	
	IF @Total IS NULL OR @Total=''
	BEGIN  
		SET @SQL = @SQL + ',F_Points = NULL ' 
	END 
    ELSE IF @Total <> '-1'
	BEGIN  
		SET @SQL = @SQL + ',F_Points = ''' + cast(@Total as nvarchar(10)) + ''' ' 
	END
	
	IF @Point IS NULL OR @Point=''
	BEGIN  
		SET @SQL = @SQL + ',F_RealScore = NULL ' 
	END 
    ELSE IF @Point <> '-1'
	BEGIN  
		SET @SQL = @SQL + ',F_RealScore = ''' + cast(@Point as nvarchar(10)) + ''' ' 
	END
	
    IF @Rank IS NULL OR @Rank=''
	BEGIN  
 		SET @SQL = @SQL + ',F_Rank = NULL ' 
	END 
    ELSE IF @Rank <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_Rank = ''' + cast(@Rank as nvarchar(10)) + ''' ' 
	END

	 IF @10s IS NULL OR @10s =''
    BEGIN
		SET @SQL = @SQL + ',F_WinPoints = NULL ' 
    END
    ELSE IF @10s <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_WinPoints = ''' + cast(@10s as nvarchar(50)) + ''' ' 
	END 
	
	IF @Xs IS NULL OR @Xs=''
    BEGIN
		SET @SQL = @SQL + ',F_LosePoints = NULL ' 
    END
    ELSE IF @Xs <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_LosePoints = ''' + cast(@Xs as nvarchar(50)) + ''' ' 
	END
	 
	IF @Target IS NULL OR @Target=''
    BEGIN
		SET @SQL = @SQL + ',F_Comment = NULL ' 
    END
    ELSE IF @Target <> '-1'
	BEGIN 
		SET @SQL = @SQL + ',F_Comment = ''' + @Target + ''' ' 
	END 
	
    IF @IRMCode IS NULL 
    BEGIN
		SET @SQL = @SQL + ',F_IRMID = NULL ' 
    END
	ELSE IF @IRMCode <> '-1'
    BEGIN
        UPDATE TS_Match_Split_Result SET F_Points = NULL WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 
        UPDATE TS_Match_Result SET F_Points = NULL, F_Rank = NULL WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

	    DECLARE @DisciplineID   INT
		DECLARE @IRMID          INT
		SELECT  @DisciplineID = E.F_DisciplineID FROM TS_Match AS M  
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
        SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IrmCode = @IRMCode AND F_DisciplineID = @DisciplineID
		SET @SQL = @SQL + ',F_IRMID = ''' + cast(@IRMID as nvarchar(10)) + ''' '
    END
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
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

