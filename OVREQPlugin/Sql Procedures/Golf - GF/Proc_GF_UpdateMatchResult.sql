IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_UpdateMatchResult]
----功		  能：更新一场比赛的实时成绩
----作		  者： 张翠霞
----日		  期: 2010-10-05

CREATE PROCEDURE [dbo].[Proc_GF_UpdateMatchResult] (	
	@MatchID				INT,
	@IsDetail               INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID或CompetitionID或Hole不存在！ 
                       
    CREATE TABLE #tmp_RoundResult(
									F_CompetitionID					INT,
									F_Point                         INT,
									F_Rank                          INT,
									F_IRMID                         INT
								  )
								  
    CREATE TABLE #tmp_EventResult(
                                    F_RegisterID       INT,
                                    F_R1Point          INT,
                                    F_R2Point          INT,
                                    F_R3Point          INT,
                                    F_R4Point          INT,
                                    F_R1ToPar          INT,
                                    F_R2ToPar          INT,
                                    F_R3ToPar          INT,
                                    F_R4ToPar          INT,
                                    F_IRMIDR1            INT,
                                    F_IRMIDR2            INT,
                                    F_IRMIDR3            INT,                                    
                                    F_IRMIDR4            INT,
									F_IRMCodeR1        NVARCHAR(10),
									F_IRMCodeR2        NVARCHAR(10),
									F_IRMCodeR3        NVARCHAR(10),
									F_IRMCodeR4        NVARCHAR(10),                                                                        
                                    F_Point            INT,
                                    F_ToPar            INT,
                                    F_Rank             INT,
                                    F_DisplayPos       INT,
                                    F_IRMID            INT,
                                    F_IRMCode          NVARCHAR(10),
                                    F_Last9HolePoint   INT,
                                    F_Last9HoleToPar   INT,
                                    F_Last6HolePoint   INT,
                                    F_Last6HoleToPar   INT,
                                    F_Last3HolePoint   INT,
                                    F_Last3HoleToPar   INT)
    IF @IsDetail = 1
    BEGIN                                    
        ALTER TABLE #tmp_EventResult ADD                          
                                    F_R4H18Point     INT,
                                    F_R4H18ToPar     INT,
                                    F_R4H17Point     INT,
                                    F_R4H17ToPar     INT,
                                    F_R4H16Point     INT,
                                    F_R4H16ToPar     INT,
                                    F_R4H15Point     INT,
                                    F_R4H15ToPar     INT,
                                    F_R4H14Point     INT,
                                    F_R4H14ToPar     INT,
                                    F_R4H13Point     INT,
                                    F_R4H13ToPar     INT,
                                    F_R4H12Point     INT,
                                    F_R4H12ToPar     INT,
                                    F_R4H11Point     INT,
                                    F_R4H11ToPar     INT,
                                    F_R4H10Point     INT,
                                    F_R4H10ToPar     INT,
                                    F_R4H09Point     INT,
                                    F_R4H09ToPar     INT,
                                    F_R4H08Point     INT,
                                    F_R4H08ToPar     INT,
                                    F_R4H07Point     INT,
                                    F_R4H07ToPar     INT,
                                    F_R4H06Point     INT,
                                    F_R4H06ToPar     INT,
                                    F_R4H05Point     INT,
                                    F_R4H05ToPar     INT,
                                    F_R4H04Point     INT,
                                    F_R4H04ToPar     INT,
                                    F_R4H03Point     INT,
                                    F_R4H03ToPar     INT,
                                    F_R4H02Point     INT,
                                    F_R4H02ToPar     INT,
                                    F_R4H01Point     INT,
                                    F_R4H01ToPar     INT,

                                    F_R3H18Point     INT,
                                    F_R3H18ToPar     INT,
                                    F_R3H17Point     INT,
                                    F_R3H17ToPar     INT,
                                    F_R3H16Point     INT,
                                    F_R3H16ToPar     INT,
                                    F_R3H15Point     INT,
                                    F_R3H15ToPar     INT,
                                    F_R3H14Point     INT,
                                    F_R3H14ToPar     INT,
                                    F_R3H13Point     INT,
                                    F_R3H13ToPar     INT,
                                    F_R3H12Point     INT,
                                    F_R3H12ToPar     INT,
                                    F_R3H11Point     INT,
                                    F_R3H11ToPar     INT,
                                    F_R3H10Point     INT,
                                    F_R3H10ToPar     INT,
                                    F_R3H09Point     INT,
                                    F_R3H09ToPar     INT,
                                    F_R3H08Point     INT,
                                    F_R3H08ToPar     INT,
                                    F_R3H07Point     INT,
                                    F_R3H07ToPar     INT,
                                    F_R3H06Point     INT,
                                    F_R3H06ToPar     INT,
                                    F_R3H05Point     INT,
                                    F_R3H05ToPar     INT,
                                    F_R3H04Point     INT,
                                    F_R3H04ToPar     INT,
                                    F_R3H03Point     INT,
                                    F_R3H03ToPar     INT,
                                    F_R3H02Point     INT,
                                    F_R3H02ToPar     INT,
                                    F_R3H01Point     INT,
                                    F_R3H01ToPar     INT,
                                    
                                    F_R2H18Point     INT,
                                    F_R2H18ToPar     INT,
                                    F_R2H17Point     INT,
                                    F_R2H17ToPar     INT,
                                    F_R2H16Point     INT,
                                    F_R2H16ToPar     INT,
                                    F_R2H15Point     INT,
                                    F_R2H15ToPar     INT,
                                    F_R2H14Point     INT,
                                    F_R2H14ToPar     INT,
                                    F_R2H13Point     INT,
                                    F_R2H13ToPar     INT,
                                    F_R2H12Point     INT,
                                    F_R2H12ToPar     INT,
                                    F_R2H11Point     INT,
                                    F_R2H11ToPar     INT,
                                    F_R2H10Point     INT,
                                    F_R2H10ToPar     INT,
                                    F_R2H09Point     INT,
                                    F_R2H09ToPar     INT,
                                    F_R2H08Point     INT,
                                    F_R2H08ToPar     INT,
                                    F_R2H07Point     INT,
                                    F_R2H07ToPar     INT,
                                    F_R2H06Point     INT,
                                    F_R2H06ToPar     INT,
                                    F_R2H05Point     INT,
                                    F_R2H05ToPar     INT,
                                    F_R2H04Point     INT,
                                    F_R2H04ToPar     INT,
                                    F_R2H03Point     INT,
                                    F_R2H03ToPar     INT,
                                    F_R2H02Point     INT,
                                    F_R2H02ToPar     INT,
                                    F_R2H01Point     INT,
                                    F_R2H01ToPar     INT,
                                   
                                    F_R1H18Point     INT,
                                    F_R1H18ToPar     INT,
                                    F_R1H17Point     INT,
                                    F_R1H17ToPar     INT,
                                    F_R1H16Point     INT,
                                    F_R1H16ToPar     INT,
                                    F_R1H15Point     INT,
                                    F_R1H15ToPar     INT,
                                    F_R1H14Point     INT,
                                    F_R1H14ToPar     INT,
                                    F_R1H13Point     INT,
                                    F_R1H13ToPar     INT,
                                    F_R1H12Point     INT,
                                    F_R1H12ToPar     INT,
                                    F_R1H11Point     INT,
                                    F_R1H11ToPar     INT,
                                    F_R1H10Point     INT,
                                    F_R1H10ToPar     INT,
                                    F_R1H09Point     INT,
                                    F_R1H09ToPar     INT,
                                    F_R1H08Point     INT,
                                    F_R1H08ToPar     INT,
                                    F_R1H07Point     INT,
                                    F_R1H07ToPar     INT,
                                    F_R1H06Point     INT,
                                    F_R1H06ToPar     INT,
                                    F_R1H05Point     INT,
                                    F_R1H05ToPar     INT,
                                    F_R1H04Point     INT,
                                    F_R1H04ToPar     INT,
                                    F_R1H03Point     INT,
                                    F_R1H03ToPar     INT,
                                    F_R1H02Point     INT,
                                    F_R1H02ToPar     INT,
                                    F_R1H01Point     INT,
                                    F_R1H01ToPar     INT                                                                        
    END                                  
              
    DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT

    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID
            
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID)
    BEGIN
    SET @Result = -1
    RETURN
    END
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
        INSERT INTO #tmp_RoundResult(F_CompetitionID, F_Point, F_IRMID)
        SELECT F_CompetitionPosition, CAST(F_PointsCharDes2 AS INT), F_IRMID
        FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_PointsCharDes1 IS NOT NULL
        
        UPDATE #tmp_RoundResult SET F_Rank = B.RankPts
		FROM #tmp_RoundResult AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY (CASE WHEN F_IRMID IS NOT NULL THEN 1 ELSE 0 END), (CASE WHEN F_Point IS NULL THEN 1 ELSE 0 END), F_Point) AS RankPts
		, * FROM #tmp_RoundResult)
		AS B ON A.F_CompetitionID = B.F_CompetitionID
		
		UPDATE #tmp_RoundResult SET F_Rank = NULL WHERE F_IRMID IS NOT NULL
		
		UPDATE TS_Match_Result SET F_PointsNumDes1 = B.F_Rank
		FROM TS_Match_Result AS MR LEFT JOIN #tmp_RoundResult AS B ON MR.F_CompetitionPosition = B.F_CompetitionID
		WHERE MR.F_MatchID = @MatchID
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO #tmp_EventResult(F_RegisterID, F_R1Point, F_R1ToPar, F_IRMIDR1, 
		F_R2Point, F_R2ToPar, F_IRMIDR2, F_R3Point, F_R3ToPar, F_IRMIDR3,
		F_R4Point, F_R4ToPar, F_IRMIDR4, F_IRMID)
		SELECT F_RegisterID
		, (CASE WHEN @PhaseOrder >= 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 1, 1) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 1, 2) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 1, 3) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 2, 1) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 2, 2) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 2, 3) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 3, 1) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 3, 2) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 3, 3) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 4, 1) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 4, 2) ELSE 0 END)
		, (CASE WHEN @PhaseOrder >= 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, F_RegisterID, 4, 3) ELSE 0 END)
		, F_IRMID
		FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL
		
		update #tmp_EventResult set f_irmcoder1 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr1)
		update #tmp_EventResult set f_irmcoder2 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr2)
		update #tmp_EventResult set f_irmcoder3 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr3)
		update #tmp_EventResult set f_irmcoder4 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr4)
		UPDATE #tmp_EventResult SET F_IRMCode = [dbo].[Fun_GF_GetTotalIRMCode] (@phaseorder,f_irmcoder1,f_irmcoder2,f_irmcoder3,f_irmcoder4) 
		UPDATE #tmp_EventResult SET F_IRMID = [dbo].[Fun_GF_GetIRMID] (F_IRMCode)
		
		UPDATE #tmp_EventResult SET F_Point = F_R1Point + F_R2Point + F_R3Point + F_R4Point
		UPDATE #tmp_EventResult SET F_ToPar = F_R1ToPar + F_R2ToPar + F_R3ToPar + F_R4ToPar
		
		IF @IsDetail = 1
		BEGIN
			UPDATE #tmp_EventResult SET F_Last9HolePoint = [dbo].[Fun_GF_GetRegisterLastMuHoleInfo](@EventID,F_RegisterID,@PhaseOrder,1,9)
			UPDATE #tmp_EventResult SET F_Last9HoleToPar = [dbo].[Fun_GF_GetRegisterLastMuHoleInfo](@EventID,F_RegisterID,@PhaseOrder,2,9)
			UPDATE #tmp_EventResult SET F_Last6HolePoint = [dbo].[Fun_GF_GetRegisterLastMuHoleInfo](@EventID,F_RegisterID,@PhaseOrder,1,6)
			UPDATE #tmp_EventResult SET F_Last6HoleToPar = [dbo].[Fun_GF_GetRegisterLastMuHoleInfo](@EventID,F_RegisterID,@PhaseOrder,2,6)
			UPDATE #tmp_EventResult SET F_Last3HolePoint = [dbo].[Fun_GF_GetRegisterLastMuHoleInfo](@EventID,F_RegisterID,@PhaseOrder,1,3)
			UPDATE #tmp_EventResult SET F_Last3HoleToPar = [dbo].[Fun_GF_GetRegisterLastMuHoleInfo](@EventID,F_RegisterID,@PhaseOrder,2,3)
		
			UPDATE #tmp_EventResult SET F_R4H18Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,18,1)
			UPDATE #tmp_EventResult SET F_R4H18ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,18,2)
			UPDATE #tmp_EventResult SET F_R4H17Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,17,1)
			UPDATE #tmp_EventResult SET F_R4H17ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,17,2)
			UPDATE #tmp_EventResult SET F_R4H16Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,16,1)
			UPDATE #tmp_EventResult SET F_R4H16ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,16,2)
			UPDATE #tmp_EventResult SET F_R4H15Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,15,1)
			UPDATE #tmp_EventResult SET F_R4H15ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,15,2)
			UPDATE #tmp_EventResult SET F_R4H14Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,14,1)
			UPDATE #tmp_EventResult SET F_R4H14ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,14,2)
			UPDATE #tmp_EventResult SET F_R4H13Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,13,1)
			UPDATE #tmp_EventResult SET F_R4H13ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,13,2)
			UPDATE #tmp_EventResult SET F_R4H12Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,12,1)
			UPDATE #tmp_EventResult SET F_R4H12ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,12,2)
			UPDATE #tmp_EventResult SET F_R4H11Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,11,1)
			UPDATE #tmp_EventResult SET F_R4H11ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,11,2)
			UPDATE #tmp_EventResult SET F_R4H10Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,10,1)
			UPDATE #tmp_EventResult SET F_R4H10ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,10,2)
			UPDATE #tmp_EventResult SET F_R4H09Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,9,1)
			UPDATE #tmp_EventResult SET F_R4H09ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,9,2)
			UPDATE #tmp_EventResult SET F_R4H08Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,8,1)
			UPDATE #tmp_EventResult SET F_R4H08ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,8,2)
			UPDATE #tmp_EventResult SET F_R4H07Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,7,1)
			UPDATE #tmp_EventResult SET F_R4H07ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,7,2)
			UPDATE #tmp_EventResult SET F_R4H06Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,6,1)
			UPDATE #tmp_EventResult SET F_R4H06ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,6,2)
			UPDATE #tmp_EventResult SET F_R4H05Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,5,1)
			UPDATE #tmp_EventResult SET F_R4H05ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,5,2)
			UPDATE #tmp_EventResult SET F_R4H04Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,4,1)
			UPDATE #tmp_EventResult SET F_R4H04ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,4,2)
			UPDATE #tmp_EventResult SET F_R4H03Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,3,1)
			UPDATE #tmp_EventResult SET F_R4H03ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,3,2)
			UPDATE #tmp_EventResult SET F_R4H02Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,2,1)
			UPDATE #tmp_EventResult SET F_R4H02ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,2,2)
			UPDATE #tmp_EventResult SET F_R4H01Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,1,1)
			UPDATE #tmp_EventResult SET F_R4H01ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,4,1,2)

			UPDATE #tmp_EventResult SET F_R3H18Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,18,1)
			UPDATE #tmp_EventResult SET F_R3H18ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,18,2)
			UPDATE #tmp_EventResult SET F_R3H17Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,17,1)
			UPDATE #tmp_EventResult SET F_R3H17ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,17,2)
			UPDATE #tmp_EventResult SET F_R3H16Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,16,1)
			UPDATE #tmp_EventResult SET F_R3H16ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,16,2)
			UPDATE #tmp_EventResult SET F_R3H15Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,15,1)
			UPDATE #tmp_EventResult SET F_R3H15ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,15,2)
			UPDATE #tmp_EventResult SET F_R3H14Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,14,1)
			UPDATE #tmp_EventResult SET F_R3H14ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,14,2)
			UPDATE #tmp_EventResult SET F_R3H13Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,13,1)
			UPDATE #tmp_EventResult SET F_R3H13ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,13,2)
			UPDATE #tmp_EventResult SET F_R3H12Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,12,1)
			UPDATE #tmp_EventResult SET F_R3H12ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,12,2)
			UPDATE #tmp_EventResult SET F_R3H11Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,11,1)
			UPDATE #tmp_EventResult SET F_R3H11ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,11,2)
			UPDATE #tmp_EventResult SET F_R3H10Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,10,1)
			UPDATE #tmp_EventResult SET F_R3H10ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,10,2)
			UPDATE #tmp_EventResult SET F_R3H09Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,9,1)
			UPDATE #tmp_EventResult SET F_R3H09ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,9,2)
			UPDATE #tmp_EventResult SET F_R3H08Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,8,1)
			UPDATE #tmp_EventResult SET F_R3H08ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,8,2)
			UPDATE #tmp_EventResult SET F_R3H07Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,7,1)
			UPDATE #tmp_EventResult SET F_R3H07ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,7,2)
			UPDATE #tmp_EventResult SET F_R3H06Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,6,1)
			UPDATE #tmp_EventResult SET F_R3H06ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,6,2)
			UPDATE #tmp_EventResult SET F_R3H05Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,5,1)
			UPDATE #tmp_EventResult SET F_R3H05ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,5,2)
			UPDATE #tmp_EventResult SET F_R3H04Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,4,1)
			UPDATE #tmp_EventResult SET F_R3H04ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,4,2)
			UPDATE #tmp_EventResult SET F_R3H03Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,3,1)
			UPDATE #tmp_EventResult SET F_R3H03ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,3,2)
			UPDATE #tmp_EventResult SET F_R3H02Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,2,1)
			UPDATE #tmp_EventResult SET F_R3H02ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,2,2)
			UPDATE #tmp_EventResult SET F_R3H01Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,1,1)
			UPDATE #tmp_EventResult SET F_R3H01ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,3,1,2)

			UPDATE #tmp_EventResult SET F_R2H18Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,18,1)
			UPDATE #tmp_EventResult SET F_R2H18ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,18,2)
			UPDATE #tmp_EventResult SET F_R2H17Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,17,1)
			UPDATE #tmp_EventResult SET F_R2H17ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,17,2)
			UPDATE #tmp_EventResult SET F_R2H16Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,16,1)
			UPDATE #tmp_EventResult SET F_R2H16ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,16,2)
			UPDATE #tmp_EventResult SET F_R2H15Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,15,1)
			UPDATE #tmp_EventResult SET F_R2H15ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,15,2)
			UPDATE #tmp_EventResult SET F_R2H14Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,14,1)
			UPDATE #tmp_EventResult SET F_R2H14ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,14,2)
			UPDATE #tmp_EventResult SET F_R2H13Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,13,1)
			UPDATE #tmp_EventResult SET F_R2H13ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,13,2)
			UPDATE #tmp_EventResult SET F_R2H12Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,12,1)
			UPDATE #tmp_EventResult SET F_R2H12ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,12,2)
			UPDATE #tmp_EventResult SET F_R2H11Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,11,1)
			UPDATE #tmp_EventResult SET F_R2H11ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,11,2)
			UPDATE #tmp_EventResult SET F_R2H10Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,10,1)
			UPDATE #tmp_EventResult SET F_R2H10ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,10,2)
			UPDATE #tmp_EventResult SET F_R2H09Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,9,1)
			UPDATE #tmp_EventResult SET F_R2H09ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,9,2)
			UPDATE #tmp_EventResult SET F_R2H08Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,8,1)
			UPDATE #tmp_EventResult SET F_R2H08ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,8,2)
			UPDATE #tmp_EventResult SET F_R2H07Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,7,1)
			UPDATE #tmp_EventResult SET F_R2H07ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,7,2)
			UPDATE #tmp_EventResult SET F_R2H06Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,6,1)
			UPDATE #tmp_EventResult SET F_R2H06ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,6,2)
			UPDATE #tmp_EventResult SET F_R2H05Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,5,1)
			UPDATE #tmp_EventResult SET F_R2H05ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,5,2)
			UPDATE #tmp_EventResult SET F_R2H04Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,4,1)
			UPDATE #tmp_EventResult SET F_R2H04ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,4,2)
			UPDATE #tmp_EventResult SET F_R2H03Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,3,1)
			UPDATE #tmp_EventResult SET F_R2H03ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,3,2)
			UPDATE #tmp_EventResult SET F_R2H02Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,2,1)
			UPDATE #tmp_EventResult SET F_R2H02ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,2,2)
			UPDATE #tmp_EventResult SET F_R2H01Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,1,1)
			UPDATE #tmp_EventResult SET F_R2H01ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,2,1,2)

			UPDATE #tmp_EventResult SET F_R1H18Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,18,1)
			UPDATE #tmp_EventResult SET F_R1H18ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,18,2)
			UPDATE #tmp_EventResult SET F_R1H17Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,17,1)
			UPDATE #tmp_EventResult SET F_R1H17ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,17,2)
			UPDATE #tmp_EventResult SET F_R1H16Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,16,1)
			UPDATE #tmp_EventResult SET F_R1H16ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,16,2)
			UPDATE #tmp_EventResult SET F_R1H15Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,15,1)
			UPDATE #tmp_EventResult SET F_R1H15ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,15,2)
			UPDATE #tmp_EventResult SET F_R1H14Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,14,1)
			UPDATE #tmp_EventResult SET F_R1H14ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,14,2)
			UPDATE #tmp_EventResult SET F_R1H13Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,13,1)
			UPDATE #tmp_EventResult SET F_R1H13ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,13,2)
			UPDATE #tmp_EventResult SET F_R1H12Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,12,1)
			UPDATE #tmp_EventResult SET F_R1H12ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,12,2)
			UPDATE #tmp_EventResult SET F_R1H11Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,11,1)
			UPDATE #tmp_EventResult SET F_R1H11ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,11,2)
			UPDATE #tmp_EventResult SET F_R1H10Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,10,1)
			UPDATE #tmp_EventResult SET F_R1H10ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,10,2)
			UPDATE #tmp_EventResult SET F_R1H09Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,9,1)
			UPDATE #tmp_EventResult SET F_R1H09ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,9,2)
			UPDATE #tmp_EventResult SET F_R1H08Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,8,1)
			UPDATE #tmp_EventResult SET F_R1H08ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,8,2)
			UPDATE #tmp_EventResult SET F_R1H07Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,7,1)
			UPDATE #tmp_EventResult SET F_R1H07ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,7,2)
			UPDATE #tmp_EventResult SET F_R1H06Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,6,1)
			UPDATE #tmp_EventResult SET F_R1H06ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,6,2)
			UPDATE #tmp_EventResult SET F_R1H05Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,5,1)
			UPDATE #tmp_EventResult SET F_R1H05ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,5,2)
			UPDATE #tmp_EventResult SET F_R1H04Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,4,1)
			UPDATE #tmp_EventResult SET F_R1H04ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,4,2)
			UPDATE #tmp_EventResult SET F_R1H03Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,3,1)
			UPDATE #tmp_EventResult SET F_R1H03ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,3,2)
			UPDATE #tmp_EventResult SET F_R1H02Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,2,1)
			UPDATE #tmp_EventResult SET F_R1H02ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,2,2)
			UPDATE #tmp_EventResult SET F_R1H01Point = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,1,1)
			UPDATE #tmp_EventResult SET F_R1H01ToPar = [dbo].[Fun_GF_GetRegisterSingleHoleNum](@EventID,F_RegisterID,1,1,2)
        END
        
		UPDATE #tmp_EventResult SET F_Rank = B.RankPts
		FROM #tmp_EventResult AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY (CASE WHEN F_IRMID IS NOT NULL THEN 1 ELSE 0 END), (CASE WHEN F_Point IS NULL THEN 1 ELSE 0 END), F_ToPar) AS RankPts
		, * FROM #tmp_EventResult)
		AS B ON A.F_RegisterID = B.F_RegisterID
		
        IF @IsDetail is null OR @IsDetail <> 1
        BEGIN				
			UPDATE #tmp_EventResult SET F_DisplayPos = B.DisplayPos
			FROM #tmp_EventResult AS A 
			LEFT JOIN (SELECT row_number() OVER(ORDER BY (CASE WHEN F_IRMID IS NOT NULL THEN 1 ELSE 0 END), 
			F_IRMCodeR1,F_IRMCodeR2,F_IRMCodeR3,F_IRMCodeR4, (CASE WHEN F_Point IS NULL THEN 1 ELSE 0 END), F_ToPar,
			F_R4Point, F_R4ToPar, F_R3Point, F_R3ToPar, F_R2Point, F_R2ToPar, F_R1Point, F_R1ToPar) AS DisplayPos
			, * FROM #tmp_EventResult)
			AS B ON A.F_RegisterID = B.F_RegisterID
		END
		ELSE
		BEGIN
			UPDATE #tmp_EventResult SET F_DisplayPos = B.DisplayPos
			FROM #tmp_EventResult AS A 
			LEFT JOIN (SELECT row_number() OVER(ORDER BY (CASE WHEN F_IRMID IS NOT NULL THEN 1 ELSE 0 END), 
			F_IRMCodeR1,F_IRMCodeR2,F_IRMCodeR3,F_IRMCodeR4, (CASE WHEN F_Point IS NULL THEN 1 ELSE 0 END), F_ToPar,
			F_R4Point, F_R4ToPar, F_R3Point, F_R3ToPar, F_R2Point, F_R2ToPar, F_R1Point, F_R1ToPar, 
			F_Last9HolePoint, F_Last9HoleToPar, F_Last6HolePoint, F_Last6HoleToPar, F_Last3HolePoint, F_Last3HoleToPar, 
			F_R4H18Point, F_R4H18ToPar, F_R4H17Point, F_R4H17ToPar, F_R4H16Point, F_R4H16ToPar, F_R4H15Point, F_R4H15ToPar,F_R4H14Point, F_R4H14ToPar, F_R4H13Point, F_R4H13ToPar,
			F_R4H12Point, F_R4H12ToPar, F_R4H11Point, F_R4H11ToPar, F_R4H10Point, F_R4H10ToPar, F_R4H09Point, F_R4H09ToPar,F_R4H08Point, F_R4H08ToPar, F_R4H07Point, F_R4H07ToPar,
			F_R4H06Point, F_R4H06ToPar, F_R4H05Point, F_R4H05ToPar, F_R4H04Point, F_R4H04ToPar, F_R4H03Point, F_R4H03ToPar,F_R4H02Point, F_R4H02ToPar, F_R4H01Point, F_R4H01ToPar,
			F_R3H18Point, F_R3H18ToPar, F_R3H17Point, F_R3H17ToPar, F_R3H16Point, F_R3H16ToPar, F_R3H15Point, F_R3H15ToPar,F_R3H14Point, F_R3H14ToPar, F_R3H13Point, F_R3H13ToPar,
			F_R3H12Point, F_R3H12ToPar, F_R3H11Point, F_R3H11ToPar, F_R3H10Point, F_R3H10ToPar, F_R3H09Point, F_R3H09ToPar,F_R3H08Point, F_R3H08ToPar, F_R3H07Point, F_R3H07ToPar,
			F_R3H06Point, F_R3H06ToPar, F_R3H05Point, F_R3H05ToPar, F_R3H04Point, F_R3H04ToPar, F_R3H03Point, F_R3H03ToPar,F_R3H02Point, F_R3H02ToPar, F_R3H01Point, F_R3H01ToPar,
			F_R2H18Point, F_R2H18ToPar, F_R2H17Point, F_R2H17ToPar, F_R2H16Point, F_R2H16ToPar, F_R2H15Point, F_R2H15ToPar,F_R2H14Point, F_R2H14ToPar, F_R2H13Point, F_R2H13ToPar,
			F_R2H12Point, F_R2H12ToPar, F_R2H11Point, F_R2H11ToPar, F_R2H10Point, F_R2H10ToPar, F_R2H09Point, F_R2H09ToPar,F_R2H08Point, F_R2H08ToPar, F_R2H07Point, F_R2H07ToPar,
			F_R2H06Point, F_R2H06ToPar, F_R2H05Point, F_R2H05ToPar, F_R2H04Point, F_R2H04ToPar, F_R2H03Point, F_R2H03ToPar,F_R2H02Point, F_R2H02ToPar, F_R2H01Point, F_R2H01ToPar,
			F_R1H18Point, F_R1H18ToPar, F_R1H17Point, F_R1H17ToPar, F_R1H16Point, F_R1H16ToPar, F_R1H15Point, F_R1H15ToPar,F_R1H14Point, F_R1H14ToPar, F_R1H13Point, F_R1H13ToPar,
			F_R1H12Point, F_R1H12ToPar, F_R1H11Point, F_R1H11ToPar, F_R1H10Point, F_R1H10ToPar, F_R1H09Point, F_R1H09ToPar,F_R1H08Point, F_R1H08ToPar, F_R1H07Point, F_R1H07ToPar,
			F_R1H06Point, F_R1H06ToPar, F_R1H05Point, F_R1H05ToPar, F_R1H04Point, F_R1H04ToPar, F_R1H03Point, F_R1H03ToPar,F_R1H02Point, F_R1H02ToPar, F_R1H01Point, F_R1H01ToPar
			) AS DisplayPos
			, * FROM #tmp_EventResult)
			AS B ON A.F_RegisterID = B.F_RegisterID
		END
		
		UPDATE #tmp_EventResult SET F_Rank = NULL WHERE F_IRMID IS NOT NULL
		
		UPDATE TS_Match_Result SET F_Rank = NULL, F_DisplayPosition = NULL WHERE F_MatchID = @MatchID
		
		UPDATE TS_Match_Result SET F_PointsCharDes3 = (CASE WHEN B.F_Point = 0 THEN NULL ELSE CAST(B.F_Point AS NVARCHAR(10)) END)
		, F_PointsCharDes4 = (CASE WHEN B.F_Point = 0 THEN NULL ELSE CAST(B.F_ToPar AS NVARCHAR(10)) END), 
		F_Rank = B.F_Rank, F_DisplayPosition = B.F_DisplayPos
		FROM TS_Match_Result AS MR LEFT JOIN #tmp_EventResult AS B ON MR.F_RegisterID = B.F_RegisterID
		WHERE MR.F_MatchID = @MatchID
		
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



