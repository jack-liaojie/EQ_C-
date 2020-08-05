IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetEventGroupList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetEventGroupList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_HO_GetEventGroupList]
--描    述：得到Event下的Group列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年09月06日


CREATE PROCEDURE [dbo].[Proc_Report_HO_GetEventGroupList](
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
                                F_PhaseName     NVARCHAR(50),
                                F_Count         INT,
							)
							
    IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID AND F_DisciplineID = @DisciplineID)
    BEGIN
      RETURN
    END
    
    INSERT INTO #Tmp_Table(F_PhaseID, F_PhaseName)
    SELECT A.F_PhaseID, C.F_PhaseLongName
    FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
    WHERE A.F_EventID = @EventID AND B.F_DisciplineID = @DisciplineID AND A.F_PhaseIsPool = 1
    
    UPDATE A SET A.F_Count = B.[Count] FROM #Tmp_Table AS A LEFT JOIN
    (SELECT COUNT(PP.F_PhaseID) AS [Count], PP.F_PhaseID FROM TS_Phase_Position AS PP LEFT JOIN TS_Phase AS P
    ON PP.F_PhaseID = P.F_PhaseID WHERE P.F_PhaseIsPool = 1 AND P.F_EventID = @EventID GROUP BY PP.F_PhaseID) AS B ON A.F_PhaseID = B.F_PhaseID

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

GO

/*EXEC Proc_Report_HO_GetEventGroupList 9, 16, 'CHN'*/


