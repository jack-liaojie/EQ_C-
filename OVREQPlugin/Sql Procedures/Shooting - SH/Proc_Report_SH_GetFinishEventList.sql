IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetFinishEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetFinishEventList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetFinishEventList](
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
                                F_Order      INT
							)

	INSERT INTO #Tmp_Table(F_EventID, F_Date, F_Order, F_EventName)
    SELECT DISTINCT A.F_EventID, [dbo].[Fun_Report_GF_GetDateTime](B.F_CloseDate, 4), B.F_Order, C.F_EventLongName
    FROM TS_Event_Result AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    LEFT JOIN TS_Event_Des AS C ON B.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
    WHERE B.F_DisciplineID = @DisciplineID AND B.F_EventStatusID = 110

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


