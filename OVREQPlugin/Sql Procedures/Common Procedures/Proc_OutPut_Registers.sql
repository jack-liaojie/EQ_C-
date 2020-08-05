IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_OutPut_Registers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_OutPut_Registers]

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










--名    称：[Proc_OutPut_Registers]
--描    述：导出注册人员信息
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月16日

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