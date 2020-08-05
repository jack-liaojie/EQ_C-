IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdatePlayerIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdatePlayerIRM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�[Proc_GF_UpdatePlayerIRM]
----��		  �ܣ�����һ���������˶�Ա��IRM״̬
----��		  �ߣ� �Ŵ�ϼ
----��		  ��: 2010-10-12

CREATE PROCEDURE [dbo].[Proc_GF_UpdatePlayerIRM] (	
	@MatchID				INT,
	@CompetitionID		    INT,
	@IRM                    NVARCHAR(50),
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; ����ʧ�ܣ���ʾû�����κβ�����
					   -- @Result = 1; ���³ɹ���
                       -- @Result = -1; ����ʧ�ܣ���MatchID��CompetitionID�����ڣ� 
    
    DECLARE @IRMID INT
    SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IRMCODE = @IRM
                                          
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID)
    BEGIN
    SET @Result = -1
    RETURN
    END
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
 
      UPDATE TS_Match_Result SET F_IRMID = @IRMID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		UPDATE TS_Match_Result SET F_PointsNumDes1 = NULL, F_Rank = NULL WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID AND F_IRMID IS NOT NULL

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
        EXEC Proc_GF_UpdateMatchResult @MatchID, 0, @Result OUTPUT

		IF @Result<>1  --����ʧ�ܷ���  
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



