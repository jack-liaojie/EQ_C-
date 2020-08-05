IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_SetCurrentSplitIndicator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_SetCurrentSplitIndicator]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_BD_SetCurrentSplitIndicator]
----��		  �ܣ����õ�ǰ������־
----��		  �ߣ���ǿ
----��		  ��: 2011-05-04

CREATE PROCEDURE [dbo].[Proc_BD_SetCurrentSplitIndicator]
		@MatchID     INT, 
		@MatchSplitID INT,  --��ID���������ID��������Ϊ��һ��,0Ϊȡ�����оֵ�״̬,-1Ϊ����Ϊ���һ��
		@Flag   INT, --�ֱ�־  2Ϊ���ڱ�����3Ϊ�Ѿ�����������Ϊ���ڱ�����1Ϊ����δ��ʼ������Ϊ���ڱ���
		@Result INT OUTPUT-- -1��match��split�����ڣ�-2:flag�������� 1�ɹ�,-3��������
		
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SetID INT 
	DECLARE @GameID INT
	DECLARE @FatherSplitID INT
	
	IF @Flag NOT IN (1,2,3)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	IF @MatchSplitID = 0
	BEGIN
		UPDATE TS_Match_Split_Info SET F_MatchSplitComment = NULL WHERE F_MatchID = @MatchID AND F_MatchSplitComment IS NOT NULL
		SET @Result = 1
		RETURN
	END
	
	
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	IF @MatchType IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF @MatchSplitID = -1
	BEGIN
	
		IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
		BEGIN
			SET @Result = -1
			RETURN
		END
		
		SELECT @GameID = MAX(F_MatchSplitID) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND (F_MatchSplitStatusID IS NOT NULL AND F_MatchSplitStatusID != 0 )
		--���Ϊ�գ�˵������δ��ʼ��@SetIDΪ1
		IF @GameID IS NULL
			BEGIN
				SET @GameID = 1
			END
			
		--�ݹ����
		EXEC Proc_BD_SetCurrentSplitIndicator @MatchID, @GameID, 3, @Result OUTPUT
		RETURN
		
	END
	
	IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	
	
	
	IF @MatchType = 1
		BEGIN
			
			--����մ�״̬��comment
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = NULL 
			WHERE F_MatchID = @MatchID AND F_MatchSplitComment IS NOT NULL
			
			--����״̬
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = CONVERT( NVARCHAR(4), @Flag)
			WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID	
		END
	ELSE IF @MatchType = 3
		BEGIN
			
	
			
			SET @GameID = @MatchSplitID
			SELECT @SetID = F_FatherMatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
			
			--��Ϊ��ID����ȡ��һ�ֵ�splitID
			IF @SetID = 0
			BEGIN
				SELECT @GameID = F_MatchSplitID FROM TS_Match_Split_Info 
				WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @MatchSplitID AND F_Order = 1
				
				SET @SetID = @MatchSplitID
			END
			
			--����մ�״̬��comment
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = NULL 
			WHERE F_MatchID = @MatchID AND F_MatchSplitComment IS NOT NULL
			
			--����״̬
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = CONVERT( NVARCHAR(4), @Flag)
			WHERE F_MatchID = @MatchID AND F_MatchSplitID IN ( @SetID, @GameID)
		END
	ELSE
		BEGIN
			SET @Result = -3
			RETURN
		END
	
	SET @Result = 1
	
SET NOCOUNT OFF
END


GO


