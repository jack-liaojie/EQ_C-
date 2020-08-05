IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateMatchGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateMatchGroupInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--��    �ƣ�[Proc_GF_UpdateMatchGroupInfo]
--��    ��������ǰ������ѡ��������Ϣ��Tee��StartTime
--����˵���� 
--˵    ����
--�� �� �ˣ��Ŵ�ϼ
--��    �ڣ�2010��10��11��


CREATE PROCEDURE [dbo].[Proc_GF_UpdateMatchGroupInfo](
												@MatchID		    INT,
												@Group              INT,
												@Tee                INT,
												@StartTime          NVARCHAR(50),
												@Result             AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;     -- @Result = 0; ����ʧ�ܣ���ʾû�����κβ�����
					   -- @Result = 1; ���³ɹ���
                       -- @Result = -1; ����ʧ�ܣ���MatchID��Group�����ڣ� 
                       -- @Result = -2; ����ʧ�ܣ���Tee�����ڣ� 

	SET LANGUAGE ENGLISH					
							
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
	    SET @Result = -1
	    RETURN
	END
						
	IF NOT EXISTS(SELECT F_CompetitionPositionDes2 FROM TS_Match_Result WHERE F_CompetitionPositionDes2 = @Group)
	BEGIN
	    SET @Result = -1
	    RETURN
	END
	
	IF NOT EXISTS(SELECT F_Order FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Tee)
	BEGIN
	    SET @Result = -2
	    RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
	UPDATE TS_Match_Result SET F_StartTimeNumDes = (CASE WHEN @Tee = 0 THEN NULL ELSE @Tee END)
	, F_StartTimeCharDes = (CASE WHEN @StartTime = '' THEN NULL ELSE @StartTime END)
	WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes2 = @Group
	
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

GO


