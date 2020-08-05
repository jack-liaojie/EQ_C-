IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_UpdateMatchPeriod]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_UpdateMatchPeriod]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_BK_UpdateMatchPeriod]
--��    �������� ��������
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2010��09��21��

CREATE PROCEDURE [dbo].[Proc_BK_UpdateMatchPeriod]
                 @MatchID             INT,   
                 @Period              NVARCHAR(50),
                 @Result              AS INT OUTPUT

AS
BEGIN
   SET NOCOUNT ON

SET @Result = 0;

    IF NOT EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
      BEGIN
        SET @Result = -1
        RETURN
      END

    UPDATE TS_Match SET F_MatchComment1 = @Period  WHERE F_MatchID = @MatchID

    IF @@error <> 0
      BEGIN
        SET @Result = 0
        RETURN
      END

    SET @Result = 1

   
Set NOCOUNT OFF
End
	
set QUOTED_IDENTIFIER OFF
