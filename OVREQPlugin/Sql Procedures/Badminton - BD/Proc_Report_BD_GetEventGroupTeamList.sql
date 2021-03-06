IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetEventGroupTeamList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetEventGroupTeamList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_BD_GetEventGroupTeamList]
--描    述：得到Event下的Group下的Team列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年07月14日
---修改:王强2011-2-23，国家名使用短名


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetEventGroupTeamList](
                                                @DisciplineID       INT,
												@EventID            INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_PhaseID          INT,
                                F_Position         INT,
                                F_RegisterName     NVARCHAR(150),
                                F_Count            INT
							)
							
    CREATE TABLE #table_Count(
	                            F_PhaseID     INT,
	                            F_Count       INT
	                          )
							
    IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID AND F_DisciplineID = @DisciplineID)
    BEGIN
      RETURN
    END
    
    INSERT INTO #Tmp_Table(F_PhaseID, F_Position, F_RegisterName)
    SELECT C.F_PhaseID, C.F_PhasePosition, D.F_PrintShortName
    FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    LEFT JOIN TS_Phase_Position AS C ON A.F_PhaseID = C.F_PhaseID
    LEFT JOIN TR_Register AS M ON C.F_RegisterID = M.F_RegisterID
    LEFT JOIN TC_Delegation AS N ON M.F_DelegationID = N.F_DelegationID
    LEFT JOIN TR_Register_Des AS D ON M.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode  
    WHERE A.F_EventID = @EventID AND B.F_DisciplineID = @DisciplineID AND (A.F_PhaseIsPool = 1 OR A.F_PhaseType=2)
    
    INSERT INTO #table_Count(F_PhaseID, F_Count)
    SELECT C.F_PhaseID, COUNT(C.F_PhaseID) + 5
    FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    LEFT JOIN TS_Phase_Position AS C ON A.F_PhaseID = C.F_PhaseID
    WHERE A.F_EventID = @EventID AND B.F_DisciplineID = @DisciplineID AND (A.F_PhaseIsPool = 1 OR A.F_PhaseType=2)
    GROUP BY C.F_PhaseID
    
    UPDATE A SET A.F_Count = B.F_Count FROM #Tmp_Table AS A LEFT JOIN #table_Count AS B ON A.F_PhaseID = B.F_PhaseID

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF






GO

