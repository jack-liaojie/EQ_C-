if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddEvent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddEvent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�proc_AddEvent
----��		  �ܣ����һ��Event����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-09 

CREATE PROCEDURE proc_AddEvent 
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
	DECLARE @NewEventID AS INT	

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Event WHERE F_DisciplineID = @DisciplineID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_Event (F_DisciplineID, F_EventCode, F_OpenDate, F_CloseDate, F_Order, F_SexCode, F_EventInfo, F_PlayerRegTypeID, F_CompetitionTypeID)
			VALUES (@DisciplineID, @EventCode, @OpenDate, @CloseDate, @Order, @SexCode, @EventInfo, @PlayerRegTypeID, @CompetitionType)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		SET @NewEventID = @@IDENTITY

		insert into TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName, F_EventComment)
			VALUES (@NewEventID, @languageCode, @EventLongName, @EventShortName, @EventComment)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @NewEventID
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

