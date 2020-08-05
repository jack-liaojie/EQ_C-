IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_DeleteMatchJudge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_DeleteMatchJudge]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_JU_DeleteMatchJudge]
--��    ��: �����ĿΪһ�� Match ɾ��һ������
--�� �� ��: �����
--��    ��: 2009��12��14��
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_DeleteMatchJudge]
	@MatchID						INT,
	@ServantNum						INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @Order					INT

	SELECT @Order = F_Order
	FROM TS_Match_Servant
	WHERE F_MatchID = @MatchID
		AND F_ServantNum = @ServantNum

	SET Implicit_Transactions off
	BEGIN TRANSACTION		-- �趨����

	DELETE TS_Match_Servant
	WHERE F_MatchID = @MatchID
		AND F_ServantNum = @ServantNum

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- ����ع�
		SET @Result = 0		-- ����ʧ��
		RETURN
	END

	UPDATE TS_Match_Servant
	SET F_Order = F_Order - 1 
	WHERE F_MatchID = @MatchID
		AND F_Order > @Order

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- ����ع�
		SET @Result = 0		-- ����ʧ��
		RETURN
	END

	COMMIT TRANSACTION		-- �ɹ��ύ����
	SET @Result = 1			-- ���³ɹ�
	RETURN

SET NOCOUNT OFF
END


/*

-- Just for test
DECLARE @Result	INT
EXEC [Proc_JU_DeleteMatchJudge] 1611, 1, @Result OUTPUT

*/