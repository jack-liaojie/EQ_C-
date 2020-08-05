if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchSourcePhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchSourcePhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateMatchSourcePhase]
----��		  �ܣ�����SoucePhase
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-19

CREATE PROCEDURE [dbo].[Proc_UpdateMatchSourcePhase] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@SourcePhaseID				INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���

	IF @SourcePhaseID = -1 OR @SourcePhaseID = 0
	BEGIN
		SET @SourcePhaseID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Match_Result SET F_SourcePhaseID = @SourcePhaseID 
					WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
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
