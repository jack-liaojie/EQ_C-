IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchModels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchModels]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_GetMatchModels]
--��    �����õ�Match��������ģ���б�
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��12��10��



CREATE PROCEDURE [dbo].[Proc_GetMatchModels](
				@MatchID			INT
)
AS
Begin
SET NOCOUNT ON 

	SELECT F_Order, F_MatchModelName, F_MatchModelComment, F_MatchID, F_MatchModelID FROM TS_Match_Model WHERE F_MatchID = @MatchID
		ORDER BY F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

