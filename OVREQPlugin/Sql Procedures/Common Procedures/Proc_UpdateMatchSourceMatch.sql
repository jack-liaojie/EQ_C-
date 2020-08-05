if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchSourceMatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchSourceMatch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateMatchSourceMatch]
----��		  �ܣ�����SouceMatch
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-19

CREATE PROCEDURE [dbo].[Proc_UpdateMatchSourceMatch] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@SourceMatchID				INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���

	IF @SourceMatchID = -1 OR @SourceMatchID = 0
	BEGIN
		SET @SourceMatchID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Match_Result SET F_SourceMatchID = @SourceMatchID 
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

