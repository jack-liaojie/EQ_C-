IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_UpdateMatchIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_UpdateMatchIRM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_UpdateMatchIRM]
--��    ��: ����ָ��һ������һ�������ߵ� IRM ���, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��



CREATE PROCEDURE [dbo].[Proc_Schedule_UpdateMatchIRM]
	@MatchID				INT,
	@RegisterID				INT,
	@IRMID					INT,
	@Result					AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;	--@Result = 0;	����ʧ�ܣ���ʾû�����κβ�����
						--@Result = 1;	���³ɹ�  
						--@Result = -1; ����ʧ�ܣ�@MatchID, @RegisterID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	UPDATE TS_Match_Result SET F_IRMID = @IRMID
	WHERE F_matchID = @MatchID
		AND F_RegisterID = @RegisterID

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