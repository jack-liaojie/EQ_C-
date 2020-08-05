IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_LoadMatchModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_LoadMatchModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_LoadMatchModel]
--��    ��������Match�Ľ�������ģ��Ӧ�õ�����֮��
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��12��09��



CREATE PROCEDURE [dbo].[Proc_LoadMatchModel](
				@MatchID			INT,
				@MatchModelID		INT,
				@Result				AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result = 0; 	����Match�Ľ�������ģ��Ӧ�õ�����֮��ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	����Match�Ľ�������ģ��Ӧ�õ�����֮�гɹ���
					-- @Result = -1;	����Match�Ľ�������ģ��Ӧ�õ�����֮��ʧ�ܣ�Match״̬�Ѿ���Running, ��������д˲�����
					-- @Result = -2;	����Match�Ľ�������ģ��Ӧ�õ�����֮��ʧ�ܣ�@MatchModelID����Чֵ��


	IF EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchStatusID >= 50 AND F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Match SET F_UsingModelID = @MatchModelID WHERE F_MatchID = @MatchID
        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		UPDATE TS_Match_Result SET F_CompetitionPositionDes1 = B.F_CompetitionPositionDes1, F_CompetitionPositionDes2 = B.F_CompetitionPositionDes2,
			F_StartPhaseID = B.F_StartPhaseID, F_StartPhasePosition = B.F_StartPhasePosition, F_SourcePhaseID = B.F_SourcePhaseID, F_SourcePhaseRank = B.F_SourcePhaseRank,
			F_SourceMatchID = B.F_SourceMatchID, F_SourceMatchRank = B.F_SourceMatchRank, F_HistoryMatchID = B.F_HistoryMatchID, F_HistoryMatchRank = B.F_HistoryMatchRank, F_HistoryLevel = B.F_HistoryLevel,
			F_RegisterID = NULL FROM TS_Match_Result AS A LEFT JOIN TS_Match_Model_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition WHERE B.F_MatchID = @MatchID AND B.F_MatchModelID = @MatchModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END



		UPDATE TS_Match_Result_Des SET F_CompetitorSourceDes = B.F_CompetitorSourceDes, F_SouceProgressDes = B.F_SouceProgressDes, F_SouceProgressType = B.F_SouceProgressType, F_Comment = B.F_Comment
			FROM TS_Match_Result_Des AS A LEFT JOIN TS_Match_Model_Match_Result_Des AS B
				ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition AND A.F_LanguageCode = B.F_LanguageCode
					WHERE B.F_MatchID = @MatchID AND B.F_MatchModelID = @MatchModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

