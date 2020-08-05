IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CreateMatchGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CreateMatchGroup]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_GF_CreateMatchGroup]
----功		  能：更新一场比赛的实时成绩
----作		  者： 张翠霞
----日		  期: 2010-10-05

CREATE PROCEDURE [dbo].[Proc_GF_CreateMatchGroup] (	
	@MatchID				INT,
	@Sides		            INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID不存在！
                       -- @Result = -2; 更新失败，该Tee不存在！
                       -- @Result = -3; 更新失败，缺少参赛运动员！
                       
    DECLARE @PlayerNum AS INT
    DECLARE @GroupCount AS INT
    DECLARE @GroupAdd AS INT
    DECLARE @GroupAddNum AS INT
    DECLARE @SQL NVARCHAR(MAX)
    
            
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
    BEGIN
		SET @Result = -1
		RETURN
    END
    
    SELECT @PlayerNum = COUNT(F_CompetitionPosition) FROM TS_Match_Result WHERE F_MatchID = @MatchID
    IF @PlayerNum <= 0
    BEGIN
		SET @Result = -3
		RETURN
    END
    
    SET @GroupAdd = 0
    SET @GroupCount = @PlayerNum / @Sides
    SET @GroupAddNum = @PlayerNum % @Sides
    
    IF @GroupAddNum <> 0
    BEGIN
        SET @GroupAdd = 1
    END
    
    CREATE TABLE #Tmp_Table(
                          F_CompetitionPosition    INT, 
                          F_Order                  INT,
                          F_Group                  INT,
                          F_Sides                  INT
                          )
    INSERT INTO #Tmp_Table(F_CompetitionPosition, F_Order)
    SELECT F_CompetitionPosition, F_CompetitionPositionDes1
    FROM TS_Match_Result WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition
    
    IF @GroupAdd = 1
    BEGIN	
		Update #Tmp_Table SET [F_Group] = 1 WHERE F_Order <= @GroupAddNum
    END
    
    DECLARE @Order AS INT
    SET @Order = 0
    
    WHILE @Order < @GroupCount
    BEGIN
       DECLARE @StartOrder AS INT
       DECLARE @MidTime AS NVARCHAR(10)
       SET @StartOrder = @Order * @Sides + @GroupAddNum      
       SET @Order = @Order + 1
       
       Update #Tmp_Table SET [F_Group] = @Order + @GroupAdd WHERE F_Order > @StartOrder AND F_Order <= (@StartOrder + @Sides)	  
    END
    
    UPDATE #Tmp_Table SET F_Sides = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT DENSE_RANK() OVER(PARTITION BY F_Group ORDER BY F_Order) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition
		
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	    UPDATE TS_Match_Result SET F_CompetitionPositionDes2 = B.F_Group, F_FinishTimeNumDes = F_Sides
	    FROM TS_Match_Result AS A LEFT JOIN #Tmp_Table AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition
	    WHERE A.F_MatchID = @MatchID
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END


GO


