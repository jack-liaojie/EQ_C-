IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddPhaseResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddPhaseResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_AddPhaseResult]
----��		  �ܣ�TS_Phase_Result�����һ����¼
----��		  �ߣ�֣���� 
----��		  ��: 2009-09-03 

CREATE PROCEDURE [dbo].[Proc_AddPhaseResult]
    @PhaseID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	���ʧ�ܣ���ʾû�����κβ�����
					  -- @Result >= 1; 	��ӳɹ�,����@EventResultNumber
                      -- @Result = -1; 	���ʧ�ܣ���PhaseID������

    IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
    BEGIN
      SET @Result = -1
      RETURN
    END

	DECLARE @PhaseResultNumber AS INT
    SELECT @PhaseResultNumber = (CASE WHEN MAX(F_PhaseResultNumber) IS NULL THEN 0 ELSE MAX(F_PhaseResultNumber) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID

	DECLARE @PhaseRank AS INT
    SELECT @PhaseRank = (CASE WHEN MAX(F_PhaseRank) IS NULL THEN 0 ELSE MAX(F_PhaseRank) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID

	DECLARE @PhaseDiplayPosition AS INT
    SELECT @PhaseDiplayPosition = (CASE WHEN MAX(F_PhaseDisplayPosition) IS NULL THEN 0 ELSE MAX(F_PhaseDisplayPosition) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_Phase_Result (F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_PhaseDisplayPosition) VALUES (@PhaseID, @PhaseResultNumber, @PhaseRank, @PhaseDiplayPosition)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @PhaseResultNumber
	RETURN

SET NOCOUNT OFF
END
