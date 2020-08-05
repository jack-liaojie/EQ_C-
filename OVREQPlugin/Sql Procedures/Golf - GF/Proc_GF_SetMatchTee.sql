IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_SetMatchTee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_SetMatchTee]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----�洢�������ƣ�[Proc_GF_SetMatchTee]
----��		  �ܣ�����һ�������Ŀ�����Ϣ
----��		  �ߣ� �ⶨ�P
----��		  ��: 2011-07-16

CREATE PROCEDURE [dbo].[Proc_GF_SetMatchTee] (	
	@MatchID				INT,
	@Start                  INT,
	@Finish                 INT,
	@Tee		            INT,
	@StartTime			    NVARCHAR(50),
	@SpanTime				NVARCHAR(50),
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
                       
    DECLARE @StTime AS DATETIME
    DECLARE @SpTime AS DATETIME
    DECLARE @SQL NVARCHAR(MAX)
    
    SET @StTime = @StartTime
    SET @SpTime = @SpanTime
            
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
    BEGIN
		SET @Result = -1
		RETURN
    END
    
    IF NOT EXISTS(SELECT F_Order FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Tee)
    BEGIN
		SET @Result = -2
		RETURN
    END

    SET @StTime = @StartTime
    
    CREATE TABLE #Tmp_Table(
                          F_CompetitionPosition    INT, 
                          F_Order                  INT,
                          F_Group                  INT,
                          F_Tee                    INT,
                          F_StartTime              NVARCHAR(100) 
                          )
    INSERT INTO #Tmp_Table(F_CompetitionPosition, F_Order, F_Group, F_Tee)
    SELECT F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, @Tee
    FROM TS_Match_Result WHERE F_MatchID = @MatchID 
    AND cast(F_CompetitionPositionDes2 as int) >= @Start
    AND cast(F_CompetitionPositionDes2 as int) <= @Finish
    ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition
    
    DECLARE @MaxGroup AS INT 
    select @MaxGroup = MAX(F_Group) from #Tmp_Table
    
    DECLARE @Order AS INT
    SET @Order = @Start

    WHILE @Order <= @MaxGroup
    BEGIN
       DECLARE @StartOrder AS INT
       DECLARE @MidTime AS NVARCHAR(10)
       SET @MidTime = CONVERT(NVARCHAR(5), @StTime, 108)
       
       Update #Tmp_Table SET F_StartTime = @MidTime WHERE F_Group = @Order	  
	   SET @StTime = @StTime + @SpanTime
       SET @Order = @Order + 1
    END
		
    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
	UPDATE TS_Match_Result SET F_StartTimeNumDes = B.F_Tee, F_StartTimeCharDes = B.F_StartTime
	FROM TS_Match_Result AS A LEFT JOIN #Tmp_Table AS B ON A.F_CompetitionPosition = B.F_CompetitionPosition 
	WHERE A.F_MatchID = @MatchID and A.F_CompetitionPosition in (select F_CompetitionPosition from #Tmp_Table)
		
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


