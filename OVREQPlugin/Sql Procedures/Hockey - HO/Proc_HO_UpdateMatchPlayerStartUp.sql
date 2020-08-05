IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_UpdateMatchPlayerStartUp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_UpdateMatchPlayerStartUp]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--��    �ƣ�[Proc_HO_UpdateMatchPlayerStartUp]
--��    ��������Match�µ��˶�Ա��StartUp
--����˵���� 
--˵    ����
--�� �� �ˣ��Ŵ�ϼ
--��    �ڣ�2012��08��21��


CREATE PROCEDURE [dbo].[Proc_HO_UpdateMatchPlayerStartUp](
												@MatchID		    INT,
                                                @Pos                INT,
                                                @RegisterID         INT,
                                                @StartUpID          INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�ɹ���

	SET LANGUAGE ENGLISH

    DECLARE @CompetitionPosition INT
    SELECT @CompetitionPosition = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Pos

    SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

    UPDATE TS_Match_Member SET F_StartUp = (CASE WHEN @StartUpID = -1 THEN NULL ELSE @StartUpID END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_RegisterID = @RegisterID

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


