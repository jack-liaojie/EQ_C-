
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetEventGroupList]    Script Date: 10/18/2010 19:45:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetEventGroupList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetEventGroupList]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetEventGroupList]    Script Date: 10/18/2010 19:45:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_BD_GetEventGroupList]
--描    述：得到Event下的Group列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年07月14日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetEventGroupList](
                                                @DisciplineID       INT,
												@EventID            INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_PhaseID       INT,
                                F_PhaseName     NVARCHAR(50)
							)
							
    IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID AND F_DisciplineID = @DisciplineID)
    BEGIN
      RETURN
    END
    
    INSERT INTO #Tmp_Table(F_PhaseID, F_PhaseName)
    SELECT A.F_PhaseID, C.F_PhaseLongName
    FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
    WHERE A.F_EventID = @EventID AND B.F_DisciplineID = @DisciplineID AND (A.F_PhaseIsPool = 1 OR A.F_PhaseType = 2)

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF





GO

