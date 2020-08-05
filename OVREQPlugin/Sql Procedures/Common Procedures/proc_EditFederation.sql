IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditFederation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditFederation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[proc_AddFederation]
----��		  �ܣ��༭Federation
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_EditFederation]
	@FederationID			INT,
    @FederationCode			NVARCHAR(10),
    @LanguageCode			CHAR(3),
	@FederationLongName		NVARCHAR(50),
	@FederationShortName	NVARCHAR(50),
	@FederationComment		NVARCHAR(50),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	�༭Federationʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	�༭Federation�ɹ�����ֵ��ΪFederationID
					  -- @Result=-1;	�༭Federationʧ�ܣ�@FederationID��Ч��
					  -- @Result=-2;	�༭Federationʧ�ܣ�@FederationCode�ظ���

	IF NOT EXISTS(SELECT F_FederationID FROM TC_Federation WHERE F_FederationID = @FederationID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF EXISTS(SELECT F_FederationID FROM TC_Federation WHERE F_FederationCode = @FederationCode AND F_FederationID <> @FederationID)
	BEGIN
			SET @Result = -2
			RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TC_Federation SET F_FederationCode = @FederationCode WHERE F_FederationID = @FederationID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		IF NOT EXISTS(SELECT F_FederationID FROM TC_Federation_Des WHERE F_FederationID = @FederationID AND F_LanguageCode = @LanguageCode)
		BEGIN
			INSERT INTO TC_Federation_Des (F_FederationID, F_LanguageCode, F_FederationLongName, F_FederationShortName, F_FederationComment) VALUES(@FederationID, @LanguageCode, @FederationLongName, @FederationShortName, @FederationComment)

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TC_Federation_Des SET  F_FederationLongName = @FederationLongName, F_FederationShortName = @FederationShortName, F_FederationComment = @FederationComment
				WHERE F_FederationID = @FederationID AND F_LanguageCode = @LanguageCode

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

