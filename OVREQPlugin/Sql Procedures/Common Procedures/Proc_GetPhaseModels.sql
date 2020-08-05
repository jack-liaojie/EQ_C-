IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPhaseModels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPhaseModels]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_GetPhaseModels]
--��    �����õ�Phase��������ģ���б�
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��12��10��



CREATE PROCEDURE [dbo].[Proc_GetPhaseModels](
				@PhaseID			INT
)
AS
Begin
SET NOCOUNT ON 

	SELECT F_Order, F_PhaseModelName, F_PhaseModelComment, F_PhaseID, F_PhaseModelID FROM TS_Phase_Model WHERE F_PhaseID = @PhaseID
		ORDER BY F_Order
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

