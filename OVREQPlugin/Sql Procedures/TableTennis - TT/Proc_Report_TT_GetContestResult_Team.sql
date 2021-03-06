IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_GetContestResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_GetContestResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_TT_GetContestResult_Team]
----功		  能：得到团体赛Match的描述信息
----作		  者：张翠霞
----日		  期: 2010-01-25



CREATE PROCEDURE [dbo].[Proc_Report_TT_GetContestResult_Team] 
                   (	
					@MatchID			    INT,
					@LanguageCode           CHAR(3)		,
					@Swap                   INT = 0
                   )	
AS
BEGIN
SET NOCOUNT ON
		DECLARE @PosA INT = 1
		DECLARE @PosB INT = 2
		IF @Swap = 1
		BEGIN
			SET @PosA = 2
			SET @PosB = 1
		END

        CREATE TABLE #Temp_table(
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(10),
                                   F_Court         NVARCHAR(100),
                                   F_EventCode     NVARCHAR(20),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(10), 
                                   F_AMatch        INT,
                                   F_BMatch        INT,
                                   F_MatchTime     NVARCHAR(10),
                                   F_MatchResult   NVARCHAR(100),
                                   F_AIRMID         INT,
                                   F_BIRMID         INT,
                                   F_AIRM           NVARCHAR(10),
                                   F_BIRM           NVARCHAR(10),
                                   F_MatchTitle     NVARCHAR(200),
                                   F_CourtNo       INT,
                                   F_Umpire1Des NVARCHAR(100),
                                   F_Umpire2Des NVARCHAR(100),
                                   F_Umpire3Des NVARCHAR(100),
                                   F_ResultA INT,
                                   F_ResultB INT
                                )

        DECLARE @APosID INT
        DECLARE @BPosID INT
        DECLARE @GameCount INT
        SELECT @APosID = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosA
        SELECT @BPosID = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosB
        SET @GameCount = (SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosA) + (SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosB)

        INSERT INTO #Temp_Table(F_MatchID, F_StartTime, F_Court, F_EventCode, F_RoundName, F_MatchNum, F_AName, F_ANOC, F_BName, F_BNOC, F_AMatch, F_BMatch, F_MatchTime, F_MatchResult, F_AIRMID, F_BIRMID, F_CourtNo, F_ResultA, F_ResultB)
        SELECT A.F_MatchID, LEFT(CONVERT (NVARCHAR(100), A.F_StartTime, 108), 5), F.F_CourtShortName, E.F_EventComment, C.F_PhaseShortName, A.F_RaceNum
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = @PosA AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = @PosA AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = @PosB AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = @PosB AND X.F_MatchID = A.F_MatchID)
        ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosA)
        ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosB)
        ,[dbo].[Fun_BD_GetTimeForReport](A.F_SpendTime, @LanguageCode)
        ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 1, 0)
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosA)
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @PosB)
        ,A.F_CourtID
        ,CASE WHEN G.F_ResultID = 1 THEN 1 ELSE 0 END
        ,CASE WHEN H.F_ResultID = 1 THEN 1 ELSE 0 END
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court_Des AS F ON A.F_CourtID = F.F_CourtID AND F.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Match_Result AS G ON G.F_MatchID = A.F_MatchID AND G.F_CompetitionPositionDes1 = @PosA
        LEFT JOIN TS_Match_Result AS H ON H.F_MatchID = A.F_MatchID AND H.F_CompetitionPositionDes1 = @PosB
        WHERE A.F_MatchID = @MatchID

        UPDATE #Temp_table SET F_AIRM = '(' + B.F_IRMCODE + ')' FROM #Temp_table AS A LEFT JOIN TC_IRM AS B ON A.F_AIRMID = B.F_IRMID
        UPDATE #Temp_table SET F_BIRM = '(' + B.F_IRMCODE + ')' FROM #Temp_table AS A LEFT JOIN TC_IRM AS B ON A.F_BIRMID = B.F_IRMID
        UPDATE #Temp_table SET F_MatchTitle = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, -1, 1, @LanguageCode)
        
        CREATE TABLE #TMP_UMPIRE
        (
			RegisterID INT,
			F_Order INT,
			UmpireDes NVARCHAR(100)
        )
        
        INSERT INTO #TMP_UMPIRE (RegisterID, F_Order, UmpireDes)
        (
			SELECT A.F_RegisterID, ROW_NUMBER() OVER( ORDER BY A.F_Order, A.F_RegisterID),
					C.F_PrintShortName + '(' + B.F_NOC + ')'
			FROM TS_Match_Servant AS A
			LEFT JOIN TR_Register AS B ON B.F_RegisterID = A.F_RegisterID
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'ENG'
			WHERE A.F_MatchID = @MatchID
        )
        
        UPDATE #Temp_table SET F_Umpire1Des = (SELECT UmpireDes FROM #TMP_UMPIRE WHERE F_Order = 1)
        UPDATE #Temp_table SET F_Umpire2Des = (SELECT UmpireDes FROM #TMP_UMPIRE WHERE F_Order = 2)
        UPDATE #Temp_table SET F_Umpire3Des = (SELECT UmpireDes FROM #TMP_UMPIRE WHERE F_Order = 3)
        
        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END


GO

