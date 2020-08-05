IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchJudge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchJudge]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_WR_UpdateMatchJudge]
--��    ��: �����ĿΪһ�� Match ����һ�����е���Ϣ  
--�� �� ��: �����
--��    ��: 2010��11��8�� ����һ
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchJudge]
	@MatchID						INT,
	@ServantNum						INT,
	@RegisterID						INT,
	@FunctionID						INT,
	@Order							INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	DECLARE @OldOrder				INT

	SELECT @OldOrder = F_Order
	FROM TS_Match_Servant
	WHERE F_MatchID = @MatchID
		AND F_ServantNum = @ServantNum

	SET Implicit_Transactions off
	BEGIN TRANSACTION		-- �趨����

	IF @RegisterID IS NOT NULL
	BEGIN
		UPDATE TS_Match_Servant
		SET F_RegisterID = @RegisterID
			, F_FunctionID = @FunctionID
		WHERE F_MatchID = @MatchID
			AND F_ServantNum = @ServantNum
	END

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- ����ع�
		SET @Result = 0		-- ����ʧ��
		RETURN
	END

	IF @FunctionID IS NOT NULL
	BEGIN
		UPDATE TS_Match_Servant
		SET F_FunctionID = @FunctionID
		WHERE F_MatchID = @MatchID
			AND F_ServantNum = @ServantNum
	END

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- ����ع�
		SET @Result = 0		-- ����ʧ��
		RETURN
	END

	IF @Order IS NOT NULL
	BEGIN
		UPDATE TS_Match_Servant
		SET F_Order = @Order
		WHERE F_MatchID = @MatchID
			AND F_ServantNum = @ServantNum

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- ����ع�
			SET @Result = 0		-- ����ʧ��
			RETURN
		END

		UPDATE TS_Match_Servant
		SET F_Order = @OldOrder
		WHERE F_MatchID = @MatchID
			AND F_Order = @Order
			AND F_ServantNum <> @ServantNum

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- ����ع�
			SET @Result = 0		-- ����ʧ��
			RETURN
		END
	END

	COMMIT TRANSACTION		-- �ɹ��ύ����
	SET @Result = 1			-- ���³ɹ�
	RETURN

SET NOCOUNT OFF
END


/*

-- Just for test
DECLARE @Result	INT
EXEC [Proc_JU_UpdateMatchJudge] 1611, 1, 1065, 104, NULL, @Result OUTPUT

*/