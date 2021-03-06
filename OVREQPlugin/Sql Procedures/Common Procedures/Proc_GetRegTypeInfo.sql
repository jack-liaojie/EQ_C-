IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----存储过程名称：[Proc_GetRegTypeInfo]
----功		  能：得到所有的注册类型信息
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetRegTypeInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_RegTypeLongDescription, A.F_RegTypeID 
	FROM TC_RegType AS A 
	LEFT JOIN TC_RegType_Des AS B 
		ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode= @LanguageCode

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetRegTypeInfo] 'CHN'
--exec [Proc_GetRegTypeInfo] 'ENG'