IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SaveMatchModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SaveMatchModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_SaveMatchModel]
--��    �����洢��Match�Ľ�������ģ��
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��12��09��



CREATE PROCEDURE [dbo].[Proc_SaveMatchModel](
				@MatchID			INT,
				@MatchModelName		NVARCHAR(100),
				@MatchModelComment	NVARCHAR(200),
				@Order				INT = 0,
				@Result				AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result=0; 	�洢��Match�Ľ�������ģ��ʧ�ܣ���ʾû�����κβ�����
					-- @Result>0; 	�洢��Match�Ľ�������ģ�ͳɹ����˼�Ϊ@MatchModelID

	DECLARE @MatchModelID AS INT
	SELECT @MatchModelID = CASE WHEN MAX(F_MatchModelID) IS NULL THEN 1 ELSE MAX(F_MatchModelID) + 1 END FROM TS_Match_Model WHERE F_MatchID = @MatchID
	IF (@Order = 0)
	BEGIN
		SELECT @Order = ISNULL(MAX(F_Order), 0) + 1 FROM TS_Match_Model	WHERE F_MatchID = @MatchID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_Match_Model (F_MatchID, F_MatchModelID, F_Order, F_MatchModelName, F_MatchModelComment) 
			VALUES (@MatchID, @MatchModelID, @Order, @MatchModelName, @MatchModelComment) 

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END
		
		UPDATE TS_Match SET F_UsingModelID = @MatchModelID WHERE F_MatchID = @MatchID
        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END
		
		INSERT INTO TS_Match_Model_Match_Result(F_MatchID, F_MatchModelID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2,
				F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT @MatchID AS F_MatchID, @MatchModelID AS F_MatchModelID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2,
				F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel
				FROM TS_Match_Result WHERE F_MatchID = @MatchID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		INSERT INTO TS_Match_Model_Match_Result_Des(F_MatchID, F_MatchModelID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @MatchID AS F_MatchID, @MatchModelID AS F_MatchModelID, F_CompetitionPosition, F_LanguageCode, F_SouceProgressDes, F_SouceProgressType, F_CompetitorSourceDes, F_Comment
				FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @MatchModelID
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

