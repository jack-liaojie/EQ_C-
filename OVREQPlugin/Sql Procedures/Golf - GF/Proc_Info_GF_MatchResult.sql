IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_GF_MatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_GF_MatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_GF_MatchResult]
----功   能：比赛成绩、单场或者多场
----作	 者：吴定昉
----日   期：2012-09-11 

/*
	参数说明：
	序号	参数名称	参数说明
	1		@MatchID	指定的比赛ID
*/

/*
	功能描述：按照交换协议规范，组织数据。
			  此存储过程遵照内部的MS SQL SERVER编码规范。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_GF_MatchResult]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

    DECLARE @DisciplineCode AS NVARCHAR(50)
    DECLARE @GenderCode     AS NVARCHAR(50)
    DECLARE @EventCode      AS NVARCHAR(50)
    DECLARE @EventID        AS INT
    DECLARE @PhaseCode      AS NVARCHAR(50)
    DECLARE @UnitCode       AS NVARCHAR(50)
    DECLARE @VunueCode      AS NVARCHAR(50)
	DECLARE @LanguageCode   AS CHAR(3)	
	DECLARE @MatchStatusID  INT
	
	SELECT @DisciplineCode = D.F_DisciplineCode, @GenderCode = S.F_GenderCode
	, @EventCode = E.F_EventCode, @EventID = E.F_EventID
	, @PhaseCode = P.F_PhaseCode, @UnitCode = M.F_MatchCode
	, @VunueCode = V.F_VenueCode, @MatchStatusID = M.F_MatchStatusID
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
	WHERE F_MatchID = @MatchID
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	DECLARE @Content AS NVARCHAR(MAX)
	
	
	--团体成绩
	CREATE TABLE #Table_Team(
	                               F_TeamID     INT,
	                               F_Noc        NVARCHAR(10),
	                               F_NocDes     NVARCHAR(150),
	                               F_Round1     INT,
	                               F_RoundEx1   NVARCHAR(10),
	                               F_ToPar1     NVARCHAR(10),
	                               F_IRM1       NVARCHAR(10),
	                               F_Round2     INT,
	                               F_RoundEx2   NVARCHAR(10),
	                               F_ToPar2     NVARCHAR(10),
	                               F_IRM2       NVARCHAR(10),
	                               F_Round3     INT,
	                               F_RoundEx3   NVARCHAR(10),
	                               F_ToPar3     NVARCHAR(10),
	                               F_IRM3       NVARCHAR(10),
	                               F_Round4     INT,
	                               F_RoundEx4   NVARCHAR(10),
	                               F_ToPar4     NVARCHAR(10),
	                               F_IRM4       NVARCHAR(10),
	                               F_Total      INT,
	                               F_TotalEx    NVARCHAR(100),
	                               F_ToPar      NVARCHAR(10),
	                               F_IRM        NVARCHAR(10),	                               
	                               F_Rank       NVARCHAR(10),
								   F_DisplayPos    INT,		                               
	                              )
	                              
	INSERT INTO #Table_Team(F_TeamID, F_Noc, F_NocDes, 
	F_Round1, F_ToPar1, F_IRM1, F_Round2, F_ToPar2, F_IRM2, F_Round3, F_ToPar3, F_IRM3, F_Round4, F_ToPar4, F_IRM4,
	F_Total, F_ToPar, F_IRM, F_Rank, F_DisplayPos)
	EXEC [dbo].[Proc_GF_CalTeamResult] @MatchID, 0
		
    UPDATE A SET A.F_Noc = D.F_DelegationCode, A.F_NocDes = DD.F_DelegationLongName
    FROM #Table_Team AS A
    LEFT JOIN TR_Register AS R ON A.F_TeamID = R.F_RegisterID LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID
    WHERE DD.F_LanguageCode = @LanguageCode
    
    UPDATE #Table_Team SET F_Round1 = NULL, F_ToPar1 = NULL WHERE F_Round1 = 0
    UPDATE #Table_Team SET F_Round2 = NULL, F_ToPar2 = NULL WHERE F_Round2 = 0
    UPDATE #Table_Team SET F_Round3 = NULL, F_ToPar3 = NULL WHERE F_Round3 = 0
    UPDATE #Table_Team SET F_Round4 = NULL, F_ToPar4 = NULL WHERE F_Round4 = 0
    UPDATE #Table_Team SET F_Total = NULL, F_ToPar = NULL WHERE F_Total = 0
    UPDATE #Table_Team SET F_ToPar1 = 'E' WHERE F_ToPar1 = 0
    UPDATE #Table_Team SET F_ToPar2 = 'E' WHERE F_ToPar2 = 0
    UPDATE #Table_Team SET F_ToPar3 = 'E' WHERE F_ToPar3 = 0
    UPDATE #Table_Team SET F_ToPar4 = 'E' WHERE F_ToPar4 = 0
    UPDATE #Table_Team SET F_ToPar = 'E' WHERE F_ToPar = 0
  
    UPDATE #Table_Team SET F_RoundEx1 = F_Round1 WHERE F_IRM1 IS NULL
    UPDATE #Table_Team SET F_RoundEx1 = F_IRM1 WHERE F_IRM1 IS NOT NULL
    UPDATE #Table_Team SET F_RoundEx2 = F_Round2 WHERE F_IRM2 IS NULL
    UPDATE #Table_Team SET F_RoundEx2 = F_IRM2 WHERE F_IRM2 IS NOT NULL
    UPDATE #Table_Team SET F_RoundEx3 = F_Round3 WHERE F_IRM3 IS NULL
    UPDATE #Table_Team SET F_RoundEx3 = F_IRM3 WHERE F_IRM3 IS NOT NULL
    UPDATE #Table_Team SET F_RoundEx4 = F_Round4 WHERE F_IRM4 IS NULL
    UPDATE #Table_Team SET F_RoundEx4 = F_IRM4 WHERE F_IRM4 IS NOT NULL
   
    UPDATE #Table_Team SET F_TotalEx = F_Total WHERE F_IRM IS NULL
    UPDATE #Table_Team SET F_TotalEx = F_IRM WHERE F_IRM IS NOT NULL
    
    DECLARE @n AS INT
    DECLARE @MaxDisPos AS INT
    DECLARE @count AS INT
    SELECT @MaxDisPos = max(F_DisplayPos) FROM #Table_Team
    SET @n = 1
    SET @count = 0
    while(@n<@MaxDisPos)
    begin
		DECLARE @nNVAR AS NVARCHAR(10)
		SET @nNVAR = cast(@n as NVARCHAR(10))
        SELECT @count = COUNT(*) FROM #Table_Team WHERE F_Rank = @nNVAR
		update #Table_Team set F_Rank = 'T' + F_Rank where @count > 1 and F_Rank = @nNVAR
		set @n = @n + 1
    end
	
	--SELECT * FROM #Table_Team ORDER BY case when F_DisplayPos is null then 999 else F_DisplayPos end, F_Noc
	
	--个人成绩
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
                                F_Out1          NVARCHAR(10),
                                F_In1           NVARCHAR(10),
                                F_Round2        INT,
                                F_RoundEx2      NVARCHAR(10),
                                F_R2            NVARCHAR(10),
                                F_ToPar2        INT,
                                F_IRM2          NVARCHAR(10),
                                F_Rank2         INT,
                                F_Out2          NVARCHAR(10),
                                F_In2           NVARCHAR(10),
                                F_Round3        INT,
                                F_RoundEx3      NVARCHAR(10),
                                F_R3            NVARCHAR(10),
                                F_ToPar3        INT,
                                F_IRM3          NVARCHAR(10),
                                F_Rank3         INT,
                                F_Out3          NVARCHAR(10),
                                F_In3           NVARCHAR(10),
                                F_Round4        INT,
                                F_RoundEx4      NVARCHAR(10),
                                F_R4            NVARCHAR(10),
                                F_ToPar4        INT,
                                F_IRM4          NVARCHAR(10),
                                F_Rank4         INT,
                                F_Out4          NVARCHAR(10),
                                F_In4           NVARCHAR(10),
                                F_Total         INT,
                                F_IRM           NVARCHAR(10),
                                F_Pos           INT
							)
							
	DECLARE @SexCode AS INT
	DECLARE @IndividualEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @TeamEventID AS INT
    DECLARE @PlayerNum AS INT
    SELECT @SexCode = E.F_SexCode, @IndividualEventID = E.F_EventID, @PhaseOrder = P.F_Order 
    FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SET @PlayerNum = (CASE WHEN @SexCode = 1 THEN 3 WHEN @SexCode = 2 THEN 2 ELSE 0 END)
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
	
	INSERT INTO #Tmp_Table(F_TeamID, F_RegisterID, F_RegisterCode, F_EventID, F_NOC, F_NOCDes, F_PrintLN)
	SELECT RM.F_RegisterID, RM.F_MemberRegisterID, R.F_RegisterCode, E.F_EventID, 
	D.F_DelegationCode, DD.F_DelegationLongName, RD.F_PrintLongName
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
    
    SELECT TOP 1 @MatchID1 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 1 AND M.F_Order = 1
    SELECT TOP 1 @MatchID2 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 2 AND M.F_Order = 1
    SELECT TOP 1 @MatchID3 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 3 AND M.F_Order = 1
    SELECT TOP 1 @MatchID4 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		WHERE P.F_EventID = @IndividualEventID AND P.F_Order = 4 AND M.F_Order = 1
    
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
    
    --Out,In
    UPDATE T SET T.F_Out1 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order <=9),
				 T.F_In1 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order >9)   
    FROM #Tmp_Table AS T WHERE @PhaseOrder >= 1
 
    UPDATE T SET T.F_Out2 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order <=9),
				 T.F_In2 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order >9)   
    FROM #Tmp_Table AS T WHERE @PhaseOrder >= 2
    
    UPDATE T SET T.F_Out3 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order <=9),
				 T.F_In3 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order >9)   
    FROM #Tmp_Table AS T WHERE @PhaseOrder >= 3
    
    UPDATE T SET T.F_Out4 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order <=9),
				 T.F_In4 = (SELECT SUM(ISNULL(MSR.F_Points,0)) FROM TS_Match_Split_Result AS MSR
    LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
    LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
    WHERE MSR.F_MatchID = @MatchID1 AND MR.F_RegisterID = T.F_RegisterID AND MSI.F_Order >9)   
    FROM #Tmp_Table AS T WHERE @PhaseOrder >= 4
    
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
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID 
		ORDER BY (case when F_Round1 is null then 999 else F_Round1 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 1
		
	UPDATE #Tmp_Table SET F_Rank2 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID 
		ORDER BY (case when F_Round2 is null then 999 else F_Round2 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 2
		
	UPDATE #Tmp_Table SET F_Rank3 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID 
		ORDER BY (case when F_Round3 is null then 999 else F_Round3 end),F_RegisterCode) AS RankPts
		, * FROM #Tmp_Table)
		AS B ON A.F_RegisterID = B.F_RegisterID WHERE @PhaseOrder >= 3
		
	UPDATE #Tmp_Table SET F_Rank4 = B.RankPts
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_TeamID 
		ORDER BY (case when F_Round4 is null then 999 else F_Round4 end),F_RegisterCode) AS RankPts
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
    
	--SELECT * FROM #Tmp_Table order by F_Pos,F_TeamID,F_Rank4,F_Rank3,F_Rank2,F_Rank1
	
	SET @Content = ( SELECT @UnitCode AS [Match],
	                     @PhaseCode AS [Phase],
						 --[Row].[RANK] AS [Rank],
	                     [Row].[F_NocDes] AS [Delegation],
	                     case when @PhaseCode = 4 then ISNULL([Row].F_RoundEx1,'')
	                          when @PhaseCode = 3 then ISNULL([Row].F_RoundEx2,'')
	                          when @PhaseCode = 2 then ISNULL([Row].F_RoundEx3,'')
	                          when @PhaseCode = 1 then ISNULL([Row].F_RoundEx4,'')
	                          end AS [ResultA],
	                     ISNULL([Row].[F_ToPar],'') AS [ResultC],
	                     ISNULL([Row].F_RoundEx1,'') AS [Result1],
	                     ISNULL([Row].F_RoundEx2,'') AS [Result2],
	                     ISNULL([Row].F_RoundEx3,'') AS [Result3],
	                     ISNULL([Row].F_RoundEx4,'') AS [Result4],
	                     ISNULL([Row].F_TotalEx,'') AS [Result],
	                     N'' AS [Status],
	                        [Row1].F_PrintLN AS [AthleteName],                      
	                     case when @PhaseCode = 4 then ISNULL([Row1].F_RoundEx1,'')
	                          when @PhaseCode = 3 then ISNULL([Row1].F_RoundEx2,'')
	                          when @PhaseCode = 2 then ISNULL([Row1].F_RoundEx3,'')
	                          when @PhaseCode = 1 then ISNULL([Row1].F_RoundEx4,'')
	                          end AS [ResultA],
	                     '' AS [ResultB],
	                     case when @PhaseCode = 4 then ISNULL([Row1].F_ToPar1,'')
	                          when @PhaseCode = 3 then ISNULL([Row1].F_ToPar2,'')
	                          when @PhaseCode = 2 then ISNULL([Row1].F_ToPar3,'')
	                          when @PhaseCode = 1 then ISNULL([Row1].F_ToPar4,'')
	                          end AS [ResultC],
	                     ISNULL([Row1].F_Out1,'') AS [Result1],
	                     ISNULL([Row1].F_In1,'')  AS [Result2],
	                     ISNULL([Row1].F_Out2,'') AS [Result3],
	                     ISNULL([Row1].F_In2,'')  AS [Result4],
	                     ISNULL([Row1].F_Out3,'') AS [Result5],
	                     ISNULL([Row1].F_In3,'')  AS [Result6],
	                     ISNULL([Row1].F_Out4,'') AS [Result7],
	                     ISNULL([Row1].F_In4,'')  AS [Result8],
	                     [Row1].F_Total AS [Result]
	            FROM (SELECT * FROM #Table_Team) AS [Row] 
				LEFT JOIN (SELECT * FROM #Tmp_Table) AS [Row1]
				ON [Row].F_TeamID = [Row1].F_TeamID 
				ORDER BY [Row].F_DisplayPos,[Row1].F_Pos,[Row1].F_Rank4,[Row1].F_Rank3,[Row1].F_Rank2,[Row1].F_Rank1
			FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
		RETURN 
	END

    --SELECT cast( @Content AS XML )
	
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), 
							GETDATE() , 121 ), 12), 5), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'
    
	IF @DisciplineCode = 'GF'
		SET @DisciplineCode = 'GO'
	
	DECLARE @OutputEventCode	AS NVARCHAR(10)
	DECLARE @FileName	AS NVARCHAR(100)
	
	SET @OutputEventCode = [dbo].[Func_GF_GetOutputEventCode](@GenderCode, @EventCode)
	SET @FileName =	@DisciplineCode + @GenderCode + @OutputEventCode + @PhaseCode + @UnitCode + N'.0.CHI.1.0'
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC [Proc_Info_GF_MatchResult] 1
--EXEC [Proc_Info_GF_MatchResult] 803