IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TT_CrossPairInscription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TT_CrossPairInscription]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TT_CrossPairInscription]
----功		  能：处理跨国组合的报项
----作		  者：王强
----日		  期: 2011-6-9

CREATE PROCEDURE [dbo].[Proc_TT_CrossPairInscription] 
			@RegPairID INT,
			@BAdd INT,
			@Result INT OUTPUT
			-- 1为成功，0为失败
	
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @SexCode INT
	SELECT @SexCode = F_SexCode FROM TR_Register WHERE F_RegisterID = @RegPairID
	IF @SexCode IS NULL
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	DECLARE @EventID INT
	SELECT @EventID = A.F_EventID FROM TS_Event AS A 
	WHERE A.F_PlayerRegTypeID = 2 AND A.F_SexCode = @SexCode
	
	IF @BAdd = 0
	BEGIN
		DELETE FROM TR_Inscription WHERE F_RegisterID = @RegPairID
		SET @Result = 1
		RETURN
	END
	ELSE IF @BAdd = 1
	BEGIN
		IF EXISTS (SELECT F_EventID FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID = @RegPairID)
		BEGIN
			SET @Result = 1
			RETURN
		END
		ELSE
		BEGIN
			INSERT INTO TR_Inscription (F_EventID, F_RegisterID, F_Seed) VALUES(@EventID, @RegPairID, NULL)
			SET @Result = 1
			RETURN
		END
	END
	ELSE
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	SET @Result = 0
SET NOCOUNT OFF
END

GO

