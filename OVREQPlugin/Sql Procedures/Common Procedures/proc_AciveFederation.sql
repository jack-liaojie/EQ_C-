IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AciveFederation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AciveFederation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[proc_AciveFederation]
----��		  �ܣ�����Federation
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_AciveFederation]
	@FederationID			INT,
	@DisciplineID			INT,
	@ActiveType				INT, --1��ʾ���0��ʾ�ر�
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	ɾ��Federationʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	ɾ��Federation�ɹ���
					  -- @Result=-1;	ɾ��Federationʧ�ܣ�@FederationID��Ч��
					  -- @Result=-2;	ɾ��Federationʧ�ܣ�@FederationID��ע����Ա���ã�������ر�

	IF NOT EXISTS(SELECT F_FederationID FROM TC_Federation WHERE F_FederationID = @FederationID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF @ActiveType = 0
	BEGIN
		IF EXISTS( SELECT F_RegisterID FROM TR_Register WHERE F_FederationID = @FederationID AND F_RegisterID IN 
					( SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID IN (SELECT F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID) ) )
		BEGIN
				SET @Result = -2
				RETURN
		END
		ELSE
		BEGIN
			DELETE FROM TS_ActiveFederation WHERE F_FederationID = @FederationID AND F_DisciplineID = @DisciplineID
		END
	END
	ELSE
	BEGIN
		IF @ActiveType = 1
		BEGIN
			IF NOT EXISTS (SELECT F_FederationID FROM TS_ActiveFederation WHERE F_FederationID = @FederationID AND F_DisciplineID = @DisciplineID)
			BEGIN
				INSERT INTO TS_ActiveFederation (F_FederationID, F_DisciplineID) VALUES (@FederationID, @DisciplineID)
			END
		END
	END

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

