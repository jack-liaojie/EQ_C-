IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_GetFinishEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_GetFinishEventList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_FB_GetFinishEventList]
--描    述：得到Discipline下比赛完成得Event列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年10月27日


CREATE PROCEDURE [dbo].[Proc_Report_FB_GetFinishEventList](
												@DisciplineID		INT,
                                                @LanguageCode       CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_EventID    INT,
                                F_EventName  NVARCHAR(100),
                                F_Date       NVARCHAR(11),
							)

	INSERT INTO #Tmp_Table(F_EventID, F_Date)
    SELECT DISTINCT A.F_EventID, [dbo].[Func_Report_FB_GetDateTime](B.F_CloseDate, 7,@LanguageCode) FROM TS_Event_Result AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    WHERE B.F_DisciplineID = @DisciplineID AND A.F_RegisterID IS NOT NULL

    UPDATE #Tmp_Table SET F_EventName = B.F_EventLongName FROM #Tmp_Table AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID
    WHERE B.F_LanguageCode = @LanguageCode

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


