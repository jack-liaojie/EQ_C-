IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddPhasePosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddPhasePosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----�洢�������ƣ�[proc_AddPhasePosition]
----��		  �ܣ�Ϊ����ģ�ͷ������һ�����½׶ε�ǩλ��Ϣ
----��		  �ߣ��Ŵ�ϼ 
----��		  ��: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_AddPhasePosition]
	@PhaseID				INT,
	@PhasePosition		    INT,
	@StartPhaseID		    INT, 
	@StartPhasePosition		INT,
	@SourcePhaseID		    INT,
	@SourcePhaseRank		INT, 
	@SourceMatchID		    INT, 
	@SourceMatchRank		INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	���λ��ʧ�ܣ���ʾû�����κβ�����
					  -- @Result>=1; 	���λ�óɹ���Ϊ�µ�F_ItemID

	

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_Phase_Position (F_PhaseID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank) 
			VALUES (@PhaseID, @PhasePosition, @StartPhaseID, @StartPhasePosition, @SourcePhaseID, @SourcePhaseRank, @SourceMatchID, @SourceMatchRank)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		SET @Result = @@IDENTITY

	COMMIT TRANSACTION --�ɹ��ύ����

	RETURN

SET NOCOUNT OFF
END

GO



