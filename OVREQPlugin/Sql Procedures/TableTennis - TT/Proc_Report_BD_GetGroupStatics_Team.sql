IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetGroupStatics_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetGroupStatics_Team]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_BD_GetGroupStatics_Team]
----功		  能：得到小组比赛信息
----作		  者：张翠霞
----日		  期: 2010-01-26


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetGroupStatics_Team]
                     (
	                   @EventID       INT,
                       @LanguageCode  CHAR(3)
                      )
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
	                            F_PhaseID         INT,
                                Pool              NCHAR(10),
                                Rank              INT,
                                CP                INT,
                                Pts               INT,
                                CW                INT,
                                CL                INT,
                                Match_For         INT,
                                Match_Against     INT,
                                Games_For         INT,
                                Games_Against     INT,
                                Points_For        INT,
                                Points_Against    INT,
                                Display_Pos       INT,
                                F_RegisterID      INT,
                                F_NOC             NVARCHAR(30),
                                F_Name            NVARCHAR(100),
                                F_Order           INT
                             )

    INSERT INTO #table_tmp(F_PhaseID, F_RegisterID, Pool, Pts, Rank, Display_Pos, CW, CL, Match_For, Match_Against, Games_For, Games_Against, Points_For, Points_Against, F_Order)
    SELECT A.F_PhaseID, A.F_RegisterID, B.F_PhaseCode, A.F_PhasePoints, A.F_PhaseRank, A.F_PhaseDisplayPosition
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 1, 1)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 1, 2)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 2, 1)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 2, 2)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 3, 1)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 3, 2)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 4, 1)
    , [dbo].[Fun_BD_GetMatchWonLost](A.F_PhaseID, A.F_RegisterID, 4, 2)
    , B.F_Order
    FROM TS_Phase_Result AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    WHERE B.F_EventID = @EventID AND B.F_PhaseIsPool = 1 ORDER BY B.F_Order
    
    UPDATE #table_tmp SET CP = CW + CL
    UPDATE #table_tmp SET F_NOC = C.F_DelegationCode FROM #table_tmp AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
    UPDATE #table_tmp SET F_Name = B.F_PrintLongName FROM #table_tmp AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode

	SELECT * FROM #table_tmp ORDER BY F_Order, Display_Pos

SET NOCOUNT OFF
END


GO

