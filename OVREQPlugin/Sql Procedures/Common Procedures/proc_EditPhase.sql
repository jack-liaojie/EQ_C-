if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_EditPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_EditPhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[proc_EditPhase]
----��		  �ܣ��༭һ��Phse����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-08

CREATE PROCEDURE [dbo].[proc_EditPhase] 
	@PhaseID			INT,
	@EventID			INT,
	@FatherPhaseID		INT,
	@PhaseCode			NVARCHAR(10),
	@OpenDate			DATETIME,
	@CloseDate			DATETIME,
	@Order				INT,
	@IsPool				INT,
	@HasPools			INT,
	@StatusID			INT,
	@PhaseInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@PhaseLongName		NVARCHAR(100),
	@PhaseShortName		NVARCHAR(50),
	@PhaseComment		NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	�༭Phaseʧ�ܣ���ʾû�����κβ�����
					-- @Result=1;	�༭Phase�ɹ���
					-- @Result=-1; 	�༭Phaseʧ�ܣ�@PhaseID,@EventID,@FatherPhaseID��Ч

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @FatherPhaseID <> 0
	BEGIN
		IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID)
		BEGIN
			SET @Result = -1
			RETURN
		END
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Phase SET F_EventID = @EventID, F_FatherPhaseID = @FatherPhaseID, F_PhaseCode = @PhaseCode, F_OpenDate = @OpenDate,
							F_CloseDate = @CloseDate, F_Order = @Order, F_PhaseIsPool = @IsPool, F_PhaseHasPools = @HasPools, F_PhaseInfo = @PhaseInfo --, F_PhaseStatusID = @StatusID
				WHERE F_PhaseID = @PhaseID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END


		IF NOT EXISTS (SELECT F_PhaseID FROM TS_Phase_Des WHERE F_PhaseID = @PhaseID AND F_LanguageCode = @languageCode)
		BEGIN
			insert into TS_Phase_Des (F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment)
				VALUES (@PhaseID, @languageCode, @PhaseLongName, @PhaseShortName, @PhaseComment)

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Phase_Des SET F_PhaseLongName = @PhaseLongName, F_PhaseShortName = @PhaseShortName, F_PhaseComment = @PhaseComment
				WHERE F_PhaseID = @PhaseID AND F_LanguageCode = @languageCode

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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--exec proc_EditPhase 577, 34, 0 ,'asd', NULL, NULL, 0, 0, 0, 'PhaseInfo', 'CHN', '1', '2', '3', 0


