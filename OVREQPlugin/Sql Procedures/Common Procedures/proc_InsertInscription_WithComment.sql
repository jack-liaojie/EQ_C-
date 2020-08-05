

/****** Object:  StoredProcedure [dbo].[proc_InsertInscription_WithComment]    Script Date: 01/20/2011 18:00:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_InsertInscription_WithComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_InsertInscription_WithComment]
GO



/****** Object:  StoredProcedure [dbo].[proc_InsertInscription_WithComment]    Script Date: 01/20/2011 18:00:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�proc_InsertInscription_WithComment
----��		  �ܣ�ע����Ա����(������ɼ�������)
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-17

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

	SET @Result=0;  -- @Result=0; 	ע����Ա����ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ע����Ա����ɹ���
					-- @Result=-1; 	ע����Ա����ʧ�ܣ�@EventID��Ч��@RegisterID��Ч
					-- @Result=-2; 	ע����Ա����ʧ�ܣ��Ѿ�ע����ˣ�

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
	BEGIN TRANSACTION --�趨����

		INSERT INTO TR_Inscription (F_RegisterID, F_EventID, F_Seed, F_InscriptionRank, F_InscriptionResult, F_InscriptionComment)
			VALUES (@RegisterID, @EventID, @Seed, @InscriptionRank, @InscriptionResult, @NOCRank)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END


--		INSERT INTO TR_Inscription (F_RegisterID, F_EventID)
--			SELECT DISTINCT F_MemberRegisterID AS F_RegisterID, F_EventID FROM #Temp_Register_Member
--				 WHERE F_Exists = 0
--
--		IF @@error<>0  --����ʧ�ܷ���  
--		BEGIN 
--			ROLLBACK   --����ع�
--			SET @Result=0
--			RETURN
--		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END





GO


