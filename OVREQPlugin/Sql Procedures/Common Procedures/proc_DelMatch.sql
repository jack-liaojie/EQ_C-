if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelMatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelMatch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�proc_DelMatch
----��		  �ܣ�ɾ��һ��Phase����ɾ����Phase�����е���Phase������ɾ�����е�Match����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-08 

CREATE PROCEDURE proc_DelMatch 
	@MatchID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ��Matchʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��Match�ɹ���
					-- @Result=-1; 	ɾ��Matchʧ�ܣ���MatchID��Ч
					-- @Result=-2; 	ɾ��Matchʧ�ܣ���Match��״̬������ɾ��
					-- @Result=-3; 	ɾ��Matchʧ�ܣ���Match�ĸ��ڵ��״̬�������Matchɾ��
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	DECLARE @MatchStatusID AS INT
	DECLARE @PhaseStatusID AS INT
	SELECT @MatchStatusID = A.F_MatchStatusID, @PhaseStatusID = B.F_PhaseStatusID FROM TS_Match AS A LEFT JOIN TS_Phase AS B 
		ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID
	
	IF @MatchStatusID > 10 
	BEGIN
		SET @Result = -2
		RETURN
	END 	

	IF @PhaseStatusID > 10 
	BEGIN
		SET @Result = -3
		RETURN
	END 

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����


		DELETE FROM TS_Phase_Model_Match_Result_Des WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Match_Result WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result_Des WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Match_Model_Match_Result WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Statistic WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Member WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Servant WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Des WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_MatchRank2PhaseRank WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TS_Result_Record WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TS_Match_Result WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Des WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Match_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Match_Result SET F_HistoryMatchID = NULL, F_HistoryMatchRank = NULL, F_HistoryLevel = NULL WHERE F_HistoryMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match_Model_Match_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match_Model_Match_Result SET F_HistoryMatchID = NULL, F_HistoryMatchRank = NULL, F_HistoryLevel = NULL WHERE F_HistoryMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END



		UPDATE TS_Phase_Model_Phase_Resut SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Phase_Position SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Position SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		

		UPDATE TS_Match_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Des WHERE F_MatchID = @MatchID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match WHERE F_MatchID = @MatchID 
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

--exec proc_DelMatch 2003, 0