

/****** Object:  StoredProcedure [dbo].[proc_HB_AddMatchSplit]    Script Date: 08/30/2012 08:31:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_HB_AddMatchSplit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_HB_AddMatchSplit]
GO



/****** Object:  StoredProcedure [dbo].[proc_HB_AddMatchSplit]    Script Date: 08/30/2012 08:31:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[proc_HB_AddMatchSplit]
----��		  �ܣ�
----��		  �ߣ����� 
----��		  ��: 2009-05-05 
--�޸ļ�¼
/*    
    2010-10-07   ����       ����WP����Ŀ�����SplitDes
*/


CREATE PROCEDURE [dbo].[proc_HB_AddMatchSplit] 
	@MatchID			           INT,
	@FatherMatchSplitID			   INT,----0��������FatherMatchSplit
	@MatchSplitCode          	   NVARCHAR(20),
	@MatchType          		   INT,
	@Result 			           AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	����MatchSplitʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	����MatchSplit�ɹ�������MatchSplitID��
					-- @Result=-1; 	����MatchSplitʧ�ܣ� @MatchID��Ч
					-- @Result=-2; 	����MatchSplitsʧ�ܣ�@FatherMatchSplitID��Ч
                    -- @Result=-3;  ����MatchSplitsʧ�ܣ�@MatchSplitOrder��Ч


	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @FatherMatchSplitID IS NULL OR @FatherMatchSplitID = '' OR @FatherMatchSplitID = 0
    BEGIN
        SET @FatherMatchSplitID = 0
    END
    ELSE
    BEGIN
		IF NOT EXISTS(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @FatherMatchSplitID)
		BEGIN
			SET @Result = -2
			RETURN
		END
     END
    
    IF EXISTS (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_MatchSplitCode = @MatchSplitCode)
    BEGIN
		SET @Result = -3
		RETURN
	END
  
    DECLARE @HomeID INT
    DECLARE @AwayID INT
    DECLARE @MatchSplitOrder  AS INT
    DECLARE @MatchSplitID  AS INT
    DECLARE @MatchSplieDES AS NVARCHAR(50)

    SET @HomeID = -1
    SET @AwayID = -1
    
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
   
  
    SELECT @MatchSplitOrder = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID


   
    SELECT @MatchSplitID = (CASE WHEN MAX(F_MatchSplitID) IS NULL THEN 0 ELSE MAX(F_MatchSplitID) END) + 1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID


   ------��� TS_Match_Split_Info, TS_Match_Split_Result
    INSERT INTO TS_Match_Split_Info (F_MatchID,F_MatchSplitID,F_FatherMatchSplitID,F_Order,F_MatchSplitStatusID,F_MatchSplitType, F_MatchSplitCode) 
                VALUES (@MatchID,@MatchSplitID,@FatherMatchSplitID,@MatchSplitOrder,NULL,@MatchType, @MatchSplitCode)
    IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
   
    INSERT INTO TS_Match_Split_Result (F_MatchID,F_MatchSplitID,F_CompetitionPosition) VALUES(@MatchID, @MatchSplitID,1)
    IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
    INSERT INTO TS_Match_Split_Result (F_MatchID,F_MatchSplitID,F_CompetitionPosition) VALUES(@MatchID, @MatchSplitID,2)
    IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

   

    SELECT @HomeID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
    SELECT @AwayID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

    UPDATE TS_Match_Split_Result SET F_RegisterID = @HomeID WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 1

    IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END

    UPDATE TS_Match_Split_Result SET F_RegisterID = @AwayID WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 2

    IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END
	
	------���TS_Match_Split_Des
	IF(CAST( @MatchSplitCode AS INT) > 2 AND CAST( @MatchSplitCode AS INT) < 5)
	BEGIN
	   SET @MatchSplieDES = 'Extra Time ' + CAST((CAST( @MatchSplitCode AS INT) - 2) AS NVARCHAR(50))
	   
	   INSERT INTO TS_Match_Split_Des(F_MatchID, F_MatchSplitID, F_LanguageCode,F_MatchSplitShortName, F_MatchSplitLongName) 
			     VALUES(@MatchID, @MatchSplitID, 'ENG', @MatchSplieDES, @MatchSplieDES)

            IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
	END
	ELSE IF(CAST( @MatchSplitCode AS INT) = 51)
	BEGIN
	   SET @MatchSplieDES = 'PSO' 
	   	   
	   INSERT INTO TS_Match_Split_Des(F_MatchID, F_MatchSplitID, F_LanguageCode,F_MatchSplitShortName, F_MatchSplitLongName) 
			     VALUES(@MatchID, @MatchSplitID, 'ENG', @MatchSplieDES, @MatchSplieDES)

            IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
	END
	
	
   COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @MatchSplitID
	RETURN

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


