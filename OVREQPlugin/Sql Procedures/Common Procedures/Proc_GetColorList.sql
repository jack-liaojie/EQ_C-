IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetColorList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetColorList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----存储过程名称：[Proc_GetColorList]
----功		  能：得到所有的俱乐部列表
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetColorList](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_LanguageCode AS [Language Code]
		, B.F_ColorLongName AS [Long Name]
		, B.F_ColorShortName AS [Short Name]
		, B.F_ColorComment AS [Comment]
		, A.F_ColorID AS [ID]
	FROM TC_Color AS A 
	LEFT JOIN TC_Color_Des AS B 
		ON A.F_ColorID = B.F_ColorID AND B.F_LanguageCode= @LanguageCode

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetColorList] 'CHN'
--exec [Proc_GetColorList] 'ENG'