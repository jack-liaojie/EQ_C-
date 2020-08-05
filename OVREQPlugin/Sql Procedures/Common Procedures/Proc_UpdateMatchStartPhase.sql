if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchStartPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchStartPhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateMatchStartPhase]
----��		  �ܣ�����StartPhase
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-19

CREATE PROCEDURE [dbo].[Proc_UpdateMatchStartPhase] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@StartPhaseID				INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���

	IF @StartPhaseID = -1 OR @StartPhaseID = 0
	BEGIN
		SET @StartPhaseID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Match_Result SET F_StartPhaseID = @StartPhaseID 
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
