IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BD_AllCourtMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BD_AllCourtMatches]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_SCB_BD_AllCourtMatches]
----功		  能：获取所有场地的比赛信息
----作		  者：郑金勇
----日		  期: 2011-07-04
----修 改 记  录：
/*
                  2011-7-5     李燕    修改团体比分的显示
*/


CREATE PROCEDURE [dbo].[Proc_SCB_BD_AllCourtMatches]
            @SelSessionID           INT
AS
BEGIN
	
SET NOCOUNT ON

        DECLARE @DisciplineID		INT
		DECLARE @Date				DateTime
		DECLARE @VenueID            INT
		
		
		SELECT @VenueID = F_VenueID 
		   FROM TD_Discipline_Venue AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID
		   WHERE B.F_DisciplineCode = 'BD'
		 
		
		CREATE TABLE #table_AllCourt(
		                             F_CourtID     INT,
		                             F_CourtOrder  INT
		                             )
		 
		 INSERT INTO #table_AllCourt (F_CourtID, F_CourtOrder)
			SELECT F_CourtID, ROW_NUMBER() OVER (ORDER BY F_CourtCode)
			  FROM TC_Court WHERE F_VenueID = @VenueID ORDER BY F_CourtCode 
      
      CREATE TABLE #table_courtmatch( 
                                     F_MatchID      INT,
                                     F_CourtOrder   INT,
                                     F_MatchStatus  INT,
                                     F_StartTime    DATETIME,
                                     F_CourtID      INT,
                                     F_StatusOrder  INT,
                                     F_RowNo        INT,
                                     F_RowNoByTime  INT,
                                     F_RowSub       INT,
                                     F_RowNo_Official  INT,
                                     F_RowNo_Schedule  INT,
                                     F_RowNo_MaxOff    INT
                                     )
      
       INSERT INTO #table_courtmatch(F_MatchID, F_MatchStatus, F_StartTime, F_CourtID)
          SELECT  F_MatchID, F_MatchStatusID, CAST( RIGHT(CONVERT(NVARCHAR(MAX), F_StartTime , 121 ), 12) AS DATETIME), F_CourtID
             FROM TS_Match 
             WHERE F_SessionID = @SelSessionID 
        
        UPDATE #table_courtmatch SET F_StatusOrder = CASE F_MatchStatus WHEN 110 THEN 1 WHEN 100 THEN 1 WHEN 50 THEN 2 WHEN 40 THEN 3 WHEN 30 THEN 3 ELSE 4 END 
      
       UPDATE #table_courtmatch SET F_CourtOrder = B.F_CourtOrder
	     FROM #table_courtmatch AS A LEFT JOIN #table_AllCourt AS B ON A.F_CourtID = B.F_CourtID
       
       ---Official, UnOfficial的比赛，按照时间的降序排列
       UPDATE A SET A.F_RowNo_Official = B.F_RowNo
          FROM #table_courtmatch AS A LEFT JOIN (SELECT F_MatchID, ROW_NUMBER()OVER (PARTITION BY F_CourtOrder ORDER BY F_StatusOrder, F_StartTime DESC) AS F_RowNo FROM #table_courtmatch WHERE F_StatusOrder = 1)AS B ON A.F_MatchID = B.F_MatchID
      
      ---Schedule，Runing的比赛，按照时间的升序排列
      UPDATE A SET A.F_RowNo_Schedule = B.F_RowNo
          FROM #table_courtmatch AS A LEFT JOIN (SELECT F_MatchID, ROW_NUMBER()OVER (PARTITION BY F_CourtOrder ORDER BY F_StatusOrder, F_StartTime ASC) AS F_RowNo FROM #table_courtmatch WHERE F_StatusOrder <> 1)AS B ON A.F_MatchID = B.F_MatchID

      
      UPDATE A SET F_RowNo_MaxOff = B.F_RowNo
           FROM #table_courtmatch AS A LEFT JOIN (SELECT ISNULL(MAX(F_RowNo_Official),0) AS F_RowNo, F_CourtOrder FROM #table_courtmatch GROUP BY F_CourtOrder) AS B ON A.F_CourtOrder = B.F_CourtOrder
     
      UPDATE #table_courtmatch SET F_RowNo = F_RowNo_Official WHERE F_RowNo_Official IS NOT NULL
      UPDATE #table_courtmatch SET F_RowNo = F_RowNo_Schedule + F_RowNo_MaxOff WHERE F_RowNo_Official IS NULL     
     
       UPDATE A SET F_RowNoByTime = B.F_RowNo
          FROM #table_courtmatch AS A LEFT JOIN (SELECT F_MatchID, ROW_NUMBER()OVER (PARTITION BY F_CourtOrder ORDER BY F_StartTime ASC, F_RowNo ASC ) AS F_RowNo FROM #table_courtmatch)AS B ON  A.F_MatchID = B.F_MatchID

       UPDATE A SET A.F_RowSub = B.F_RowNoByTime  FROM #table_courtmatch AS A LEFT JOIN ( SELECT F_RowNoByTime,F_CourtOrder FROM #table_courtmatch WHERE F_RowNo = 1) AS B ON A.F_CourtOrder = B.F_CourtOrder

       UPDATE #table_courtmatch SET F_RowSub = F_RowNoByTime - F_RowSub
                 


      CREATE TABLE #table_tmp(
	                            Court_ENG       NVARCHAR(20),
	                            Court_CHN       NVARCHAR(20),
	                            Match_Code      NVARCHAR(100),
	                            MatchStatus     INT,
                                RegA_ENG        NVARCHAR(100),
                                RegA_CHN        NVARCHAR(100),
                                RegB_ENG        NVARCHAR(100),
                                RegB_CHN        NVARCHAR(100),
                                NOCA            NVARCHAR(10),
                                NOCB            NVARCHAR(10),
                                NOCA_Image      NVARCHAR(20),
                                NOCB_Image      NVARCHAR(20),
                                SevA            NVARCHAR(10),
                                SevB            NVARCHAR(10),
                                Set1_A          NVARCHAR(10),
                                Set2_A          NVARCHAR(10),
                                Set3_A          NVARCHAR(10),
                                TotalScore_A    NVARCHAR(10),
                                Set1_B          NVARCHAR(10),
                                Set2_B          NVARCHAR(10),
                                Set3_B          NVARCHAR(10),
                                TotalScore_B    NVARCHAR(10),
                                Rank_A          INT,
                                Rank_B          INT,
                                HRegID          INT,
                                VRegID          INT,
                                Sev             INT,
                                F_MatchID       INT,
                                F_PhaseID       INT,
                                F_PhaseCode     NVARCHAR(20),
                                F_PhaseName     NVARCHAR(20),
                                F_MatchStatus   INT,
                                F_RowNo         INT,
                                F_CourtID       INT,
                                F_CourtOrder    INT,
                                F_EventCode     NVARCHAR(20),
                                F_GoupNo        INT,
                                F_RaceNum       INT,
                                F_AIRM          NVARCHAR(10),
                                F_BIRM          NVARCHAR(10),
                                ServiceA        INT,
                                ServiceB        INT,
                                F_MatchType     INT,  --- 1,2：个人赛，3：团体赛
                                F_ASetIRM       NVARCHAR(10),
                                F_BSetIRM       NVARCHAR(10),
                                F_ASet1IRM      NVARCHAR(10),
                                F_BSet1IRM      NVARCHAR(10),
                                F_ASet2IRM      NVARCHAR(10),
                                F_BSet2IRM      NVARCHAR(10),
                                F_ASet3IRM      NVARCHAR(10),
                                F_BSet3IRM      NVARCHAR(10),
                             )


      INSERT INTO #table_tmp (F_MatchID, F_EventCode, F_CourtID, F_MatchStatus, F_RaceNum, F_PhaseCode, F_MatchType, F_RowNo)
            SELECT M.F_MatchID, E.F_EventCode, M.F_CourtID, M.F_MatchStatusID, M.F_RaceNum, P.F_PhaseCode, E.F_PlayerRegTypeID, TC.F_RowSub
                FROM #table_courtmatch AS TC LEFT JOIN TS_Match AS M ON TC.F_MatchID = M.F_MatchID 
                     LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                     LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                 WHERE TC.F_RowSub IN (0,1,2)
                 ORDER BY TC.F_RowSub
       
       --select * from #table_courtmatch where f_courtorder = 4 ORDER BY F_RowSub
       --select * from       #table_tmp   where f_courtid = 4
     	--删除轮空比赛
	  DELETE FROM #table_tmp WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
	 
	  
	  ---  设置CourtOrder,RowNo
	  UPDATE #table_tmp SET F_CourtOrder = B.F_CourtOrder
	     FROM #table_tmp AS A LEFT JOIN #table_AllCourt AS B ON A.F_CourtID = B.F_CourtID
     
      --UPDATE A SET A.F_RowNo = B.F_RowNo
      --    FROM #table_tmp AS A LEFT JOIN (SELECT F_MatchID, ROW_NUMBER()OVER (PARTITION BY F_CourtOrder ORDER BY F_RaceNum ) AS F_RowNo FROM #table_tmp)AS B ON  A.F_MatchID = B.F_MatchID
      
      UPDATE #table_tmp SET F_PhaseName = ''
      
      --UPDATE #table_tmp SET F_PhaseName = CASE F_PhaseCode WHEN '7' THEN 'R1' WHEN '6' THEN 'R2' WHEN '5' THEN 'R3' WHEN '4' THEN 'R4' WHEN '3' THEN 'QF' WHEN '2' THEN 'SF' WHEN '1' THEN 'F' END WHERE F_EventCode IN ('001', '101')
      --UPDATE #table_tmp SET F_PhaseName = CASE F_PhaseCode WHEN '6' THEN 'R1' WHEN '5' THEN 'R2' WHEN '4' THEN 'R3' WHEN '3' THEN 'QF' WHEN '2' THEN 'SF' WHEN '1' THEN 'F' END WHERE F_EventCode IN ('002', '102', '201')
      --UPDATE #table_tmp SET F_PhaseName = CASE F_PhaseCode WHEN 'E' THEN 'CT1' WHEN 'D' THEN 'CT2' WHEN 'C' THEN 'CT3' WHEN 'B' THEN 'CT4' WHEN 'A' THEN 'CT5' END WHERE F_EventCode IN ('001','101')

      UPDATE #table_tmp SET Match_Code = CASE F_EventCode WHEN '001' THEN 'MS' WHEN '101' THEN 'WS' WHEN '002' THEN 'MD' WHEN '102' THEN 'WD' WHEN '202' THEN 'XD' WHEN '203' THEN 'XT' ELSE ''END     
      UPDATE #table_tmp SET Match_Code = Match_Code + ' ' + F_PhaseName
	  
	  UPDATE #table_tmp SET MatchStatus = CASE WHEN F_MatchStatus < 50 THEN 0  WHEN F_MatchStatus < 100 THEN 1  WHEN F_MatchStatus IN (100, 110) THEN 2 ELSE F_MatchStatus END

	  
	  UPDATE #table_tmp SET Court_ENG = CD1.F_CourtShortName, Court_CHN = CD2.F_CourtShortName
	  FROM #table_tmp AS M
	  LEFT JOIN TC_Court_Des AS CD1 ON M.F_CourtID = CD1.F_CourtID AND CD1.F_LanguageCode = 'ENG'
	  LEFT JOIN TC_Court_Des AS CD2 ON M.F_CourtID = CD2.F_CourtID AND CD2.F_LanguageCode = 'CHN'     
	 
	UPDATE #table_tmp SET HRegID = MR.F_RegisterID, RegA_ENG = RS1.F_SBShortName, RegA_CHN = RS2.F_SBShortName, NOCA = D.F_DelegationShortName
       FROM #table_tmp AS TT 
           LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 1
           LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
           LEFT JOIN TR_Register_Des AS RS1 ON R.F_RegisterID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
           LEFT JOIN TR_Register_Des AS RS2 ON R.F_RegisterID = RS2.F_RegisterID AND RS2.F_LanguageCode = 'CHN'
           LEFT JOIN TC_Delegation_Des AS D ON R.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN'
           
    UPDATE #table_tmp SET VRegID = MR.F_RegisterID, RegB_ENG = RS1.F_SBShortName, RegB_CHN = RS2.F_SBShortName, NOCB = D.F_DelegationShortName
       FROM #table_tmp AS TT 
           LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 2
           LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
           LEFT JOIN TR_Register_Des AS RS1 ON R.F_RegisterID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
           LEFT JOIN TR_Register_Des AS RS2 ON R.F_RegisterID = RS2.F_RegisterID AND RS2.F_LanguageCode = 'CHN'
           LEFT JOIN TC_Delegation_Des AS D ON R.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN'
   
  
   UPDATE #table_tmp SET Rank_A = CASE  B.F_Rank WHEN  1 THEN 1 WHEN 2 THEN 0 ELSE NULL END, Rank_B =  CASE  C.F_Rank WHEN  1 THEN 1 WHEN 2 THEN 0 ELSE NULL END,
                         F_AIRM = I1.F_IRMCode, F_BIRM = I2.F_IRMCode
      FROM #table_tmp AS A 
         LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
         LEFT JOIN TS_Match_Result AS C ON A.F_MatchID = C.F_MatchID AND C.F_CompetitionPosition = 2
         LEFT JOIN TC_IRM AS I1 ON B.F_IRMID = I1.F_IRMID
         LEFT JOIN TC_IRM AS I2 ON C.F_IRMID = I2.F_IRMID
              
    ----个人赛，Set1，Set2，Set3：用于显示各局比分，Total：显示总比分
	UPDATE #table_tmp SET Set1_A = MSR1.F_Points, Set1_B = MSR2.F_Points, F_ASet1IRM = I1.F_IRMCode, F_BSet1IRM = I2.F_IRMCode
	       FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	           LEFT JOIN TC_IRM AS I1 ON MSR1.F_IRMID = I1.F_IRMID
	           LEFT JOIN TC_IRM AS I2 ON MSR2.F_IRMID = I2.F_IRMID
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_Order = 1 AND MSI.F_MatchSplitStatusID IN (50, 100, 110) AND TT.F_MatchType <> 3
    
    UPDATE #table_tmp SET Set2_A = MSR1.F_Points, Set2_B = MSR2.F_Points, F_ASet2IRM = I1.F_IRMCode, F_BSet2IRM = I2.F_IRMCode
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	           LEFT JOIN TC_IRM AS I1 ON MSR1.F_IRMID = I1.F_IRMID
	           LEFT JOIN TC_IRM AS I2 ON MSR2.F_IRMID = I2.F_IRMID
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_Order = 2  AND MSI.F_MatchSplitStatusID IN (50, 100, 110) AND TT.F_MatchType <> 3
		
     UPDATE #table_tmp SET Set3_A = MSR1.F_Points, Set3_B = MSR2.F_Points, F_ASet3IRM = I1.F_IRMCode, F_BSet3IRM = I2.F_IRMCode
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	           LEFT JOIN TC_IRM AS I1 ON MSR1.F_IRMID = I1.F_IRMID
	           LEFT JOIN TC_IRM AS I2 ON MSR2.F_IRMID = I2.F_IRMID
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_Order = 3  AND MSI.F_MatchSplitStatusID IN (50, 100, 110) AND TT.F_MatchType <> 3

      UPDATE #table_tmp SET TotalScore_A = MSR1.F_Points, TotalScore_B = MSR2.F_Points
	       FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Result AS MSR1 ON TT.F_MatchID = MSR1.F_MatchID  AND MSR1.F_CompetitionPosition = 1 
	           LEFT JOIN TS_Match_Result AS MSR2 ON TT.F_MatchID = MSR2.F_MatchID  AND MSR2.F_CompetitionPosition = 2
	        WHERE TT.F_MatchType <> 3
       
      UPDATE #table_tmp SET TotalScore_A = F_AIRM, TotalScore_B = NULL WHERE F_AIRM IS NOT NULL OR F_BIRM IS NOT NULL AND F_MatchType <> 3
      UPDATE #table_tmp SET TotalScore_B = F_BIRM, TotalScore_A = NULL WHERE F_BIRM IS NOT NULL OR F_AIRM IS NOT NULL AND F_MatchType <> 3   
      
      	  

      -----团体赛中，Total显示为空，Set1显示总比分，Set2显示当前小场的场比分，Set3显示当前小肠的当前局比分
      
      UPDATE #table_tmp SET Set1_A = MSR1.F_Points, Set1_B = MSR2.F_Points
	       FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Result AS MSR1 ON TT.F_MatchID = MSR1.F_MatchID  AND MSR1.F_CompetitionPosition = 1 
	           LEFT JOIN TS_Match_Result AS MSR2 ON TT.F_MatchID = MSR2.F_MatchID  AND MSR2.F_CompetitionPosition = 2
	        WHERE TT.F_MatchType = 3

    UPDATE #table_tmp SET Set2_A = MSR1.F_Points, Set2_B = MSR2.F_Points, F_ASet2IRM = I1.F_IRMCode, F_BSet2IRM = I2.F_IRMCode
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	           LEFT JOIN TC_IRM AS I1 ON MSR1.F_IRMID = I1.F_IRMID
	           LEFT JOIN TC_IRM AS I2 ON MSR2.F_IRMID = I2.F_IRMID
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_MatchSplitStatusID = 50 AND TT.F_MatchType = 3
		
     UPDATE #table_tmp SET Set3_A = MSR1.F_Points, Set3_B = MSR2.F_Points, F_ASet3IRM  = I1.F_IRMCode, F_BSet2IRM = I2.F_IRMCode
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	           LEFT JOIN TC_IRM AS I1 ON MSR1.F_IRMID = I1.F_IRMID
	           LEFT JOIN TC_IRM AS I2 ON MSR2.F_IRMID = I2.F_IRMID
	        WHERE MSI.F_FatherMatchSplitID <> 0 AND MSI.F_MatchSplitStatusID = 50 AND TT.F_MatchType = 3
	        
      UPDATE #table_tmp  SET Set1_A = F_AIRM, Set1_B = NULL  WHERE (F_AIRM IS NOT NULL OR F_BIRM IS NOT NULL) AND F_MatchType = 3
	  UPDATE #table_tmp  SET Set1_B = F_BIRM, Set1_A = NULL  WHERE (F_BIRM IS NOT NULL OR F_AIRM IS NOT NULL) AND F_MatchType = 3   

      UPDATE #table_tmp SET Set2_A = F_ASet2IRM, Set2_B = NULL WHERE (F_ASet2IRM IS NOT NULL OR F_ASet2IRM IS NOT NULL) AND F_MatchType = 3
      UPDATE #table_tmp SET Set2_B = F_BSet2IRM, Set2_A = NULL WHERE (F_BSet2IRM IS NOT NULL OR F_BSet2IRM IS NOT NULL) AND F_MatchType = 3

      UPDATE #table_tmp SET Set3_A = F_ASet3IRM, Set3_B = NULL WHERE (F_ASet3IRM IS NOT NULL OR F_ASet3IRM IS NOT NULL) AND F_MatchType = 3
      UPDATE #table_tmp SET Set3_B = F_BSet3IRM, Set3_A = NULL WHERE (F_BSet3IRM IS NOT NULL OR F_BSet3IRM IS NOT NULL) AND F_MatchType = 3

	  UPDATE #table_tmp SET NOCA_Image = '[image]' + NOCA 
	  UPDATE #table_tmp SET NOCB_Image = '[image]' + NOCB
	   
	   
	
	CREATE TABLE #table_RowNo(
	                           F_RowNo  INT
	                           )
	INSERT INTO #table_RowNo (F_RowNo)
		SELECT DISTINCT F_RowNo FROM #table_tmp 
	  
    CREATE TABLE #table_UsedCourt(F_Num				INT,
								  F_CourtOrder		INT)
	
	
	CREATE TABLE #Table_Cols (Name NVARCHAR(100))
	INSERT INTO #Table_Cols ([name]) values (N'Court_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'Match_Code')
	INSERT INTO #Table_Cols ([name]) values (N'RegA_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'NOCA')
	INSERT INTO #Table_Cols ([name]) values (N'NOCA_Image')
	INSERT INTO #Table_Cols ([name]) values (N'RegB_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'NOCB')
	INSERT INTO #Table_Cols ([name]) values (N'NOCB_Image')
	INSERT INTO #Table_Cols ([name]) values (N'SevA')
	INSERT INTO #Table_Cols ([name]) values (N'SevB')
	INSERT INTO #Table_Cols ([name]) values (N'Set1_A')
	INSERT INTO #Table_Cols ([name]) values (N'Set1_B')
	INSERT INTO #Table_Cols ([name]) values (N'Set2_A')
	INSERT INTO #Table_Cols ([name]) values (N'Set2_B')
	INSERT INTO #Table_Cols ([name]) values (N'Set3_A')
	INSERT INTO #Table_Cols ([name]) values (N'Set3_B')
	INSERT INTO #Table_Cols ([name]) values (N'TotalScore_A')
	INSERT INTO #Table_Cols ([name]) values (N'TotalScore_B')
	INSERT INTO #Table_Cols ([name]) values (N'MatchStatus')
	INSERT INTO #Table_Cols ([name]) values (N'F_RowNo')
	INSERT INTO #Table_Cols ([name]) values (N'Rank_A')
	INSERT INTO #Table_Cols ([name]) values (N'Rank_B')

	INSERT INTO #table_UsedCourt (F_Num, F_CourtOrder)
    SELECT ROW_NUMBER() OVER(ORDER BY F_CourtOrder) AS F_Num, F_CourtOrder FROM (SELECT DISTINCT(F_CourtOrder) AS F_CourtOrder FROM #table_tmp) AS A
    
    DECLARE @Sql AS NVARCHAR(MAX)
    DECLARE @Col AS NVARCHAR(MAX)
    DECLARE @Tables AS NVARCHAR(MAX)
    
    SET @Col = ''
    SET @Tables = ''
    
	DECLARE @i		AS INT
	DECLARE @Temp	AS INT
	SET @Temp =1
	
	while(@Temp<12)
	BEGIN
		SET @i = NULL
		SELECT @i = F_CourtOrder FROM #table_UsedCourt WHERE F_Num = @Temp
		IF @i IS NOT NULL
		BEGIN
		
			SELECT @Col = @Col +', T'+CAST(@Temp AS NVARCHAR(MAX))+'.'+ Name + ' AS C'+CAST(@Temp AS NVARCHAR(MAX))+'_' + Name FROM #Table_Cols
			SET @Tables = @Tables + 
			'
			 LEFT JOIN  
				(
				SELECT Court_ENG, Match_Code, RegA_ENG, NOCA,NOCA_Image, RegB_ENG, NOCB,NOCB_Image, 
					   SevA, SevB, Set1_A, Set1_B, Set2_A, Set2_B, Set3_A, Set3_B, TotalScore_A, TotalScore_B, MatchStatus, F_RowNo, Rank_A, Rank_B
				FROM #table_tmp WHERE F_CourtOrder = '+CAST(@i AS NVARCHAR(MAX))+'
				) AS T'+CAST(@Temp AS NVARCHAR(MAX))+' ON T0.F_RowNo = T'+CAST(@Temp AS NVARCHAR(MAX))+'.F_RowNo
			'
		END
		ELSE
		BEGIN
			SELECT @Col = @Col +', NULL AS C'+CAST(@Temp AS NVARCHAR(MAX))+'_' + Name FROM #Table_Cols
		END
		
		SET @Temp = @Temp + 1
	END
    
	SET @Sql = 
    '
    SELECT T0.F_RowNo'
    + @Col + 
    '
    FROM #table_RowNo   AS T0'
    +@Tables
    
    --SELECT @Sql
	exec (@Sql)


SET NOCOUNT OFF
END




GO


