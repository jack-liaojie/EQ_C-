IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdateMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdateMatchResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_SL_UpdateMatchResult]
--描    述: 激流回旋项目,更新比赛成绩
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月08日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SL_UpdateMatchResult]
	@MatchID				INT,
	@CompetitionPosition	INT,
    @Pen                    INT,
    @Time                   NVARCHAR(50),
    @Result                 NVARCHAR(50),
    @PenSec                 NVARCHAR(50),
    @Behind                 NVARCHAR(50),
    @Rank                   INT,
	@DisplayPosition		INT,
	@IRMCode		        NVARCHAR(10),
	@Return  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON
	
 	DECLARE @SQL		    NVARCHAR(max)
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

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
    SET @SQL = ''
    SET @SQL = @SQL + 'UPDATE TS_Match_Result SET '
    SET @SQL = @SQL + 'F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''' '
	IF @Pen IS NULL
	BEGIN  
		SET @SQL = @SQL + ',F_Points = NULL ' 
	END 
    ELSE IF @Pen <> -1 
	BEGIN  
		SET @SQL = @SQL + ',F_Points = ''' + cast(@Pen as nvarchar(10)) + ''' ' 
	END
    IF @Time IS NULL
	BEGIN  
 		SET @SQL = @SQL + ',F_PointsCharDes1 = NULL ' 
	END 
    ELSE IF @Time <> '-1' 
	BEGIN  
		SET @SQL = @SQL + ',F_PointsCharDes1 = ''' + cast(@Time as nvarchar(50)) + ''' ' 
	END
    IF @Result IS NULL
	BEGIN  
 		SET @SQL = @SQL + ',F_PointsCharDes2 = NULL ' 
	END 
	ELSE IF @Result <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_PointsCharDes2 = ''' + cast(@Result as nvarchar(50)) + ''' ' 
	END
    IF @PenSec IS NULL
	BEGIN  
 		SET @SQL = @SQL + ',F_PointsCharDes3 = NULL ' 
	END 
	ELSE IF @PenSec <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_PointsCharDes3 = ''' + cast(@PenSec as nvarchar(50)) + ''' ' 
	END
    IF @Behind IS NULL
	BEGIN  
 		SET @SQL = @SQL + ',F_PointsCharDes4 = NULL ' 
	END 
	ELSE IF @Behind <> '-1' 
	BEGIN 
		SET @SQL = @SQL + ',F_PointsCharDes4 = ''' + cast(@Behind as nvarchar(50)) + ''' ' 
	END
    IF @Rank IS NULL
	BEGIN  
 		SET @SQL = @SQL + ',F_Rank = NULL ' 
	END 
    ELSE IF @Rank <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_Rank = ''' + cast(@Rank as nvarchar(10)) + ''' ' 
	END
    IF @DisPlayPosition IS NULL
    BEGIN
		SET @SQL = @SQL + ',F_DisplayPosition = NULL ' 
    END
    ELSE IF @DisPlayPosition <> -1 
	BEGIN 
		SET @SQL = @SQL + ',F_DisplayPosition = ''' + cast(@DisplayPosition as nvarchar(50)) + ''' ' 
	END
    IF @IRMCode IS NULL 
    BEGIN
		SET @SQL = @SQL + ',F_IRMID = NULL ' 
    END
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
    SET @SQL = @SQL + 'AND F_CompetitionPosition = ''' + cast(@CompetitionPosition as nvarchar(10)) + ''''
	EXEC (@SQL)

	DECLARE @DisciplineCode NVARCHAR(10)
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @SexCode        INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
	DECLARE @Heats2ndRoundID INT

    --//处理设置IRM = DSQ-C
    IF @IRMCode IS NOT NULL AND @IRMCode <> '-1' AND @IRMCode = 'DSQ-C' 
    BEGIN	
		SELECT @DisciplineCode = D.F_DisciplineCode,
		@EventCode = E.F_EventCode, 
		@SexCode = E.F_SexCode, 
		@PhaseCode = P.F_PhaseCode, 
		@MatchCode = M.F_MatchCode FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE F_MatchID = @MatchID
		
		IF @PhaseCode = '9' AND @MatchCode = '01'
		BEGIN
			SELECT @Heats2ndRoundID = M.F_MatchID FROM TS_Match AS M 
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
			LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
			WHERE E.F_EventCode = @EventCode 
			AND E.F_SexCode = @SexCode
			AND P.F_PhaseCode = @PhaseCode
			AND M.F_MatchCode = '02' 
			AND D.F_DisciplineCode = @DisciplineCode 
			
			UPDATE TS_Match_Result SET F_IRMID = @IRMID, F_RealScore = 4 
			WHERE F_MatchID = @Heats2ndRoundID AND F_CompetitionPosition = @CompetitionPosition
		END	
    END
    --//处理还原IRM = DSQ-C
    IF @IRMCode IS NULL --AND @IRMCode <> '-1' AND @IRMCode = '' 
    BEGIN
			SELECT @DisciplineCode = D.F_DisciplineCode,
			@EventCode = E.F_EventCode, 
			@SexCode = E.F_SexCode, 
			@PhaseCode = P.F_PhaseCode, 
			@MatchCode = M.F_MatchCode FROM TS_Match AS M 
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
			LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
			WHERE F_MatchID = @MatchID
			
			IF @PhaseCode = '9' AND @MatchCode = '01'
			BEGIN	
				SELECT @Heats2ndRoundID = M.F_MatchID FROM TS_Match AS M 
				LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
				LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
				WHERE E.F_EventCode = @EventCode 
				AND E.F_SexCode = @SexCode
				AND P.F_PhaseCode = @PhaseCode
				AND M.F_MatchCode = '02' 
				AND D.F_DisciplineCode = @DisciplineCode 
	
				SELECT @OldIRMCode = F_IrmCode FROM TC_IRM WHERE F_IRMID = 
				(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @Heats2ndRoundID AND F_CompetitionPosition = @CompetitionPosition)
				IF @OldIRMCode IS NOT NULL AND @OldIRMCode = 'DSQ-C'
				BEGIN
				
				UPDATE TS_Match_Result SET F_IRMID = @IRMID, F_RealScore = 0 
				WHERE F_MatchID = @Heats2ndRoundID AND F_CompetitionPosition = @CompetitionPosition
			END	
		END
    END


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
EXEC [Proc_SL_UpdateMatchResult] 2994,1,-1,'-1','-1','-1','-1',-1,-1,'DSQ-C',null

*/

