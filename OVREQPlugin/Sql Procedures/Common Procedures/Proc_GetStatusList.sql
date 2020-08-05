IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetStatusList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetStatusList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_GetStatusList]
--描    述：得到状态列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年11月20日
--修改记录：


CREATE PROCEDURE [dbo].[Proc_GetStatusList](
											@LanguageCode	CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_StatusLongName			NVARCHAR(100),
								F_StatusID			INT
							)


	INSERT INTO #Tmp_Table (F_StatusID, F_StatusLongName) SELECT A.F_StatusID, B.F_StatusLongName FROM
		TC_Status AS A LEFT JOIN TC_Status_Des AS B ON A.F_StatusID = B.F_StatusID AND B.F_LanguageCode = @LanguageCode

	SELECT F_StatusLongName, F_StatusID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

