IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_UpdateMatchOrderInRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_UpdateMatchOrderInRound]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_UpdateMatchOrderInRound]
--��    ��: ����ָ��һ��������Round�е�˳��, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��



CREATE PROCEDURE [dbo].[Proc_Schedule_UpdateMatchOrderInRound]
	@MatchID				INT,
	@OrderInRound			INT,
	@Result					AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;	--@Result = 0;	����ʧ�ܣ���ʾû�����κβ�����
						--@Result = 1;	���³ɹ�  
						--@Result = -1; ����ʧ�ܣ�@MatchID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	UPDATE TS_Match SET F_OrderInRound = @OrderInRound
	WHERE F_MatchID = @MatchID

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = 1

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO