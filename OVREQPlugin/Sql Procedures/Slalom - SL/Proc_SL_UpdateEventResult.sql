IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdateEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdateEventResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----名    称: [Proc_SL_UpdateEventResult]
----描    述: 激流回旋项目,更新比赛成绩
----参数说明: 
----说    明: 
----创 建 人: 吴定昉
----日    期: 2010年01月08日
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月12日       吴定昉      为满足国内运动会的报表要求，数据库结构字段发生变化进行修正。
*/



CREATE PROCEDURE [dbo].[Proc_SL_UpdateEventResult]
	@EventID		INT,
	@Return  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @PhaseID	        INT
	
	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Return = -1
		RETURN
	END
	
	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID AND F_EventStatusID >=100)
	BEGIN
	    SET @Return = 0
	    RETURN 
	END

    SELECT @PhaseID = F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = '9'

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	--清除冗余数据
	DELETE TS_Event_Result WHERE F_EventID = @EventID AND F_RegisterID IS NULL

	DELETE TS_Event_Result WHERE F_EventID = @EventID
	AND F_RegisterID NOT IN(SELECT F_RegisterID FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID)
	
	UPDATE ER SET ER.F_EventResultNumber = PR.F_PhaseResultNumber FROM TS_Event_Result AS ER 
	INNER JOIN TS_Phase_Result AS PR ON ER.F_RegisterID = PR.F_RegisterID
	WHERE ER.F_EventID = @EventID AND PR.F_PhaseID = @PhaseID 

	INSERT TS_Event_Result([F_EventID],[F_EventResultNumber],[F_RegisterID]) 
	(SELECT @EventID, F_PhaseResultNumber, F_RegisterID FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID
	 AND F_RegisterID NOT IN(SELECT F_RegisterID FROM TS_Event_Result WHERE F_EventID = @EventID))

	Update TS_Event_Result SET [F_EventRank] = NULL,[F_EventDisplayPosition] = NULL, [F_IRMID] = NULL
	WHERE F_EventID = @EventID					

    CREATE TABLE #TempRankList
    (
		[RegisterID] INT,
        [Rank] INT
    )

	DECLARE @NextPhaseID	    INT
    DECLARE @RegisterID INT
    DECLARE @Rank    INT
    DECLARE @SaveRank    INT
    DECLARE @DisPos    INT
    DECLARE @IRMID    INT    
    DECLARE @MaxDisPos   INT
    DECLARE @NewRank    INT
    DECLARE @EventDisPos    INT
    DECLARE @NewDisPos    INT
    DECLARE @NewDisPos1    INT
    DECLARE @NewDisPos2    INT
	DECLARE @PhaseIdx INT

    DECLARE @DNS_IRMID    INT    
    DECLARE @DSQR_IRMID    INT    
    DECLARE @DSQC_IRMID    INT    
    DECLARE @DNF_IRMID    INT    

    SET @DNS_IRMID = (select f_irmid from TC_IRM where F_DisciplineID = (select F_DisciplineID from TS_Event where F_EventID = @EventID) and f_irmcode = 'DNS')
    SET @DSQR_IRMID = (select f_irmid from TC_IRM where F_DisciplineID = (select F_DisciplineID from TS_Event where F_EventID = @EventID) and f_irmcode = 'DSQ-R')
    SET @DSQC_IRMID = (select f_irmid from TC_IRM where F_DisciplineID = (select F_DisciplineID from TS_Event where F_EventID = @EventID) and f_irmcode = 'DSQ-C')
    SET @DNF_IRMID = (select f_irmid from TC_IRM where F_DisciplineID = (select F_DisciplineID from TS_Event where F_EventID = @EventID) and f_irmcode = 'DNF')

	SET @NewRank = 0
	SET @NewDisPos = 1 --主要处理正常顺序
	SET @NewDisPos1 = 10001 --主要处理Heats阶段的IRM=DSQ-R或IRM=DNS
	SET @NewDisPos2 = 20001 --主要处理IRM=DSQ-C
  	SET @PhaseIdx = 1	
  	
	WHILE @PhaseIdx <= 3
	BEGIN
		IF @PhaseIdx = 1
		BEGIN
			SET @NextPhaseID = -1
			SELECT @PhaseID = F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = '1'
		END
		ELSE IF @PhaseIdx = 2
		BEGIN
			SELECT @NextPhaseID = F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = '1'
			SELECT @PhaseID = F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = '2'
		END
		ELSE
		BEGIN
			SELECT @NextPhaseID = F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = '2'
			SELECT @PhaseID = F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseCode = '9'
		END

        SET @MaxDisPos = 0
		SET @MaxDisPos = (SELECT MAX(case when F_PhaseDisplayPosition IS null then 0 else F_PhaseDisplayPosition end) FROM TS_Phase_Result WHERE f_phaseid = @PhaseID)

		SET @SaveRank = -1		
		SET @DisPos = 1	
		WHILE @DisPos <= @MaxDisPos
		BEGIN
 			SELECT @RegisterID = [F_RegisterID],@Rank = [F_PhaseRank], @IRMID = [F_IRMID]
			FROM TS_Phase_Result WHERE f_phaseid = @PhaseID and F_PhaseDisplayPosition = @DisPos

            SET @EventDisPos = NULL
            SELECT @EventDisPos = F_EventDisplayPosition FROM TS_Event_Result WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID
            IF @EventDisPos IS NOT NULL 
            BEGIN
				SET @DisPos = @DisPos + 1
				continue
            END
            
			IF @IRMID IS NULL OR @IRMID = @DSQC_IRMID OR @IRMID = @DNF_IRMID 
			    IF @IRMID IS NOT NULL AND @IRMID = @DSQC_IRMID
			        BEGIN--IRM=DSQ-C,则没有项目名次，重新设置显示顺序
					Update TS_Event_Result SET [F_EventRank] = NULL,[F_EventDisplayPosition] = @NewDisPos2, [F_IRMID] = @IRMID
					WHERE F_EventID = @EventID AND [F_RegisterID] = @RegisterID
					SET @NewDisPos2 = @NewDisPos2 + 1
					END
			    ELSE
			        BEGIN--IRM=NULL或IRM=DNF,则都是含有项目名次，这些名次都是由阶段名次计算得到			        
			        IF @Rank <> @SaveRank SET @NewRank = @NewRank + 1					
					Update TS_Event_Result SET [F_EventRank] = @NewRank,[F_EventDisplayPosition] = @NewDisPos, [F_IRMID] = @IRMID
					WHERE F_EventID = @EventID AND [F_RegisterID] = @RegisterID
					END
			ELSE
			    IF @PhaseIdx=3
			   		BEGIN--在Heats中，IRM=DNS或IRM=DSQ-R,则是没有阶段名次，也没有项目名次，重新设置显示顺序
					Update TS_Event_Result SET [F_EventRank] = NULL,[F_EventDisplayPosition] = @NewDisPos1, [F_IRMID] = @IRMID
					WHERE F_EventID = @EventID AND [F_RegisterID] = @RegisterID
					SET @NewDisPos1 = @NewDisPos1 + 1
					END
                ELSE
                    BEGIN--在Semifinal,Final中，IRM=DNS或IRM=DSQ-R,则是没有阶段名次，但有项目名次
			        IF @SaveRank IS NOT NULL SET @NewRank = @NewRank + 1					                    
				    Update TS_Event_Result SET [F_EventRank] = @NewRank,[F_EventDisplayPosition] = @NewDisPos, [F_IRMID] = @IRMID
				    WHERE F_EventID = @EventID AND [F_RegisterID] = @RegisterID	
				    END					
			
			SET @DisPos = @DisPos + 1
			SET @NewDisPos = @NewDisPos + 1
			SET @SaveRank = @Rank
           END		
		   
		SET @PhaseIdx = @PhaseIdx + 1
	END 

    --重新还原没有项目名次的人员的显示顺序
    --@NewDisPos1相关优先顺序
    SET @MaxDisPos = (SELECT MAX(case when F_EventDisplayPosition IS null then 0 else F_EventDisplayPosition end) FROM TS_Event_Result 
    WHERE f_eventid = @EventID and [F_EventDisplayPosition] <= 10000)
	Update TS_Event_Result SET [F_EventDisplayPosition] = [F_EventDisplayPosition] - 10000 + @MaxDisPos
	WHERE F_EventID = @EventID AND [F_EventDisplayPosition] > 10000 AND [F_EventDisplayPosition] < 20000				
    --@NewDisPos2
    SET @MaxDisPos = (SELECT MAX(case when F_EventDisplayPosition IS null then 0 else F_EventDisplayPosition end) FROM TS_Event_Result 
    WHERE f_eventid = @EventID and [F_EventDisplayPosition] <= 20000)
	Update TS_Event_Result SET [F_EventDisplayPosition] = [F_EventDisplayPosition] - 20000 + @MaxDisPos
	WHERE F_EventID = @EventID AND [F_EventDisplayPosition] > 20000				
    
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
exec Proc_SL_UpdateEventResult 4,null

select i.f_inscriptionnum,er.f_eventrank,er.f_eventdiplayposition,(case when ii.f_irmcode is not null then ii.f_irmcode else '' end) as f_irmcode,
er.f_eventid,er.f_eventresultnumber,er.f_registerid from TS_Event_Result as er 
left join tr_register as r on er.f_registerid = r.f_registerid 
left join tr_inscription as i on r.f_registerid = i.f_registerid and i.f_eventid = 1
left join tc_irm as ii on ii.f_irmid = er.f_irmid
where er.F_EventID = 4 order by f_eventdiplayposition

delete TS_Event_Result where F_EventID = 4
*/



