

/****** Object:  StoredProcedure [dbo].[proc_InsertInscription_WithComment]    Script Date: 01/20/2011 18:00:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_InsertInscription_WithComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_InsertInscription_WithComment]
GO



/****** Object:  StoredProcedure [dbo].[proc_InsertInscription_WithComment]    Script Date: 01/20/2011 18:00:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_InsertInscription_WithComment
----功		  能：注册人员报项(含报项成绩等属性)
----作		  者：郑金勇 
----日		  期: 2009-04-17

CREATE PROCEDURE [dbo].[proc_InsertInscription_WithComment] 
	@EventID			   INT,
	@RegisterID			   INT,
	@InscriptionResult     NVARCHAR(100),   
	@InscriptionRank       INT,
	@NOCRank               NVARCHAR(100),
	@Seed                  INT, 
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
	

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Inscription (F_RegisterID, F_EventID, F_Seed, F_InscriptionRank, F_InscriptionResult, F_InscriptionComment)
			VALUES (@RegisterID, @EventID, @Seed, @InscriptionRank, @InscriptionResult, @NOCRank)

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


