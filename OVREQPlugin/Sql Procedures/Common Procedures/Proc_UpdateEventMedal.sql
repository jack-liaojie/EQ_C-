if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateEventMedal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateEventMedal]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateEventMedal]
----��		  �ܣ��޸�EventResult�еĻ����
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-06 

CREATE PROCEDURE [dbo].[Proc_UpdateEventMedal] 
	@EventID			INT,
	@Position			INT,
	@MedalID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	�޸�EventResult�еĻ�ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	�޸�EventResult�еĻ񽱳ɹ���
					-- @Result=-1; 	�޸�EventResult�еĻ�ʧ�ܣ�@EventID��Ч,@Position ��Ч
					-- @Result=-2; 	�޸�EventResult�еĻ�ʧ�ܣ���Event��״̬�������޸�

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event_Result WHERE F_EventID = @EventID AND F_EventResultNumber = @Position)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @MedalID = -1
	BEGIN
		SET @MedalID = NULL 
	END

	UPDATE TS_Event_Result SET F_MedalID = @MedalID WHERE F_EventID = @EventID AND F_EventResultNumber = @Position
	IF @@error<>0   
	BEGIN 
		SET @Result=0
		RETURN
	END

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

