IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BD_AllCourtRunningMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BD_AllCourtRunningMatches]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_SCB_BD_AllCourtRunningMatches]
----功		  能：获取所有场地的比赛信息，此存储过程获取的是所有场地的正在比赛的信息
----作		  者：郑金勇
----日		  期: 2011-07-04


CREATE PROCEDURE [dbo].[Proc_SCB_BD_AllCourtRunningMatches]
            @SelSessionID           INT
AS
BEGIN
	
SET NOCOUNT ON

        DECLARE @DisciplineID		INT
		DECLARE @Date				DateTime
		DECLARE @VenueID            INT
		
		SELECT @DisciplineID = F_DisciplineID
			, @Date = F_SessionDate FROM TS_Session WHERE F_SessionID = @SelSessionID
			
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

		CREATE TABLE #table_Court(
		                         F_CourtID    INT,
		                         F_CourtOrder INT
		                         )

       INSERT INTO #table_Court (F_CourtID, F_CourtOrder)
          SELECT F_CourtID, F_CourtOrder
            FROM #table_AllCourt WHERE F_CourtOrder BETWEEN 1 AND 11

     
      CREATE TABLE #table_tmp(
	                            Court_ENG       NVARCHAR(20),
	                            Court_CHN       NVARCHAR(20),
	                            Match_Code      NVARCHAR(100),
	                            MatchStatus     INT,
                                RegA_ENG        NVARCHAR(100),
                                RegA_CHN        NVARCHAR(100),
                                RegB_ENG        NVARCHAR(100),
                                RegB_CHN        NVARCHAR(100),
								RegA1_ENG       NVARCHAR(100),
                                RegA2_ENG       NVARCHAR(100),
                                RegB1_ENG       NVARCHAR(100),
                                RegB2_ENG       NVARCHAR(100),
                                NOCA            NVARCHAR(10),
                                NOCB            NVARCHAR(10),
                                NOCA_Image      NVARCHAR(20),
                                NOCB_Image      NVARCHAR(20),
                                SevA            NVARCHAR(10),
                                SevB            NVARCHAR(10),
                                Set1_A          NVARCHAR(20),
                                Set2_A          NVARCHAR(20),
                                Set3_A          NVARCHAR(20),
                                TotalScore_A    NVARCHAR(10),
                                Set1_B          NVARCHAR(20),
                                Set2_B          NVARCHAR(20),
                                Set3_B          NVARCHAR(20),
                                TotalScore_B    NVARCHAR(10),
                                
                                Set1_Point_A    INT,
                                Set2_Point_A    INT,
                                Set3_Point_A    INT,
                                Set1_Point_B    INT,
                                Set2_Point_B    INT,
                                Set3_Point_B    INT,
                                Set1_Rank_A    INT,
                                Set2_Rank_A    INT,
                                Set3_Rank_A    INT,
                                Set1_Rank_B    INT,
                                Set2_Rank_B    INT,
                                Set3_Rank_B    INT,
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
                                F_ACurPoints		INT,		-----正在进行的Game的比分
                                F_BCurPoints		INT,		-----正在进行的Game的比分
								MatchPoints			NVARCHAR(30),----单场比赛的成绩 0:2
                                TeamMatchPoints		NVARCHAR(30),----团体赛的总成绩 3:2
                                MatchSplitCode		NVARCHAR(20),----团体赛的标识G1\G2\G3\G4\G5
                                MatchPointA			NVARCHAR(30),
                                MatchPointB			NVARCHAR(30),
                                TeamMatchPointA		NVARCHAR(30),
                                TeamMatchPointB		NVARCHAR(30),
                                HRegTypeID		INT,
                                VRegTypeID		INT,
                                RegA1ID			INT,
                                RegA2ID			INT,
                                RegB1ID			INT,
                                RegB2ID			INT,
                                F_PlayerRegTypeID	INT,
                                F_RunningSplitID_Level1		INT
                             )


      INSERT INTO #table_tmp (F_MatchID, F_EventCode, F_CourtID, F_MatchStatus, F_RaceNum, F_PhaseCode, F_PlayerRegTypeID)
            SELECT M.F_MatchID, E.F_EventCode, M.F_CourtID, M.F_MatchStatusID, M.F_RaceNum, P.F_PhaseCode, E.F_PlayerRegTypeID
                FROM TS_Match AS M 
                     LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                     LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                 WHERE M.F_SessionID = @SelSessionID AND M.F_CourtID IN (SELECT F_CourtID FROM #table_Court) AND M.F_MatchStatusID IN (50,100)
                   ORDER BY M.F_OrderInSession, M.F_MatchNum
                
                 
      ----删除轮空比赛
	  DELETE FROM #table_tmp WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
	 
	  
	  ----设置CourtOrder,RowNo
	  UPDATE #table_tmp SET F_CourtOrder = B.F_CourtOrder
	     FROM #table_tmp AS A LEFT JOIN #table_Court AS B ON A.F_CourtID = B.F_CourtID
     
      UPDATE A SET A.F_RowNo = B.F_RowNo
          FROM #table_tmp AS A LEFT JOIN (SELECT F_MatchID, ROW_NUMBER()OVER (PARTITION BY F_CourtOrder ORDER BY F_RaceNum ) AS F_RowNo FROM #table_tmp)AS B ON  A.F_MatchID = B.F_MatchID
      
      ----整理比赛的编码
      UPDATE #table_tmp SET F_PhaseName = ''
      
      UPDATE #table_tmp SET Match_Code = CASE F_EventCode WHEN '001' THEN 'MS' WHEN '101' THEN 'WS' WHEN '002' THEN 'MD' WHEN '102' THEN 'WD' WHEN '202' THEN 'XD' WHEN '203' THEN 'XT' ELSE ''END  +  B.F_RaceNum 
      FROM #table_tmp AS A
      LEFT JOIN TS_Match AS B ON B.F_MatchID = A.F_MatchID
      --UPDATE #table_tmp SET Match_Code = Match_Code + ' ' + F_PhaseName
	  
	  ----不用管比赛的状态,此存储过程查询出来的全部是Running状态的比赛
	  UPDATE #table_tmp SET MatchStatus = CASE WHEN F_MatchStatus < 50 THEN 0  WHEN F_MatchStatus < 100 THEN 1  WHEN F_MatchStatus IN (100, 110) THEN 2 ELSE F_MatchStatus END

	  ----指定团体比赛的正在进行的MatchSplitID
	  
	  UPDATE #table_tmp SET F_RunningSplitID_Level1 = dbo.Fun_BD_GetCurrentSetAndGameID(A.F_MatchID, 1)
	  FROM #table_tmp AS A
	  
	
	  
	  UPDATE #table_tmp SET MatchSplitCode = 
	  (
			SELECT N'G' + CONVERT(NVARCHAR(10), B.F_Order) FROM TS_Match_Split_Info AS B 
			WHERE B.F_MatchID = TT.F_MatchID AND B.F_MatchSplitID =  TT.F_RunningSplitID_Level1
		)
	  FROM #table_tmp AS TT 
	  WHERE TT.F_PlayerRegTypeID IN (1,2)
	  
	  UPDATE #table_tmp SET MatchSplitCode = 
	  (
			SELECT N'M' + CONVERT(NVARCHAR(10), B.F_Order) FROM TS_Match_Split_Info AS B 
			WHERE B.F_MatchID = TT.F_MatchID AND B.F_MatchSplitID =  TT.F_RunningSplitID_Level1
		)
	  FROM #table_tmp AS TT 
	  WHERE TT.F_PlayerRegTypeID = 3
	  
	  
	  ----更新场地中英文名称
	  UPDATE #table_tmp SET Court_ENG = CD1.F_CourtShortName, Court_CHN = CD2.F_CourtShortName
	  FROM #table_tmp AS M
	  LEFT JOIN TC_Court_Des AS CD1 ON M.F_CourtID = CD1.F_CourtID AND CD1.F_LanguageCode = 'ENG'
	  LEFT JOIN TC_Court_Des AS CD2 ON M.F_CourtID = CD2.F_CourtID AND CD2.F_LanguageCode = 'CHN'     



	  ----更新对阵双方的运动员ID
	  
	  ----单双打比赛的处理
	  UPDATE #table_tmp SET HRegID = MR.F_RegisterID, HRegTypeID = R.F_RegTypeID, RegA_ENG = RS1.F_SBShortName, RegA_CHN = RS2.F_SBShortName, NOCA = D.F_DelegationShortName
		FROM #table_tmp AS TT 
		   LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 1
		   LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
		   LEFT JOIN TR_Register_Des AS RS1 ON R.F_RegisterID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
		   LEFT JOIN TR_Register_Des AS RS2 ON R.F_RegisterID = RS2.F_RegisterID AND RS2.F_LanguageCode = 'CHN'
		   LEFT JOIN TC_Delegation_Des AS D ON R.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN' 
		   WHERE TT.F_PlayerRegTypeID IN (1,2)
	
	  UPDATE #table_tmp SET VRegID = MR.F_RegisterID, VRegTypeID = R.F_RegTypeID, RegB_ENG = RS1.F_SBShortName, RegB_CHN = RS2.F_SBShortName, NOCB = D.F_DelegationShortName
		FROM #table_tmp AS TT 
		   LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 2
		   LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
		   LEFT JOIN TR_Register_Des AS RS1 ON R.F_RegisterID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
		   LEFT JOIN TR_Register_Des AS RS2 ON R.F_RegisterID = RS2.F_RegisterID AND RS2.F_LanguageCode = 'CHN'
		   LEFT JOIN TC_Delegation_Des AS D ON R.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN' 
		   WHERE TT.F_PlayerRegTypeID IN (1,2)




	 ----团体比赛的处理
	 
	 
	 UPDATE #table_tmp SET NOCA = D.F_DelegationShortName
		FROM #table_tmp AS TT 
		   LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 1   
		   LEFT JOIN TR_Register AS TeamR ON MR.F_RegisterID = TeamR.F_RegisterID
		   LEFT JOIN TC_Delegation_Des AS D ON TeamR.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN'
		   
	UPDATE #table_tmp SET NOCB = D.F_DelegationShortName
		FROM #table_tmp AS TT 
		   LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 2
		   LEFT JOIN TR_Register AS TeamR ON MR.F_RegisterID = TeamR.F_RegisterID
		   LEFT JOIN TC_Delegation_Des AS D ON TeamR.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN'
		   
	 UPDATE #table_tmp SET HRegID = MSR.F_RegisterID, HRegTypeID = R.F_RegTypeID, RegA_ENG = RS1.F_SBShortName, RegA_CHN = RS2.F_SBShortName
		FROM #table_tmp AS TT 
		   LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 1
		   LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
		   LEFT JOIN TS_Match_Split_Info AS MSI ON MR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID 
		   LEFT JOIN TR_Register AS R ON MSR.F_RegisterID = R.F_RegisterID 
		   LEFT JOIN TR_Register_Des AS RS1 ON R.F_RegisterID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
		   LEFT JOIN TR_Register_Des AS RS2 ON R.F_RegisterID = RS2.F_RegisterID AND RS2.F_LanguageCode = 'CHN'
		   LEFT JOIN TR_Register AS TeamR ON MR.F_RegisterID = TeamR.F_RegisterID
		   LEFT JOIN TC_Delegation AS D ON TeamR.F_DelegationID = D.F_DelegationID 
		   WHERE TT.F_PlayerRegTypeID = 3 AND MSI.F_MatchSplitID = TT.F_RunningSplitID_Level1 --MSI.F_MatchSplitStatusID = 50 AND MSI.F_FatherMatchSplitID = 0
	       --WHERE TT.F_PlayerRegTypeID = 3 AND MSI.F_MatchSplitStatusID = 50 AND MSI.F_FatherMatchSplitID = 0
	  UPDATE #table_tmp SET VRegID = MSR.F_RegisterID, VRegTypeID = R.F_RegTypeID, RegB_ENG = RS1.F_SBShortName, RegB_CHN = RS2.F_SBShortName
		FROM #table_tmp AS TT 
		   LEFT JOIN TS_Match_Result AS MR ON TT.F_MatchID = MR.F_MatchID AND MR.F_CompetitionPositionDes1 = 2
		   LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
		   LEFT JOIN TS_Match_Split_Info AS MSI ON MR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
		   LEFT JOIN TR_Register AS R ON MSR.F_RegisterID = R.F_RegisterID 
		   LEFT JOIN TR_Register_Des AS RS1 ON R.F_RegisterID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
		   LEFT JOIN TR_Register_Des AS RS2 ON R.F_RegisterID = RS2.F_RegisterID AND RS2.F_LanguageCode = 'CHN'
		   LEFT JOIN TR_Register AS TeamR ON MR.F_RegisterID = TeamR.F_RegisterID
		   LEFT JOIN TC_Delegation AS D ON TeamR.F_DelegationID = D.F_DelegationID 
		   WHERE TT.F_PlayerRegTypeID = 3 AND MSI.F_MatchSplitID = TT.F_RunningSplitID_Level1--AND MSI.F_MatchSplitStatusID = 50 AND MSI.F_FatherMatchSplitID = 0
		   --WHERE TT.F_PlayerRegTypeID = 3 AND MSI.F_MatchSplitStatusID = 50 AND MSI.F_FatherMatchSplitID = 0
		   
		   
		
		   
   --单打运动员就是本身
   UPDATE #table_tmp SET RegA1ID = HRegID WHERE HRegTypeID = 1
   UPDATE #table_tmp SET RegB1ID = VRegID WHERE VRegTypeID = 1
   
   --双打运动员特殊处理
   UPDATE TT SET TT.RegA1ID = RM.F_MemberRegisterID FROM #table_tmp AS TT LEFT JOIN TR_Register_Member AS RM 
		ON TT.HRegID = RM.F_RegisterID WHERE TT.HRegTypeID = 2 AND RM.F_Order = 1
   
   UPDATE TT SET TT.RegA2ID = RM.F_MemberRegisterID FROM #table_tmp AS TT LEFT JOIN TR_Register_Member AS RM 
		ON TT.HRegID = RM.F_RegisterID WHERE TT.HRegTypeID = 2 AND RM.F_Order = 2
		
   UPDATE TT SET TT.RegB1ID = RM.F_MemberRegisterID FROM #table_tmp AS TT LEFT JOIN TR_Register_Member AS RM 
		ON TT.VRegID = RM.F_RegisterID WHERE TT.VRegTypeID = 2 AND RM.F_Order = 1
   
   UPDATE TT SET TT.RegB2ID = RM.F_MemberRegisterID FROM #table_tmp AS TT LEFT JOIN TR_Register_Member AS RM 
		ON TT.VRegID = RM.F_RegisterID WHERE TT.VRegTypeID = 2 AND RM.F_Order = 2
   
   --实现双打比赛的两个运动员的名字两行展现   
   UPDATE TT SET TT.RegA1_ENG = RS1.F_SBShortName
       FROM #table_tmp AS TT 
           LEFT JOIN TR_Register_Des AS RS1 ON TT.RegA1ID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
   
   UPDATE TT SET TT.RegA2_ENG = RS1.F_SBShortName
       FROM #table_tmp AS TT 
           LEFT JOIN TR_Register_Des AS RS1 ON TT.RegA2ID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
   
   UPDATE TT SET TT.RegB1_ENG = RS1.F_SBShortName
       FROM #table_tmp AS TT 
           LEFT JOIN TR_Register_Des AS RS1 ON TT.RegB1ID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
   
   UPDATE TT SET TT.RegB2_ENG = RS1.F_SBShortName
       FROM #table_tmp AS TT 
           LEFT JOIN TR_Register_Des AS RS1 ON TT.RegB2ID = RS1.F_RegisterID AND RS1.F_LanguageCode = 'ENG'
           

   ----实现单双打比赛的成绩处理
   UPDATE #table_tmp SET Rank_A = CASE  B.F_Rank WHEN  1 THEN 1 WHEN 2 THEN 0 ELSE NULL END
						, Rank_B =  CASE  C.F_Rank WHEN  1 THEN 1 WHEN 2 THEN 0 ELSE NULL END
						, F_AIRM = I1.F_IRMCode, F_BIRM = I2.F_IRMCode
						, MatchPointA = B.F_Points, MatchPointB = C.F_Points, MatchPoints = CAST(B.F_Points AS NVARCHAR(30)) + ':' + CAST(C.F_Points AS NVARCHAR(30))
      FROM #table_tmp AS A 
         LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
         LEFT JOIN TS_Match_Result AS C ON A.F_MatchID = C.F_MatchID AND C.F_CompetitionPosition = 2
         LEFT JOIN TC_IRM AS I1 ON B.F_IRMID = I1.F_IRMID
         LEFT JOIN TC_IRM AS I2 ON C.F_IRMID = I2.F_IRMID 
         WHERE A.F_PlayerRegTypeID IN (1,2)
                
	UPDATE #table_tmp SET Set1_Point_A = MSR1.F_Points, Set1_Point_B = MSR2.F_Points, Set1_Rank_A = MSR1.F_Rank, Set1_Rank_B = MSR2.F_Rank
	       FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_MatchSplitID = 1 AND MSI.F_MatchSplitStatusID IN (100, 110)
			AND TT.F_PlayerRegTypeID IN (1,2)
			
    UPDATE #table_tmp SET Set2_Point_A = MSR1.F_Points, Set2_Point_B = MSR2.F_Points, Set2_Rank_A = MSR1.F_Rank, Set2_Rank_B = MSR2.F_Rank
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_MatchSplitID = 2  AND MSI.F_MatchSplitStatusID IN (100, 110)
			AND TT.F_PlayerRegTypeID IN (1,2)
			
     UPDATE #table_tmp SET Set3_Point_A = MSR1.F_Points, Set3_Point_B = MSR2.F_Points, Set3_Rank_A = MSR1.F_Rank, Set3_Rank_B = MSR2.F_Rank
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_FatherMatchSplitID = 0 AND MSI.F_MatchSplitID = 3 AND MSI.F_MatchSplitStatusID IN (100, 110)
			AND TT.F_PlayerRegTypeID IN (1,2)
			
     UPDATE #table_tmp SET F_ACurPoints = MSR1.F_Points, F_BCurPoints = MSR2.F_Points, ServiceA= MSR1.F_Service, ServiceB = MSR2.F_Service
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_MatchSplitID = dbo.Fun_BD_GetCurrentSetAndGameID(TT.F_MatchID, 1)
			AND TT.F_PlayerRegTypeID IN (1,2)
		
      UPDATE #table_tmp SET TotalScore_A = F_AIRM WHERE F_AIRM IS NOT NULL OR F_BIRM IS NOT NULL AND F_PlayerRegTypeID IN (1,2)
      UPDATE #table_tmp SET TotalScore_B = F_BIRM WHERE F_BIRM IS NOT NULL OR F_AIRM IS NOT NULL AND F_PlayerRegTypeID IN (1,2)   
	  
	  UPDATE #table_tmp SET SevA = '1' WHERE ServiceA = 1 AND F_PlayerRegTypeID IN (1,2)
	  UPDATE #table_tmp SET SevB = '1' WHERE ServiceB = 1 AND F_PlayerRegTypeID IN (1,2)
	  
	----实现团体比赛的成绩处理
    UPDATE #table_tmp SET Rank_A = CASE  B.F_Rank WHEN  1 THEN 1 WHEN 2 THEN 0 ELSE NULL END
						, Rank_B =  CASE  C.F_Rank WHEN  1 THEN 1 WHEN 2 THEN 0 ELSE NULL END
                        , F_AIRM = I1.F_IRMCode, F_BIRM = I2.F_IRMCode
                        , MatchPointA = B.F_Points, MatchPointB = C.F_Points
                        , TeamMatchPoints = CAST(B.F_Points AS NVARCHAR(30)) + ':' + CAST(C.F_Points AS NVARCHAR(30))
      FROM #table_tmp AS A 
         LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
         LEFT JOIN TS_Match_Result AS C ON A.F_MatchID = C.F_MatchID AND C.F_CompetitionPosition = 2
         LEFT JOIN TC_IRM AS I1 ON B.F_IRMID = I1.F_IRMID
         LEFT JOIN TC_IRM AS I2 ON C.F_IRMID = I2.F_IRMID 
         WHERE A.F_PlayerRegTypeID = 3
                
	UPDATE #table_tmp SET Set1_Point_A = MSR1.F_Points, Set1_Point_B = MSR2.F_Points, Set1_Rank_A = MSR1.F_Rank, Set1_Rank_B = MSR2.F_Rank
	       FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID AND TT.F_RunningSplitID_Level1 = MSI.F_FatherMatchSplitID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_Order = 1 AND MSI.F_MatchSplitStatusID  IN (100, 110)
			AND TT.F_PlayerRegTypeID = 3
			
    UPDATE #table_tmp SET Set2_Point_A = MSR1.F_Points, Set2_Point_B = MSR2.F_Points, Set2_Rank_A = MSR1.F_Rank, Set2_Rank_B = MSR2.F_Rank
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID AND TT.F_RunningSplitID_Level1 = MSI.F_FatherMatchSplitID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_Order = 2  AND MSI.F_MatchSplitStatusID  IN (100, 110)
			AND TT.F_PlayerRegTypeID = 3

     UPDATE #table_tmp SET Set3_Point_A = MSR1.F_Points, Set3_Point_B = MSR2.F_Points, Set3_Rank_A = MSR1.F_Rank, Set3_Rank_B = MSR2.F_Rank
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID AND TT.F_RunningSplitID_Level1 = MSI.F_FatherMatchSplitID 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_Order = 3 AND MSI.F_MatchSplitStatusID  IN (100, 110)
			AND TT.F_PlayerRegTypeID = 3
			
		
	  UPDATE #table_tmp SET F_ACurPoints = MSR1.F_Points, F_BCurPoints = MSR2.F_Points, ServiceA= MSR1.F_Service, ServiceB = MSR2.F_Service
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID AND TT.F_RunningSplitID_Level1 = MSI.F_FatherMatchSplitID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE  MSI.F_MatchSplitID = dbo.Fun_BD_GetCurrentSetAndGameID(TT.F_MatchID,2) AND TT.F_PlayerRegTypeID = 3
	  
	  
	  UPDATE #table_tmp SET SevA = '1' WHERE ServiceA = 1 AND F_PlayerRegTypeID = 3
	  UPDATE #table_tmp SET SevB = '1' WHERE ServiceB = 1 AND F_PlayerRegTypeID = 3
	

	  UPDATE #table_tmp SET MatchPointA = MSR1.F_Points, MatchPointB = MSR2.F_Points,  MatchPoints = CAST(MSR1.F_Points AS NVARCHAR(30)) + N':' + CAST(MSR2.F_Points AS NVARCHAR(30))
	      FROM #table_tmp AS TT
	           LEFT JOIN TS_Match_Split_Info AS MSI  ON TT.F_MatchID = MSI.F_MatchID AND TT.F_RunningSplitID_Level1 = MSI.F_MatchSplitID
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE  MSI.F_MatchSplitStatusID = 50 AND TT.F_PlayerRegTypeID = 3
	 
	  
	  ----分别处理单双打比赛和团体展现
	  --2011-08-09
	  --UPDATE #table_tmp SET TeamMatchPoints = '', MatchSplitCode = '' WHERE F_PlayerRegTypeID IN (1, 2)
	  UPDATE #table_tmp SET TeamMatchPoints = '' WHERE F_PlayerRegTypeID IN (1, 2)
	  UPDATE #table_tmp SET Set1_A = CAST(Set1_Point_A AS NVARCHAR(20)) + ':' + CAST(Set1_Point_B AS NVARCHAR(20)) + '(1)' WHERE Set1_Rank_A = 1
	  UPDATE #table_tmp SET Set2_A = CAST(Set2_Point_A AS NVARCHAR(20)) + ':' + CAST(Set2_Point_B AS NVARCHAR(20)) + '(2)' WHERE Set2_Rank_A = 1
	  UPDATE #table_tmp SET Set3_A = CAST(Set3_Point_A AS NVARCHAR(20)) + ':' + CAST(Set3_Point_B AS NVARCHAR(20)) + '(3)' WHERE Set3_Rank_A = 1
	  UPDATE #table_tmp SET Set1_B = CAST(Set1_Point_A AS NVARCHAR(20)) + ':' + CAST(Set1_Point_B AS NVARCHAR(20)) + '(1)' WHERE Set1_Rank_B = 1
	  UPDATE #table_tmp SET Set2_B = CAST(Set2_Point_A AS NVARCHAR(20)) + ':' + CAST(Set2_Point_B AS NVARCHAR(20)) + '(2)' WHERE Set2_Rank_B = 1
	  UPDATE #table_tmp SET Set3_B = CAST(Set3_Point_A AS NVARCHAR(20)) + ':' + CAST(Set3_Point_B AS NVARCHAR(20)) + '(3)' WHERE Set3_Rank_B = 1
	  
	  --UPDATE #table_tmp SET NOCA_Image = '[image]' + NOCA 
	  --UPDATE #table_tmp SET NOCB_Image = '[image]' + NOCB
	  UPDATE #table_tmp SET NOCA_Image = NOCA 
	  UPDATE #table_tmp SET NOCB_Image = NOCB
		
	  UPDATE #table_tmp SET Set1_A = '', Set1_B = '', Set2_A = '', Set2_B = '', Set3_A = '', Set3_B  = '',
				F_ACurPoints = NULL, F_BCurPoints = NULL, MatchPoints = '',MatchSplitCode = '',SevA = '',SevB=''		
	  WHERE F_PlayerRegTypeID = 3 AND F_MatchStatus = 100
	
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
	INSERT INTO #Table_Cols ([name]) values (N'RegA1_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'RegA2_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'RegB1_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'RegB2_ENG')
	INSERT INTO #Table_Cols ([name]) values (N'F_ACurPoints')
	INSERT INTO #Table_Cols ([name]) values (N'F_BCurPoints')
	INSERT INTO #Table_Cols ([name]) values (N'MatchPoints')
	INSERT INTO #Table_Cols ([name]) values (N'TeamMatchPoints')
	INSERT INTO #Table_Cols ([name]) values (N'MatchSplitCode')
	INSERT INTO #table_UsedCourt (F_Num, F_CourtOrder)
    SELECT ROW_NUMBER() OVER(ORDER BY F_CourtOrder) AS F_Num, F_CourtOrder FROM (SELECT DISTINCT(F_CourtOrder) AS F_CourtOrder FROM #table_tmp) AS A
    
    DECLARE @Sql AS NVARCHAR(MAX)
    DECLARE @Col AS NVARCHAR(MAX)
    DECLARE @Tables AS NVARCHAR(MAX)
    
    SET @Col = ''
    SET @Tables = ''
    
	DECLARE @i		AS INT
	DECLARE @iMap  INT
	--DECLARE @Temp	AS INT
	--SET @Temp =1
	SET @i = 1
	while(@i<12)
	BEGIN
		--SET @i = NULL
		--SELECT @i = F_CourtOrder FROM #table_UsedCourt WHERE F_Num = @Temp
		--IF @i IS NOT NULL
		--BEGIN
		SET @iMap = CASE @i WHEN 1 THEN 1
							WHEN 2 THEN 2
							WHEN 3 THEN 3
							WHEN 4 THEN 4
							WHEN 5 THEN 5
							WHEN 6 THEN 6
							WHEN 7 THEN 7
							WHEN 8 THEN 8
							WHEN 9 THEN 9
							WHEN 10 THEN 10
							WHEN 11 THEN 11
							ELSE 0 END
							
		
			SELECT @Col = @Col +', T'+CAST(@iMap AS NVARCHAR(MAX))+'.'+ Name + ' AS C'+CAST(@iMap AS NVARCHAR(MAX))+'_' + Name FROM #Table_Cols
			SET @Tables = @Tables + 
			'
			 LEFT JOIN  
				(
				SELECT Court_ENG, Match_Code, RegA_ENG, NOCA,NOCA_Image, RegB_ENG, NOCB,NOCB_Image, 
					   SevA, SevB, Set1_A, Set1_B, Set2_A, Set2_B, Set3_A, Set3_B, TotalScore_A, TotalScore_B, MatchStatus, F_RowNo, Rank_A, Rank_B
					   , RegA1_ENG, RegA2_ENG, RegB1_ENG, RegB2_ENG, F_ACurPoints, F_BCurPoints, MatchPoints, TeamMatchPoints
					   , MatchSplitCode
				FROM #table_tmp WHERE F_CourtOrder = '+CAST(@i AS NVARCHAR(MAX))+'
				) AS T'+CAST(@iMap AS NVARCHAR(MAX))+' ON T0.F_RowNo = T'+CAST(@iMap AS NVARCHAR(MAX))+'.F_RowNo
			'
		--END
		--ELSE
		--BEGIN
		--	SELECT @Col = @Col +', NULL AS C'+CAST(@Temp AS NVARCHAR(MAX))+'_' + Name FROM #Table_Cols
		--END
		
		SET @i = @i + 1
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


--EXEC Proc_SCB_BD_AllCourtRunningMatches 940