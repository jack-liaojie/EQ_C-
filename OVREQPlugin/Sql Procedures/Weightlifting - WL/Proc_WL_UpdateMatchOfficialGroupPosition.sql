IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateMatchOfficialGroupPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateMatchOfficialGroupPosition]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    �ƣ�[Proc_WL_UpdateMatchOfficialGroupPosition]
--��    ��������Match�µĹ�ԱPosition
--����˵���� 
--˵    ����
--�� �� �ˣ��޿�
--��    �ڣ�2011��01��10��


CREATE PROCEDURE [dbo].[Proc_WL_UpdateMatchOfficialGroupPosition](
												@OfficialGroupID    INT,
                                                @RegisterID         INT,
                                                @PositionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���
		
    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
    UPDATE TS_Group_Official 
    SET 
    F_PositionID = (CASE WHEN @PositionID = -1 THEN NULL ELSE @PositionID END)
   
    WHERE F_OfficialGroupID = @OfficialGroupID AND F_RegisterID = @RegisterID

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


