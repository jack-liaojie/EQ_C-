IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetResultsTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetResultsTeam]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_GF_GetResultsTeam]
--描    述：得到当前Event下得各个代表团成绩
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年10月07日


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetResultsTeam](
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
	                            F_RegisterCode  NVARCHAR(10),
                                F_EventID       INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_PrintLN       NVARCHAR(100),
                                F_Round1        INT,
                                F_RoundEx1      NVARCHAR(10),
                                F_R1            NVARCHAR(10),
                                F_ToPar1        INT,
                                F_IRM1          NVARCHAR(10),
                                F_Rank1         INT,
                                F_Round2        INT,
                                F_RoundEx2      NVARCHAR(10),
                                F_R2            NVARCHAR(10),
                                F_ToPar2        INT,
                                F_IRM2          NVARCHAR(10),
                                F_Rank2         INT,
                                F_Round3        INT,
                                F_RoundEx3      NVARCHAR(10),
                                F_R3            NVARCHAR(10),
                                F_ToPar3        INT,
                                F_IRM3          NVARCHAR(10),
                                F_Rank3         INT,
                                F_Round4        INT,
                                F_RoundEx4      NVARCHAR(10),
                                F_R4            NVARCHAR(10),
                                F_ToPar4        INT,
                                F_IRM4          NVARCHAR(10),
                                F_Rank4         INT,
                                F_Total         INT,
                                F_IRM           NVARCHAR(10),
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
	
	INSERT INTO #Tmp_Table(F_TeamID, F_RegisterID, F_RegisterCode, F_EventID, F_NOC, F_NOCDes, F_PrintLN)
	SELECT RM.F_RegisterID, RM.F_MemberRegisterID, R.F_RegisterCode, E.F_EventID, D.F_DelegationCode, DD.F_DelegationLongName, RD.F_PrintLongName
	FROM TR_Register_Member AS RM
	LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID
	LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
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
    
    IF @PhaseOrder = 1
		UPDATE A SET A.F_Total = MR.F_PointsCharDes3
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
		WHERE MR.F_MatchID = @MatchID1
    IF @PhaseOrder = 2
		UPDATE A SET A.F_Total = MR.F_PointsCharDes3
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
		WHERE MR.F_MatchID = @MatchID2
    IF @PhaseOrder = 3
		UPDATE A SET A.F_Total = MR.F_PointsCharDes3
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
		WHERE MR.F_MatchID = @MatchID3
    IF @PhaseOrder = 4
		UPDATE A SET A.F_Total = MR.F_PointsCharDes3
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS MR ON A.F_RegisterID = MR.F_RegisterID
		WHERE MR.F_MatchID = @MatchID4
    
    UPDATE #Tmp_Table SET F_IRM1 = NULL WHERE F_IRM1 IN ('DQ')
    UPDATE #Tmp_Table SET F_IRM2 = NULL WHERE F_IRM2 IN ('DQ')
    UPDATE #Tmp_Table SET F_IRM3 = NULL WHERE F_IRM3 IN ('DQ')
    UPDATE #Tmp_Table SET F_IRM4 = NULL WHERE F_IRM4 IN ('DQ')
    
    UPDATE #Tmp_Table SET F_Round1 = NULL, F_ToPar1 = NULL WHERE F_IRM1 IN ('RTD', 'WD')
    UPDATE #Tmp_Table SET F_Round2 = NULL, F_ToPar2 = NULL WHERE F_IRM2 IN ('RTD', 'WD')
    UPDATE #Tmp_Table SET F_Round3 = NULL, F_ToPar3 = NULL WHERE F_IRM3 IN ('RTD', 'WD')
    UPDATE #Tmp_Table SET F_Round4 = NULL, F_ToPar4 = NULL WHERE F_IRM4 IN ('RTD', 'WD')
  
	UPDATE #Tmp_Table SET F_IRM = [dbo].[Fun_GF_GetTotalIRMCode] (@phaseorder,F_IRM1,F_IRM2,F_IRM3,F_IRM4)
  
    UPDATE #Tmp_Table SET F_Rank1 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (case when F_Round1 is null then 999 else F_Round1 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 1
		
	UPDATE #Tmp_Table SET F_Rank2 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (case when F_Round2 is null then 999 else F_Round2 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 2
		
	UPDATE #Tmp_Table SET F_Rank3 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (case when F_Round3 is null then 999 else F_Round3 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 3
		
	UPDATE #Tmp_Table SET F_Rank4 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID ORDER BY (case when F_Round4 is null then 999 else F_Round4 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 4

    UPDATE #Tmp_Table SET F_RoundEx1 = F_Round1 WHERE F_IRM1 IS NULL
    UPDATE #Tmp_Table SET F_RoundEx1 = F_IRM1 WHERE F_IRM1 IS NOT NULL
    UPDATE #Tmp_Table SET F_RoundEx2 = F_Round2 WHERE F_IRM2 IS NULL
    UPDATE #Tmp_Table SET F_RoundEx2 = F_IRM2 WHERE F_IRM2 IS NOT NULL
    UPDATE #Tmp_Table SET F_RoundEx3 = F_Round3 WHERE F_IRM3 IS NULL
    UPDATE #Tmp_Table SET F_RoundEx3 = F_IRM3 WHERE F_IRM3 IS NOT NULL
    UPDATE #Tmp_Table SET F_RoundEx4 = F_Round4 WHERE F_IRM4 IS NULL
    UPDATE #Tmp_Table SET F_RoundEx4 = F_IRM4 WHERE F_IRM4 IS NOT NULL

    UPDATE #Tmp_Table SET F_R1 = ' *' WHERE F_Rank1 > @PlayerNum
    UPDATE #Tmp_Table SET F_R2 = ' *' WHERE F_Rank2 > @PlayerNum
    UPDATE #Tmp_Table SET F_R3 = ' *' WHERE F_Rank3 > @PlayerNum
    UPDATE #Tmp_Table SET F_R4 = ' *' WHERE F_Rank4 > @PlayerNum
    
	SELECT * FROM #Tmp_Table order by F_Pos,F_TeamID,F_Rank4,F_Rank3,F_Rank2,F_Rank1

Set NOCOUNT OFF
End

GO


