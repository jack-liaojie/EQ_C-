IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetModels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetModels]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_GetModels]
--��    �����õ����е�ģ��
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��08��20��

CREATE PROCEDURE [dbo].[Proc_GetModels]
AS
Begin
SET NOCOUNT ON 

	SELECT F_Order, F_ModelName, F_ModelComment, F_ModelID FROM TM_Model ORDER BY F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_GetModels]