IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelMatchModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelMatchModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_DelMatchModel]
--��    ����ɾ��һMatch�Ľ�������ģ��
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��12��10��



CREATE PROCEDURE [dbo].[Proc_DelMatchModel](
				@MatchID			INT,
				@MatchModelID		INT,
				@Result			AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result=0; 	ɾ����Phase�Ľ�������ģ��ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ����Phase�Ľ�������ģ�ͳɹ���

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_Match_Model_Match_Result_Des WHERE F_MatchID = @MatchID AND F_MatchModelID = @MatchModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result WHERE F_MatchID = @MatchID AND F_MatchModelID = @MatchModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Match_Model WHERE F_MatchID = @MatchID AND F_MatchModelID = @MatchModelID

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


GO

