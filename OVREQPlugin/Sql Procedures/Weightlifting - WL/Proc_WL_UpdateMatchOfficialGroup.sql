IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateMatchOfficialGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateMatchOfficialGroup]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--��    �ƣ�[Proc_WL_UpdateMatchOfficialGroup]
--��    ����ɾ��Match�µĹ�Ա
--����˵���� 
--˵    ����
--�� �� �ˣ��޿�
--��    �ڣ�2011��01��26��

CREATE PROCEDURE [dbo].[Proc_WL_UpdateMatchOfficialGroup](
						@MatchID		    INT,
                        @OfficialGroupID    INT,
                        @OPType				INT, --0:Add     1:Remove
                        @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���
	DECLARE @pMatchID INT 
		SET @pMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE F_MatchCode ='01' AND F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)


    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	IF(@OPType =1)
	BEGIN
    DELETE FROM  TS_Match_OfficialGroup WHERE F_MatchID = @pMatchID AND F_OfficialGroupID = @OfficialGroupID

    IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
	END
    ELSE
    BEGIN
    IF EXISTS(SELECT F_MatchID FROM  TS_Match_OfficialGroup WHERE F_MatchID = @pMatchID)
		BEGIN
		UPDATE TS_Match_OfficialGroup SET F_OfficialGroupID = @OfficialGroupID WHERE F_MatchID = @pMatchID
		END
	ELSE 
		BEGIN
		 INSERT INTO TS_Match_OfficialGroup(F_OfficialGroupID, F_MatchID)
			VALUES (@OfficialGroupID, @pMatchID)
		END

    IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
	END
    COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO



