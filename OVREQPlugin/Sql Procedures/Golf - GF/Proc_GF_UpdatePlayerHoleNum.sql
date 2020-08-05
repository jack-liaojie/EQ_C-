IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdatePlayerHoleNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdatePlayerHoleNum]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�[Proc_GF_UpdatePlayerHoleNum]
----��		  �ܣ�����һ��������ʵʱ�ɼ�
----��		  �ߣ� �Ŵ�ϼ
----��		  ��: 2010-10-05

CREATE PROCEDURE [dbo].[Proc_GF_UpdatePlayerHoleNum] (	
	@MatchID				INT,
	@CompetitionID		    INT,
	@Hole					INT,
	@HoleNum				INT,
	@DoRank                 INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; ����ʧ�ܣ���ʾû�����κβ�����
					   -- @Result = 1; ���³ɹ���
                       -- @Result = -1; ����ʧ�ܣ���MatchID��CompetitionID��Hole�����ڣ� 
                                  
    DECLARE @MatchSplitID AS INT
    DECLARE @HolePar AS INT
    DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    
    SELECT @MatchSplitID = F_MatchSplitID, @HolePar = CAST(F_MatchSplitComment AS INT) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Hole
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID
            
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID AND F_MatchSplitID = @MatchSplitID)
    BEGIN
    SET @Result = -1
    RETURN
    END
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
 
      UPDATE TS_Match_Split_Result SET F_Points = (CASE @HoleNum WHEN 0 THEN NULL ELSE @HoleNum END), F_SplitPoints = (CASE @HoleNum WHEN 0 THEN NULL ELSE (@HoleNum - @HolePar) END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID AND F_MatchSplitID = @MatchSplitID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		DECLARE @MatchPoints AS INT
		DECLARE @MatchPar AS INT
		SELECT @MatchPoints = SUM(CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END), @MatchPar = SUM(CASE WHEN F_SplitPoints IS NULL THEN 0 ELSE F_SplitPoints END) FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID
        UPDATE TS_Match_Result SET F_PointsCharDes1 = (CASE WHEN @MatchPoints = 0 THEN NULL ELSE @MatchPoints END), F_PointsCharDes2 = (CASE WHEN @MatchPoints = 0 THEN NULL ELSE @MatchPar END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID
        
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		if @DoRank is not null and @DoRank = 1
			EXEC Proc_GF_UpdateMatchResult @MatchID, 0, @Result OUTPUT
		else 
		    set @Result = 1	

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



