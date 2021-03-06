IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetResult_Single]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetResult_Single]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_BD_GetResult_Single]
----功		  能：得到该Match的比分等信息
----作		  者：张翠霞
----日		  期: 2010-01-23
----修		  改：管仁良 2010-10-19 添加Game6 Game7
--- 修改:王强2011-1-17增加一些信息



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetResult_Single] 
                   (	
					@MatchID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        CREATE TABLE #Temp_table(
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(30),
                                   F_Date          NVARCHAR(20),
                                   F_Court         NVARCHAR(100),
                                   F_EventCode     NVARCHAR(20),
                                   F_RoundName     NVARCHAR(300),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(300),
                                   F_ASName        NVARCHAR(300),--新增
                                   F_ANOC          NVARCHAR(30),
                                   F_BName         NVARCHAR(300),
                                   F_BSName        NVARCHAR(300),--新增
                                   F_BNOC          NVARCHAR(30), 
                                   F_AMatch        INT,
                                   F_BMatch        INT,
                                   F_AMatchDes     NVARCHAR(30),
                                   F_BMatchDes     NVARCHAR(30),
                                   F_MatchTime     NVARCHAR(30),
                                   F_AGame1        NVARCHAR(30),
                                   F_AGame2        NVARCHAR(30), 
                                   F_AGame3        NVARCHAR(30),
                                   F_AGame4        NVARCHAR(30),
                                   F_AGame5        NVARCHAR(30),
                                   F_AGame6		   NVARCHAR(30),
                                   F_AGame7		   NVARCHAR(30),
                                   F_BGame1        NVARCHAR(30),
                                   F_BGame2        NVARCHAR(30),
                                   F_BGame3        NVARCHAR(30),
                                   F_BGame4        NVARCHAR(30),
                                   F_BGame5        NVARCHAR(30),
                                   F_BGame6        NVARCHAR(30),
                                   F_BGame7        NVARCHAR(30),
                                   F_Game1Time     NVARCHAR(30),
                                   F_Game2Time     NVARCHAR(30),
                                   F_Game3Time     NVARCHAR(30),
                                   F_Game4Time     NVARCHAR(30),
                                   F_Game5Time     NVARCHAR(30),
                                   F_Game6Time     NVARCHAR(30),
                                   F_Game7Time     NVARCHAR(30),                                   
                                   F_MatchDes      NVARCHAR(300),
                                   F_AIRMID        INT,
                                   F_BIRMID        INT,
                                   F_AIRM          NVARCHAR(30),
                                   F_BIRM          NVARCHAR(30),
                                   F_MatchTitle    NVARCHAR(300),
                                   F_Match         NVARCHAR(30),--add
                                   F_MatchResult   NVARCHAR(300),
                                   F_RegisterAID   INT,--add
                                   F_RegisterBID   INT,--add
                                   F_CourtNo       INT,
                                   F_ResultA   INT,
                                   F_ResultB   INT,
                                   F_NameA1 NVARCHAR(100),
                                   F_NameA2 NVARCHAR(100),
                                   F_NameB1 NVARCHAR(100),
                                   F_NameB2 NVARCHAR(100),
                                   F_NOCA1 NVARCHAR(20),
                                   F_NOCA2 NVARCHAR(20),
                                   F_NOCB1 NVARCHAR(20),
                                   F_NOCB2 NVARCHAR(20)
                                )

        DECLARE @APosID INT
        DECLARE @BPosID INT
        SELECT @APosID = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
        SELECT @BPosID = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2

        INSERT INTO #Temp_Table(
			F_MatchID, F_StartTime, F_Court, F_EventCode, F_RoundName, F_MatchNum, F_RegisterAID, F_RegisterBID, F_AName, F_ASName, F_ANOC, F_BName, F_BSName, F_BNOC, 
			F_AMatch, F_BMatch,F_AMatchDes, F_BMatchDes, F_MatchTime,
			F_AGame1, F_AGame2, F_AGame3, F_AGame4, F_AGame5, F_AGame6, F_AGame7,
			F_BGame1, F_BGame2, F_BGame3, F_BGame4, F_BGame5, F_BGame6, F_BGame7, 
			F_Game1Time, F_Game2Time, F_Game3Time, F_Game4Time, F_Game5Time, F_Game6Time, F_Game7Time,
			F_AIRMID, F_BIRMID, F_MatchDes, F_CourtNo, F_ResultA, F_ResultB
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
        ,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_CompetitionPositionDes1 = 1)
        ,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_CompetitionPositionDes1 = 2)
        ,[dbo].[Fun_BD_GetTimeForReport](A.F_SpendTime, @LanguageCode)
        -- AGame Points
        ,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 1 AND X.F_CompetitionPosition = @APosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 2 AND X.F_CompetitionPosition = @APosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 3 AND X.F_CompetitionPosition = @APosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 4 AND X.F_CompetitionPosition = @APosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 5 AND X.F_CompetitionPosition = @APosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 6 AND X.F_CompetitionPosition = @APosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 7 AND X.F_CompetitionPosition = @APosID)
        -- BGame Points
        ,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 1 AND X.F_CompetitionPosition = @BPosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 2 AND X.F_CompetitionPosition = @BPosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 3 AND X.F_CompetitionPosition = @BPosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 4 AND X.F_CompetitionPosition = @BPosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 5 AND X.F_CompetitionPosition = @BPosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 6 AND X.F_CompetitionPosition = @BPosID)
		,(SELECT ISNULL( CONVERT( NVARCHAR(30), F_Points),'') +  ISNULL('(' + Y.F_IRMCODE + ')','')
			FROM TS_Match_Split_Result AS X LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = X.F_IRMID
			WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = 7 AND X.F_CompetitionPosition = @BPosID)
        -- Game Time
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 1)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 2)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 3)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 4)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 5)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 6)
        ,(SELECT [dbo].[Fun_BD_GetTimeForReport](F_SpendTime, @LanguageCode) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = 7)
        -- Math IRM
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2)
        ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 2, 0)
        ,F.F_CourtID
        ,CASE WHEN G.F_ResultID = 1 THEN 1 ELSE 0 END
        ,CASE WHEN H.F_ResultID = 1 THEN 1 ELSE 0 END
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court_Des AS F ON A.F_CourtID = F.F_CourtID AND F.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Match_Result AS G ON G.F_MatchID = A.F_MatchID AND G.F_CompetitionPositionDes1 = 1
        LEFT JOIN TS_Match_Result AS H ON H.F_MatchID = A.F_MatchID AND H.F_CompetitionPositionDes1 = 2
        WHERE A.F_MatchID = @MatchID
        
        --UPDATE #Temp_Table SET F_AGame1 = NULL, F_BGame1 = NULL, F_Game1Time = NULL WHERE F_AGame1 + F_BGame1 = 0
        --UPDATE #Temp_Table SET F_AGame2 = NULL, F_BGame2 = NULL, F_Game2Time = NULL WHERE F_AGame2 + F_BGame2 = 0
        --UPDATE #Temp_Table SET F_AGame3 = NULL, F_BGame3 = NULL, F_Game3Time = NULL WHERE F_AGame3 + F_BGame3 = 0
        --UPDATE #Temp_Table SET F_AGame4 = NULL, F_BGame4 = NULL, F_Game4Time = NULL WHERE F_AGame4 + F_BGame4 = 0
        --UPDATE #Temp_Table SET F_AGame5 = NULL, F_BGame5 = NULL, F_Game5Time = NULL WHERE F_AGame5 + F_BGame5 = 0
        --UPDATE #Temp_Table SET F_AGame6 = NULL, F_BGame6 = NULL, F_Game6Time = NULL WHERE F_AGame6 + F_BGame6 = 0
        --UPDATE #Temp_Table SET F_AGame7 = NULL, F_BGame7 = NULL, F_Game7Time = NULL WHERE F_AGame7 + F_BGame7 = 0

        UPDATE #Temp_Table SET F_AIRM = (CASE WHEN A.F_AIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_AIRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BIRM = (CASE WHEN A.F_BIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BIRMID = B.F_IRMID
        --UPDATE #Temp_table SET F_MatchTitle = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, 0, 1, @LanguageCode)
        UPDATE #Temp_table SET F_MatchTitle = F_AName + F_AIRM + ' - ' + F_BName + F_BIRM
        UPDATE #Temp_table SET F_Match = dbo.Fun_Report_BD_GetMatchResultDes(@MatchID,12,0)
        UPDATE #Temp_table SET F_MatchResult = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, 0, 2, @LanguageCode)
        
        DECLARE @MatchType INT 
        
        SELECT @MatchType = C.F_PlayerRegTypeID
        FROM TS_Match AS A
        LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
        LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
        WHERE A.F_MatchID = @MatchID
        
        UPDATE #Temp_table SET F_NameA1 = F_ASName, F_NameB1 = F_BSName, F_NOCA1 = F_ANOC, F_NOCB1 = F_BNOC
        
        --双打
        IF @MatchType = 2
        BEGIN
			UPDATE #Temp_table SET F_NameA1 = dbo.Fun_BDTT_GetRegisterName(C11.F_MemberRegisterID, 21, 'ENG',0),
								   F_NameA2 = dbo.Fun_BDTT_GetRegisterName(C12.F_MemberRegisterID, 21, 'ENG',0),
								   F_NameB1 = dbo.Fun_BDTT_GetRegisterName(C21.F_MemberRegisterID, 21, 'ENG',0),
								   F_NameB2 = dbo.Fun_BDTT_GetRegisterName(C22.F_MemberRegisterID, 21, 'ENG',0),
								   F_NOCA1 = dbo.Fun_BDTT_GetPlayerNOC(C11.F_MemberRegisterID),
								   F_NOCA2 = dbo.Fun_BDTT_GetPlayerNOC(C12.F_MemberRegisterID),
								   F_NOCB1 = dbo.Fun_BDTT_GetPlayerNOC(C21.F_MemberRegisterID),
								   F_NOCB2 = dbo.Fun_BDTT_GetPlayerNOC(C22.F_MemberRegisterID)
			FROM #Temp_table AS A
			LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
			LEFT JOIN TR_Register_Member AS C11 ON C11.F_RegisterID = B1.F_RegisterID AND C11.F_Order = 1 
			LEFT JOIN TR_Register_Member AS C12 ON C12.F_RegisterID = B1.F_RegisterID AND C12.F_Order = 2 
			LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
			LEFT JOIN TR_Register_Member AS C21 ON C21.F_RegisterID = B2.F_RegisterID AND C21.F_Order = 1 
			LEFT JOIN TR_Register_Member AS C22 ON C22.F_RegisterID = B2.F_RegisterID AND C22.F_Order = 2
			WHERE A.F_MatchID = @MatchID 
        END
        
        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END



GO

--exec Proc_Report_BD_GetResult_Single 100,'ENG'