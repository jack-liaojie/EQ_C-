IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_RemoveMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_RemoveMatchOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--��    �ƣ�[Proc_AR_RemoveMatchOfficial]
--��    ����ɾ��Match�µĹ�Ա
--����˵���� 
--˵    ����
--�� �� �ˣ��޿�
--��    �ڣ�2011��01��26��

CREATE PROCEDURE [dbo].[Proc_AR_RemoveMatchOfficial](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���
	DECLARE @pMatchID INT 
		SET @pMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE  F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)
			
    CREATE TABLE #table_Tmp(
                             F_MatchID      INT,
                             F_ServantNum   INT,
                             F_RowCount     INT
                            )

    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
    DELETE FROM  TS_Match_Servant WHERE F_MatchID = @pMatchID AND F_RegisterID = @RegisterID

    IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

    INSERT INTO #table_Tmp(F_MatchID, F_ServantNum, F_RowCount)
    SELECT F_MatchID, F_ServantNum, ROW_NUMBER() OVER (ORDER BY F_ServantNum) FROM TS_Match_Servant WHERE F_MatchID = @pMatchID

    UPDATE TS_Match_Servant SET F_Order = B.F_RowCount FROM TS_Match_Servant AS A LEFT JOIN #table_Tmp AS B ON A.F_MatchID = B.F_MatchID
    AND A.F_ServantNum = B.F_ServantNum WHERE A.F_MatchID = @pMatchID

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



