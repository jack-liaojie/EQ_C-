IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CreateMatchGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CreateMatchGroup]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----�洢�������ƣ�[Proc_GF_CreateMatchGroup]
----��		  �ܣ�����һ��������ʵʱ�ɼ�
----��		  �ߣ� �Ŵ�ϼ
----��		  ��: 2010-10-05

CREATE PROCEDURE [dbo].[Proc_GF_CreateMatchGroup] (	
	@MatchID				INT,
	@Sides		            INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; ����ʧ�ܣ���ʾû�����κβ�����
					   -- @Result = 1; ���³ɹ���
                       -- @Result = -1; ����ʧ�ܣ���MatchID�����ڣ�
                       -- @Result = -2; ����ʧ�ܣ���Tee�����ڣ�
                       -- @Result = -3; ����ʧ�ܣ�ȱ�ٲ����˶�Ա��
                       
    DECLARE @PlayerNum AS INT
    DECLARE @GroupCount AS INT
    DECLARE @GroupAdd AS INT
    DECLARE @GroupAddNum AS INT
    DECLARE @SQL NVARCHAR(MAX)
    
            
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
    BEGIN
		SET @Result = -1
		RETURN
    END
    
    SELECT @PlayerNum = COUNT(F_CompetitionPosition) FROM TS_Match_Result WHERE F_MatchID = @MatchID
    IF @PlayerNum <= 0
    BEGIN
		SET @Result = -3
		RETURN
    END
    
    SET @GroupAdd = 0
    SET @GroupCount = @PlayerNum / @Sides
    SET @GroupAddNum = @PlayerNum % @Sides
    
    IF @GroupAddNum <> 0
    BEGIN
        SET @GroupAdd = 1
    END
    
    CREATE TABLE #Tmp_Table(
                          F_CompetitionPosition    INT, 
                          F_Order                  INT,
                          F_Group                  INT,
                          F_Sides                  INT
                          )
    INSERT INTO #Tmp_Table(F_CompetitionPosition, F_Order)
    SELECT F_CompetitionPosition, F_CompetitionPositionDes1
    FROM TS_Match_Result WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition
    
    IF @GroupAdd = 1
    BEGIN	
		Update #Tmp_Table SET [F_Group] = 1 WHERE F_Order <= @GroupAddNum
    END
    
    DECLARE @Order AS INT
    SET @Order = 0
    
    WHILE @Order < @GroupCount
    BEGIN
       DECLARE @StartOrder AS INT
       DECLARE @MidTime AS NVARCHAR(10)
       SET @StartOrder = @Order * @Sides + @GroupAddNum      
       SET @Order = @Order + 1
       
       Update #Tmp_Table SET [F_Group] = @Order + @GroupAdd WHERE F_Order > @StartOrder AND F_Order <= (@StartOrder + @Sides)	  
    END
    
    UPDATE #Tmp_Table SET F_Sides = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT DENSE_RANK() OVER(PARTITION BY F_Group ORDER BY F_Order) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition
		
    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
	    UPDATE TS_Match_Result SET F_CompetitionPositionDes2 = B.F_Group, F_FinishTimeNumDes = F_Sides
	    FROM TS_Match_Result AS A LEFT JOIN #Tmp_Table AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition
	    WHERE A.F_MatchID = @MatchID
		
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


