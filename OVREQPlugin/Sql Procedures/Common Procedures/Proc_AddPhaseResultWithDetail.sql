IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddPhaseResultWithDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddPhaseResultWithDetail]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_AddPhaseResultWithDetail]
----��		  �ܣ�TS_Phase_Result�����һ����¼
----��		  �ߣ�֣���� 
----��		  ��: 2009-09-09 

CREATE PROCEDURE [dbo].[Proc_AddPhaseResultWithDetail]
    @PhaseID				INT,
	@PhaseRank			    INT,
	@SourcePhaseID		    INT,
	@SourcePhaseRank		INT, 
	@SourceMatchID		    INT, 
	@SourceMatchRank		INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	���ʧ�ܣ���ʾû�����κβ�����
					  -- @Result >= 1; 	��ӳɹ�,����PhaseResultID
                      -- @Result = -1; 	���ʧ�ܣ���PhaseID������

    IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
    BEGIN
      SET @Result = -1
      RETURN
    END

	DECLARE @PhaseResultID AS INT
    SELECT @PhaseResultID = (CASE WHEN MAX(F_PhaseResultNumber) IS NULL THEN 0 ELSE MAX(F_PhaseResultNumber) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID


	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		
		INSERT INTO TS_Phase_Result (F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank) 
			VALUES (@PhaseID, @PhaseResultID, @PhaseRank, @SourcePhaseID, @SourcePhaseRank, @SourceMatchID, @SourceMatchRank)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @PhaseResultID
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO