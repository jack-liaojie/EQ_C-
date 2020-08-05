IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CreateSingleEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CreateSingleEventResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_CreateSingleEventResult]
----功		  能：计算单打赛比赛的最终排名
----作		  者： 张翠霞
----日		  期: 2010-10-12

CREATE PROCEDURE [dbo].[Proc_GF_CreateSingleEventResult] (	
	@MatchID				INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！ 
								  
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	--存储个人赛奖牌信息
	DECLARE @n INT
	DECLARE @MaxPos INT
	DECLARE @EventID	        INT
	DECLARE @RegisterID	        INT
	DECLARE @EventResultNumber	        INT
	
	select @EventID = p.F_EventID from TS_Match as m left join TS_Phase as p on m.F_PhaseID = p.F_PhaseID
	where m.F_MatchID = @MatchID 
	
    delete from TS_Event_Result where F_EventID = @EventID
	
	set @n = 1
	select @MaxPos = max(F_DisplayPosition) from TS_Match_Result where f_matchid = @matchid and F_DisplayPosition is not null

	while @n < @MaxPos and @n < 4
	begin
	    select @RegisterID = F_RegisterID from TS_Match_Result where f_matchid = @matchid and F_DisplayPosition = @n
	    if @RegisterID is null 
	        continue

		set @EventResultNumber = NULL
		SELECT @EventResultNumber = F_EventResultNumber FROM TS_Event_Result 
		WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID

		IF @EventResultNumber IS NULL
		BEGIN
			SELECT @EventResultNumber = max(F_EventResultNumber)+1 FROM TS_Event_Result 
			WHERE F_EventID = @EventID
		  
			IF @EventResultNumber IS NULL
				SET @EventResultNumber = 1

			INSERT INTO TS_Event_Result(F_EventID,F_EventResultNumber,F_RegisterID) 
			VALUES( @EventID,@EventResultNumber,@RegisterID )
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END			
		END
		
		UPDATE TS_Event_Result SET F_EventPointsCharDes3 = T.F_PointsCharDes3,F_EventPointsCharDes4 = T.F_PointsCharDes4, 
		F_IRMID = T.F_IRMID,
		F_EventRank = T.F_Rank, F_EventDisplayPosition = T.F_DisplayPosition
		FROM TS_Event_Result AS ER LEFT JOIN TS_Match_Result AS T ON ER.F_RegisterID = T.F_RegisterID and T.F_MatchID = @MatchID
		WHERE F_EventID = @EventID AND F_EventResultNumber = @EventResultNumber
		
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
	
SET NOCOUNT OFF
END

GO



