if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_EditEvent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_EditEvent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�proc_EditEvent
----��		  �ܣ��༭һ��Event����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-09 

CREATE PROCEDURE [dbo].[proc_EditEvent] 
	@EventID			INT,
	@DisciplineID		INT,
	@EventCode			NVARCHAR(10),
	@OpenDate			DATETIME,
	@CloseDate			DATETIME,
	@Order				INT,
	@SexCode			INT,
	@PlayerRegTypeID	INT,
	@EventInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@EventLongName		NVARCHAR(100),
	@EventShortName		NVARCHAR(50),
	@EventComment		NVARCHAR(100),
	@CompetitionType	INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	���Eventʧ�ܣ���ʾû�����κβ�����
					-- @Result>=1; 	���Event�ɹ�����ֵ��ΪEventID
					-- @Result=-1; 	���Eventʧ�ܣ�@DisciplineID��Ч

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Event SET F_DisciplineID = @DisciplineID, F_EventCode = @EventCode, F_OpenDate = @OpenDate,
							F_SexCode = @SexCode, F_CloseDate = @CloseDate, F_Order = @Order, F_EventInfo = @EventInfo,
							F_PlayerRegTypeID = @PlayerRegTypeID, F_CompetitionTypeID = @CompetitionType
				WHERE F_EventID = @EventID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		IF NOT EXISTS (SELECT F_EventID FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @languageCode)
		BEGIN
			insert into TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName, F_EventComment)
				VALUES (@EventID, @languageCode, @EventLongName, @EventShortName, @EventComment)

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Event_Des SET F_EventLongName = @EventLongName, F_EventShortName = @EventShortName, F_EventComment = @EventComment
				WHERE F_EventID = @EventID AND F_LanguageCode = @languageCode

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

