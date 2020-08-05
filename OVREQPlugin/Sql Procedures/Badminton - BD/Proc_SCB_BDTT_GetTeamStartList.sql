IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetTeamStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetTeamStartList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_BDTT_GetTeamStartList]
----功		  能：获取SCB需要的乒乓球团体赛出场对阵名单
----作		  者：王强
----日		  期: 2011-2-17
----修改	记录:
-----------------1	2010-11-27	变更存储过程的参数
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetTeamStartList]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #Table_SubMatch( 
									Match_No INT, 
									Registration_A1_ENG NVARCHAR(100),
									Registration_A1_CHN NVARCHAR(100),
									Registration_A2_ENG NVARCHAR(100),
									Registration_A2_CHN NVARCHAR(100),
									Registration_B1_ENG NVARCHAR(100),
									Registration_B1_CHN NVARCHAR(100),
									Registration_B2_ENG NVARCHAR(100),
									Registration_B2_CHN NVARCHAR(100)
								)
    
    --首先判断比赛是否轮空
   
		
		--插入SubMatch信息
		
		DECLARE @RegisterIDA INT
		DECLARE @RegisterAMember1 INT
		DECLARE @RegisterAMember2 INT
		DECLARE @RegisterIDB INT
		DECLARE @RegisterBMember1 INT
		DECLARE @RegisterBMember2 INT
		DECLARE @SplitType INT
		DECLARE @MatchOrder INT
		DECLARE tmp_cursor CURSOR FOR 
		(
			SELECT C.F_RegisterID AS RegisterIDA, D.F_RegisterID AS RegisterIDB, C.F_MatchSplitType AS SplitType, C.F_Order AS [MatchOrder]
			FROM 
			(
				SELECT  B.F_RegisterID, A.F_MatchSplitType, B.F_CompetitionPosition, A.F_Order
				FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchSplitID = A.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 1
			) AS C
			LEFT JOIN 
			(
				SELECT B.F_RegisterID, A.F_MatchSplitType, B.F_CompetitionPosition, A.F_Order
				FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchSplitID = A.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 2
			) AS D ON D.F_Order = C.F_Order
		)
		OPEN tmp_cursor
		FETCH NEXT FROM tmp_cursor INTO @RegisterIDA,@RegisterIDB,@SplitType,@MatchOrder
		WHILE @@FETCH_STATUS=0
			BEGIN
				INSERT INTO #Table_SubMatch VALUES( @MatchOrder, '','','','','','','','')
				--单人赛
				IF @SplitType <= 5
					BEGIN
					
						UPDATE #Table_SubMatch SET Registration_A1_ENG = CASE WHEN @SplitType IN (1,2) THEN B.F_SBLongName ELSE B.F_SBShortName END,Registration_A2_ENG = ''
						FROM TR_Register AS A
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_RegisterID = @RegisterIDA AND Match_No = @MatchOrder
						
						UPDATE #Table_SubMatch SET Registration_A1_CHN = CASE WHEN @SplitType IN (1,2) THEN B.F_SBLongName ELSE B.F_SBShortName END, Registration_A2_CHN = ''
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'CHN'
						WHERE A.F_RegisterID = @RegisterIDA AND Match_No = @MatchOrder
						
						UPDATE #Table_SubMatch SET Registration_B1_ENG = CASE WHEN @SplitType IN (1,2) THEN B.F_SBLongName ELSE B.F_SBShortName END, Registration_B2_ENG = ''
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_RegisterID = @RegisterIDB AND Match_No = @MatchOrder
						
						UPDATE #Table_SubMatch SET Registration_B1_CHN = CASE WHEN @SplitType IN (1,2) THEN B.F_SBLongName ELSE B.F_SBShortName END, Registration_B2_CHN = ''
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'CHN'
						WHERE A.F_RegisterID = @RegisterIDB AND Match_No = @MatchOrder
					END
				ELSE IF  @SplitType >= 6--@SplitType >= 3 AND @SplitType <= 5
					BEGIN
						
						--A1
						SELECT @RegisterAMember1 = MAX(F_MemberRegisterID) FROM TR_Register_Member 
						WHERE F_RegisterID = @RegisterIDA
						
						--A2
						SELECT @RegisterAMember2 = MIN(F_MemberRegisterID) FROM TR_Register_Member 
						WHERE F_RegisterID = @RegisterIDA
						
						--B1
						SELECT @RegisterBMember1 = MAX(F_MemberRegisterID) FROM TR_Register_Member 
						WHERE F_RegisterID = @RegisterIDB
						
						--B2
						SELECT @RegisterBMember2 = MIN(F_MemberRegisterID) FROM TR_Register_Member 
						WHERE F_RegisterID = @RegisterIDB
						
						--更新A1 ENG
						UPDATE #Table_SubMatch SET Registration_A1_ENG = B.F_SBLongName
						FROM TR_Register AS A
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_RegisterID = @RegisterAMember1 AND Match_No = @MatchOrder
						
						
						--A1 CHN
						UPDATE #Table_SubMatch SET Registration_A1_CHN = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'CHN'
						WHERE A.F_RegisterID = @RegisterAMember1 AND Match_No = @MatchOrder
						
						--更新到A2
						UPDATE #Table_SubMatch SET Registration_A2_ENG = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_RegisterID = @RegisterAMember2 AND Match_No = @MatchOrder
						
						--A2 CHN
						UPDATE #Table_SubMatch SET Registration_A2_CHN = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'CHN'
						WHERE A.F_RegisterID = @RegisterAMember2 AND Match_No = @MatchOrder
						
						--更新到B1
						UPDATE #Table_SubMatch SET Registration_B1_ENG = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_RegisterID = @RegisterBMember1 AND Match_No = @MatchOrder
						
						--B1 CHN
						UPDATE #Table_SubMatch SET Registration_B1_CHN = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'CHN'
						WHERE A.F_RegisterID = @RegisterBMember1 AND Match_No = @MatchOrder
						
						--更新到B2
						UPDATE #Table_SubMatch SET Registration_B2_ENG = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_RegisterID = @RegisterBMember2 AND Match_No = @MatchOrder
						
						UPDATE #Table_SubMatch SET Registration_B2_CHN = B.F_SBLongName
						FROM TR_Register AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'CHN'
						WHERE A.F_RegisterID = @RegisterBMember2 AND Match_No = @MatchOrder
						
					END
				FETCH NEXT FROM tmp_cursor INTO @RegisterIDA,@RegisterIDB,@SplitType,@MatchOrder
			END
		CLOSE tmp_cursor
		DEALLOCATE tmp_cursor
		
	DECLARE @StartTime NVARCHAR(20)
	DECLARE @CourtNameENG NVARCHAR(100)
	DECLARE @EventAndPhaseNameENG NVARCHAR(100)
	DECLARE @TeamNameAENG NVARCHAR(100)
	DECLARE @TeamNameBENG NVARCHAR(100)
	
	DECLARE @CourtNameCHN NVARCHAR(100)
	DECLARE @EventAndPhaseNameCHN NVARCHAR(100)
	DECLARE @TeamNameACHN NVARCHAR(100)
	DECLARE @TeamNameBCHN NVARCHAR(100)
	DECLARE @NOCA NVARCHAR(20)
	DECLARE @NOCB NVARCHAR(20)
	
	SELECT @StartTime = UPPER( LEFT( CONVERT( NVARCHAR(20),F_StartTime, 108), 5) ), @CourtNameENG = UPPER( B.F_CourtShortName),
		   @EventAndPhaseNameENG =  REPLACE( UPPER( D.F_EventShortName + ' ' + E.F_PhaseShortName ), 'GROUP', 'GROUP'),
		   @TeamNameAENG = (SELECT UPPER(Y.F_SBLongName) FROM TS_Match_Result AS X 
						 LEFT JOIN TR_Register_Des AS Y ON Y.F_RegisterID = X.F_RegisterID AND Y.F_LanguageCode = 'ENG'
						 WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1),
   		   @TeamNameBENG = (SELECT UPPER(Y.F_SBLongName) FROM TS_Match_Result AS X 
				 LEFT JOIN TR_Register_Des AS Y ON Y.F_RegisterID = X.F_RegisterID AND Y.F_LanguageCode = 'ENG'
				 WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2),
		   @NOCA = (SELECT '[Image]'+ dbo.Fun_BDTT_GetPlayerNOC(X.F_RegisterID) FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1),
		   @NOCB = (SELECT '[Image]'+ dbo.Fun_BDTT_GetPlayerNOC(X.F_RegisterID) FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Result AS F ON F.F_MatchID = A.F_MatchID
	WHERE A.F_MatchID = @MatchID
	
	SELECT @StartTime = LEFT( CONVERT( NVARCHAR(20),F_StartTime, 108), 5), @CourtNameCHN = B.F_CourtShortName,
		   @EventAndPhaseNameCHN =  D.F_EventShortName + '' + E.F_PhaseShortName,
		   @TeamNameACHN = (SELECT UPPER(Y.F_SBLongName) FROM TS_Match_Result AS X 
						 LEFT JOIN TR_Register_Des AS Y ON Y.F_RegisterID = X.F_RegisterID AND Y.F_LanguageCode = 'CHN'
						 WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1),
   		   @TeamNameBCHN = (SELECT UPPER(Y.F_SBLongName) FROM TS_Match_Result AS X 
				 LEFT JOIN TR_Register_Des AS Y ON Y.F_RegisterID = X.F_RegisterID AND Y.F_LanguageCode = 'CHN'
				 WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Match_Result AS F ON F.F_MatchID = A.F_MatchID
	WHERE A.F_MatchID = @MatchID
	
	SELECT A.*,@StartTime AS StartTime, @CourtNameENG AS CourtName_ENG,@CourtNameCHN AS CourtName_CHN, @EventAndPhaseNameENG AS PhaseName_ENG, @EventAndPhaseNameCHN PhaseName_CHN,
			@NOCA AS NOCA, @TeamNameAENG AS TeamNameA_ENG, @TeamNameACHN AS TeamNameA_CHN, @NOCB AS NOCB, @TeamNameBENG AS TeamNameB_ENG, @TeamNameBCHN AS TeamNameB_CHN,
			@EventAndPhaseNameENG + '（' + @EventAndPhaseNameCHN +'）' AS PhaseName_All,
			@CourtNameENG + '（' + @CourtNameCHN + '）' AS CourtName_All from #Table_SubMatch AS A
	RETURN
	
SET NOCOUNT OFF
END


GO


