IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CreateTeamEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CreateTeamEventResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GF_CreateTeamEventResult]
----功		  能：计算团体比赛的最终排名
----作		  者： 张翠霞
----日		  期: 2010-10-12

CREATE PROCEDURE [dbo].[Proc_GF_CreateTeamEventResult] (	
	@MatchID				INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
					   
	DECLARE @SexCode AS INT
	DECLARE @IndiEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @TeamEventID AS INT
    DECLARE @TeamMatchID AS INT
    
    SELECT @SexCode = E.F_SexCode, @IndiEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
    
    SELECT TOP 1 @TeamMatchID = F_MatchID FROM TS_Match AS M
    LEFT JOIN TS_Phase AS P ON M.f_Phaseid = P.f_phaseid 
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE E.F_SexCode = @SexCode AND E.F_PlayerRegTypeID = 3 
    AND E.F_EventID = @TeamEventID AND P.F_Order = @PhaseOrder
					   
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
                       
	--存储团体赛奖牌信息
	DECLARE @n INT
	DECLARE @MaxPos INT
	DECLARE @RegisterID	        INT
	DECLARE @EventResultNumber	        INT

    delete from TS_Event_Result where F_EventID = @TeamEventID
	
	set @n = 1
	select @MaxPos = max(F_DisplayPosition) from TS_Match_Result where f_matchid = @TeamMatchID and F_DisplayPosition is not null
    
	while @n < @MaxPos and @n < 4 
	begin
	    select @RegisterID = F_RegisterID from TS_Match_Result where f_matchid = @TeamMatchID and F_DisplayPosition = @n
	    if @RegisterID is null 
	        continue

		set @EventResultNumber = NULL
		SELECT @EventResultNumber = F_EventResultNumber FROM TS_Event_Result 
		WHERE F_EventID = @TeamEventID AND F_RegisterID = @RegisterID

		IF @EventResultNumber IS NULL
		BEGIN
			SELECT @EventResultNumber = max(F_EventResultNumber)+1 FROM TS_Event_Result 
			WHERE F_EventID = @TeamEventID
		  
			IF @EventResultNumber IS NULL
				SET @EventResultNumber = 1

			INSERT INTO TS_Event_Result(F_EventID,F_EventResultNumber,F_RegisterID) 
			VALUES( @TeamEventID,@EventResultNumber,@RegisterID )
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END			
		END
		
		UPDATE TS_Event_Result SET F_EventPointsCharDes3 = T.F_PointsCharDes3,F_EventPointsCharDes4 = T.F_PointsCharDes4, 
		F_IRMID = T.F_IRMID, F_EventRank = T.F_Rank, F_EventDisplayPosition = T.F_DisplayPosition
		FROM TS_Event_Result AS ER LEFT JOIN TS_Match_Result AS T ON ER.F_RegisterID = T.F_RegisterID and T.F_MatchID = @TeamMatchID
		WHERE F_EventID = @TeamEventID AND F_EventResultNumber = @EventResultNumber
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
	    set @n = @n + 1
	end

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN
    
Set NOCOUNT OFF
End	

GO




