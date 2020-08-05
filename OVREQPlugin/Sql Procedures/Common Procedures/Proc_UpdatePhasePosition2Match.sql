if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdatePhasePosition2Match]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdatePhasePosition2Match]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdatePhasePosition2Match]
----功		  能：将抽签好的签位人员指定到对应比赛之中
----作		  者：郑金勇 
----日		  期: 2009-09-09

CREATE PROCEDURE [DBO].[Proc_UpdatePhasePosition2Match] 
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
	@Result 					AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;	-- @Result = 0; 	更新比赛人员失败，表示没有作任何操作！
						-- @Result = 1; 	更新比赛人员成功！
						-- @Result = -1		有的比赛状态时开始，不允许重新进行对阵编排

	IF @NodeType = -1
	BEGIN

		IF EXISTS (SELECT A.F_MatchID FROM TS_Match AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID
								WHERE ISNULL(B.F_StartPhaseID, 0) = 0 AND ISNULL(B.F_StartPhasePosition, 0) != 0 AND A.F_MatchStatusID > 30 AND C.F_EventID = @EventID) 
		BEGIN
			SET @Result = -1;
			RETURN
		END

	    SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务
		
			UPDATE A SET A.F_RegisterID = -1 FROM TS_Match_Result AS A LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID LEFT JOIN TS_Phase AS D ON C.F_PhaseID = D.F_PhaseID
				WHERE ISNULL(A.F_StartPhaseID, 0)  = 0 AND ISNULL(A.F_StartPhasePosition, 0) != 0 AND D.F_EventID = @EventID
		
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		
			UPDATE TS_Match_Result SET F_RegisterID = B.F_RegisterID FROM TS_Match_Result AS A LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID LEFT JOIN TS_Phase AS D ON C.F_PhaseID = D.F_PhaseID
				INNER JOIN TS_Event_Position AS B ON D.F_EventID = B.F_EventID AND A.F_StartPhasePosition = B.F_EventPosition 
				WHERE ISNULL(A.F_StartPhaseID, 0) = 0  AND ISNULL(A.F_StartPhasePosition, 0) != 0 AND D.F_EventID = @EventID
				
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			
		COMMIT TRANSACTION --成功提交事务
			
		SET @Result = 1;
		
	END
	ELSE
	IF @NodeType = 0
	BEGIN


		IF EXISTS (SELECT A.F_MatchID FROM TS_Match AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
						WHERE B.F_StartPhaseID = @PhaseID AND ISNULL(B.F_StartPhasePosition, 0) != 0 AND A.F_MatchStatusID > 30)
		BEGIN
			SET @Result = -1;
			RETURN
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务
		
			UPDATE TS_Match_Result SET F_RegisterID = -1 WHERE F_StartPhaseID = @PhaseID AND ISNULL(F_StartPhasePosition, 0) != 0
		    IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			
			UPDATE TS_Match_Result SET F_RegisterID = B.F_RegisterID FROM TS_Match_Result AS A INNER JOIN TS_Phase_Position AS B ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
				WHERE A.F_StartPhaseID = @PhaseID AND ISNULL(A.F_StartPhasePosition, 0) != 0
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			
		COMMIT TRANSACTION --成功提交事务
		SET @Result = 1;
		
	END
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*

DECLARE @Result AS INT
EXEC Proc_UpdatePhasePosition2Match 377, @Result OUTPUT
SELECT @Result
*/