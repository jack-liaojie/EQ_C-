IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetIndividualScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetIndividualScore]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_HO_GetIndividualScore]
----功		  能：得到当前Event信息
----作		  者：张翠霞
----日		  期: 2012-09-06

CREATE PROCEDURE [dbo].[Proc_Report_HO_GetIndividualScore]
             @EventID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Statistic(
								F_RegisterID          INT,
								F_Rank                INT,
								F_Bib                 INT,
								F_Name                NVARCHAR(150),
								F_Delegation          NVARCHAR(150),
								F_MatchNum            INT,
								F_FG                  INT,
								F_PC                  INT,
								F_PS                  INT,
								F_Total               INT
                                )
    
    INSERT INTO #table_Statistic(F_RegisterID, F_Bib, F_Name, F_Delegation, F_MatchNum, F_FG, F_PC, F_PS)
    SELECT DISTINCT MA.F_RegisterID, RM.F_ShirtNumber, RD.F_PrintLongName, DD.F_DelegationLongName
    , [dbo].[Fun_Report_HO_GetIndividualStatistic](@EventID, MA.F_RegisterID, 1)
    , [dbo].[Fun_Report_HO_GetIndividualStatistic](@EventID, MA.F_RegisterID, 2)
    , [dbo].[Fun_Report_HO_GetIndividualStatistic](@EventID, MA.F_RegisterID, 3)
    , [dbo].[Fun_Report_HO_GetIndividualStatistic](@EventID, MA.F_RegisterID, 4)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TS_Match AS M ON MA.F_MatchID = M.F_MatchID
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TR_Register_Member AS RM ON MA.F_RegisterID = RM.F_MemberRegisterID
    LEFT JOIN TR_Register AS R ON MA.F_RegisterID = R.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
    WHERE P.F_EventID = @EventID
    
    UPDATE #table_Statistic SET F_Total = F_FG + F_PC + F_PS
    DELETE FROM #table_Statistic WHERE F_Total = 0
    
    UPDATE #table_Statistic SET F_Rank = B.RankTotal
	FROM #table_Statistic AS A 
	LEFT JOIN (SELECT RANK() OVER(ORDER BY F_Total DESC) AS RankTotal, * FROM #table_Statistic)
	AS B ON A.F_RegisterID = B.F_RegisterID
    
    SELECT * FROM #table_Statistic ORDER BY F_Rank, F_Name

    
Set NOCOUNT OFF
End

GO
/*EXEC Proc_Report_HO_GetIndividualScore 16, 'CHN'*/



