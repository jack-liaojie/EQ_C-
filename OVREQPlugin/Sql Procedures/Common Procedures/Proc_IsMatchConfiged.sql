IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_IsMatchConfiged]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_IsMatchConfiged]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�[Proc_IsMatchConfiged]
----��		  �ܣ��ж�һ���������Ѿ�ָ�����������Լ��ж�һ��������Splits�Ƿ����ָ���ľ���������д���
----��		  �ߣ�֣���� 
----��		  ��: 2010-09-20

CREATE PROCEDURE [dbo].[Proc_IsMatchConfiged] (	
	@MatchID					INT,
	@Result						INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result=0; 	����������������û��ָ����Ҳû�д���MatchSplit��
					-- @Result=1; 	�����������������Ѿ�ָ����Ҳû�д���MatchSplit��
					-- @Result=-1; 	�жϵ��������Ƿ����ú�ʧ�ܣ���@MatchID��Ч
	
	
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF NOT EXISTS (SELECT F_MatchID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID AND F_CompetitionRuleID IS NULL)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END






GO


