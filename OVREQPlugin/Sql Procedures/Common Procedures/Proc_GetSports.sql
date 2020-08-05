IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetSports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetSports]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetSports]
--描    述：得到所有的Sports
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年08月13日

CREATE PROCEDURE [dbo].[Proc_GetSports](
				 @LanguageCode	CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_Active AS [Active], A.F_Order AS [Order],A.F_SportCode AS [Code],
		B.F_SportLongName AS [Long Name],B.F_SportShortName AS [Short Name],
		Convert(varchar(10),A.F_OpenDate,120) AS [Open Date],CONVERT(VARCHAR(10),A.F_CloseDate,120) AS [Close Date],
		A.F_SportID AS [ID]
	FROM TS_Sport AS A left join TS_Sport_Des AS B
	ON A.F_SportID = B.F_SportID AND B.F_LanguageCode=@LanguageCode
	ORDER BY [Order]

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_GetSports] 'CHN'