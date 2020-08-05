IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetClubList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetClubList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----存储过程名称：[Proc_GetClubList]
----功		  能：得到所有的俱乐部列表
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetClubList](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_ClubCode AS [Code]
		, B.F_ClubLongName AS [Long Name]
		, B.F_ClubShortName AS [Short Name]
		, A.F_CLubID AS [ID]
	FROM TC_Club AS A 
	LEFT JOIN TC_Club_Des AS B 
		ON A.F_CLubID = B.F_CLubID AND B.F_LanguageCode= @LanguageCode

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetClubList] 'CHN'
--exec [Proc_GetClubList] 'ENG'