IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetEventList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_GF_GetEventList]
--描    述：得到Discipline下得Event列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年09月15日


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetEventList](
												@DisciplineID		INT,
												@EventID            INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_EventID       INT,
                                F_EventCode     NVARCHAR(10),
                                F_SexCode       NVARCHAR(10),
                                F_GenderCode    NVARCHAR(10),
								F_Name			NVARCHAR(100),
								F_CHNName       NVARCHAR(100)
							)

    IF @EventID = -1
    BEGIN
	INSERT INTO #Tmp_Table (F_EventID, F_EventCode, F_GenderCode) 
	  SELECT E.F_EventID, E.F_EventCode, S.F_GenderCode
	  FROM TS_Event AS E
	  LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	  WHERE F_DisciplineID = @DisciplineID ORDER BY F_Order
	END
	ELSE
	BEGIN
	  INSERT INTO #Tmp_Table (F_EventID, F_EventCode, F_SexCode) 
	  SELECT E.F_EventID, E.F_EventCode, S.F_GenderCode
	  FROM TS_Event AS E
	  LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	  WHERE F_EventID = @EventID
	END
	
    UPDATE A SET A.F_Name = B.F_EventLongName FROM #Tmp_Table AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = 'ENG'
    UPDATE A SET A.F_CHNName = B.F_EventLongName FROM #Tmp_Table AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = 'CHN'

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

