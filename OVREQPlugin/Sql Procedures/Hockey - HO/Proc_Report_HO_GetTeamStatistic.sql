IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetTeamStatistic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetTeamStatistic]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_HO_GetTeamStatistic]
----功		  能：得到当前Event下队伍的技术统计
----作		  者：张翠霞
----日		  期: 2012-09-06

CREATE PROCEDURE [dbo].[Proc_Report_HO_GetTeamStatistic]
             @EventID         INT,
             @Type            INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Statistic(
								F_RegisterID          INT,
								F_TeamName            NVARCHAR(100),
								F_MatchNum      	  INT,
								F_HTotal              NVARCHAR(50),
								F_HPercent            NVARCHAR(50),
								F_HFG                 NVARCHAR(50),
								F_HPC                 NVARCHAR(50),
								F_HPS                 NVARCHAR(50),
								F_VTotal              NVARCHAR(50),
								F_VPercent            NVARCHAR(50),
								F_VFG                 NVARCHAR(50),
								F_VPC                 NVARCHAR(50),
								F_VPS                 NVARCHAR(50),
								F_HGoalA              INT,
								F_HTotalA             INT,
								F_HFGGoal             INT,
								F_HFGTotal            INT,
								F_HPCGoal             INT,
								F_HPCTotal            INT,
								F_HPSGoal             INT,
								F_HPSTotal            INT,
								F_HGCard              INT,
								F_HYCard              INT,
								F_HRCard              INT,
								F_VGoalA              INT,
								F_VTotalA             INT,
								F_VFGGoal             INT,
								F_VFGTotal            INT,
								F_VPCGoal             INT,
								F_VPCTotal            INT,
								F_VPSGoal             INT,
								F_VPSTotal            INT,
								F_VGCard              INT,
								F_VYCard              INT,
								F_VRCard              INT,
                                )
    
    CREATE TABLE #TableTotal(
                               F_Total       NVARCHAR(10),
                               F_Percent     INT,
                               F_FG          NVARCHAR(10),
                               F_PC          NVARCHAR(10),
                               F_PS          NVARCHAR(10),
                               F_AGoal       INT,
                               F_ATotal      INT,
                               F_FGGoal      INT,
                               F_FGTotal     INT,
                               F_PCGoal      INT,
                               F_PCTotal     INT,
                               F_PSGoal      INT,
                               F_PSTotal     INT,
                               F_GCard       INT,
                               F_YCard       INT,
                               F_RCard       INT,
                             )
    
    INSERT INTO #table_Statistic(F_RegisterID, F_TeamName, F_MatchNum, F_HFGGoal, F_HFGTotal, F_HPCGoal, F_HPCTotal, F_HPSGoal, F_HPSTotal
    , F_HGCard, F_HYCard, F_HRCard, F_VFGGoal, F_VFGTotal, F_VPCGoal, F_VPCTotal, F_VPSGoal, F_VPSTotal, F_VGCard, F_VYCard, F_VRCard)
    SELECT DISTINCT MR.F_RegisterID, RD.F_PrintLongName
    , [dbo].[Fun_HO_GetMatchWonLost](@EventID, MR.F_RegisterID, 4, 0)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 1)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 2)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 3)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 4)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 5)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 6)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 7)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 8)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 1, 9)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 1)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 2)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 3)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 4)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 5)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 6)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 7)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 8)
    , [dbo].[Fun_Report_HO_GetTeamStatistic](@EventID, MR.F_RegisterID, 2, 9)
    FROM TS_Match_Result AS MR
    LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    WHERE E.F_EventID = @EventID AND MR.F_RegisterID IS NOT NULL

    UPDATE #table_Statistic SET F_HGoalA = F_HFGGoal + F_HPCGoal + F_HPSGoal
    UPDATE #table_Statistic SET F_HTotalA = F_HFGTotal + F_HPCTotal + F_HPSTotal
    UPDATE #table_Statistic SET F_VGoalA = F_VFGGoal + F_VPCGoal + F_VPSGoal
    UPDATE #table_Statistic SET F_VTotalA = F_VFGTotal + F_VPCTotal + F_VPSTotal
    UPDATE #table_Statistic SET F_HTotal = CAST(F_HGoalA AS NVARCHAR(3)) + '/' + CAST(F_HTotalA AS NVARCHAR(3)) WHERE F_HGoalA <> 0 AND F_HTotalA <> 0
    UPDATE #table_Statistic SET F_HPercent = CAST((F_HGoalA / 1.00 / F_HTotalA * 100) AS INT) WHERE F_HGoalA <> 0 AND F_HTotalA <> 0
    UPDATE #table_Statistic SET F_HFG = CAST(F_HFGGoal AS NVARCHAR(3)) + '/' + CAST(F_HFGTotal AS NVARCHAR(3)) WHERE F_HFGGoal <> 0 AND F_HFGTotal <> 0
    UPDATE #table_Statistic SET F_HPC = CAST(F_HPCGoal AS NVARCHAR(3)) + '/' + CAST(F_HPCTotal AS NVARCHAR(3)) WHERE F_HPCGoal <> 0 AND F_HPCTotal <> 0
    UPDATE #table_Statistic SET F_HPS = CAST(F_HPSGoal AS NVARCHAR(3)) + '/' + CAST(F_HPSTotal AS NVARCHAR(3)) WHERE F_HPSGoal <> 0 AND F_HPSTotal <> 0
    
    UPDATE #table_Statistic SET F_VTotal = CAST(F_VGoalA AS NVARCHAR(3)) + '/' + CAST(F_VTotalA AS NVARCHAR(3)) WHERE F_VGoalA <> 0 AND F_VTotalA <> 0
    UPDATE #table_Statistic SET F_VPercent = CAST((F_VGoalA / 1.00 / F_VTotalA * 100) AS INT) WHERE F_VGoalA <> 0 AND F_VTotalA <> 0
    UPDATE #table_Statistic SET F_VFG = CAST(F_VFGGoal AS NVARCHAR(3)) + '/' + CAST(F_VFGTotal AS NVARCHAR(3)) WHERE F_VFGGoal <> 0 AND F_VFGTotal <> 0
    UPDATE #table_Statistic SET F_VPC = CAST(F_VPCGoal AS NVARCHAR(3)) + '/' + CAST(F_VPCTotal AS NVARCHAR(3)) WHERE F_VPCGoal <> 0 AND F_VPCTotal <> 0
    UPDATE #table_Statistic SET F_VPS = CAST(F_VPSGoal AS NVARCHAR(3)) + '/' + CAST(F_VPSTotal AS NVARCHAR(3)) WHERE F_VPSGoal <> 0 AND F_VPSTotal <> 0

    INSERT INTO #TableTotal(F_AGoal, F_ATotal, F_FGGoal, F_FGTotal, F_PCGoal, F_PCTotal, F_PSGoal, F_PSTotal, F_GCard, F_YCard, F_RCard)
    SELECT SUM(F_HGoalA), SUM(F_HTotalA), SUM(F_HFGGoal), SUM(F_HFGTotal), SUM(F_HPCGoal), SUM(F_HPCTotal), SUM(F_HPSGoal), SUM(F_HPSTotal), SUM(F_HGCard), SUM(F_HYCard), SUM(F_HRCard)
    FROM #table_Statistic
    
    UPDATE #TableTotal SET F_Total = CAST(F_AGoal AS NVARCHAR(3)) + '/' + CAST(F_ATotal AS NVARCHAR(3)) WHERE F_AGoal <> 0 AND F_ATotal <> 0
    UPDATE #TableTotal SET F_Percent = CAST((F_AGoal / 1.00 / F_ATotal * 100) AS INT) WHERE F_AGoal <> 0 AND F_ATotal <> 0
    UPDATE #TableTotal SET F_FG = CAST(F_FGGoal AS NVARCHAR(3)) + '/' + CAST(F_FGTotal AS NVARCHAR(3)) WHERE F_FGGoal <> 0 AND F_FGTotal <> 0
    UPDATE #TableTotal SET F_PC = CAST(F_PCGoal AS NVARCHAR(3)) + '/' + CAST(F_PCTotal AS NVARCHAR(3)) WHERE F_PCGoal <> 0 AND F_PCTotal <> 0
    UPDATE #TableTotal SET F_PS = CAST(F_PSGoal AS NVARCHAR(3)) + '/' + CAST(F_PSTotal AS NVARCHAR(3)) WHERE F_PSGoal <> 0 AND F_PSTotal <> 0
    
    IF @Type = 1
    BEGIN
		SELECT F_TeamName, F_MatchNum, F_HTotal, F_HPercent, F_HFG, F_HPC, F_HPS, F_HGCard, F_HYCard, F_HRCard
		, F_VTotal, F_VPercent, F_VFG, F_VPC, F_VPS, F_VGCard, F_VYCard, F_VRCard
		FROM #table_Statistic		
    END
    ELSE IF @Type = 2
    BEGIN
		SELECT F_Total, F_Percent, F_FG, F_PC, F_PS, F_GCard, F_YCard, F_RCard
		FROM #TableTotal
    END
    
Set NOCOUNT OFF
End

GO
/*EXEC Proc_Report_HO_GetTeamStatistic 16, 1, 'CHN'*/



