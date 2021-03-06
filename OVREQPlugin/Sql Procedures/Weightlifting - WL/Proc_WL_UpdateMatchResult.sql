IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateMatchResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_WL_UpdateMatchResult]
--描    述: 举重项目,更新比赛成绩
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月16日
--修改记录：
/*			
	日期					修改人		修改内容
	2011-01-11				崔凯		修改赛果表时插入试举次数（F_Points）
	2011-03-09				崔凯		修改赛果时插入最好成绩的试举次数，用于排名（F_WinPoints）
*/



CREATE PROCEDURE [dbo].[Proc_WL_UpdateMatchResult]
	@MatchID				INT,
	@CompetitionPosition	INT,
    @1stAttempt             NVARCHAR(10),
    @1stRes                 NVARCHAR(10),
    @2ndAttempt             NVARCHAR(10),
    @2ndRes                 NVARCHAR(10),
    @3rdAttempt             NVARCHAR(10),
    @3rdRes                 NVARCHAR(10),
    @Result                 NVARCHAR(10),
    @Rank                   INT,
    @DisplayPosition	    INT,
    @IRMCode                NVARCHAR(10),
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
	DECLARE @RegisterID     INT
	DECLARE @DisciplineID   INT
	DECLARE @IRMID		    INT
	DECLARE @OldIRMCode		NVARCHAR(10)

	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END

    SELECT @RegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	IF @RegisterID IS NULL
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

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
     
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''' '
	IF @1stAttempt IS NULL
		SET @SQL = @SQL + ',F_PointsCharDes1 = NULL ' 
    ELSE IF @1stAttempt <> '-1' 
		SET @SQL = @SQL + ',F_PointsCharDes1 = ''' + cast(@1stAttempt as nvarchar(10)) + ''' ' 
	IF @1stRes IS NULL
		SET @SQL = @SQL + ',F_PointsNumDes1 = NULL ' 
    ELSE IF @1stRes <> '-1' 
		SET @SQL = @SQL + ',F_PointsNumDes1 = ' + cast(@1stRes as nvarchar(10)) + ' ' 
	IF @2ndAttempt IS NULL
		SET @SQL = @SQL + ',F_PointsCharDes2 = NULL ' 
    ELSE IF @2ndAttempt <> '-1' 
		SET @SQL = @SQL + ',F_PointsCharDes2 = ''' + cast(@2ndAttempt as nvarchar(10)) + ''' ' 
	IF @2ndRes IS NULL
		SET @SQL = @SQL + ',F_PointsNumDes2 = NULL ' 
    ELSE IF @2ndRes <> '-1' 
		SET @SQL = @SQL + ',F_PointsNumDes2 = ' + cast(@2ndRes as nvarchar(10)) + ' ' 
	IF @3rdAttempt IS NULL
		SET @SQL = @SQL + ',F_PointsCharDes3 = NULL ' 
    ELSE IF @3rdAttempt <> '-1' 
		SET @SQL = @SQL + ',F_PointsCharDes3 = ''' + cast(@3rdAttempt as nvarchar(10)) + ''' '
	IF @3rdRes IS NULL
		SET @SQL = @SQL + ',F_PointsNumDes3 = NULL ' 
    ELSE IF @3rdRes <> '-1' 
		SET @SQL = @SQL + ',F_PointsNumDes3 = ' + cast(@3rdRes as nvarchar(10)) + ' ' 
	IF @Result IS NULL
		SET @SQL = @SQL + ',F_PointsCharDes4 = NULL ' 
    ELSE IF @Result <> '-1' 
		SET @SQL = @SQL + ',F_PointsCharDes4 = ''' + cast(@Result as nvarchar(10)) + ''' ' 		
	IF @Rank IS NULL
		SET @SQL = @SQL + ',F_Rank = NULL ' 
    ELSE IF @Rank <> -1 
		SET @SQL = @SQL + ',F_Rank = ''' + cast(@Rank as nvarchar(10)) + ''' ' 		
	IF @DisplayPosition IS NULL
		SET @SQL = @SQL + ',F_DisplayPosition = NULL ' 
    ELSE IF @DisplayPosition <> -1 
		SET @SQL = @SQL + ',F_DisplayPosition = ''' + cast(@DisplayPosition as nvarchar(10)) + ''' ' 		
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''''
	EXEC (@SQL)
	
	--崔凯：插入F_Points值，记录运动员试举次数，在试举状态更新时同步更新
	DECLARE @AttemptTimes INT
	SET @AttemptTimes=(SELECT 
		 CASE WHEN [F_PointsCharDes1] IS NOT NULL AND [F_PointsNumDes1] IS NOT NULL  
			  AND [F_PointsNumDes2] IS NULL 
			  THEN 2
			  WHEN [F_PointsCharDes1] IS NOT NULL AND [F_PointsNumDes1] IS NOT NULL  
			  AND  [F_PointsCharDes2] IS NOT NULL AND [F_PointsNumDes2] IS NOT NULL
			  AND [F_PointsNumDes3] IS NULL
			  THEN 3
			  WHEN [F_PointsCharDes1] IS NOT NULL AND [F_PointsNumDes1] IS NOT NULL 
			   AND [F_PointsCharDes2] IS NOT NULL AND [F_PointsNumDes2] IS NOT NULL 
			   AND [F_PointsCharDes3] IS NOT NULL AND [F_PointsNumDes3] IS NOT NULL THEN 4
			ELSE 1
		 END
		FROM [dbo].[TS_Match_Result] 
		where F_MatchID = @MatchID AND F_RegisterID = @RegisterID)
	SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_Points = ''' + cast(@AttemptTimes as nvarchar(10)) + ''' '
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''''
	EXEC(@SQL)
	--END
	
	--崔凯：插入F_WinPoints值，记录运动员最好成绩的试举次数，在试举状态更新时同步更新
	DECLARE @ResultNumber INT
	SET @ResultNumber=(SELECT 
		 CASE WHEN [F_PointsCharDes1] IS NOT NULL AND [F_PointsCharDes4] IS NOT NULL  
			  AND  [F_PointsCharDes1] =[F_PointsCharDes4] AND dbo.Fun_WL_GetIsSuccess(F_PointsNumDes1) =1 THEN 1
			  WHEN [F_PointsCharDes2] IS NOT NULL AND [F_PointsCharDes4] IS NOT NULL  
			  AND  [F_PointsCharDes2] =[F_PointsCharDes4] AND dbo.Fun_WL_GetIsSuccess(F_PointsNumDes2) =1  THEN 2
			  WHEN [F_PointsCharDes3] IS NOT NULL AND [F_PointsCharDes4] IS NOT NULL  
			  AND  [F_PointsCharDes3] =[F_PointsCharDes4] AND dbo.Fun_WL_GetIsSuccess(F_PointsNumDes3) =1  THEN 3
			ELSE 0
		 END
		FROM [dbo].[TS_Match_Result] 
		where F_MatchID = @MatchID AND F_RegisterID = @RegisterID)
	SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_WinPoints = ''' + cast(@ResultNumber as nvarchar(10)) + ''' '
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''''
	EXEC(@SQL)
	--END
	
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''' '
    IF @IRMCode IS NULL 
		SET @SQL = @SQL + ',F_IRMID = NULL ' 
	ELSE IF @IRMCode <> '-1'
    BEGIN
		SELECT  @DisciplineID = E.F_DisciplineID FROM TS_Match AS M  
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
        WHERE M.F_MatchID = @MatchID
		SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IrmCode = @IRMCode AND F_DisciplineID = @DisciplineID
		SET @SQL = @SQL + ',F_IRMID = ''' + cast(@IRMID as nvarchar(10)) + ''' '
    END
    SET @SQL = @SQL + 'WHERE F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + ''''
    SET @SQL = @SQL + 'AND F_RegisterID = ''' + cast(@RegisterID as nvarchar(10)) + ''''
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
EXEC [Proc_WL_UpdateMatchResult] 1,1,'123','-1','-1','-1',-1,-1,'-1',null

*/

