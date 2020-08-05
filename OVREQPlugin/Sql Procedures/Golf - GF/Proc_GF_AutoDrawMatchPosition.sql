IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_AutoDrawMatchPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_AutoDrawMatchPosition]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GF_AutoDrawMatchPosition]
--描    述: 高尔夫比赛，抽签选择
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2011-02-22
--修改日期：2011-07-18 吴定昉，重新编写分组算法，先按成绩差先出发，成绩好后出发，同一国家尽可能不分配在同一组


CREATE PROCEDURE [dbo].[Proc_GF_AutoDrawMatchPosition]
	@MatchID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	表示生成初始比赛签位失败，什么动作也没有
					  -- @Result = 1; 	表示生成初始比赛签位
		
    DECLARE @EventID INT
    DECLARE @TeamEventID INT
    DECLARE @SexCode INT		  
    DECLARE @PhaseOrder INT
    DECLARE @PreMatchID INT
    DECLARE @MatchIDR1 AS INT
    DECLARE @MatchIDR2 AS INT
    DECLARE @MatchIDR3 AS INT
    DECLARE @MatchIDR4 AS INT    
    
    IF EXISTS (SELECT MR.F_CompetitionPositionDes2, MR.F_FinishTimeNumDes FROM TS_Match_Result AS MR 
    WHERE MR.F_MatchID = @MatchID AND F_CompetitionPositionDes2 IS NULL)
		RETURN
    
    SELECT @EventID = E.F_EventID, @SexCode = E.F_SexCode, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    SELECT @MatchIDR1 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 1) 
    SELECT @MatchIDR2 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 2) 
    SELECT @MatchIDR3 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 3) 
    SELECT @MatchIDR4 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 4) 
    
    SELECT @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
    
    IF @PhaseOrder <> 1
    BEGIN
        SELECT @PreMatchID = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_Order = @PhaseOrder - 1 AND P.F_EventID = @EventID
    END

	CREATE TABLE #table_IndiPlayer(
	                                 F_IndiPlayerID    INT,
	                                 F_IndiPlayerOrder INT,
	                                 F_DelegationID    INT,
	                                )
	                                
	CREATE TABLE #table_ExistPhasePosition(
											F_KeyID			 INT,
	                                        F_DelegationID   INT,
	                                        F_IndiPlayerID   INT,
	                                        F_Group          INT,
	                                        F_CompetitionPos INT,
	                                        F_IndiPlayerOrder INT,
	                                        )
	                                        
	IF @PhaseOrder = 1
	BEGIN
	    CREATE TABLE #table_Temp(
	                                 F_DelegationID    INT,
	                                 F_DelegationOrder INT,
	                                 F_IndiPlayerID    INT,
	                                 F_IndiPlayerOrder INT,
	                                 F_DelegationCode  NVARCHAR(10), 
	                                 F_PlayerName      NVARCHAR(150)
	                                )
	                                 
	    INSERT INTO #table_Temp(F_DelegationID, F_IndiPlayerID, F_DelegationCode, F_PlayerName)
	    SELECT R.F_DelegationID, I1.F_RegisterID, D.F_DelegationCode, RD.F_LongName FROM TR_Inscription AS I1 
	    LEFT JOIN TR_Register AS R ON I1.F_RegisterID = R.F_RegisterID
	    LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID	    
	    LEFT JOIN TR_Register_Des AS RD ON I1.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	    WHERE I1.F_EventID = @EventID AND I1.F_RegisterID NOT IN (SELECT RM.F_MemberRegisterID FROM TR_Register_Member AS RM LEFT JOIN TR_Inscription
	    AS I2 ON RM.F_RegisterID = I2.F_RegisterID WHERE I2.F_EventID = @TeamEventID)
	                                 
	    INSERT INTO #table_Temp(F_DelegationID, F_IndiPlayerID, F_DelegationCode, F_PlayerName)
	    SELECT R.F_DelegationID, RM.F_MemberRegisterID, D.F_DelegationCode, RD.F_LongName FROM TR_Register_Member AS RM 
	    LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID
	    LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID 
	    LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	    LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	    WHERE I.F_EventID = @TeamEventID AND RM.F_MemberRegisterID IN (SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID)
/*
	    INSERT INTO #table_IndiPlayer(F_IndiPlayerID,F_IndiPlayerOrder,F_DelegationID)
	    SELECT F_IndiPlayerID, ROW_NUMBER() OVER(ORDER BY F_PlayerName), F_DelegationID FROM #table_Temp
	    ORDER BY F_PlayerName DESC
*/	

		DECLARE tCursor CURSOR	
			FOR SELECT F_IndiPlayerID FROM #table_Temp

		OPEN tCursor
		DECLARE @IndiPlayerID INT
			FETCH NEXT FROM  tCursor INTO @IndiPlayerID
		WHILE @@FETCH_STATUS =0
			BEGIN
                update #table_Temp set F_IndiPlayerOrder = cast(RAND()*100000 as int) 
                where F_IndiPlayerID = @IndiPlayerID	     
				FETCH NEXT FROM tCursor INTO @IndiPlayerID
			END	
		CLOSE tCursor
		DEALLOCATE tCursor
        
	    INSERT INTO #table_IndiPlayer(F_IndiPlayerID,F_IndiPlayerOrder,F_DelegationID)
	    SELECT F_IndiPlayerID, ROW_NUMBER() OVER(ORDER BY F_IndiPlayerOrder), F_DelegationID FROM #table_Temp
	    ORDER BY F_IndiPlayerOrder	    
	END
	ELSE IF @PhaseOrder IN (2, 3, 4)
	BEGIN
	    CREATE TABLE #table(
	                                 F_DelegationID    INT,
	                                 F_DelegationOrder INT,
	                                 F_IndiPlayerID    INT,
	                                 F_IndiPlayerOrder INT,
	                                 F_IRMCode         NVARCHAR(10),
	                                )
	     
	    DECLARE @MaxPos INT
	    set @MaxPos = 0
	    select @MaxPos = max(F_DisplayPosition) from TS_Match_Result where F_MatchID = @PreMatchID and F_DisplayPosition is not null

	    INSERT INTO #table(F_DelegationID, F_IndiPlayerID, F_IndiPlayerOrder, F_IRMCode)   
	    select d.F_DelegationID,mrr1.F_RegisterID,mr.F_DisplayPosition,
	    case when @PhaseOrder = 2 then [dbo].[Fun_GF_GetTotalIRMCode](@PhaseOrder,IR1.F_IRMCODE,null,null,null) 
	         when @PhaseOrder = 3 then [dbo].[Fun_GF_GetTotalIRMCode](@PhaseOrder,IR1.F_IRMCODE,IR2.F_IRMCODE,null,null)
	         when @PhaseOrder = 4 then [dbo].[Fun_GF_GetTotalIRMCode](@PhaseOrder,IR1.F_IRMCODE,IR2.F_IRMCODE,IR3.F_IRMCODE,null)
	         end
	    from TS_Match_Result as mrr1
	    left join TR_Register as r on mrr1.F_RegisterID = r.F_RegisterID 
	    left join TC_Delegation as d on r.F_DelegationID = d.F_DelegationID 
	    left join TS_Match_Result as mr on mrr1.F_RegisterID = mr.F_RegisterID and mr.F_MatchID = @PreMatchID
	    left join TC_IRM as i on mr.F_IRMID = i.F_IRMID
	    left join TS_Match_Result as mrr2 on mrr1.F_RegisterID = mrr2.F_RegisterID and mrr2.F_MatchID = @MatchIDR2
	    left join TS_Match_Result as mrr3 on mrr1.F_RegisterID = mrr3.F_RegisterID and mrr3.F_MatchID = @MatchIDR3
	    left join TS_Match_Result as mrr4 on mrr1.F_RegisterID = mrr4.F_RegisterID and mrr4.F_MatchID = @MatchIDR4
	    left join TC_IRM as IR1 on mrr1.F_IRMID = IR1.F_IRMID
	    left join TC_IRM as IR2 on mrr2.F_IRMID = IR2.F_IRMID
	    left join TC_IRM as IR3 on mrr3.F_IRMID = IR3.F_IRMID
	    left join TC_IRM as IR4 on mrr4.F_IRMID = IR4.F_IRMID
	    where mrr1.F_MatchID = @MatchIDR1 
        
	    --过滤退赛人员
	    delete #table where F_IRMCode is not null and F_IRMCode ='RTD' or F_IRMCode = 'WD'
	    --过滤被取消比赛资格,且仅仅参加个人赛，没有参加团体赛
	    delete #table where F_IRMCode is not null and F_IRMCode ='DQ' 
	    and F_IndiPlayerID not in (SELECT RM.F_MemberRegisterID FROM TR_Register_Member AS RM
		LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID AND I.F_EventID = @TeamEventID)

	    INSERT INTO #table_IndiPlayer(F_IndiPlayerID,F_IndiPlayerOrder,F_DelegationID)
	    SELECT T.F_IndiPlayerID, T.F_IndiPlayerOrder, T.F_DelegationID FROM #table AS T
	    ORDER BY T.F_IndiPlayerOrder DESC

		IF EXISTS (SELECT * FROM #table_IndiPlayer WHERE F_IndiPlayerOrder IS NULL)
			RETURN
	END
    
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	UPDATE TS_Match_Result SET F_RegisterID = NULL WHERE F_MatchID = @MatchID

	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	
	DELETE FROM #table_ExistPhasePosition
    INSERT INTO #table_ExistPhasePosition(F_KeyID, F_IndiPlayerID, F_DelegationID, F_Group, F_CompetitionPos)
    SELECT MR.F_CompetitionPosition, MR.F_RegisterID, R.F_DelegationID, MR.F_CompetitionPositionDes2, MR.F_FinishTimeNumDes 
    FROM TS_Match_Result AS MR LEFT JOIN TR_Register AS R
    ON MR.F_RegisterID = R.F_RegisterID WHERE MR.F_MatchID = @MatchID
	 
	CREATE TABLE #table_KeyIDs(
	                       F_KeyID			INT,
						   F_Group			    INT,
						   F_CompetitionPos	    INT
						   )

	CREATE TABLE #temp_MaxPlayCounInDele(
						   F_DelegationID	INT,
						   F_PlayerCount	INT,
						   )						   
						   
	DECLARE @RegisterID INT
    DECLARE @DelegationID INT
    DECLARE @Group INT
    DECLARE @CompetitionPos INT
    DECLARE @IndiPlayerOrder INT
				
	WHILE EXISTS (SELECT F_IndiPlayerID FROM #table_IndiPlayer)
	BEGIN
	    SET @Group = NULL
	    SET @CompetitionPos = NULL
	    
	    DELETE FROM #table_KeyIDs
	    INSERT INTO #table_KeyIDs(F_KeyID,F_Group,F_CompetitionPos) 
	    SELECT F_KeyID, F_Group, F_CompetitionPos FROM #table_ExistPhasePosition WHERE F_IndiPlayerID IS NULL
	    
	    SELECT TOP 1 @Group = F_Group, @CompetitionPos = F_CompetitionPos FROM #table_KeyIDs ORDER BY F_Group, F_CompetitionPos	  
	          
	    DECLARE @MaxOrder INT
	    SET @MaxOrder = 0
	    SELECT @MaxOrder = MAX(F_IndiPlayerOrder) FROM #table_IndiPlayer WHERE F_IndiPlayerOrder IS NOT NULL

	    WHILE 0 <= @MaxOrder
	    BEGIN       
  			SELECT TOP 1 @RegisterID = F_IndiPlayerID, @DelegationID = F_DelegationID,@IndiPlayerOrder = F_IndiPlayerOrder 
  			FROM #table_IndiPlayer WHERE F_IndiPlayerOrder = @MaxOrder
			SET @MaxOrder = @MaxOrder - 1
			if @RegisterID is null 
			  continue 
			
			DECLARE @GroupNullCount INT --组内空余个数
			SET @GroupNullCount = 0
			SELECT @GroupNullCount = COUNT(*) FROM #table_ExistPhasePosition WHERE F_Group = @Group AND F_IndiPlayerID IS NULL 

			DECLARE @NullGroupCount INT --非当前组外的空组个数
			SET @NullGroupCount = 0
			SELECT @NullGroupCount = COUNT(distinct F_Group) FROM #table_ExistPhasePosition WHERE F_IndiPlayerID IS NULL AND F_Group <> @Group

			DECLARE @DelegationCountInPlayerMoreNullGroup INT --剩余人数大于空组的国家数目(非当前国家)
			SET @DelegationCountInPlayerMoreNullGroup = 0
            INSERT INTO #temp_MaxPlayCounInDele(F_DelegationID) 
			SELECT distinct F_DelegationID FROM #table_IndiPlayer WHERE F_DelegationID is not null and F_DelegationID <> @DelegationID
			Update #temp_MaxPlayCounInDele set F_PlayerCount = (select COUNT(F_IndiPlayerID) from #table_IndiPlayer as B 
			where A.F_DelegationID = B.F_DelegationID) FROM #temp_MaxPlayCounInDele AS A
			SELECT @DelegationCountInPlayerMoreNullGroup = count(F_DelegationID) FROM #temp_MaxPlayCounInDele
			where F_PlayerCount > @NullGroupCount
			delete from #temp_MaxPlayCounInDele
			if @DelegationCountInPlayerMoreNullGroup > 0 and @DelegationCountInPlayerMoreNullGroup >= @GroupNullCount
			begin
			   continue
			end   	
			
			IF NOT EXISTS(SELECT F_IndiPlayerID FROM #table_ExistPhasePosition WHERE F_Group = @Group AND F_DelegationID = @DelegationID)
				BREAK 
	
			DECLARE @DelegationCount INT --剩余其他国家数
			SET @DelegationCount = 0
			SELECT @DelegationCount = COUNT(distinct F_DelegationID) FROM #table_IndiPlayer WHERE F_DelegationID is not null and F_DelegationID <> @DelegationID
			
			DECLARE @DelegationPlayerCount INT --该国家剩余人数
			SET @DelegationPlayerCount = 0
			SELECT @DelegationPlayerCount = COUNT(*) FROM #table_IndiPlayer WHERE F_DelegationID = @DelegationID
			
            --当该国家剩余人数大于空组个数时，
            --并且现有组内不存在剩余国家里面，未在该组出现的国家。
            --则允许出现组内重复一个国家的运动员
			IF @DelegationPlayerCount > @NullGroupCount
			BEGIN 
			  IF NOT EXISTS (SELECT distinct F_DelegationID FROM #table_IndiPlayer WHERE F_DelegationID is not null
			  and F_DelegationID not in (SELECT distinct F_DelegationID FROM #table_ExistPhasePosition WHERE F_Group = @Group and F_DelegationID is not null))
			  BEGIN
				BREAK
			  END --如果组内存在剩余国家未出现，并且剩余位置大于剩余其他国家
			  ELSE IF @GroupNullCount > @DelegationCount
			    BREAK	
			END	
		END		

	    UPDATE #table_ExistPhasePosition SET F_IndiPlayerID = @RegisterID, F_DelegationID = @DelegationID,
	    F_IndiPlayerOrder = @IndiPlayerOrder 
	    WHERE F_Group = @Group AND F_CompetitionPos = @CompetitionPos
	    	    
	    DELETE FROM #table_IndiPlayer WHERE F_IndiPlayerID = @RegisterID
	    
	    IF NOT EXISTS (SELECT F_KeyID FROM #table_ExistPhasePosition WHERE F_IndiPlayerID IS NULL)
			BREAK	    
	END
    
    update #table_ExistPhasePosition set F_CompetitionPos = B.F_Order
    FROM #table_ExistPhasePosition as A
    left join (SELECT row_number() OVER(PARTITION BY F_Group order by F_IndiPlayerOrder desc) as F_Order,* FROM #table_ExistPhasePosition) as B
    on A.F_KeyID = B.F_KeyID

    update #table_ExistPhasePosition set F_KeyID = B.KeyID
    FROM #table_ExistPhasePosition as A
    left join (SELECT row_number() OVER(order by F_Group, F_CompetitionPos) as KeyID,* FROM #table_ExistPhasePosition) as B
    on A.F_KeyID = B.F_KeyID

    UPDATE MR SET MR.F_RegisterID = T.F_IndiPlayerID FROM TS_Match_Result AS MR LEFT JOIN #table_ExistPhasePosition AS T
    ON MR.F_CompetitionPosition = T.F_KeyID WHERE MR.F_MatchID = @MatchID
    
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



