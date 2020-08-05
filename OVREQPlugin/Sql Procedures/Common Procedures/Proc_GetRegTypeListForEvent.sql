IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeListForEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeListForEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetRegTypeListForEvent]
--描    述：得到一个Event可能的参赛人员类型
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月12日

CREATE PROCEDURE [dbo].[Proc_GetRegTypeListForEvent](
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_RegType(
								F_RegTypeID							INT,
								F_RegTypeLongDescription			NVARCHAR(100)
							)

	INSERT INTO #Tmp_RegType ( F_RegTypeLongDescription, F_RegTypeID ) SELECT B.F_RegTypeLongDescription, A.F_RegTypeID
		FROM TC_RegType AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID WHERE A.F_RegTypeID IN (1,2,3) AND B.F_LanguageCode = @LanguageCode
	
	SELECT F_RegTypeLongDescription, F_RegTypeID FROM #Tmp_RegType

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


