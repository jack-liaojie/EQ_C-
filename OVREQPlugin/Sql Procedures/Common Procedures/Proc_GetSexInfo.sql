IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetSexInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetSexInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----存储过程名称：[Proc_GetSexInfo]
----功		  能：得到所有的性别信息
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetSexInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_SexLongName,A.F_SexCode FROM TC_Sex as A LEFT JOIN TC_Sex_Des as B ON A.F_SexCode = B.F_SexCode WHERE B.F_LanguageCode= @LanguageCode

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetSexInfo] 'CHN'
--exec [Proc_GetSexInfo] 'ENG'