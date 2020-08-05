IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_UpdatePlayerArrow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_UpdatePlayerArrow]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--��    ��: [Proc_AR_UpdatePlayerArrow]
--��    ��: �����Ŀ,����ĳ��һ�μ�����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2010��10��11��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_AR_UpdatePlayerArrow]
	@MatchID				INT,
	@CompetitionPosition	INT,
	@MathcSplitID			INT,
	@ArrowIndex				Nvarchar(10),
	@Ring					Nvarchar(10),
	@Auto					INT,
	@Result  			    AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SET @Result=0;  -- @Result=0; 	����Matchʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	����Match�ɹ������أ�
					-- @Result=-1; 	����Matchʧ�ܣ�@MatchID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --�趨����
	
	DECLARE @Arrow VARCHAR(10)
	DECLARE @IsX Int
	SET @IsX =0
	IF(UPPER(@Ring) = 'X')
	BEGIN
		SET @Ring = '10'
		SET @IsX = 1
	END
	ELSE IF(UPPER(@Ring) = 'M')
	BEGIN
		SET @Ring = '0'
	END	
	ELSE IF(UPPER(@Ring) = '')
	BEGIN
		SET @Ring = Null
	END
	
	
	UPDATE TS_Match_Split_Result 
	SET F_Points = @Ring, 
		F_SplitInfo1 = (CASE WHEN @Ring ='10' OR UPPER(@Ring) = 'X' THEN 1 ELSE 0 END),
		F_SplitInfo2 =@IsX
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID AND MSR.F_MatchID=@MatchID AND  MSI.F_MatchID= @MatchID 
	WHERE MSI.F_MatchID= @MatchID 
	AND MSI.F_FatherMatchSplitID = @MathcSplitID 
	AND MSR.F_CompetitionPosition = @CompetitionPosition
	AND (MSI.F_MatchSplitType = 1 OR MSI.F_MatchSplitType = 3)
	AND MSI.F_MatchSplitCode = @ArrowIndex
	
	IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END
	
	if(@Auto =1)
	begin
	
		UPDATE TS_Match_Split_Result SET F_Points = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND (MSI.F_MatchSplitType = 1 OR MSI.F_MatchSplitType = 3))
		,F_Comment1 =  (SELECT SUM(F_SplitInfo1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND (MSI.F_MatchSplitType = 1 OR MSI.F_MatchSplitType = 3))
		,F_Comment2 =  (SELECT SUM(F_SplitInfo2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND (MSI.F_MatchSplitType = 1 OR MSI.F_MatchSplitType = 3))
		FROM TS_Match_Split_Result AS MSR
		LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
		WHERE MSR.F_MatchID= @MatchID 
		AND MSI.F_MatchSplitID = @MathcSplitID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
	end
	
	COMMIT TRANSACTION --�ɹ��ύ����


	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_UpdatePlayerArrow 1,1,1,'1',9,0,OUTPUT
*/
