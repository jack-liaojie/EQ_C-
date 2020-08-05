IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_DelCompetitionRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_DelCompetitionRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�[Proc_GF_DelCompetitionRule]
----��		  �ܣ�ɾ��һ����Ŀ��һ����������
----��		  �ߣ��Ŵ�ϼ
----��		  ��: 2010-09-27

CREATE PROCEDURE [dbo].[Proc_GF_DelCompetitionRule] (	
	@CompetitionRuleID					INT,
	@Result								INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result=0; 	ɾ����������ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ����������ɹ���
					-- @Result=-1; 	ɾ����������ʧ�ܣ���CompetitionRuleID��Ч
					-- @Result=-2; 	ɾ����������ʧ�ܣ��þ��������Ѿ��б�������,������ɾ��.
					
	
	IF NOT EXISTS(SELECT F_CompetitionRuleID FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
		DELETE FROM TD_CompetitionRule_Des WHERE F_CompetitionRuleID = @CompetitionRuleID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
	COMMIT TRANSACTION
	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END






GO


