IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_OutPut_Registers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_OutPut_Registers]

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










--��    �ƣ�[Proc_OutPut_Registers]
--��    ��������ע����Ա��Ϣ
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��04��16��

CREATE   PROCEDURE [dbo].[Proc_OutPut_Registers](
													@DisciplineID		INT
)
					
As
Begin
SET NOCOUNT ON 

	SELECT * FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID

Set NOCOUNT OFF
End	
GO

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
GO


--EXEC [Proc_OutPut_Registers] 0