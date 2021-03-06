/****** Object:  StoredProcedure [dbo].[proc_DelAllInsription]    Script Date: 12/17/2009 15:01:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelAllInsription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelAllInsription]
GO
/****** Object:  StoredProcedure [dbo].[proc_DelAllInsription]    Script Date: 12/17/2009 14:59:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：proc_DelAllInsription
----功		  能：删除一个注册队员的所有报项信息
----作		  者：李燕
----日		  期: 2009-04-08 

CREATE PROCEDURE [dbo].[proc_DelAllInsription] 
	@RegisterID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Register失败，标示没有做任何操作！
					-- @Result=1; 	删除Register成功！
					-- @Result=-1; 	删除Register失败，该@RegisterID无效
					-- @Result=-2; 	删除Register失败，该@RegisterID的有参加的比赛，不允许删除


	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	

	IF EXISTS(SELECT F_RegisterID FROM TS_Event_Result WHERE F_RegisterID = @RegisterID AND F_EventID IN(SELECT F_EventID FROM TR_Inscription WHERE F_RegisterID = @RegisterID))
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Result AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID  WHERE A.F_RegisterID = @RegisterID AND B.F_EventID IN(SELECT F_EventID FROM TR_Inscription WHERE F_RegisterID = @RegisterID))
	BEGIN
		SET @Result = -2
		RETURN
	END

    IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Competitors AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID  WHERE A.F_RegisterID = @RegisterID AND B.F_EventID IN(SELECT F_EventID FROM TR_Inscription WHERE F_RegisterID = @RegisterID))
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Match_Result AS A LEFT JOIN  TS_Match AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID WHERE C.F_EventID IN(SELECT F_EventID FROM TR_Inscription WHERE F_RegisterID = @RegisterID) AND F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TR_Inscription WHERE F_RegisterID = @RegisterID 
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

set ANSI_NULLS OFF
set QUOTED_IDENTIFIER OFF
