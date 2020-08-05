

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetGroupStatics]    Script Date: 05/03/2011 08:24:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetGroupStatics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetGroupStatics]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetGroupStatics]    Script Date: 05/03/2011 08:24:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










----存储过程名称：[Proc_Report_BD_GetGroupStatics]
----功		  能：得到小组比赛信息
----作		  者：李燕
----日		  期: 2011-03-12
----修  改 记 录：
/*
                 2011-05-03    李燕   获取W,L时，比赛状态可以为110,100
*/


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetGroupStatics]
                     (
	                   @EventID         INT,
	                   @LanguageCode    NVARCHAR(3)
           
                      )
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
                                F_RegisterID      INT,
                                F_PhaseID         INT,
                                F_NOCCode         NVARCHAR(30),
                                F_RegisterSN      NVARCHAR(100),
                                F_RegisterLN      NVARCHAR(100),
                                [Rank]            INT,
                                Match_Played      INT,
                                Match_For         INT,
                                Match_Against     INT,
                                Display_Pos       INT,
                                F_Pos             INT,
                             )

    INSERT INTO #table_tmp(F_RegisterID, F_PhaseID, F_Pos)
    SELECT A.F_RegisterID, B.F_PhaseID, A.F_PhasePosition 
         FROM TS_Phase_Position  AS A
         LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
         LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
         WHERE C.F_EventID = @EventID AND B.F_PhaseIsPool = 1 

    UPDATE #table_tmp SET F_NOCCode = D.F_DelegationCode, F_RegisterLN = C.F_PrintShortName + '(' + D.F_DelegationCode + ')', F_RegisterSN = D.F_DelegationCode
        FROM #table_tmp AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
            LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
            LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
   
            
--------Points
    UPDATE #table_tmp SET Match_Played = B.F_MatchCount FROM #table_tmp AS A LEFT JOIN 
                  (SELECT X.F_RegisterID, Count(Y.F_MatchID)AS F_MatchCount FROM #table_tmp AS X LEFT JOIN TS_Match_Result AS Y ON  X.F_RegisterID = Y.F_RegisterID LEFT JOIN TS_Match AS Z ON Y.F_MatchID = Z.F_MatchID AND Z.F_PhaseID = X.F_PhaseID
                      WHERE Z.F_MatchStatusID in (110, 100) GROUP BY X.F_RegisterID) AS B ON A.F_RegisterID = B.F_RegisterID

    UPDATE #table_tmp SET Match_For = B.F_MatchCount FROM #table_tmp AS A LEFT JOIN 
                  (SELECT X.F_RegisterID, Count(Y.F_MatchID) AS F_MatchCount FROM #table_tmp AS X LEFT JOIN TS_Match_Result AS Y ON  X.F_RegisterID = Y.F_RegisterID LEFT JOIN TS_Match AS Z ON Y.F_MatchID = Z.F_MatchID AND Z.F_PhaseID = X.F_PhaseID
                      WHERE Z.F_MatchStatusID in (110, 100)  AND Y.F_ResultID = 1 GROUP BY X.F_RegisterID) AS B ON A.F_RegisterID = B.F_RegisterID

    UPDATE #table_tmp SET Match_Against = B.F_MatchCount FROM #table_tmp AS A LEFT JOIN 
                  (SELECT X.F_RegisterID, Count(Y.F_MatchID) AS F_MatchCount FROM #table_tmp AS X LEFT JOIN TS_Match_Result AS Y ON  X.F_RegisterID = Y.F_RegisterID LEFT JOIN TS_Match AS Z ON Y.F_MatchID = Z.F_MatchID AND Z.F_PhaseID = X.F_PhaseID
                      WHERE Z.F_MatchStatusID in (110, 100) AND Y.F_ResultID = 2 GROUP BY X.F_RegisterID) AS B ON A.F_RegisterID = B.F_RegisterID

    UPDATE #table_tmp SET Match_Played = IsNULL(Match_Played, 0)
    UPDATE #table_tmp SET Match_For = IsNULL(Match_For, 0)
    UPDATE #table_tmp SET Match_Against = IsNULL(Match_Against, 0)


	
    UPDATE #table_tmp SET [Rank] = B.F_PhaseRank, Display_Pos = B.F_PhaseDisplayPosition FROM #table_tmp AS A LEFT JOIN TS_Phase_Result AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_RegisterID = B.F_RegisterID
	

    SELECT * FROM #table_tmp ORDER BY F_Pos

SET NOCOUNT OFF
END


GO


