IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CalTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CalTeamResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_CalTeamResult]
--描    述: 计算团体比赛成绩
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年12月14日


CREATE PROCEDURE [dbo].[Proc_GF_CalTeamResult](
												@MatchID		    INT,
												@IsDetail           INT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
	                            F_TeamID        INT,
	                            F_RegisterID    INT,
	                            F_Bib           INT,
                                F_EventID       INT,
                                F_NOC           NVARCHAR(10),
                                F_Round1        INT,
                                F_ToPar1        INT,
                                F_IRM1          NVARCHAR(10),
                                F_Rank1         INT,
                                F_Round2        INT,
                                F_ToPar2        INT,
                                F_IRM2          NVARCHAR(10),
                                F_Rank2         INT,
                                F_Round3        INT,
                                F_ToPar3        INT,
                                F_IRM3          NVARCHAR(10),
                                F_Rank3         INT,
                                F_Round4        INT,
                                F_ToPar4        INT,
                                F_IRM4          NVARCHAR(10),
                                F_Rank4         INT,
							)                        
							
	DECLARE @SexCode AS INT
	DECLARE @IndividualEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    DECLARE @TeamEventID AS INT
    DECLARE @PlayerNum AS INT
    SELECT @EventID = E.F_EventID, @SexCode = E.F_SexCode, @IndividualEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SET @PlayerNum = (CASE WHEN @SexCode = 1 THEN 3 WHEN @SexCode = 2 THEN 2 ELSE 0 END)
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
	
	INSERT INTO #Tmp_Table(F_TeamID, F_RegisterID, F_EventID, F_NOC, F_Bib)
	SELECT RM.F_RegisterID, RM.F_MemberRegisterID, E.F_EventID, D.F_DelegationCode, R.F_Bib
	FROM TR_Register_Member AS RM
	LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID
	LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	WHERE E.F_EventID = @TeamEventID AND E.F_PlayerRegTypeID = 3 ORDER BY D.F_DelegationCode, CAST(R.F_Bib AS INT)
    
    DECLARE @MatchID1 AS INT
    DECLARE @MatchID2 AS INT
    DECLARE @MatchID3 AS INT
    DECLARE @MatchID4 AS INT
    
    SELECT TOP 1 @MatchID1 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 1 AND M.F_Order = 1
    SELECT TOP 1 @MatchID2 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 2 AND M.F_Order = 1
    SELECT TOP 1 @MatchID3 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 3 AND M.F_Order = 1
    SELECT TOP 1 @MatchID4 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 4 AND M.F_Order = 1
    
    UPDATE A SET A.F_Round1 = MR.F_PointsCharDes1, A.F_ToPar1 = MR.F_PointsCharDes2, F_IRM1 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID1 AND @PhaseOrder >= 1
    
    UPDATE A SET A.F_Round2 = MR.F_PointsCharDes1, A.F_ToPar2 = MR.F_PointsCharDes2, F_IRM2 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID2 AND @PhaseOrder >= 2
    
    UPDATE A SET A.F_Round3 = MR.F_PointsCharDes1, A.F_ToPar3 = MR.F_PointsCharDes2, F_IRM3 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID3 AND @PhaseOrder >= 3
    
    UPDATE A SET A.F_Round4 = MR.F_PointsCharDes1, A.F_ToPar4 = MR.F_PointsCharDes2, F_IRM4 = I.F_IRMCODE
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
    LEFT JOIN TC_IRM AS I ON MR.F_IRMID = I.F_IRMID
    WHERE MR.F_MatchID = @MatchID4 AND @PhaseOrder >= 4
    
    UPDATE #Tmp_Table SET F_IRM1 = NULL WHERE F_IRM1 IN ('DQ')
    UPDATE #Tmp_Table SET F_IRM2 = NULL WHERE F_IRM2 IN ('DQ')
    UPDATE #Tmp_Table SET F_IRM3 = NULL WHERE F_IRM3 IN ('DQ')
    UPDATE #Tmp_Table SET F_IRM4 = NULL WHERE F_IRM4 IN ('DQ')
    
    UPDATE #Tmp_Table SET F_Round1 = NULL, F_ToPar1 = NULL WHERE F_IRM1 IN ('RTD', 'WD')
    UPDATE #Tmp_Table SET F_Round2 = NULL, F_ToPar2 = NULL WHERE F_IRM2 IN ('RTD', 'WD')
    UPDATE #Tmp_Table SET F_Round3 = NULL, F_ToPar3 = NULL WHERE F_IRM3 IN ('RTD', 'WD')
    UPDATE #Tmp_Table SET F_Round4 = NULL, F_ToPar4 = NULL WHERE F_IRM4 IN ('RTD', 'WD')
    
    UPDATE #Tmp_Table SET F_Rank1 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round1 IS NULL THEN 1 ELSE 0 END), F_ToPar1, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 1
		
	UPDATE #Tmp_Table SET F_Rank2 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round2 IS NULL THEN 1 ELSE 0 END), F_ToPar2, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 2
		
	UPDATE #Tmp_Table SET F_Rank3 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round3 IS NULL THEN 1 ELSE 0 END), F_ToPar3, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 3
		
	UPDATE #Tmp_Table SET F_Rank4 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (CASE WHEN F_Round4 IS NULL THEN 1 ELSE 0 END), F_ToPar4, F_Bib) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 4

	CREATE TABLE #Table_TotalRank(
	                               F_TeamID     INT,
	                               F_TeamCode   NVARCHAR(10),
	                               F_Noc        NVARCHAR(10),
	                               F_Round1     INT,
	                               F_ToPar1     NVARCHAR(10),
                                   F_IRM1       NVARCHAR(10),
	                               F_Round2     INT,
	                               F_ToPar2     NVARCHAR(10),
                                   F_IRM2       NVARCHAR(10),	                               
	                               F_Round3     INT,
	                               F_ToPar3     NVARCHAR(10),
                                   F_IRM3       NVARCHAR(10),	                               	                               
	                               F_Round4     INT,
	                               F_ToPar4     NVARCHAR(10),
                                   F_IRM4       NVARCHAR(10),	                               	                               
	                               F_Total      INT,
	                               F_ToPar      NVARCHAR(10),
	                               F_IRM        NVARCHAR(10),
	                               F_Rank       NVARCHAR(10),
								   F_DisplayPos    INT,							   
								   F_Last9HolePoint  INT,
								   F_Last9HoleToPar  INT,
								   F_Last6HolePoint  INT,
								   F_Last6HoleToPar  INT,
								   F_Last3HolePoint  INT,
								   F_Last3HoleToPar  INT,
	                              )
    IF @IsDetail = 1
    BEGIN                                    
        ALTER TABLE #Table_TotalRank ADD                          
                                    F_R4H18Point     INT,
                                    F_R4H18ToPar     INT,
                                    F_R4H17Point     INT,
                                    F_R4H17ToPar     INT,
                                    F_R4H16Point     INT,
                                    F_R4H16ToPar     INT,
                                    F_R4H15Point     INT,
                                    F_R4H15ToPar     INT,
                                    F_R4H14Point     INT,
                                    F_R4H14ToPar     INT,
                                    F_R4H13Point     INT,
                                    F_R4H13ToPar     INT,
                                    F_R4H12Point     INT,
                                    F_R4H12ToPar     INT,
                                    F_R4H11Point     INT,
                                    F_R4H11ToPar     INT,
                                    F_R4H10Point     INT,
                                    F_R4H10ToPar     INT,
                                    F_R4H09Point     INT,
                                    F_R4H09ToPar     INT,
                                    F_R4H08Point     INT,
                                    F_R4H08ToPar     INT,
                                    F_R4H07Point     INT,
                                    F_R4H07ToPar     INT,
                                    F_R4H06Point     INT,
                                    F_R4H06ToPar     INT,
                                    F_R4H05Point     INT,
                                    F_R4H05ToPar     INT,
                                    F_R4H04Point     INT,
                                    F_R4H04ToPar     INT,
                                    F_R4H03Point     INT,
                                    F_R4H03ToPar     INT,
                                    F_R4H02Point     INT,
                                    F_R4H02ToPar     INT,
                                    F_R4H01Point     INT,
                                    F_R4H01ToPar     INT,

                                    F_R3H18Point     INT,
                                    F_R3H18ToPar     INT,
                                    F_R3H17Point     INT,
                                    F_R3H17ToPar     INT,
                                    F_R3H16Point     INT,
                                    F_R3H16ToPar     INT,
                                    F_R3H15Point     INT,
                                    F_R3H15ToPar     INT,
                                    F_R3H14Point     INT,
                                    F_R3H14ToPar     INT,
                                    F_R3H13Point     INT,
                                    F_R3H13ToPar     INT,
                                    F_R3H12Point     INT,
                                    F_R3H12ToPar     INT,
                                    F_R3H11Point     INT,
                                    F_R3H11ToPar     INT,
                                    F_R3H10Point     INT,
                                    F_R3H10ToPar     INT,
                                    F_R3H09Point     INT,
                                    F_R3H09ToPar     INT,
                                    F_R3H08Point     INT,
                                    F_R3H08ToPar     INT,
                                    F_R3H07Point     INT,
                                    F_R3H07ToPar     INT,
                                    F_R3H06Point     INT,
                                    F_R3H06ToPar     INT,
                                    F_R3H05Point     INT,
                                    F_R3H05ToPar     INT,
                                    F_R3H04Point     INT,
                                    F_R3H04ToPar     INT,
                                    F_R3H03Point     INT,
                                    F_R3H03ToPar     INT,
                                    F_R3H02Point     INT,
                                    F_R3H02ToPar     INT,
                                    F_R3H01Point     INT,
                                    F_R3H01ToPar     INT,
                                    
                                    F_R2H18Point     INT,
                                    F_R2H18ToPar     INT,
                                    F_R2H17Point     INT,
                                    F_R2H17ToPar     INT,
                                    F_R2H16Point     INT,
                                    F_R2H16ToPar     INT,
                                    F_R2H15Point     INT,
                                    F_R2H15ToPar     INT,
                                    F_R2H14Point     INT,
                                    F_R2H14ToPar     INT,
                                    F_R2H13Point     INT,
                                    F_R2H13ToPar     INT,
                                    F_R2H12Point     INT,
                                    F_R2H12ToPar     INT,
                                    F_R2H11Point     INT,
                                    F_R2H11ToPar     INT,
                                    F_R2H10Point     INT,
                                    F_R2H10ToPar     INT,
                                    F_R2H09Point     INT,
                                    F_R2H09ToPar     INT,
                                    F_R2H08Point     INT,
                                    F_R2H08ToPar     INT,
                                    F_R2H07Point     INT,
                                    F_R2H07ToPar     INT,
                                    F_R2H06Point     INT,
                                    F_R2H06ToPar     INT,
                                    F_R2H05Point     INT,
                                    F_R2H05ToPar     INT,
                                    F_R2H04Point     INT,
                                    F_R2H04ToPar     INT,
                                    F_R2H03Point     INT,
                                    F_R2H03ToPar     INT,
                                    F_R2H02Point     INT,
                                    F_R2H02ToPar     INT,
                                    F_R2H01Point     INT,
                                    F_R2H01ToPar     INT,
                                   
                                    F_R1H18Point     INT,
                                    F_R1H18ToPar     INT,
                                    F_R1H17Point     INT,
                                    F_R1H17ToPar     INT,
                                    F_R1H16Point     INT,
                                    F_R1H16ToPar     INT,
                                    F_R1H15Point     INT,
                                    F_R1H15ToPar     INT,
                                    F_R1H14Point     INT,
                                    F_R1H14ToPar     INT,
                                    F_R1H13Point     INT,
                                    F_R1H13ToPar     INT,
                                    F_R1H12Point     INT,
                                    F_R1H12ToPar     INT,
                                    F_R1H11Point     INT,
                                    F_R1H11ToPar     INT,
                                    F_R1H10Point     INT,
                                    F_R1H10ToPar     INT,
                                    F_R1H09Point     INT,
                                    F_R1H09ToPar     INT,
                                    F_R1H08Point     INT,
                                    F_R1H08ToPar     INT,
                                    F_R1H07Point     INT,
                                    F_R1H07ToPar     INT,
                                    F_R1H06Point     INT,
                                    F_R1H06ToPar     INT,
                                    F_R1H05Point     INT,
                                    F_R1H05ToPar     INT,
                                    F_R1H04Point     INT,
                                    F_R1H04ToPar     INT,
                                    F_R1H03Point     INT,
                                    F_R1H03ToPar     INT,
                                    F_R1H02Point     INT,
                                    F_R1H02ToPar     INT,
                                    F_R1H01Point     INT,
                                    F_R1H01ToPar     INT                                                                        
    END          	                              
                              
	INSERT INTO #Table_TotalRank(F_TeamID, F_ToPar1, F_Round1, F_IRM1, F_ToPar2, F_Round2, F_IRM2, F_ToPar3, F_Round3, F_IRM3, F_ToPar4, F_Round4, F_IRM4)
	SELECT F_TeamID
	, (SELECT SUM(CASE WHEN F_ToPar1 IS NULL THEN 0 ELSE F_ToPar1 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank1 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank1 < @PlayerNum + 1)
	, [dbo].[Fun_GF_GetTeamRoundHoleInfo] (@IndividualEventID, F_TeamID, 1, 3)
	, (SELECT SUM(CASE WHEN F_ToPar2 IS NULL THEN 0 ELSE F_ToPar2 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank2 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank2 < @PlayerNum + 1)
	, case when @PhaseOrder>=2 then [dbo].[Fun_GF_GetTeamRoundHoleInfo] (@IndividualEventID, F_TeamID, 2, 3) else null end
	, (SELECT SUM(CASE WHEN F_ToPar3 IS NULL THEN 0 ELSE F_ToPar3 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank3 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round3 IS NULL THEN 0 ELSE F_Round3 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank3 < @PlayerNum + 1)
	, case when @PhaseOrder>=3 then [dbo].[Fun_GF_GetTeamRoundHoleInfo] (@IndividualEventID, F_TeamID, 3, 3) else null end
	, (SELECT SUM(CASE WHEN F_ToPar4 IS NULL THEN 0 ELSE F_ToPar4 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank4 < @PlayerNum + 1)
	, (SELECT SUM(CASE WHEN F_Round4 IS NULL THEN 0 ELSE F_Round4 END) FROM #Tmp_Table WHERE F_TeamID = A.F_TeamID AND F_Rank4 < @PlayerNum + 1)
	, case when @PhaseOrder>=4 then [dbo].[Fun_GF_GetTeamRoundHoleInfo] (@IndividualEventID, F_TeamID, 4, 3) else null end
	FROM #Tmp_Table AS A GROUP BY A.F_TeamID
    
    IF @PhaseOrder = 1
	UPDATE #Table_TotalRank SET F_Total = (CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END)
	, F_ToPar = (CASE WHEN F_ToPar1 IS NULL THEN 0 ELSE F_ToPar1 END)
    IF @PhaseOrder = 2
	UPDATE #Table_TotalRank SET F_Total = (CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) + (CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END)
	, F_ToPar = (CASE WHEN F_ToPar1 IS NULL THEN 0 ELSE F_ToPar1 END) + (CASE WHEN F_ToPar2 IS NULL THEN 0 ELSE F_ToPar2 END)
    IF @PhaseOrder = 3
	UPDATE #Table_TotalRank SET F_Total = (CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) + (CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END)
	+ (CASE WHEN F_Round3 IS NULL THEN 0 ELSE F_Round3 END)
	, F_ToPar = (CASE WHEN F_ToPar1 IS NULL THEN 0 ELSE F_ToPar1 END) + (CASE WHEN F_ToPar2 IS NULL THEN 0 ELSE F_ToPar2 END)
	+ (CASE WHEN F_ToPar3 IS NULL THEN 0 ELSE F_ToPar3 END)
    IF @PhaseOrder = 4
	UPDATE #Table_TotalRank SET F_Total = (CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) + (CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END)
	+ (CASE WHEN F_Round3 IS NULL THEN 0 ELSE F_Round3 END) + (CASE WHEN F_Round4 IS NULL THEN 0 ELSE F_Round4 END)
	, F_ToPar = (CASE WHEN F_ToPar1 IS NULL THEN 0 ELSE F_ToPar1 END) + (CASE WHEN F_ToPar2 IS NULL THEN 0 ELSE F_ToPar2 END)
	+ (CASE WHEN F_ToPar3 IS NULL THEN 0 ELSE F_ToPar3 END) + (CASE WHEN F_ToPar4 IS NULL THEN 0 ELSE F_ToPar4 END)
	
	UPDATE #Table_TotalRank SET F_Last9HolePoint = [dbo].[Fun_GF_GetTeamLastMuHoleInfo](@IndividualEventID,F_TeamID,@PhaseOrder,1,9)
	UPDATE #Table_TotalRank SET F_Last9HoleToPar = [dbo].[Fun_GF_GetTeamLastMuHoleInfo](@IndividualEventID,F_TeamID,@PhaseOrder,2,9)
	
	UPDATE #Table_TotalRank SET F_Last6HolePoint = [dbo].[Fun_GF_GetTeamLastMuHoleInfo](@IndividualEventID,F_TeamID,@PhaseOrder,1,6)
	UPDATE #Table_TotalRank SET F_Last6HoleToPar = [dbo].[Fun_GF_GetTeamLastMuHoleInfo](@IndividualEventID,F_TeamID,@PhaseOrder,2,6)
	
	UPDATE #Table_TotalRank SET F_Last3HolePoint = [dbo].[Fun_GF_GetTeamLastMuHoleInfo](@IndividualEventID,F_TeamID,@PhaseOrder,1,3)
	UPDATE #Table_TotalRank SET F_Last3HoleToPar = [dbo].[Fun_GF_GetTeamLastMuHoleInfo](@IndividualEventID,F_TeamID,@PhaseOrder,2,3)

	IF @IsDetail = 1
	BEGIN
		UPDATE #Table_TotalRank SET F_R4H18Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,18,1)
		UPDATE #Table_TotalRank SET F_R4H18ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,18,2)
		UPDATE #Table_TotalRank SET F_R4H17Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,17,1)
		UPDATE #Table_TotalRank SET F_R4H17ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,17,2)
		UPDATE #Table_TotalRank SET F_R4H16Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,16,1)
		UPDATE #Table_TotalRank SET F_R4H16ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,16,2)
		UPDATE #Table_TotalRank SET F_R4H15Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,15,1)
		UPDATE #Table_TotalRank SET F_R4H15ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,15,2)
		UPDATE #Table_TotalRank SET F_R4H14Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,14,1)
		UPDATE #Table_TotalRank SET F_R4H14ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,14,2)
		UPDATE #Table_TotalRank SET F_R4H13Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,13,1)
		UPDATE #Table_TotalRank SET F_R4H13ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,13,2)
		UPDATE #Table_TotalRank SET F_R4H12Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,12,1)
		UPDATE #Table_TotalRank SET F_R4H12ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,12,2)
		UPDATE #Table_TotalRank SET F_R4H11Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,11,1)
		UPDATE #Table_TotalRank SET F_R4H11ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,11,2)
		UPDATE #Table_TotalRank SET F_R4H10Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,10,1)
		UPDATE #Table_TotalRank SET F_R4H10ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,10,2)
		UPDATE #Table_TotalRank SET F_R4H09Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,9,1)
		UPDATE #Table_TotalRank SET F_R4H09ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,9,2)
		UPDATE #Table_TotalRank SET F_R4H08Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,8,1)
		UPDATE #Table_TotalRank SET F_R4H08ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,8,2)
		UPDATE #Table_TotalRank SET F_R4H07Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,7,1)
		UPDATE #Table_TotalRank SET F_R4H07ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,7,2)
		UPDATE #Table_TotalRank SET F_R4H06Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,6,1)
		UPDATE #Table_TotalRank SET F_R4H06ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,6,2)
		UPDATE #Table_TotalRank SET F_R4H05Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,5,1)
		UPDATE #Table_TotalRank SET F_R4H05ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,5,2)
		UPDATE #Table_TotalRank SET F_R4H04Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,4,1)
		UPDATE #Table_TotalRank SET F_R4H04ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,4,2)
		UPDATE #Table_TotalRank SET F_R4H03Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,3,1)
		UPDATE #Table_TotalRank SET F_R4H03ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,3,2)
		UPDATE #Table_TotalRank SET F_R4H02Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,2,1)
		UPDATE #Table_TotalRank SET F_R4H02ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,2,2)
		UPDATE #Table_TotalRank SET F_R4H01Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,1,1)
		UPDATE #Table_TotalRank SET F_R4H01ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,4,1,2)

		UPDATE #Table_TotalRank SET F_R3H18Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,18,1)
		UPDATE #Table_TotalRank SET F_R3H18ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,18,2)
		UPDATE #Table_TotalRank SET F_R3H17Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,17,1)
		UPDATE #Table_TotalRank SET F_R3H17ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,17,2)
		UPDATE #Table_TotalRank SET F_R3H16Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,16,1)
		UPDATE #Table_TotalRank SET F_R3H16ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,16,2)
		UPDATE #Table_TotalRank SET F_R3H15Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,15,1)
		UPDATE #Table_TotalRank SET F_R3H15ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,15,2)
		UPDATE #Table_TotalRank SET F_R3H14Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,14,1)
		UPDATE #Table_TotalRank SET F_R3H14ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,14,2)
		UPDATE #Table_TotalRank SET F_R3H13Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,13,1)
		UPDATE #Table_TotalRank SET F_R3H13ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,13,2)
		UPDATE #Table_TotalRank SET F_R3H12Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,12,1)
		UPDATE #Table_TotalRank SET F_R3H12ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,12,2)
		UPDATE #Table_TotalRank SET F_R3H11Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,11,1)
		UPDATE #Table_TotalRank SET F_R3H11ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,11,2)
		UPDATE #Table_TotalRank SET F_R3H10Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,10,1)
		UPDATE #Table_TotalRank SET F_R3H10ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,10,2)
		UPDATE #Table_TotalRank SET F_R3H09Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,9,1)
		UPDATE #Table_TotalRank SET F_R3H09ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,9,2)
		UPDATE #Table_TotalRank SET F_R3H08Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,8,1)
		UPDATE #Table_TotalRank SET F_R3H08ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,8,2)
		UPDATE #Table_TotalRank SET F_R3H07Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,7,1)
		UPDATE #Table_TotalRank SET F_R3H07ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,7,2)
		UPDATE #Table_TotalRank SET F_R3H06Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,6,1)
		UPDATE #Table_TotalRank SET F_R3H06ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,6,2)
		UPDATE #Table_TotalRank SET F_R3H05Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,5,1)
		UPDATE #Table_TotalRank SET F_R3H05ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,5,2)
		UPDATE #Table_TotalRank SET F_R3H04Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,4,1)
		UPDATE #Table_TotalRank SET F_R3H04ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,4,2)
		UPDATE #Table_TotalRank SET F_R3H03Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,3,1)
		UPDATE #Table_TotalRank SET F_R3H03ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,3,2)
		UPDATE #Table_TotalRank SET F_R3H02Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,2,1)
		UPDATE #Table_TotalRank SET F_R3H02ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,2,2)
		UPDATE #Table_TotalRank SET F_R3H01Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,1,1)
		UPDATE #Table_TotalRank SET F_R3H01ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,3,1,2)

		UPDATE #Table_TotalRank SET F_R2H18Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,18,1)
		UPDATE #Table_TotalRank SET F_R2H18ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,18,2)
		UPDATE #Table_TotalRank SET F_R2H17Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,17,1)
		UPDATE #Table_TotalRank SET F_R2H17ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,17,2)
		UPDATE #Table_TotalRank SET F_R2H16Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,16,1)
		UPDATE #Table_TotalRank SET F_R2H16ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,16,2)
		UPDATE #Table_TotalRank SET F_R2H15Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,15,1)
		UPDATE #Table_TotalRank SET F_R2H15ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,15,2)
		UPDATE #Table_TotalRank SET F_R2H14Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,14,1)
		UPDATE #Table_TotalRank SET F_R2H14ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,14,2)
		UPDATE #Table_TotalRank SET F_R2H13Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,13,1)
		UPDATE #Table_TotalRank SET F_R2H13ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,13,2)
		UPDATE #Table_TotalRank SET F_R2H12Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,12,1)
		UPDATE #Table_TotalRank SET F_R2H12ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,12,2)
		UPDATE #Table_TotalRank SET F_R2H11Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,11,1)
		UPDATE #Table_TotalRank SET F_R2H11ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,11,2)
		UPDATE #Table_TotalRank SET F_R2H10Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,10,1)
		UPDATE #Table_TotalRank SET F_R2H10ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,10,2)
		UPDATE #Table_TotalRank SET F_R2H09Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,9,1)
		UPDATE #Table_TotalRank SET F_R2H09ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,9,2)
		UPDATE #Table_TotalRank SET F_R2H08Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,8,1)
		UPDATE #Table_TotalRank SET F_R2H08ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,8,2)
		UPDATE #Table_TotalRank SET F_R2H07Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,7,1)
		UPDATE #Table_TotalRank SET F_R2H07ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,7,2)
		UPDATE #Table_TotalRank SET F_R2H06Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,6,1)
		UPDATE #Table_TotalRank SET F_R2H06ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,6,2)
		UPDATE #Table_TotalRank SET F_R2H05Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,5,1)
		UPDATE #Table_TotalRank SET F_R2H05ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,5,2)
		UPDATE #Table_TotalRank SET F_R2H04Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,4,1)
		UPDATE #Table_TotalRank SET F_R2H04ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,4,2)
		UPDATE #Table_TotalRank SET F_R2H03Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,3,1)
		UPDATE #Table_TotalRank SET F_R2H03ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,3,2)
		UPDATE #Table_TotalRank SET F_R2H02Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,2,1)
		UPDATE #Table_TotalRank SET F_R2H02ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,2,2)
		UPDATE #Table_TotalRank SET F_R2H01Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,1,1)
		UPDATE #Table_TotalRank SET F_R2H01ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,2,1,2)
		UPDATE #Table_TotalRank SET F_R1H18Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,18,1)
		UPDATE #Table_TotalRank SET F_R1H18ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,18,2)
		UPDATE #Table_TotalRank SET F_R1H17Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,17,1)
		UPDATE #Table_TotalRank SET F_R1H17ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,17,2)
		UPDATE #Table_TotalRank SET F_R1H16Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,16,1)
		UPDATE #Table_TotalRank SET F_R1H16ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,16,2)
		UPDATE #Table_TotalRank SET F_R1H15Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,15,1)
		UPDATE #Table_TotalRank SET F_R1H15ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,15,2)
		UPDATE #Table_TotalRank SET F_R1H14Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,14,1)
		UPDATE #Table_TotalRank SET F_R1H14ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,14,2)
		UPDATE #Table_TotalRank SET F_R1H13Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,13,1)
		UPDATE #Table_TotalRank SET F_R1H13ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,13,2)
		UPDATE #Table_TotalRank SET F_R1H12Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,12,1)
		UPDATE #Table_TotalRank SET F_R1H12ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,12,2)
		UPDATE #Table_TotalRank SET F_R1H11Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,11,1)
		UPDATE #Table_TotalRank SET F_R1H11ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,11,2)
		UPDATE #Table_TotalRank SET F_R1H10Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,10,1)
		UPDATE #Table_TotalRank SET F_R1H10ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,10,2)
		UPDATE #Table_TotalRank SET F_R1H09Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,9,1)
		UPDATE #Table_TotalRank SET F_R1H09ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,9,2)
		UPDATE #Table_TotalRank SET F_R1H08Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,8,1)
		UPDATE #Table_TotalRank SET F_R1H08ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,8,2)
		UPDATE #Table_TotalRank SET F_R1H07Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,7,1)
		UPDATE #Table_TotalRank SET F_R1H07ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,7,2)
		UPDATE #Table_TotalRank SET F_R1H06Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,6,1)
		UPDATE #Table_TotalRank SET F_R1H06ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,6,2)
		UPDATE #Table_TotalRank SET F_R1H05Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,5,1)
		UPDATE #Table_TotalRank SET F_R1H05ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,5,2)
		UPDATE #Table_TotalRank SET F_R1H04Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,4,1)
		UPDATE #Table_TotalRank SET F_R1H04ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,4,2)
		UPDATE #Table_TotalRank SET F_R1H03Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,3,1)
		UPDATE #Table_TotalRank SET F_R1H03ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,3,2)
		UPDATE #Table_TotalRank SET F_R1H02Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,2,1)
		UPDATE #Table_TotalRank SET F_R1H02ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,2,2)
		UPDATE #Table_TotalRank SET F_R1H01Point = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,1,1)
		UPDATE #Table_TotalRank SET F_R1H01ToPar = [dbo].[Fun_GF_GetTeamSingleHole](@EventID,F_TeamID,1,1,2)
    END

	UPDATE #Table_TotalRank SET F_IRM = [dbo].[Fun_GF_GetTotalIRMCode] (@phaseorder,F_IRM1,F_IRM2,F_IRM3,F_IRM4)
	
	UPDATE #Table_TotalRank SET F_Rank = B.RankPts
		FROM #Table_TotalRank AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY (CASE WHEN F_IRM IS NOT NULL THEN 1 ELSE 0 END),(CASE WHEN F_Total = 0 THEN 1 ELSE 0 END), F_Total) AS RankPts
		, * FROM #Table_TotalRank)
		AS B ON A.F_TeamID = B.F_TeamID

    IF @IsDetail is null OR @IsDetail <> 1
    BEGIN				
	UPDATE #Table_TotalRank SET F_DisplayPos = B.DisplayPos
		FROM #Table_TotalRank AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY (CASE WHEN F_IRM IS NOT NULL THEN 1 ELSE 0 END),
		F_IRM1,F_IRM2,F_IRM3,F_IRM4, (CASE WHEN F_Total = 0 THEN 1 ELSE 0 END), F_Total,
		F_Round4, F_Round3, F_Round2, F_Round1, 
		F_Last9HolePoint, F_Last6HolePoint, F_Last3HolePoint) AS DisplayPos
		, * FROM #Table_TotalRank)
		AS B ON A.F_TeamID = B.F_TeamID
	END
	ELSE
	BEGIN
		UPDATE #Table_TotalRank SET F_DisplayPos = B.DisplayPos
		FROM #Table_TotalRank AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY (CASE WHEN F_IRM IS NOT NULL THEN 1 ELSE 0 END),
		F_IRM1,F_IRM2,F_IRM3,F_IRM4, (CASE WHEN F_Total = 0 THEN 1 ELSE 0 END), F_Total,
		F_Round4, F_Round3, F_Round2, F_Round1, 
		F_Last9HolePoint, F_Last6HolePoint, F_Last3HolePoint, 
		F_R4H18Point, F_R4H17Point, F_R4H16Point, F_R4H15Point, F_R4H14Point, F_R4H13Point,
		F_R4H12Point, F_R4H11Point, F_R4H10Point, F_R4H09Point, F_R4H08Point, F_R4H07Point,
		F_R4H06Point, F_R4H05Point, F_R4H04Point, F_R4H03Point, F_R4H02Point, F_R4H01Point,
		F_R3H18Point, F_R3H17Point, F_R3H16Point, F_R3H15Point, F_R3H14Point, F_R3H13Point,
		F_R3H12Point, F_R3H11Point, F_R3H10Point, F_R3H09Point, F_R3H08Point, F_R3H07Point,
		F_R3H06Point, F_R3H05Point, F_R3H04Point, F_R3H03Point, F_R3H02Point, F_R3H01Point,
		F_R2H18Point, F_R2H17Point, F_R2H16Point, F_R2H15Point, F_R2H14Point, F_R2H13Point,
		F_R2H12Point, F_R2H11Point, F_R2H10Point, F_R2H09Point, F_R2H08Point, F_R2H07Point,
		F_R2H06Point, F_R2H05Point, F_R2H04Point, F_R2H03Point, F_R2H02Point, F_R2H01Point,
		F_R1H18Point, F_R1H17Point, F_R1H16Point, F_R1H15Point, F_R1H14Point, F_R1H13Point,
		F_R1H12Point, F_R1H11Point, F_R1H10Point, F_R1H09Point, F_R1H08Point, F_R1H07Point,
		F_R1H06Point, F_R1H05Point, F_R1H04Point, F_R1H03Point, F_R1H02Point, F_R1H01Point
		) AS DisplayPos
		, * FROM #Table_TotalRank)
		AS B ON A.F_TeamID = B.F_TeamID
	END
		 
    UPDATE A SET A.F_Noc = D.F_DelegationCode
    FROM #Table_TotalRank AS A
    LEFT JOIN TR_Register AS R ON A.F_TeamID = R.F_RegisterID LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    
	UPDATE #Table_TotalRank SET F_Round1 = NULL, F_ToPar1 = NULL WHERE F_IRM1 IS NOT NULL
	UPDATE #Table_TotalRank SET F_Round2 = NULL, F_ToPar2 = NULL WHERE F_IRM2 IS NOT NULL
	UPDATE #Table_TotalRank SET F_Round3 = NULL, F_ToPar3 = NULL WHERE F_IRM3 IS NOT NULL
	UPDATE #Table_TotalRank SET F_Round4 = NULL, F_ToPar4 = NULL WHERE F_IRM4 IS NOT NULL
	UPDATE #Table_TotalRank SET F_Rank = NULL, F_Total = NULL, F_ToPar = NULL WHERE F_IRM IS NOT NULL
	--UPDATE #Table_TotalRank SET F_Rank = NULL, F_Total = NULL, F_ToPar = NULL WHERE F_Total = 0
    
    UPDATE A SET A.F_TeamCode = B.F_RegisterCode FROM #Table_TotalRank AS A LEFT JOIN TR_Register AS B ON A.F_TeamID = B.F_RegisterID
    UPDATE #Table_TotalRank SET F_Round1 = NULL, F_ToPar1 = NULL WHERE F_Round1 = 0
    UPDATE #Table_TotalRank SET F_Round2 = NULL, F_ToPar2 = NULL WHERE F_Round2 = 0
    UPDATE #Table_TotalRank SET F_Round3 = NULL, F_ToPar3 = NULL WHERE F_Round3 = 0
    UPDATE #Table_TotalRank SET F_Round4 = NULL, F_ToPar4 = NULL WHERE F_Round4 = 0
    UPDATE #Table_TotalRank SET F_Total = NULL, F_ToPar = NULL WHERE F_Total = 0

    UPDATE #Table_TotalRank SET F_ToPar1 = '+'+F_ToPar1 WHERE cast(F_ToPar1 as int) > 0
    UPDATE #Table_TotalRank SET F_ToPar2 = '+'+F_ToPar2 WHERE cast(F_ToPar2 as int) > 0
    UPDATE #Table_TotalRank SET F_ToPar3 = '+'+F_ToPar3 WHERE cast(F_ToPar3 as int) > 0
    UPDATE #Table_TotalRank SET F_ToPar4 = '+'+F_ToPar4 WHERE cast(F_ToPar4 as int) > 0
    UPDATE #Table_TotalRank SET F_ToPar = '+'+F_ToPar WHERE cast(F_ToPar as int) > 0
	
	IF @PhaseOrder = 1
		UPDATE #Table_TotalRank SET F_Round2 = NULL,F_ToPar2 = NULL,F_IRM2 = NULL,F_Round3 = NULL,F_ToPar3 = NULL,F_IRM3 = NULL,F_Round4 = NULL,F_ToPar4 = NULL,F_IRM4 = NULL
	IF @PhaseOrder = 2
		UPDATE #Table_TotalRank SET F_Round3 = NULL,F_ToPar3 = NULL,F_IRM3 = NULL,F_Round4 = NULL,F_ToPar4 = NULL,F_IRM4 = NULL
	IF @PhaseOrder = 3
		UPDATE #Table_TotalRank SET F_Round4 = NULL,F_ToPar4 = NULL,F_IRM4 = NULL
	
	SELECT F_TeamID AS F_TeamID, F_TeamCode AS F_TeamCode, F_Noc AS F_NOC,
	F_Round1 AS F_Round1, F_ToPar1 AS F_ToPar1, F_IRM1 AS F_IRM1,
	F_Round2 AS F_Round2, F_ToPar2 AS F_ToPar2, F_IRM2 AS F_IRM2,
	F_Round3 AS F_Round3, F_ToPar3 AS F_ToPar3, F_IRM3 AS F_IRM3,
	F_Round4 AS F_Round4, F_ToPar4 AS F_ToPar4, F_IRM4 AS F_IRM4,
	F_Total AS F_Total, F_ToPar AS F_ToPar, F_IRM AS F_IRM, F_Rank AS F_Rank, F_DisplayPos AS F_Order
	FROM #Table_TotalRank ORDER BY F_DisplayPos, F_Noc

Set NOCOUNT OFF
End

GO

/*
exec [Proc_GF_CalTeamResult] 2,0
exec [Proc_GF_CalTeamResult] 8,1
*/

