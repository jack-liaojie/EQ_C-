if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelCompetitionPosition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelCompetitionPosition]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[proc_DelCompetitionPosition]
----��		  �ܣ�ɾ��һ��������λ��
----��		  �ߣ�֣���� 
----��		  ��: 2009-11-11 

CREATE PROCEDURE [dbo].[proc_DelCompetitionPosition] 
	@MatchID						INT,
	@CompetitionPosition			INT,
	@Result 						AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ��һ��������λ��ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��һ��������λ�óɹ���
					-- @Result=-1; 	ɾ��һ��������λ��ʧ�ܣ�@MatchID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition)
	BEGIN
		SET @Result = -1
		RETURN
	END
	 
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Phase_Model_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
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
/*
exec proc_DelCompetitionPosition 1075, 4, 1
*/