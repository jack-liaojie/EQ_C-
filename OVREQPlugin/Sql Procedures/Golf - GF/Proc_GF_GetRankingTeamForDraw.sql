IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetRankingTeamForDraw]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetRankingTeamForDraw]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GF_GetRankingTeamForDraw]
--描    述：得到当前Event下得各个代表团成绩
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2011年02月22日


CREATE PROCEDURE [dbo].[Proc_GF_GetRankingTeamForDraw](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
	                            F_TeamID        INT,
	                            F_RegisterID    INT,
                                F_EventID       INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(10),
                                F_PrintLN       NVARCHAR(100),
                                F_Round1        INT,
                                F_Par1          INT,
                                F_IRM1          NVARCHAR(10),
                                F_Rank1         INT,
                                F_Round2        INT,
                                F_Par2          INT,
                                F_IRM2          NVARCHAR(10),
                                F_Rank2         INT,
                                F_Round3        INT,
                                F_Par3          INT,
                                F_IRM3          NVARCHAR(10),
                                F_Rank3         INT,
                                F_Round4        INT,
                                F_Par4          INT,
                                F_IRM4          NVARCHAR(10),
                                F_Rank4         INT,
                                F_Total         INT,
                                F_Pos           INT
							)
							
	DECLARE @SexCode AS INT
	DECLARE @IndividualEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @TeamEventID AS INT
    DECLARE @PlayerNum AS INT
    SELECT @SexCode = E.F_SexCode, @IndividualEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SET @PlayerNum = (CASE WHEN @SexCode = 1 THEN 3 WHEN @SexCode = 2 THEN 2 ELSE 0 END)
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
	
	INSERT INTO #Tmp_Table(F_TeamID, F_RegisterID, F_EventID, F_NOC, F_NOCDes, F_Bib, F_PrintLN)
	SELECT RM.F_RegisterID, RM.F_MemberRegisterID, E.F_EventID, D.F_DelegationCode, DD.F_DelegationLongName, R.F_Bib, RD.F_PrintLongName
	FROM TR_Register_Member AS RM
	LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID
	LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE E.F_EventID = @TeamEventID AND E.F_PlayerRegTypeID = 3 ORDER BY D.F_DelegationCode, CAST(R.F_Bib AS INT)

    UPDATE #Tmp_Table SET F_Bib = F_NOC + F_Bib
    
    DECLARE @MatchID1 AS INT
    DECLARE @MatchID2 AS INT
    DECLARE @MatchID3 AS INT
    DECLARE @MatchID4 AS INT
    
    SELECT TOP 1 @MatchID1 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 1 AND M.F_Order = 1
    SELECT TOP 1 @MatchID2 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 2 AND M.F_Order = 1
    SELECT TOP 1 @MatchID3 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 3 AND M.F_Order = 1
    SELECT TOP 1 @MatchID4 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 4 AND M.F_Order = 1
    
    UPDATE A SET A.F_Round1 = MR.F_PointsCharDes1, A.F_Par1 = MR.F_PointsCharDes2, F_IRM1 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID1 AND @PhaseOrder >= 1
    
    UPDATE A SET A.F_Round2 = MR.F_PointsCharDes1, A.F_Par2 = MR.F_PointsCharDes2, F_IRM2 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID2 AND @PhaseOrder >= 2
    
    UPDATE A SET A.F_Round3 = MR.F_PointsCharDes1, A.F_Par3 = MR.F_PointsCharDes2, F_IRM3 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID3 AND @PhaseOrder >= 3
    
    UPDATE A SET A.F_Round4 = MR.F_PointsCharDes1, A.F_Par4 = MR.F_PointsCharDes2, F_IRM4 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID4 AND @PhaseOrder >= 4
    
    UPDATE #Tmp_Table SET F_Round1 = NULL, F_Par1 = NULL WHERE F_IRM1 IN ('RTD', 'WD', 'DQ')
    UPDATE #Tmp_Table SET F_Round2 = NULL, F_Par2 = NULL WHERE F_IRM2 IN ('RTD', 'WD') OR (F_IRM1 <> 'DQ' AND F_IRM2 = 'DQ')
    UPDATE #Tmp_Table SET F_Round3 = NULL, F_Par3 = NULL WHERE F_IRM3 IN ('RTD', 'WD') OR (F_IRM1 <> 'DQ' AND F_IRM2 <> 'DQ' AND F_IRM3 = 'DQ')
    UPDATE #Tmp_Table SET F_Round4 = NULL, F_Par4 = NULL WHERE F_IRM4 IN ('RTD', 'WD') OR (F_IRM1 <> 'DQ' AND F_IRM2 <> 'DQ' AND F_IRM3 <> 'DQ' AND F_IRM4 = 'DQ')
    
    UPDATE #Tmp_Table SET F_Rank1 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round1 IS NULL THEN 1 ELSE 0 END), F_Par1, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 1
		
	UPDATE #Tmp_Table SET F_Rank2 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round2 IS NULL THEN 1 ELSE 0 END), F_Par2, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 2
		
	UPDATE #Tmp_Table SET F_Rank3 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round3 IS NULL THEN 1 ELSE 0 END), F_Par3, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 3
		
	UPDATE #Tmp_Table SET F_Rank4 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round4 IS NULL THEN 1 ELSE 0 END), F_Par4, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 4
		
	CREATE TABLE #Table_TotalRank(
	                               F_TeamID     INT,
	                               F_Point1     INT,
	                               F_P1         NVARCHAR(10),
	                               F_Point2     INT,
	                               F_P2         NVARCHAR(10),
	                               F_Point3     INT,
	                               F_P3         NVARCHAR(10),
	                               F_Point4     INT,
	                               F_P4         NVARCHAR(10),
	                               F_Total      INT,
	                               F_Par        NVARCHAR(10),
	                               F_Pos        INT,
	                               F_Noc        NVARCHAR(10),
	                               F_NocDes     NVARCHAR(150),
	                               F_Count      INT,
                                   F_Rank       NVARCHAR(10)
	                              )
	INSERT INTO #Table_TotalRank(F_TeamID, F_P1, F_Point1, F_P2, F_Point2, F_P3, F_Point3, F_P4, F_Point4)
	SELECT F_TeamID
	, (SELECT SUM(CASE WHEN F_Par1 IS NULL THEN 0 ELSE F_Par1 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank1 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank1 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Par2 IS NULL THEN 0 ELSE F_Par2 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank2 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank2 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Par3 IS NULL THEN 0 ELSE F_Par3 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank3 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round3 IS NULL THEN 0 ELSE F_Round3 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank3 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Par4 IS NULL THEN 0 ELSE F_Par4 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank4 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round4 IS NULL THEN 0 ELSE F_Round4 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank4 < @PlayerNum + 1)
	FROM #Tmp_Table AS A GROUP BY A.F_TeamID
	
	UPDATE #Table_TotalRank SET F_Total = (CASE WHEN F_Point1 IS NULL THEN 0 ELSE F_Point1 END) + (CASE WHEN F_Point2 IS NULL THEN 0 ELSE F_Point2 END)
	+ (CASE WHEN F_Point3 IS NULL THEN 0 ELSE F_Point3 END) + (CASE WHEN F_Point4 IS NULL THEN 0 ELSE F_Point4 END)
	, F_Par = (CASE WHEN F_P1 IS NULL THEN 0 ELSE CAST(F_P1 AS INT) END) + (CASE WHEN F_P2 IS NULL THEN 0 ELSE CAST(F_P2 AS INT) END)
	+ (CASE WHEN F_P3 IS NULL THEN 0 ELSE CAST(F_P3 AS INT) END) + (CASE WHEN F_P4 IS NULL THEN 0 ELSE CAST(F_P4 AS INT) END)
	
	UPDATE #Table_TotalRank SET F_Pos = B.RankPts
		FROM #Table_TotalRank AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY (CASE WHEN F_Total = 0 THEN 1 ELSE 0 END), CAST(F_Par AS INT)) AS RankPts
		, * FROM #Table_TotalRank)
		AS B ON A.F_TeamID = B.F_TeamID
		
	--判断是否是最后一场比赛结束，如果是，有并列排名需要重新计算
    IF EXISTS(SELECT F_MatchStatusID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE C.F_EventID = @IndividualEventID AND A.F_MatchStatusID NOT IN (100, 110))
    BEGIN
        GOTO LOPO
    END
    
    IF @PhaseOrder <> 4
    BEGIN
        GOTO LOPO
    END
    
    DECLARE @Count1 AS INT
    DECLARE @Count2 AS INT
    DECLARE @Count3 AS INT
    
    SELECT @Count1 = COUNT(F_Pos) FROM #Table_TotalRank WHERE F_Pos = 1
    SELECT @Count2 = COUNT(F_Pos) FROM #Table_TotalRank WHERE F_Pos = 2
    SELECT @Count3 = COUNT(F_Pos) FROM #Table_TotalRank WHERE F_Pos = 3
    
    IF @Count1 < 2 AND @Count2 < 2 AND @Count3 < 2
    GOTO LOPO
    
    CREATE TABLE #tmp_EventResult(
                                    F_TeamID           INT,
                                    F_Par              INT,
                                    F_R4P18            INT,
                                    F_R4P17            INT,
                                    F_R4P16            INT,
                                    F_R4P15            INT,
                                    F_R4P14            INT,
                                    F_R4P13            INT,
                                    F_R4P12            INT,
                                    F_R4P11            INT,
                                    F_R4P10            INT,
                                    F_R4P9             INT,
                                    F_R4P8             INT,
                                    F_R4P7             INT,
                                    F_R4P6             INT,
                                    F_R4P5             INT,
                                    F_R4P4             INT,
                                    F_R4P3             INT,
                                    F_R4P2             INT,
                                    F_R4P1             INT,
                                    F_R3P18            INT,
                                    F_R3P17            INT,
                                    F_R3P16            INT,
                                    F_R3P15            INT,
                                    F_R3P14            INT,
                                    F_R3P13            INT,
                                    F_R3P12            INT,
                                    F_R3P11            INT,
                                    F_R3P10            INT,
                                    F_R3P9             INT,
                                    F_R3P8             INT,
                                    F_R3P7             INT,
                                    F_R3P6             INT,
                                    F_R3P5             INT,
                                    F_R3P4             INT,
                                    F_R3P3             INT,
                                    F_R3P2             INT,
                                    F_R3P1             INT,
                                    F_R2P18            INT,
                                    F_R2P17            INT,
                                    F_R2P16            INT,
                                    F_R2P15            INT,
                                    F_R2P14            INT,
                                    F_R2P13            INT,
                                    F_R2P12            INT,
                                    F_R2P11            INT,
                                    F_R2P10            INT,
                                    F_R2P9             INT,
                                    F_R2P8             INT,
                                    F_R2P7             INT,
                                    F_R2P6             INT,
                                    F_R2P5             INT,
                                    F_R2P4             INT,
                                    F_R2P3             INT,
                                    F_R2P2             INT,
                                    F_R2P1             INT,
                                    F_R1P18            INT,
                                    F_R1P17            INT,
                                    F_R1P16            INT,
                                    F_R1P15            INT,
                                    F_R1P14            INT,
                                    F_R1P13            INT,
                                    F_R1P12            INT,
                                    F_R1P11            INT,
                                    F_R1P10            INT,
                                    F_R1P9             INT,
                                    F_R1P8             INT,
                                    F_R1P7             INT,
                                    F_R1P6             INT,
                                    F_R1P5             INT,
                                    F_R1P4             INT,
                                    F_R1P3             INT,
                                    F_R1P2             INT,
                                    F_R1P1             INT,
                                    F_Rank             INT
                                  )
                                  
   INSERT INTO #tmp_EventResult(F_TeamID, F_Par
        ,F_R4P18, F_R4P17, F_R4P16, F_R4P15, F_R4P14, F_R4P13, F_R4P12, F_R4P11, F_R4P10, F_R4P9, F_R4P8, F_R4P7, F_R4P6, F_R4P5, F_R4P4, F_R4P3, F_R4P2, F_R4P1
		,F_R3P18, F_R3P17, F_R3P16, F_R3P15, F_R3P14, F_R3P13, F_R3P12, F_R3P11, F_R3P10, F_R3P9, F_R3P8, F_R3P7, F_R3P6, F_R3P5, F_R3P4, F_R3P3, F_R3P2, F_R3P1
		,F_R2P18, F_R2P17, F_R2P16, F_R2P15, F_R2P14, F_R2P13, F_R2P12, F_R2P11, F_R2P10, F_R2P9, F_R2P8, F_R2P7, F_R2P6, F_R2P5, F_R2P4, F_R2P3, F_R2P2, F_R2P1
		,F_R1P18, F_R1P17, F_R1P16, F_R1P15, F_R1P14, F_R1P13, F_R1P12, F_R1P11, F_R1P10, F_R1P9, F_R1P8, F_R1P7, F_R1P6, F_R1P5, F_R1P4, F_R1P3, F_R1P2, F_R1P1
        )
   SELECT F_TeamID, F_Par
        , [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 18, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 17, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 16, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 15, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 14, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 13, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 12, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 11, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 10, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 9, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 8, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 7, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 6, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 5, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 4, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 3, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 2, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 4, 1, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 18, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 17, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 16, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 15, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 14, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 13, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 12, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 11, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 10, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 9, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 8, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 7, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 6, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 5, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 4, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 3, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 2, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 3, 1, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 18, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 17, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 16, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 15, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 14, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 13, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 12, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 11, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 10, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 9, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 8, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 7, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 6, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 5, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 4, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 3, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 2, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 2, 1, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 18, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 17, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 16, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 15, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 14, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 13, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 12, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 11, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 10, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 9, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 8, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 7, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 6, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 5, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 4, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 3, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 2, 2)
		, [dbo].[Fun_GF_GetTeamSingleBestHole](@IndividualEventID, F_TeamID, 1, 1, 2)
   FROM #Table_TotalRank WHERE F_Pos IN (1, 2, 3)
   
   UPDATE #tmp_EventResult SET F_Rank = B.RankPts
		FROM #tmp_EventResult AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY F_Par
		,F_R4P18, F_R4P17, F_R4P16, F_R4P15, F_R4P14, F_R4P13, F_R4P12, F_R4P11, F_R4P10, F_R4P9, F_R4P8, F_R4P7, F_R4P6, F_R4P5, F_R4P4, F_R4P3, F_R4P2, F_R4P1
		,F_R3P18, F_R3P17, F_R3P16, F_R3P15, F_R3P14, F_R3P13, F_R3P12, F_R3P11, F_R3P10, F_R3P9, F_R3P8, F_R3P7, F_R3P6, F_R3P5, F_R3P4, F_R3P3, F_R3P2, F_R3P1
		,F_R2P18, F_R2P17, F_R2P16, F_R2P15, F_R2P14, F_R2P13, F_R2P12, F_R2P11, F_R2P10, F_R2P9, F_R2P8, F_R2P7, F_R2P6, F_R2P5, F_R2P4, F_R2P3, F_R2P2, F_R2P1
		,F_R1P18, F_R1P17, F_R1P16, F_R1P15, F_R1P14, F_R1P13, F_R1P12, F_R1P11, F_R1P10, F_R1P9, F_R1P8, F_R1P7, F_R1P6, F_R1P5, F_R1P4, F_R1P3, F_R1P2, F_R1P1
		) AS RankPts
		, * FROM #tmp_EventResult)
		AS B ON A.F_TeamID = B.F_TeamID
		
   UPDATE #Table_TotalRank SET F_Pos = B.F_Rank
   FROM #Table_TotalRank AS A RIGHT JOIN #tmp_EventResult AS B ON A.F_TeamID = B.F_TeamID
    --结束
	
	LOPO:	
    UPDATE A SET A.F_Noc = D.F_DelegationCode, A.F_NocDes = DD.F_DelegationLongName
    FROM #Table_TotalRank AS A
    LEFT JOIN TR_Register AS R ON A.F_TeamID = R.F_RegisterID LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID
    WHERE DD.F_LanguageCode = @LanguageCode
    
    UPDATE #Table_TotalRank SET F_Point1 = NULL, F_P1 = NULL WHERE F_Point1 = 0
    UPDATE #Table_TotalRank SET F_Point2 = NULL, F_P2 = NULL WHERE F_Point2 = 0
    UPDATE #Table_TotalRank SET F_Point3 = NULL, F_P3 = NULL WHERE F_Point3 = 0
    UPDATE #Table_TotalRank SET F_Point4 = NULL, F_P4 = NULL WHERE F_Point4 = 0
    UPDATE #Table_TotalRank SET F_Total = NULL, F_Par = NULL WHERE F_Total = 0
    UPDATE #Table_TotalRank SET F_P1 = 'E' WHERE F_P1 = 0
    UPDATE #Table_TotalRank SET F_P2 = 'E' WHERE F_P2 = 0
    UPDATE #Table_TotalRank SET F_P3 = 'E' WHERE F_P3 = 0
    UPDATE #Table_TotalRank SET F_P4 = 'E' WHERE F_P4 = 0
    UPDATE #Table_TotalRank SET F_Par = 'E' WHERE F_Par = 0
    UPDATE #Table_TotalRank SET F_Count = (SELECT COUNT(F_Pos) FROM #Table_TotalRank AS B
        WHERE A.F_Pos = B.F_Pos) FROM #Table_TotalRank AS A
        
    UPDATE #Table_TotalRank SET F_Rank = 'T' + CAST(F_Pos AS NVARCHAR(10)) WHERE F_Count > 1
    UPDATE #Table_TotalRank SET F_Rank = CAST(F_Pos AS NVARCHAR(10)) WHERE F_Count = 1
	
	SELECT F_TeamID, F_Pos AS F_TeamOrder FROM #Table_TotalRank ORDER BY F_Pos, F_Noc

Set NOCOUNT OFF
End


GO


