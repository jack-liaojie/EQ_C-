
/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetGameNum]    Script Date: 05/03/2011 09:47:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetGameNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetGameNum]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetGameNum]    Script Date: 05/03/2011 09:47:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_BD_GetGameNum]
----功		  能：得到一场比赛的局数
----作		  者：李燕
----日		  期: 2011-03-13
----修 改 记  录：
/*
*/

CREATE PROCEDURE [dbo].[Proc_Report_BD_GetGameNum] (	
	@MatchID					INT,
	@LanguageCode               NVARCHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

           DECLARE @RegTypeID  INT
           DECLARE @MatchType INT
		 
           SELECT @RegTypeID = E.F_PlayerRegTypeID, @MatchType = F_MatchTypeID 
               FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
                    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                  WHERE M.F_MatchID = @MatchID
            
            --得到比赛Action的Number        
           CREATE TABLE #tmp_ActionList(
                                        F_MatchID            INT,
                                        F_FatherSplitID      INT,
                                        F_MatchSplitID       INT,
                                        F_ActionNum          INT,
                                        F_MinActionOrder     INT,
                                        F_MaxActionOrder     INT,
                                        )
          
             INSERT INTO #tmp_ActionList(F_MatchSplitID, F_MatchID)
               SELECT F_MatchSplitID, @MatchID
                FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND ((F_FatherMatchSplitID <> 0 AND @RegTypeID = 3) OR (F_FatherMatchSplitID  = 0 AND @RegTypeID IN (1,2)))
           --INSERT INTO #tmp_ActionList(F_MatchSplitID, F_MatchID)
           --     SELECT DISTINCT F_MatchSplitID,@MatchID
           --          FROM TS_Match_Actionlist WHERE F_MatchID = @MatchID
           
           UPDATE #tmp_ActionList SET F_ActionNum = B.F_ActionNum, F_MinActionOrder = B.F_MinActionOrder, F_MaxActionOrder = B.F_MaxActionOrder
                     FROM #tmp_ActionList AS A 
                         LEFT JOIN (SELECT Y.F_MatchSplitID, COUNT(Y.F_ActionNumberID) AS F_ActionNum, MIN(Y.F_ActionOrder) AS F_MinActionOrder, MAX(Y.F_ActionOrder) AS F_MaxActionOrder
                                       FROM #tmp_ActionList AS X 
                                        LEFT JOIN TS_Match_Actionlist AS Y ON X.F_MatchSplitID = Y.F_MatchSplitID 
                                            WHERE Y.F_MatchID = @MatchID GROUP BY Y.F_MatchSplitID) AS B 
                     ON A.F_MatchSplitID = B.F_MatchSplitID
           
           UPDATE #tmp_ActionList SET F_FatherSplitID = B.F_FatherMatchSplitID
                     FROM #tmp_ActionList AS A 
                     LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
                     
            UPDATE #tmp_ActionList SET F_ActionNum = 0 WHERE F_ActionNum IS NULL
            UPDATE #tmp_ActionList SET F_MinActionOrder = 0 WHERE F_MinActionOrder IS NULL
            UPDATE #tmp_ActionList SET F_MaxActionOrder = 0 WHERE F_MaxActionOrder IS NULL
            
            
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
		
		
		 IF @MatchType = 3
			 BEGIN
				INSERT INTO #table_tmp (F_MatchID, F_FatherSplitID) 
					SELECT F_MatchID, F_MatchSplitID
					   FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
			     
				 UPDATE #table_tmp SET UM_ID = B.F_RegisterID, SVG_Long_Print_Name = D.F_PrintLongName, UM_Short_Print_Name = D.F_PrintShortName,  UM_NOC =  F.F_DelegationCode
					 FROM #table_tmp AS A 
						 LEFT JOIN TS_Match_Split_Servant AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID 
						 LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
						 LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
						 LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
						 LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
					 WHERE C.F_FunctionCode = 'UM' 
					 
				 UPDATE #table_tmp SET SVG_ID = B.F_RegisterID, UM_Long_Print_Name = D.F_PrintLongName, SVG_Short_Print_Name = D.F_PrintShortName,  SVG_NOC =  F.F_DelegationCode
				 FROM #table_tmp AS A 
					 LEFT JOIN TS_Match_Split_Servant AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID 
					 LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
					 LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
					 LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
					 LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
				 WHERE C.F_FunctionCode = 'SVJ' 
			 END
		 ELSE
			BEGIN
				INSERT INTO #table_tmp (F_MatchID, F_FatherSplitID) VALUES(@MatchID , 0)
		
				UPDATE #table_tmp SET UM_ID = B.F_RegisterID, SVG_Long_Print_Name = D.F_PrintLongName, UM_Short_Print_Name = D.F_PrintShortName,  UM_NOC =  F.F_DelegationCode
				 FROM #table_tmp AS A 
					 LEFT JOIN TS_Match_Servant AS B ON A.F_MatchID = B.F_MatchID
					 LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
					 LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
					 LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
					 LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
				 WHERE C.F_FunctionCode = 'UM' 
		         
				 UPDATE #table_tmp SET SVG_ID = B.F_RegisterID, UM_Long_Print_Name = D.F_PrintLongName, SVG_Short_Print_Name = D.F_PrintShortName,  SVG_NOC =  F.F_DelegationCode
				 FROM #table_tmp AS A 
					 LEFT JOIN TS_Match_Servant AS B ON A.F_MatchID = B.F_MatchID 
					 LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
					 LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
					 LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
					 LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
				 WHERE C.F_FunctionCode = 'SVJ' 
			END
		 
       

         
    
            
           DECLARE @MatchSplitNum   INT
           SET @MatchSplitNum = 1
           
           DECLARE @MidActionOrder  INT
           SET @MidActionOrder = 36
           
           DECLARE @MatchSplitID   INT
           DECLARE @FatherSplitID  INT
           DECLARE @ActionNum      INT
           DECLARE @MinActionOrder INT
           DECLARE @MaxActionOrder INT
                            
           CREATE TABLE #tmp_GetGameNum(
                                         F_MatchID            INT,
                                         F_MatchSplitID       INT,
                                         F_FatherSplitID      INT,
                                         F_MatchSplitNum      INT,
                                         F_MatchSplitType     INT,
                                         F_SplitStartTime     NVARCHAR(10),
                                         F_SplitEndTime       NVARCHAR(10),
                                         F_SpendTime          NVARCHAR(10),
                                         F_SplitOrder         INT,
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
                                         F_ScoreDes1          NVARCHAR(20),
                                         F_ScoreDes2          NVARCHAR(20),
                                         F_ScoreDes3          NVARCHAR(20)
                                         )
                                      
           DECLARE One_Cursor CURSOR FOR 
			SELECT F_FatherSplitID, F_MatchSplitID, F_ActionNum , F_MinActionOrder, F_MaxActionOrder FROM #tmp_ActionList 

			OPEN One_Cursor
			FETCH NEXT FROM One_Cursor INTO @FatherSplitID, @MatchSplitID, @ActionNum, @MinActionOrder, @MaxActionOrder
			           
			WHILE @@FETCH_STATUS = 0
			BEGIN
			   IF(@ActionNum <= 36)
			   BEGIN
			        INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_MinActionOrder,F_MaxActionOrder)
			         VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @MatchSplitNum, @MinActionOrder,@MaxActionOrder)
			         
			         SET @MatchSplitNum = @MatchSplitNum + 1
			   END
			   ELSE 
			   BEGIN
			      INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_MinActionOrder,F_MaxActionOrder)
			         VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @MatchSplitNum, @MinActionOrder,@MidActionOrder)
			         
			         SET @MatchSplitNum = @MatchSplitNum + 1
			         
			     INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_MinActionOrder,F_MaxActionOrder)
			         VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @MatchSplitNum, @MidActionOrder+1, @MaxActionOrder)
			         
			         SET @MatchSplitNum = @MatchSplitNum + 1
			   END
			   FETCH NEXT FROM One_Cursor INTO @FatherSplitID, @MatchSplitID, @ActionNum, @MinActionOrder, @MaxActionOrder
			END
			CLOSE One_Cursor
            DEALLOCATE One_Cursor
				
			UPDATE #tmp_GetGameNum SET F_MatchSplitType = B.F_MatchSplitType, F_SplitStartTime =  dbo.[Fun_Report_BD_GetDateTime](B.F_StartTime,3), F_SplitEndTime = dbo.[Fun_Report_BD_GetDateTime](B.F_EndTime,3), F_SpendTime = dbo.Fun_info_BD_GetTimeForHHMMSS(B.F_SpendTime) 
			    FROM #tmp_GetGameNum AS A 
			        LEFT JOIN TS_Match_Split_info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID
		 
			 IF(@RegTypeID = 1)
			 BEGIN			
			     UPDATE #tmp_GetGameNum SET F_RegA1ID = B.F_RegisterID, F_RegB2Id = C.F_RegisterID, F_SplitOrder = D.F_Order
			         FROM  #tmp_GetGameNum AS A
			           LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND B.F_CompetitionPosition = 1
					   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
					   LEFT JOIN TS_Match_Split_Info AS D ON A.F_MatchID = D.F_MatchID AND A.F_MatchSplitID = D.F_MatchSplitID

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
			    UPDATE #tmp_GetGameNum SET F_RegA1ID = B.F_RegisterID, F_RegB2Id = C.F_RegisterID
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
			
		
			CREATE TABLE #TMP_TABLE 
			(
				F_MatchID INT,
				F_FatherSplitID INT,
				ScoreDes1 NVARCHAR(20),
				ScoreDes2 NVARCHAR(20),
				ScoreDes3 NVARCHAR(20)
			)
			
			CREATE TABLE #TMP_TB_DES
			(
				F_Order INT,
				F_ScoreDes NVARCHAR(20)
			)
			

			INSERT INTO #TMP_TABLE( F_MatchID, F_FatherSplitID)
			SELECT F_MatchID, F_MatchSplitID FROM TS_Match_Split_Info AS A
			WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0

			
		--	DECLARE @FatherSplitID INT
			DECLARE mycursor CURSOR FOR SELECT F_FatherSplitID FROM #TMP_TABLE
			OPEN mycursor
			FETCH NEXT FROM mycursor INTO @FatherSplitID
			WHILE @@FETCH_STATUS = 0 
				BEGIN
					IF @MatchType = 3
						BEGIN
							DELETE FROM #TMP_TB_DES
							
							INSERT INTO #TMP_TB_DES (F_Order, F_ScoreDes)
							(
								SELECT SR.[Order], ISNULL(CAST(Sr.PtA AS NVARCHAR(10)), '')  + ( CASE WHEN Sr.IRMA IS NULL THEN '' ELSE '(' + Sr.IRMA  + ')'END )
								                 + ' : ' + ISNULL(CAST(Sr.PtB AS NVARCHAR(10)), '')   + ( CASE WHEN Sr.IRMB IS NULL THEN '' ELSE '(' + Sr.IRMB  + ')'END )
							FROM
								(SELECT ROW_NUMBER() OVER(ORDER BY A.F_MatchSplitID) AS [Order],B1.F_Points AS PtA, B2.F_Points AS PtB, I1.F_IRMCODE AS IRMA, I2.F_IRMCODE AS IRMB 
								FROM TS_Match_Split_Info AS A
								LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
								LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
								LEFT JOIN TC_IRM AS I1 ON B1.F_IRMID = I1.F_IRMID
								LEFT JOIN TC_IRM AS I2 ON B2.F_IRMID = I2.F_IRMID
								WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = @FatherSplitID) AS SR
							)
							
                            UPDATE #TMP_TB_DES SET F_ScoreDes = NULL WHERE LTRIM(RTRIM(F_ScoreDes)) = ':'
                            
							UPDATE #TMP_TABLE SET ScoreDes1 = ( SELECT CASE F_ScoreDes WHEN '0 : 0' THEN NULL ELSE F_ScoreDes END FROM #TMP_TB_DES WHERE F_Order = 1)
							WHERE F_MatchID = @MatchID AND F_FatherSplitID = @FatherSplitID
							
							UPDATE #TMP_TABLE SET ScoreDes2 = ( SELECT CASE F_ScoreDes WHEN '0 : 0' THEN NULL ELSE F_ScoreDes END FROM #TMP_TB_DES WHERE F_Order = 2)
							WHERE F_MatchID = @MatchID AND F_FatherSplitID = @FatherSplitID
							
							UPDATE #TMP_TABLE SET ScoreDes3 = ( SELECT CASE F_ScoreDes WHEN '0 : 0' THEN NULL ELSE F_ScoreDes END FROM #TMP_TB_DES WHERE F_Order = 3)
							WHERE F_MatchID = @MatchID AND F_FatherSplitID = @FatherSplitID
							
						END
					ELSE IF @MatchType IN (1,2)
						BEGIN
							UPDATE #TMP_TABLE SET ScoreDes1 =
							(
								SELECT ISNULL( CAST(B1.F_Points AS NVARCHAR(10)), '') + ( CASE WHEN B1.F_IRMID IS NULL THEN '' ELSE '(' + I1.F_IRMCode  + ')'END )
								+ ' : ' + ISNULL( CAST(B2.F_Points AS NVARCHAR(10)), '') + ( CASE WHEN B2.F_IRMID IS NULL THEN '' ELSE '(' + I2.F_IRMCode  + ')'END )
								FROM TS_Match_Split_Info AS A
								LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
											AND B1.F_CompetitionPosition = 1
								LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
											AND B2.F_CompetitionPosition = 2
							    LEFT JOIN TC_IRM AS I1 ON B1.F_IRMID = I1.F_IRMID
							    LEFT JOIN TC_IRM AS I2 ON B2.F_IRMID = I2.F_IRMID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @FatherSplitID
							) 
							WHERE F_MatchID = @MatchID AND F_FatherSplitID = @FatherSplitID
							
						 UPDATE #TMP_TABLE SET ScoreDes1 = NULL WHERE LTRIM(RTRIM(ScoreDes1)) = ':'
						END
					
					FETCH NEXT FROM mycursor INTO @FatherSplitID
				END
				
			CLOSE mycursor
			DEALLOCATE mycursor
			DROP TABLE #TMP_TB_DES
			
			IF @MatchType IN (1,2)
				BEGIN
					UPDATE #TMP_TABLE SET ScoreDes2 = 
					(
						SELECT CASE ScoreDes1 WHEN '0 : 0' THEN NULL ELSE ScoreDes1 END  FROM #TMP_TABLE WHERE F_FatherSplitID = 2
					)
					
					UPDATE #TMP_TABLE SET ScoreDes3 = 
					(
						SELECT CASE ScoreDes1 WHEN '0 : 0' THEN NULL ELSE ScoreDes1 END  FROM #TMP_TABLE WHERE F_FatherSplitID = 3
					)
					
					DELETE FROM #TMP_TABLE WHERE F_FatherSplitID IN(2,3)
					
					UPDATE #TMP_TABLE SET F_FatherSplitID = 0
				END
				
			UPDATE #tmp_GetGameNum SET F_ScoreDes1 = B.ScoreDes1, F_ScoreDes2 = B.ScoreDes2, F_ScoreDes3 = B.ScoreDes3
			FROM #tmp_GetGameNum AS A
			LEFT JOIN #TMP_TABLE AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherSplitID = A.F_FatherSplitID
			
			DROP TABLE #TMP_TABLE
			SELECT * FROM #tmp_GetGameNum ORDER BY F_FatherSplitID, F_MatchSplitID
SET NOCOUNT OFF
END 







GO

--exec [Proc_Report_BD_GetGameNum] 2, 'eng'
--exec [Proc_Report_BD_GetGameNum] 124, 'eng'
