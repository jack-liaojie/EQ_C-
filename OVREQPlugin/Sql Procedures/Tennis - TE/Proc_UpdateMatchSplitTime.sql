IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateMatchSplitTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdateMatchSplitTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_UpdateMatchSplitTime]
----��		  �ܣ�����Match��һ�̱�����ʱ�䣬ͬʱ���±�������ʱ�䡣
----��		  �ߣ�֣���� 
----��		  ��: 2010-10-18

CREATE PROCEDURE [dbo].[Proc_UpdateMatchSplitTime] (	
	@MatchID							INT,
	@SubMatchCode                       INT,  --- -1:������
	@SetNum								INT,
	@Minute								INT,
	@Result								INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result=0; 	ɾ��һ������ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��һ�������ɹ���
					-- @Result=-1; 	ɾ��һ������ʧ�ܣ���@MatchID��@SetNum��Ч
					
	
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF (@SetNum = 0)--����Match����ʱ��
	BEGIN
		UPDATE TS_Match SET F_SpendTime = @Minute WHERE F_MatchID = @MatchID
		SET @Result = 1
		RETURN
	END
	
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_FatherMatchSplitID = 0)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	DECLARE @TotalMinute AS INT

	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	    IF(@SubMatchCode = -1)
	    BEGIN
			UPDATE TS_Match_Split_Info SET F_SpendTime = @Minute WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_FatherMatchSplitID = 0
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE 
		BEGIN
			UPDATE A  SET A.F_SpendTime = @Minute 
			  FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID
			     WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitCode = @SetNum AND B.F_MatchSplitCode = @SubMatchCode AND B.F_FatherMatchSplitID = 0
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
			
		   SELECT @TotalMinute = SUM (ISNULL(A.F_SpendTime, 0)) 
		      FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B  ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID
		         WHERE  A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SubMatchCode AND B.F_FatherMatchSplitID = 0

			UPDATE TS_Match_Split_Info SET F_SpendTime = @TotalMinute 
			     WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_FatherMatchSplitID = 0
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		
		SELECT @TotalMinute = SUM (ISNULL(F_SpendTime, 0)) FROM TS_Match_Split_Info WHERE  F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
		
		UPDATE TS_Match SET F_SpendTime = @TotalMinute WHERE F_MatchID = @MatchID
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


