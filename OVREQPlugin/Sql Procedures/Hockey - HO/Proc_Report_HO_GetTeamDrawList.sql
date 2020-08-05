IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetTeamDrawList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetTeamDrawList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_HO_GetTeamDrawList]
--描    述：得到Event下小组成员表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年09月06日


CREATE PROCEDURE [dbo].[Proc_Report_HO_GetTeamDrawList](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
    
    CREATE TABLE #Tmp_Table(
                            F_PhaseID        INT,
                            F_Pos            INT,
                            F_RegisterID     INT,
                            F_RegisterLN     NVARCHAR(150), 
                            F_RegisterSN     NVARCHAR(50)
                            )

    INSERT INTO #Tmp_Table(F_PhaseID, F_Pos, F_RegisterID, F_RegisterLN, F_RegisterSN)
    SELECT A.F_PhaseID, A.F_PhasePosition, A.F_RegisterID, C.F_PrintLongName, D.F_DelegationCode
    FROM TS_Phase_Position AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Phase AS P ON A.F_PhaseID = P.F_PhaseID
    WHERE P.F_EventID = @EventID AND P.F_PhaseIsPool = 1 ORDER BY P.F_Order, A.F_PhasePosition

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End


GO

/*EXEC Proc_Report_HO_GetTeamDrawList 16, 'CHN'*/

