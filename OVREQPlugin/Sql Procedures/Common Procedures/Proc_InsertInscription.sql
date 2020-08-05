if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_InsertInscription]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_InsertInscription]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_InsertInscription
----功		  能：注册人员报项
----作		  者：郑金勇 
----日		  期: 2009-04-17

CREATE PROCEDURE proc_InsertInscription 
	@EventID			INT,
	@RegisterID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	注册人员报项失败，标示没有做任何操作！
					-- @Result=1; 	注册人员报项成功！
					-- @Result=-1; 	注册人员报项失败，@EventID无效、@RegisterID无效
					-- @Result=-2; 	注册人员报项失败，已经注册过了！

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
--	CREATE TABLE #Temp_Register_Member(
--										F_Exists				INT,
--										F_EventID				INT,
--										F_RegisterID			INT,
--										F_MemberRegisterID		INT,
--										F_NodeLevel				INT
--									   )
--
--	INSERT INTO #Temp_Register_Member (F_EventID, F_RegisterID, F_MemberRegisterID, F_NodeLevel)
--			SELECT @EventID AS F_EventID, F_RegisterID, F_MemberRegisterID, 0 AS F_NodeLevel
--				FROM TR_Register_Member WHERE F_RegisterID = @RegisterID
--
--
--	DECLARE @NodeLevel AS INT
--	SET @NodeLevel = 0
--	WHILE EXISTS( SELECT F_RegisterID FROM #Temp_Register_Member WHERE F_NodeLevel = 0 )
--	BEGIN
--		SET @NodeLevel = @NodeLevel + 1
--		UPDATE #Temp_Register_Member SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
--		
--		INSERT INTO #Temp_Register_Member (F_EventID, F_RegisterID, F_MemberRegisterID, F_NodeLevel)
--			SELECT @EventID AS F_EventID, A.F_RegisterID, A.F_MemberRegisterID, 0 AS F_NodeLevel
--				FROM TR_Register_Member AS A LEFT JOIN #Temp_Register_Member AS B 
--					ON A.F_RegisterID = B.F_MemberRegisterID WHERE B.F_NodeLevel = @NodeLevel
--	END
--	
--	UPDATE #Temp_Register_Member SET F_Exists = 0
--	UPDATE #Temp_Register_Member SET F_Exists = 1 FROM #Temp_Register_Member AS A LEFT JOIN TR_Inscription AS B
--		ON A.F_MemberRegisterID = B.F_RegisterID AND A.F_EventID = B.F_EventID WHERE B.F_EventID IS NOT NULL


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Inscription (F_RegisterID, F_EventID, F_Seed)
			VALUES (@RegisterID, @EventID, NULL)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


--		INSERT INTO TR_Inscription (F_RegisterID, F_EventID)
--			SELECT DISTINCT F_MemberRegisterID AS F_RegisterID, F_EventID FROM #Temp_Register_Member
--				 WHERE F_Exists = 0
--
--		IF @@error<>0  --事务失败返回  
--		BEGIN 
--			ROLLBACK   --事务回滚
--			SET @Result=0
--			RETURN
--		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--declare @Ret as int
--
--exec proc_InsertInscription 17,45, @Ret output
--select @Ret