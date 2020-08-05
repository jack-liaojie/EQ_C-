IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_GetResultsBracket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_GetResultsBracket]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_FB_GetResultsBracket]
--描    述：得到Event下淘汰赛的Match信息
--参数说明： 
--说    明：
--创 建 人：杨佳鹏
--日    期：2011年3月11日


CREATE PROCEDURE [dbo].[Proc_Report_FB_GetResultsBracket](
                       @EventID         INT,
                       --@RoundOrder      INT,   -----1:Final, 2:Semifinal, 3:Quarterfinal, 4:Eighthfinal
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
	                        F_EventID          INT,
                            F_MatchID          INT,
                            F_APlayerID        INT,
                            F_ADes             NVARCHAR(100),
                            F_ANOC             NVARCHAR(10),
                            F_APreResult       NVARCHAR(100),
                            F_BPlayerID        INT,
                            F_BDes             NVARCHAR(100),
                            F_BNOC             NVARCHAR(10),
                            F_BPreResult       NVARCHAR(100),
                            F_MatchName        NVARCHAR(100),
                            F_MatchDes         NVARCHAR(100),
                            F_MatchNum         INT,
                            F_MatchDate        NVARCHAR(100),
                            F_MatchResult      NVARCHAR(150),
                            F_MatchWinner      NVARCHAR(100),
                            F_PhaseName        NVARCHAR(150),   
                            F_WRank            INT,
                            F_WNOC             NVARCHAR(20),
                            F_WDes             NVARCHAR(150),
                            F_WPlayerID        INT,
                            F_LRank            INT,  
                            F_LNOC             NVARCHAR(20),
                            F_LDes             NVARCHAR(150),  
                            F_LPlayerID        INT, 
                            F_RoundCode		   NVARCHAR(50), 
                            F_OrderInRound		INT,    
                            F_MatchStatusID     INT   
							)

    INSERT INTO #Tmp_Table(F_EventID, F_MatchID, F_MatchName, F_MatchNum, F_MatchDate, F_PhaseName,F_RoundCode,F_OrderInRound,F_MatchStatusID)
             SELECT F.F_EventID, A.F_MatchID, B.F_MatchShortName, A.F_MatchNum,dbo.[Func_Report_FB_GetDateTime](A.F_MatchDate,8,@LanguageCode),-- UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)) + ' ' + UPPER(LEFT(CONVERT (NVARCHAR(100),A.F_MatchDate, 113), 7)), 
                    C.F_PhaseLongName,E.F_RoundCode,A.F_OrderInRound,A.F_MatchStatusID
             FROM TS_Match AS A 
                  LEFT JOIN TS_Match_Des AS B  ON A.F_MatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
                  LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
                  LEFT JOIN TS_Phase AS D ON A.F_PhaseID = D.F_PhaseID
                  LEFT JOIN TS_Round AS E ON A.F_RoundID = E.F_RoundID 
                  LEFT JOIN TS_Event AS F ON D.F_EventID = F.F_EventID
                WHERE D.F_EventID = @EventID 
                
      UPDATE #Tmp_Table SET F_APlayerID = B.F_RegisterID, F_ANOC =  D.F_DelegationCode, F_ADes = D.F_DelegationCode
           FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
                LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
                LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID 
                LEFT JOIN TC_Delegation_Des AS E ON E.F_DelegationID = D.F_DelegationID AND E.F_LanguageCode = @LanguageCode
            WHERE B.F_CompetitionPosition = 1
            
      UPDATE #Tmp_Table SET F_BPlayerID = B.F_RegisterID, F_BNOC =  D.F_DelegationCode, F_BDes = D.F_DelegationCode
           FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
                LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
                LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID 
                LEFT JOIN TC_Delegation_Des AS E ON E.F_DelegationID = D.F_DelegationID AND E.F_LanguageCode = @LanguageCode
            WHERE B.F_CompetitionPosition = 2
    
        UPDATE #Tmp_Table SET F_ADes = B.F_CompetitorSourceDes FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1  AND B.F_LanguageCode = @LanguageCode WHERE A.F_ADes IS NULL
        UPDATE #Tmp_Table SET F_BDes = B.F_CompetitorSourceDes FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2 AND B.F_LanguageCode = @LanguageCode WHERE A.F_BDes IS NULL
            
        UPDATE #Tmp_Table SET F_MatchWinner =  D.F_DelegationShortName, F_WPlayerID = B.F_RegisterID
               FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_Rank = 1 
               LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
               LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
               WHERE A.F_MatchStatusID = 110 OR A.F_MatchStatusID = 100       

       UPDATE #Tmp_Table SET F_MatchDes = (CASE WHEN @LanguageCode = 'ENG' THEN 'Match ' ELSE '第' END) + CAST (F_MatchNum AS NVARCHAR(20)) + (CASE WHEN @LanguageCode = 'ENG' THEN '' ELSE '场' END)
       
       DECLARE @MatchID INT
       DECLARE @MatchStatusID INT
       DECLARE @SouceMatchID INT
       DECLARE @SouceMatchStatusID INT
       DECLARE @OutPut  NVARCHAR(Max)
       DECLARE MatchIDCursor CURSOR FOR
       SELECT  F_MatchID, F_MatchStatusID FROM  #Tmp_Table
       OPEN MatchIDCursor
       FETCH NEXT FROM MatchIDCursor INTO @MatchID,@MatchStatusID
        WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @MatchStatusID = 110 OR @MatchStatusID = 100
			BEGIN
				exec [Proc_FB_GetMatchResult] @MatchID , @OutPut OUTPUT
				UPDATE #Tmp_Table SET F_MatchResult =  @OutPut WHERE F_MatchID = @MatchID
			END
			
			
			SELECT @SouceMatchID = A.F_SourceMatchID,@SouceMatchStatusID = B.F_MatchStatusID  
			FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
			IF @SouceMatchStatusID =110 OR @SouceMatchStatusID =100
			BEGIN
				exec [Proc_FB_GetMatchResult] @SouceMatchID , @OutPut OUTPUT
				UPDATE #Tmp_Table SET F_APreResult =  @OutPut WHERE F_MatchID = @MatchID
			END
			SET @SouceMatchID = NULL
			SET @SouceMatchStatusID = NULL
			
			SELECT @SouceMatchID = A.F_SourceMatchID,@SouceMatchStatusID =B.F_MatchStatusID  
			FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
			IF @SouceMatchStatusID =110 OR @SouceMatchStatusID =100
			BEGIN
				exec [Proc_FB_GetMatchResult] @SouceMatchID , @OutPut OUTPUT
				UPDATE #Tmp_Table SET F_BPreResult =  @OutPut WHERE F_MatchID = @MatchID
			END
			SET @SouceMatchID = NULL
			SET @SouceMatchStatusID = NULL
			
			
			
			FETCH NEXT FROM MatchIDCursor INTO @MatchID,@MatchStatusID
		END
		CLOSE MatchIDCursor
		DEALLOCATE MatchIDCursor
	    
       UPDATE #Tmp_Table SET F_LPlayerID = (CASE WHEN F_WPlayerID = F_APlayerID THEN F_BPlayerID WHEN F_WPlayerID = F_BPlayerID THEN F_APlayerID ELSE NULL  END)
       
       UPDATE #Tmp_Table SET F_WRank = 1, F_WDes = D.F_DelegationCode + ' - ' + E.F_DelegationShortName, F_WNOC = D.F_DelegationCode
           FROM #Tmp_Table AS A LEFT JOIN TR_Register AS C ON A.F_WPlayerID = C.F_RegisterID
                 LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
                 LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
           WHERE A.F_WPlayerID IS NOT NULL 
        
       UPDATE #Tmp_Table SET F_LRank = 2, F_LDes = D.F_DelegationCode + ' - ' + E.F_DelegationShortName, F_LNOC = D.F_DelegationCode
           FROM #Tmp_Table AS A 
                 LEFT JOIN TR_Register AS C ON A.F_LPlayerID = C.F_RegisterID
                 LEFT JOIN TC_Delegation AS D ON C.F_DelegationID = D.F_DelegationID
                 LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
           WHERE A.F_LPlayerID IS NOT NULL 
               
    SELECT * FROM #Tmp_Table ORDER BY F_RoundCode ,F_OrderInRound

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO