IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetGameSplit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetGameSplit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_BD_GetGameSplit]
----功		  能：得到一场比赛的局数
----作		  者：李燕
----日		  期: 2011-03-13
----修 改 记  录：
/*
*/

CREATE PROCEDURE [dbo].[Proc_Report_BD_GetGameSplit] (	
	@MatchID					INT,
	@LanguageCode               NVARCHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON
	
           DECLARE @RegTypeID  INT
           SELECT @RegTypeID = E.F_PlayerRegTypeID 
               FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
                    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                  WHERE M.F_MatchID = @MatchID
                    
           CREATE TABLE #tmp_SplitList(
                                        F_MatchID            INT,
                                        F_FatherSplitID      INT,
                                        F_MatchSplitID       INT,
                                        )
          
           INSERT INTO #tmp_SplitList(F_MatchSplitID, F_MatchID, F_FatherSplitID)
                SELECT F_MatchSplitID,@MatchID, F_FatherMatchSplitID
                     FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND ((F_FatherMatchSplitID <> 0 AND @RegTypeID = 3) OR (@RegTypeID IN (1,2)))
          
          
              ---得到比赛官员
    		CREATE TABLE #table_tmp(
						   F_MatchID                            INT,
						   F_FatherSplitID                      INT,
						   UM_Long_Print_Name                   NVARCHAR(100),
						   UM_Short_Print_Name                  NVARCHAR(50),
						   UM_NOC                               NVARCHAR(10),
						   SVG_Long_Print_Name                  NVARCHAR(100),
						   SVG_Short_Print_Name                 NVARCHAR(50),
						   SVG_NOC                              NVARCHAR(10),
						   UM_ID                                INT,
						   SVG_ID                               INT,
					   )
		   
		   INSERT INTO #table_tmp
		        EXEC Proc_Report_BD_GetMatchOfficials @MatchID, @LanguageCode
		        
           DECLARE @MatchSplitID   INT
           DECLARE @FatherSplitID  INT
          
                            
           CREATE TABLE #tmp_GetGameNum(
                                         F_MatchID            INT,
                                         F_MatchSplitID       INT,
                                         F_FatherSplitID      INT,
                                         F_MatchSplitNum      INT,
                                         F_MatchSplitType     INT,
                                         F_SplitOrder         INT,
                                         F_SplitStartTime     NVARCHAR(10),
                                         F_SplitEndTime       NVARCHAR(10),
                                         F_SpendTime          NVARCHAR(10),
                                         F_RegA1ID            INT,
                                         F_RegA2ID            INT,
                                         F_RegB1ID            INT,
                                         F_RegB2ID            INT,
                                         F_RegA1Name          NVARCHAR(100),
                                         F_RegA2Name          NVARCHAR(100),
                                         F_RegB1Name          NVARCHAR(100),
                                         F_RegB2Name          NVARCHAR(100),
                                         F_UMShortName        NVARCHAR(100),
                                         F_SVGShortName       NVARCHAR(100),
                                         F_UMNOC              NVARCHAR(10),
                                         F_SVGNOC             NVARCHAR(10),
                                         F_MinActionOrder     INT,
                                         F_MaxActionOrder     INT,
                                         F_OrderInCourt       INT,
                                         F_ShowSet            INT
                                         )
                                         
           DECLARE @OIC INT
           DECLARE @ShowSet INT
           DECLARE One_Cursor CURSOR FOR 
			SELECT F_FatherSplitID, F_MatchSplitID FROM #tmp_SplitList 

			OPEN One_Cursor
			FETCH NEXT FROM One_Cursor INTO @FatherSplitID, @MatchSplitID
			           
			WHILE @@FETCH_STATUS = 0
			BEGIN
			   SELECT @OIC = F_OrderInRound,@ShowSet = CASE C.F_PlayerRegTypeID WHEN 3 THEN 1 ELSE 0 END FROM TS_Match AS A 
			   LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			   LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
			   WHERE A.F_MatchID = @MatchID
			   
			    ----每个Split为2行
			   INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_OrderInCourt, F_ShowSet)
			     VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @OIC,@ShowSet)
			     
			   INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_OrderInCourt, F_ShowSet)
			     VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @OIC,@ShowSet) 
			     
			   
			 
			   FETCH NEXT FROM One_Cursor INTO @FatherSplitID, @MatchSplitID
			   END
			CLOSE One_Cursor
            DEALLOCATE One_Cursor
			
			UPDATE #tmp_GetGameNum SET F_MatchSplitType = B.F_MatchSplitType, F_SplitStartTime =  dbo.[Fun_Report_BD_GetDateTime](B.F_StartTime,3), F_SplitEndTime = dbo.[Fun_Report_BD_GetDateTime](B.F_EndTime,3), F_SpendTime = dbo.Fun_info_BD_GetTimeForHHMMSS(B.F_SpendTime)
			    FROM #tmp_GetGameNum AS A 
			        LEFT JOIN TS_Match_Split_info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID
			 
			
			 IF(@RegTypeID = 1)
			 BEGIN
			     UPDATE #tmp_GetGameNum SET F_RegA1ID = B.F_RegisterID, F_RegB1Id = C.F_RegisterID, F_SplitOrder = D.F_Order
			         FROM  #tmp_GetGameNum AS A
			           LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND B.F_CompetitionPosition = 1
					   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
					   LEFT JOIN TS_Match_Split_Info AS D ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = D.F_MatchSplitID
			   
			    UPDATE #tmp_GetGameNum SET F_SplitStartTime = dbo.[Fun_Report_BD_GetDateTime](B.F_StartTime,3)
			                               , F_SplitEndTime = dbo.[Fun_Report_BD_GetDateTime](B.F_EndTime,3)
			                               , F_SpendTime = dbo.Fun_info_BD_GetTimeForHHMMSS(B.F_SpendTime)
			       FROM  TS_Match AS B WHERE B.F_MatchID = @MatchID
					
			 END
			 ELSE IF(@RegTypeID = 2)
			 BEGIN
			    UPDATE #tmp_GetGameNum SET F_RegA1ID = RM1.F_MemberRegisterID, F_RegA2ID = RM2.F_MemberRegisterID, F_RegB1Id = RM3.F_MemberRegisterID, F_RegB2Id = RM4.F_MemberRegisterID, F_SplitOrder = D.F_Order
			         FROM  #tmp_GetGameNum AS A 
			           LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND B.F_CompetitionPosition = 1
			           LEFT JOIN TR_Register_Member AS RM1 ON B.F_RegisterID = RM1.F_RegisterID AND RM1.F_Order = 1
			           LEFT JOIN TR_Register_Member AS RM2 ON B.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order = 2
					   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
					   LEFT JOIN TR_Register_Member AS RM3 ON C.F_RegisterID = RM3.F_RegisterID AND RM3.F_Order = 1
			           LEFT JOIN TR_Register_Member AS RM4 ON C.F_RegisterID = RM4.F_RegisterID AND RM4.F_Order = 2
			           LEFT JOIN TS_Match_Split_Info AS D ON A.F_MatchID = D.F_MatchID AND A.F_MatchSplitID = D.F_MatchSplitID
			           
			     UPDATE #tmp_GetGameNum SET F_SplitStartTime = dbo.[Fun_Report_BD_GetDateTime](B.F_StartTime,3)
			                               , F_SplitEndTime = dbo.[Fun_Report_BD_GetDateTime](B.F_EndTime,3)
			                               , F_SpendTime = dbo.Fun_info_BD_GetTimeForHHMMSS(B.F_SpendTime)
			       FROM  TS_Match AS B WHERE B.F_MatchID = @MatchID
			 END
			 ELSE IF(@RegTypeID = 3)
			 BEGIN
			    UPDATE #tmp_GetGameNum SET F_RegA1ID = B.F_RegisterID, F_RegB1Id = C.F_RegisterID
			         FROM  #tmp_GetGameNum AS A 
			           LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND B.F_CompetitionPosition = 1
					   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
					WHERE A.F_MatchSplitType IN (1,2)

			    UPDATE #tmp_GetGameNum SET F_RegA1ID = RM1.F_MemberRegisterID, F_RegA2ID = RM2.F_MemberRegisterID, F_RegB1Id = RM3.F_MemberRegisterID, F_RegB2Id = RM4.F_MemberRegisterID
			         FROM  #tmp_GetGameNum AS A 
			           LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND B.F_CompetitionPosition = 1
			           LEFT JOIN TR_Register_Member AS RM1 ON B.F_RegisterID = RM1.F_RegisterID AND RM1.F_Order = 1
			           LEFT JOIN TR_Register_Member AS RM2 ON B.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order = 2
					   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
					   LEFT JOIN TR_Register_Member AS RM3 ON C.F_RegisterID = RM3.F_RegisterID AND RM3.F_Order = 1
			           LEFT JOIN TR_Register_Member AS RM4 ON C.F_RegisterID = RM4.F_RegisterID AND RM4.F_Order = 2
			          WHERE A.F_MatchSplitType IN (3,4,5)
			          
			    UPDATE #tmp_GetGameNum SET F_SplitOrder = B.F_Order
			       FROM #tmp_GetGameNum AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID 
			 END
			 
			   
			  UPDATE #tmp_GetGameNum SET F_RegA1Name = RS1.F_PrintShortName, F_RegA2Name = RS2.F_PrintShortName, F_RegB1Name = RS3.F_PrintShortName, F_RegB2Name = RS4.F_PrintShortName
			       FROM #tmp_GetGameNum AS A LEFT JOIN TR_Register_Des AS RS1 ON A.F_RegA1ID = RS1.F_RegisterID AND RS1.F_LanguageCode = @LanguageCode
			             LEFT JOIN TR_Register_Des AS RS2 ON A.F_RegA2ID = RS2.F_RegisterID AND RS2.F_LanguageCode = @LanguageCode
			             LEFT JOIN TR_Register_Des AS RS3 ON A.F_RegB1ID = RS3.F_RegisterID AND RS3.F_LanguageCode = @LanguageCode
			             LEFT JOIN TR_Register_Des AS RS4 ON A.F_RegB2ID = RS4.F_RegisterID AND RS4.F_LanguageCode = @LanguageCode


            ---更新官员的数据
            UPDATE #tmp_GetGameNum SET F_UMShortName = B.UM_Short_Print_Name, F_SVGShortName = B.SVG_Short_Print_Name, F_UMNOC = B.UM_NOC, F_SVGNOC = B.SVG_NOC
               FROM #tmp_GetGameNum AS A LEFT JOIN #table_tmp AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_FatherSplitID
			
			SELECT *,ROW_NUMBER() OVER(PARTITION BY F_FatherSplitID ORDER BY F_MatchSplitID) AS RowNum FROM #tmp_GetGameNum ORDER BY F_FatherSplitID, F_MatchSplitID
SET NOCOUNT OFF
END 






GO

--EXEC Proc_Report_TE_GetSetHistory 2, 'ENG'

--EXEC Proc_Report_TE_GetSetHistory 110, 'ENG'

--exec Proc_Report_BD_GetGameSplit 95, 'eng'
--execute Proc_Report_BD_GetGameSplit 3, 'ENG'

