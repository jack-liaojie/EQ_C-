
/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetMatchSplitResult]    Script Date: 05/03/2011 17:28:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetMatchSplitResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetMatchSplitResult]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetMatchSplitResult]    Script Date: 05/03/2011 17:28:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_BD_GetMatchSplitResult]
----功		  能：得到该Match的比分等信息
----作		  者：李燕
----日		  期: 2011-03-16
----修  改 记 录：
/*
                 2011-05-03    李燕   显示IRM
                 2011-05-03    李燕   显示Set比分
*/


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetMatchSplitResult] 
                   (	
					@MatchID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        CREATE TABLE #Temp_table(
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(10),
                                   F_Court         NVARCHAR(100),
                                   F_EventCode     NVARCHAR(20),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ASName        NVARCHAR(100),--新增
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(100),
                                   F_BSName        NVARCHAR(100),--新增
                                   F_BNOC          NVARCHAR(10), 
                                   F_AMatch        INT,
                                   F_BMatch        INT,
                                   F_MatchTime     NVARCHAR(10),
                                   F_SplitID       INT,
                                   F_SplitType     INT,
                                   F_SplitStatus   INT,
                                   F_SplitName     NVARCHAR(100),
                                   F_SplitRegAID   INT,
                                   F_SplitRegBID   INT,
                                   F_SplitAName    NVARCHAR(100),
                                   F_SplitBName    NVARCHAR(100),
                                   F_SplitAScore   INT,
                                   F_SplitBScore   INT,
                                   F_AGame1        INT,
                                   F_AGame2        INT,
                                   F_AGame3        INT,
                                   F_BGame1        INT,
                                   F_BGame2        INT,
                                   F_BGame3        INT,
                                   F_SplitScoreDes NVARCHAR(20),
                                   F_Game1Des      NVARCHAR(20),
                                   F_Game2Des      NVARCHAR(20),
                                   F_Game3Des      NVARCHAR(20),
                                   F_AIRMID        INT,
                                   F_BIRMID        INT,
                                   F_ASplitIRMID   INT,
                                   F_BSplitIRMID   INT,
                                   F_AGame1IRMID   INT,
                                   F_AGame2IRMID   INT,
                                   F_AGame3IRMID   INT,
                                   F_BGame1IRMID   INT,
                                   F_BGame2IRMID   INT,
                                   F_BGame3IRMID   INT,
                                   F_AIRM          NVARCHAR(10),
                                   F_BIRM          NVARCHAR(10),
                                   F_ASplitIRM     NVARCHAR(10),
                                   F_BSplitIRM     NVARCHAR(10),
                                   F_AGame1IRM     NVARCHAR(10),
                                   F_AGame2IRM     NVARCHAR(10),
                                   F_AGame3IRM     NVARCHAR(10),
                                   F_BGame1IRM     NVARCHAR(10),
                                   F_BGame2IRM     NVARCHAR(10),
                                   F_BGame3IRM     NVARCHAR(10),
                                   F_MatchDes      NVARCHAR(100),
                                   F_MatchTitle    NVARCHAR(100),
                                   F_Match         NVARCHAR(20),--add
                                   F_MatchResult   NVARCHAR(100),
                                   F_RegisterAID   INT,--add
                                   F_RegisterBID   INT--add
                                )

        DECLARE @APosID INT
        DECLARE @BPosID INT
        SELECT @APosID = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
        SELECT @BPosID = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2

        INSERT INTO #Temp_Table(
			F_MatchID, F_StartTime, F_Court, F_EventCode, F_RoundName, F_MatchNum, F_RegisterAID, F_RegisterBID, F_AName, F_ASName, F_ANOC, F_BName, F_BSName, F_BNOC, F_AMatch, F_BMatch, F_MatchTime,
			F_SplitType,F_SplitID,F_SplitStatus, F_SplitRegAID,F_SplitRegBID,F_SplitAName,F_SplitBName,F_SplitAScore,F_SplitBScore,F_ASplitIRMID, F_BSplitIRMID,
			F_AIRMID, F_BIRMID, F_MatchDes
        )
        SELECT 
        A.F_MatchID, [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F.F_CourtShortName, E.F_EventComment, C.F_PhaseShortName, CAST(A.F_RaceNum AS INT)
        ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2)
        ,[dbo].[Fun_BD_GetTimeForReport](A.F_SpendTime, @LanguageCode)
        -- SplitType,SplitInfo
        , MSI.F_MatchSplitType
        , MSI.F_MatchSplitID
        , MSI.F_MatchSplitStatusID
        ,(SELECT X.F_RegisterID FROM TS_Match_Split_Result AS X WHERE X.F_CompetitionPosition = 1 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT X.F_RegisterID FROM TS_Match_Split_Result AS X WHERE X.F_CompetitionPosition = 2 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Split_Result AS X LEFT JOIN TR_Register_DES AS Y ON X.F_RegisterID = Y.F_RegisterID AND Y.F_LanguageCode = @LanguageCode WHERE X.F_CompetitionPosition = 1 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Split_Result AS X LEFT JOIN TR_Register_DES AS Y ON X.F_RegisterID = Y.F_RegisterID AND Y.F_LanguageCode = @LanguageCode WHERE X.F_CompetitionPosition = 2 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT X.F_Points FROM TS_Match_Split_Result AS X WHERE X.F_CompetitionPosition = 1 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT X.F_Points FROM TS_Match_Split_Result AS X WHERE X.F_CompetitionPosition = 2 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT X.F_IRMID FROM TS_Match_Split_Result AS X WHERE X.F_CompetitionPosition = 1 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        ,(SELECT X.F_IRMID FROM TS_Match_Split_Result AS X WHERE X.F_CompetitionPosition = 2 AND X.F_MatchID = MSI.F_MatchID AND MSI.F_MatchSplitID = X.F_MatchSplitID)
        -- Math IRM
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2)
       ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 2, 0)
        FROM TS_Match_Split_Info AS MSI LEFT JOIN TS_Match AS A ON MSI.F_MatchID = A.F_MatchID
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court_Des AS F ON A.F_CourtID = F.F_CourtID AND F.F_LanguageCode = @LanguageCode
        WHERE A.F_MatchID = @MatchID AND MSI.F_FatherMatchSplitID = 0 
        
        UPDATE #Temp_Table SET F_SplitName = CASE F_SplitType WHEN 1 THEN 'MS' WHEN 2 THEN 'WS' WHEN 3 THEN 'MD' WHEN 4 THEN 'WD' WHEN 5 THEN 'XD' ELSE '' END
        
        UPDATE #Temp_Table SET F_SplitStatus = 0 WHERE F_SplitStatus IS NULL
        
        UPDATE #Temp_Table SET F_AGame1 = C.F_Points, F_BGame1 = D.F_Points, F_AGame1IRMID = C.F_IRMID, F_BGame1IRMID = D.F_IRMID
          FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_SplitID = B.F_FatherMatchSplitID
             LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
             LEFT JOIN TS_Match_Split_Result AS D ON B.F_MatchID = D.F_MatchID AND B.F_MatchSplitID = D.F_MatchSplitID AND D.F_CompetitionPosition = 2
              WHERE B.F_Order  = 1
       
       UPDATE #Temp_Table SET F_AGame2 = C.F_Points, F_BGame2 = D.F_Points, F_AGame2IRMID = C.F_IRMID, F_BGame2IRMID = D.F_IRMID 
          FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_SplitID = B.F_FatherMatchSplitID
             LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
             LEFT JOIN TS_Match_Split_Result AS D ON B.F_MatchID = D.F_MatchID AND B.F_MatchSplitID = D.F_MatchSplitID AND D.F_CompetitionPosition = 2
              WHERE B.F_Order  = 2
              
        UPDATE #Temp_Table SET F_AGame3 = C.F_Points, F_BGame3 = D.F_Points, F_AGame3IRMID = C.F_IRMID, F_BGame3IRMID = D.F_IRMID 
          FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_SplitID = B.F_FatherMatchSplitID
             LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
             LEFT JOIN TS_Match_Split_Result AS D ON B.F_MatchID = D.F_MatchID AND B.F_MatchSplitID = D.F_MatchSplitID AND D.F_CompetitionPosition = 2
              WHERE B.F_Order  = 3
              
        
             
        UPDATE #Temp_Table SET F_AGame1 = NULL, F_BGame1 = NULL WHERE F_AGame1 + F_BGame1 = 0
        UPDATE #Temp_Table SET F_AGame2 = NULL, F_BGame2 = NULL WHERE F_AGame2 + F_BGame2 = 0
        UPDATE #Temp_Table SET F_AGame3 = NULL, F_BGame3 = NULL WHERE F_AGame3 + F_BGame3 = 0
    
        
        UPDATE #Temp_Table SET F_AIRM = (CASE WHEN A.F_AIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_AIRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BIRM = (CASE WHEN A.F_BIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BIRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_ASplitIRM = (CASE WHEN A.F_ASplitIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_ASplitIRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BSplitIRM = (CASE WHEN A.F_BSplitIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BSplitIRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_AGame1IRM = (CASE WHEN A.F_AGame1IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_AGame1IRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BGame1IRM = (CASE WHEN A.F_BGame1IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BGame1IRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_AGame2IRM = (CASE WHEN A.F_AGame2IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_AGame2IRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BGame2IRM = (CASE WHEN A.F_BGame2IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BGame2IRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_AGame3IRM = (CASE WHEN A.F_AGame3IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_AGame3IRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BGame3IRM = (CASE WHEN A.F_BGame3IRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BGame3IRMID = B.F_IRMID

        UPDATE #Temp_table SET F_SplitScoreDes = ISNULL( CAST(F_SplitAScore AS NVARCHAR(20)), '') + F_ASplitIRM + ' : ' + ISNULL(CAST(F_SplitBScore AS NVARCHAR(20)), '') + F_BSplitIRM
        UPDATE #Temp_Table SET F_Game1Des = ISNULL( CAST(F_AGame1 AS NVARCHAR(10)), '') + F_AGame1IRM + ' : ' + ISNULL(CAST(F_BGame1 AS NVARCHAR(10)), '') + F_BGame1IRM
        UPDATE #Temp_Table SET F_Game2Des = ISNULL( CAST(F_AGame2 AS NVARCHAR(10)), '') + F_AGame2IRM + ' : ' + ISNULL(CAST(F_BGame2 AS NVARCHAR(10)), '') + F_BGame2IRM
        UPDATE #Temp_Table SET F_Game3Des = ISNULL( CAST(F_AGame3 AS NVARCHAR(10)), '') + F_AGame3IRM + ' : ' + ISNULL(CAST(F_BGame3 AS NVARCHAR(10)), '') + F_BGame3IRM
        
        UPDATE #Temp_table SET F_SplitScoreDes = NULL WHERE LTRIM(RTRIM(F_SplitScoreDes)) = ':'
        UPDATE #Temp_table SET F_Game1Des = NULL WHERE LTRIM(RTRIM(F_Game1Des)) = ':'
        UPDATE #Temp_table SET F_Game2Des = NULL WHERE LTRIM(RTRIM(F_Game2Des)) = ':'
        UPDATE #Temp_table SET F_Game3Des = NULL WHERE LTRIM(RTRIM(F_Game3Des)) = ':'
       
        --UPDATE #Temp_table SET F_MatchTitle = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, 0, 1, @LanguageCode)
        UPDATE #Temp_table SET F_MatchTitle = F_AName + F_AIRM + ' - ' + F_BName + F_BIRM
        UPDATE #Temp_table SET F_Match = CAST(F_AMatch AS NVARCHAR(10)) + ' - ' + CAST(F_BMatch AS NVARCHAR(10)) WHERE F_AMatch + F_BMatch <> 0
        UPDATE #Temp_table SET F_MatchResult = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, 0, 2, @LanguageCode)
        SELECT * FROM #Temp_Table
        
        
SET NOCOUNT OFF

END






GO


