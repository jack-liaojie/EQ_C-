/****** Object:  StoredProcedure [dbo].[Proc_GetRegisterInfo]    Script Date: 01/11/2010 19:06:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegisterInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegisterInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRegisterInfo]    Script Date: 01/11/2010 19:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetRegisterInfo]
----功		  能：得到当前注册人员信息
----作		  者：李燕
----日		  期: 2009-08-17
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题	
			2009年09月08日		邓年彩		添加 Bib 号的显示.		
*/ 

CREATE PROCEDURE [dbo].[Proc_GetRegisterInfo](
                                         @RegisterID      int,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

      SELECT  *
       FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
       WHERE A.F_RegisterID = @RegisterID

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

