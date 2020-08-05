

/****** Object:  StoredProcedure [dbo].[Proc_HB_CreateMatchSplits_1_Level]    Script Date: 08/30/2012 08:34:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_CreateMatchSplits_1_Level]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_CreateMatchSplits_1_Level]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_CreateMatchSplits_1_Level]    Script Date: 08/30/2012 08:34:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--��    �ƣ�[Proc_HB_CreateMatchSplits_1_Level]
--��    ����������Match_Split_Info��
--����˵���� 
--˵    ����
--�� �� �ˣ��Ŵ�ϼ
--��    �ڣ�2009��04��11��
--�޸ļ�¼
/*    
    2010-10-07   ����       ����WP����Ŀ�����ʱҪ��Statistic�������գ�ͬʱ���SplitDes
*/

	
CREATE PROCEDURE [dbo].[Proc_HB_CreateMatchSplits_1_Level](
					@MatchID					INT, --��ǰ������ID
					@MatchType					INT, --�Ƿ�Ϊ����Split  1��������2������
					@Level_1_SplitNum			INT,
                    @CreateType					INT, --1 ��ʾֱ��ɾ��ԭ�е�Split�������µ�Split, 2��ʾ����ԭ�е�Split
					@Result 					AS INT OUTPUT
)
	
AS
BEGIN
SET NOCOUNT ON

    SET @Result = 0;  -- @Result=0; 	���MatchSplitʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	���MatchSplit�ɹ���
                      -- @Result=-1;    ���MatchSplit����@MatchID��Ч
                      -- @Result=-2; 	����MatchSplitsʧ�ܣ�@Level_1_SplitNum��Ч��Ч
					  -- @Result=-3;	����MatchSplitsʧ��,����Split��Split��Ŀ��ͬ��ֻ��ɾ��ԭ�е�Split���ٴ����µ�Split
                      -- @Result=-4;	����MatchSplitsʧ��,����Split��Split��Ŀ��ͬ��ֻ��ɾ��ԭ�е�Split���ٴ����µ�Split
    
   IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
    BEGIN
		SET @Result = -1
		RETURN
	END

   IF (@Level_1_SplitNum <= 0)
    BEGIN
	    SET @Result = -2
		RETURN
    END

   IF (@CreateType = 2)
    BEGIN
        DECLARE @SplitCount INT
        SELECT @SplitCount = COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		IF (@SplitCount = @Level_1_SplitNum)
		BEGIN
			SET @Result = -3
			RETURN
		END
        ELSE IF (@SplitCount <> @Level_1_SplitNum AND @SplitCount <> 0)
        BEGIN
            SET @Result = -4
			RETURN
		END
    END

    DECLARE @SplitID INT
    DECLARE @FatherSplitID INT
    DECLARE @SplitName   NVARCHAR(50)
    DECLARE @SplitCode   INT

    SET @SplitID = 0
    SET @FatherSplitID = 0
    
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TS_Match_Statistic WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

        DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

        DELETE FROM TS_Match_Split_Des WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match SET F_MatchTypeID = @MatchType WHERE F_MatchID = @MatchID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

-----���TS_Match_Split_Info,TS_Match_Split_result,TS_match_Split_Des

    WHILE(@SplitID < @Level_1_SplitNum)
    BEGIN
		SET @SplitID = @SplitID + 1
		
		IF(@MatchType = 2)
		BEGIN
		 SET @SplitCode = '51'
		END
		ELSE
		BEGIN
		   SET @SplitCode = CAST (@SplitID AS NVARCHAR(20))
		END
        
		IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
			BEGIN
				INSERT INTO TS_Match_Split_Info(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitType, F_MatchSplitCode) 
				     VALUES(@MatchID, @SplitID, @FatherSplitID, @SplitID, @MatchType, @SplitCode)

                IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
			END

        IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1)
		BEGIN
			INSERT INTO TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES(@MatchID, @SplitID, 1)

            IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
		END

        IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2)
		BEGIN
			INSERT INTO TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES(@MatchID, @SplitID, 2)

            IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
		END
		
        IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Des WHERE F_MatchID = @MatchID )
		BEGIN
		    SET @SplitName = 'Half Time ' + CAST(@SplitID AS NVARCHAR(50))
			INSERT INTO TS_Match_Split_Des(F_MatchID, F_MatchSplitID, F_LanguageCode,F_MatchSplitShortName, F_MatchSplitLongName) 
			     VALUES(@MatchID, @SplitID, 'ENG', @SplitName, @SplitName)

            IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
		END
    END

    DECLARE @HomeID INT
    DECLARE @AwayID INT

    SET @HomeID = -1
    SET @AwayID = -1

    SELECT @HomeID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
    SELECT @AwayID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

    UPDATE TS_Match_Split_Result SET F_RegisterID = @HomeID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1

    IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END

    UPDATE TS_Match_Split_Result SET F_RegisterID = @AwayID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

    IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END

    UPDATE TS_Match SET F_MatchTypeID = @MatchType WHERE F_MatchID = @MatchID

    IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END
	
	UPDATE TS_Match_Result SET F_ResultID = NULL,F_Rank= NULL, F_Points= NULL WHERE F_MatchID = @MatchID
    IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
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


