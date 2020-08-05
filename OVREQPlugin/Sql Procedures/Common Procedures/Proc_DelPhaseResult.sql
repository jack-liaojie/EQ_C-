IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelPhaseResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelPhaseResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_DelPhaseResult]
----��		  �ܣ�TS_Phase_Result��ɾ��һ����¼
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-14 

CREATE PROCEDURE [dbo].[Proc_DelPhaseResult]
    @PhaseID			INT,
    @PhaseResultNumber  INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ�ܣ���ʾû�����κβ�����
					  -- @Result = 1; 	ɾ���ɹ�
                      -- @Result = -1; 	ɾ��ʧ�ܣ���EventID������

    IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
    BEGIN
      SET @Result = -1
      RETURN
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_PhaseResultNumber = @PhaseResultNumber

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
SET ANSI_NULLS OFF
GO