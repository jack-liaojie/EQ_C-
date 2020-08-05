IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetMedalStandings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetMedalStandings]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_SH_GetMedalStandings]
--描    述：得到Discipline下所有奖牌，按国家排序
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年09月15日


CREATE PROCEDURE [dbo].[Proc_Report_SH_GetMedalStandings](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

    CREATE TABLE #Tmp_Table(
                                F_RegisterID   INT,
                                F_DelegationID INT,
                           )

    CREATE TABLE #Number_Table(
                                  F_DelegationID INT,
                                  F_Number   INT,
                               )        
 
	
	CREATE TABLE #Tmp_Medal(
                                F_DelegationID INT,
                                F_Rank         INT,
                                F_NOC          NVARCHAR(10),
                                F_NOCDes       NVARCHAR(50),
                                F_MenG         INT,
                                F_MenS         INT,
                                F_MenB         INT,
                                F_WomenG       INT,
                                F_WomenS       INT,
                                F_WomenB       INT,
                                F_TotalG       INT,
                                F_TotalS       INT,
                                F_TotalB       INT,
                                F_TotalT       INT,
                                F_RankByTotal  NVARCHAR(10)
							)

    CREATE TABLE #Tmp_Rank(
                                F_DelegationID INT,
                                F_Rank         INT,
                           )

    CREATE TABLE #Tmp_FinishEvent(
                                     F_EventID     INT
                                 )

    CREATE TABLE #Tmp_RankByTotal(
                                     F_RankByTotal NVARCHAR(10),
                                     F_Number      INT,
                                  )

    --总的奖牌国家
    INSERT INTO #Tmp_Medal(F_DelegationID, F_NOC, F_NOCDes, F_MenG, F_MenS, F_MenB, F_WomenG, F_WomenS, F_WomenB)
    SELECT DISTINCT D.F_DelegationID, D.F_DelegationCode, E.F_DelegationShortName, 0 AS F_MenG, 0 AS F_MenS, 0 AS F_MenB, 0 AS F_WomenG, 0 AS F_WomenS, 0 AS F_WomenB FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
    WHERE C.F_DisciplineID = @DisciplineID AND A.F_RegisterID IS NOT NULL

    --计算女子金牌
    INSERT INTO #Tmp_Table(F_RegisterID, F_DelegationID)
    SELECT A.F_RegisterID, D.F_DelegationID FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID WHERE C.F_DisciplineID = @DisciplineID AND C.F_SexCode = 2 AND A.F_EventRank = 1 AND A.F_RegisterID IS NOT NULL

    INSERT INTO #Number_Table(F_DelegationID, F_Number)
    SELECT F_DelegationID, COUNT(F_DelegationID) FROM #Tmp_Table GROUP BY F_DelegationID

    UPDATE #Tmp_Medal SET F_WomenG = (CASE WHEN B.F_Number IS NULL THEN 0 ELSE B.F_Number END) FROM #Tmp_Medal AS A LEFT JOIN #Number_Table AS B ON A.F_DelegationID = B.F_DelegationID

    --计算女子银牌
    DELETE FROM #Tmp_Table
    DELETE FROM #Number_Table

    INSERT INTO #Tmp_Table(F_RegisterID, F_DelegationID)
    SELECT A.F_RegisterID, D.F_DelegationID FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID WHERE C.F_DisciplineID = @DisciplineID AND C.F_SexCode = 2 AND A.F_EventRank = 2 AND A.F_RegisterID IS NOT NULL

    INSERT INTO #Number_Table(F_DelegationID, F_Number)
    SELECT F_DelegationID, COUNT(F_DelegationID) FROM #Tmp_Table GROUP BY F_DelegationID

    UPDATE #Tmp_Medal SET F_WomenS = (CASE WHEN B.F_Number IS NULL THEN 0 ELSE B.F_Number END) FROM #Tmp_Medal AS A LEFT JOIN #Number_Table AS B ON A.F_DelegationID = B.F_DelegationID

    --计算女子铜牌
    DELETE FROM #Tmp_Table
    DELETE FROM #Number_Table

    INSERT INTO #Tmp_Table(F_RegisterID, F_DelegationID)
    SELECT A.F_RegisterID, D.F_DelegationID FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID WHERE C.F_DisciplineID = @DisciplineID AND C.F_SexCode = 2 AND A.F_EventRank = 3 AND A.F_RegisterID IS NOT NULL

    INSERT INTO #Number_Table(F_DelegationID, F_Number)
    SELECT F_DelegationID, COUNT(F_DelegationID) FROM #Tmp_Table GROUP BY F_DelegationID

    UPDATE #Tmp_Medal SET F_WomenB = (CASE WHEN B.F_Number IS NULL THEN 0 ELSE B.F_Number END) FROM #Tmp_Medal AS A LEFT JOIN #Number_Table AS B ON A.F_DelegationID = B.F_DelegationID
    
    --计算男子金牌
    DELETE FROM #Tmp_Table
    DELETE FROM #Number_Table

    INSERT INTO #Tmp_Table(F_RegisterID, F_DelegationID)
    SELECT A.F_RegisterID, D.F_DelegationID FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID WHERE C.F_DisciplineID = @DisciplineID AND C.F_SexCode = 1 AND A.F_EventRank = 1 AND A.F_RegisterID IS NOT NULL

    INSERT INTO #Number_Table(F_DelegationID, F_Number)
    SELECT F_DelegationID, COUNT(F_DelegationID) FROM #Tmp_Table GROUP BY F_DelegationID

    UPDATE #Tmp_Medal SET F_MenG = (CASE WHEN B.F_Number IS NULL THEN 0 ELSE B.F_Number END) FROM #Tmp_Medal AS A LEFT JOIN #Number_Table AS B ON A.F_DelegationID = B.F_DelegationID
    
    --计算男子银牌
    DELETE FROM #Tmp_Table
    DELETE FROM #Number_Table

    INSERT INTO #Tmp_Table(F_RegisterID, F_DelegationID)
    SELECT A.F_RegisterID, D.F_DelegationID FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID WHERE C.F_DisciplineID = @DisciplineID AND C.F_SexCode = 1 AND A.F_EventRank = 2 AND A.F_RegisterID IS NOT NULL

    INSERT INTO #Number_Table(F_DelegationID, F_Number)
    SELECT F_DelegationID, COUNT(F_DelegationID) FROM #Tmp_Table GROUP BY F_DelegationID

    UPDATE #Tmp_Medal SET F_MenS = (CASE WHEN B.F_Number IS NULL THEN 0 ELSE B.F_Number END) FROM #Tmp_Medal AS A LEFT JOIN #Number_Table AS B ON A.F_DelegationID = B.F_DelegationID
    
    --计算男子铜牌
    DELETE FROM #Tmp_Table
    DELETE FROM #Number_Table

    INSERT INTO #Tmp_Table(F_RegisterID, F_DelegationID)
    SELECT A.F_RegisterID, D.F_DelegationID FROM TS_Event_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID WHERE C.F_DisciplineID = @DisciplineID AND C.F_SexCode = 1 AND A.F_EventRank = 3 AND A.F_RegisterID IS NOT NULL

    INSERT INTO #Number_Table(F_DelegationID, F_Number)
    SELECT F_DelegationID, COUNT(F_DelegationID) FROM #Tmp_Table GROUP BY F_DelegationID

    UPDATE #Tmp_Medal SET F_MenB = (CASE WHEN B.F_Number IS NULL THEN 0 ELSE B.F_Number END) FROM #Tmp_Medal AS A LEFT JOIN #Number_Table AS B ON A.F_DelegationID = B.F_DelegationID
    

    --计算总数
    
    UPDATE #Tmp_Medal SET F_TotalG = F_MenG + F_WomenG, F_TotalS = F_MenS + F_WomenS, F_TotalB = F_MenB + F_WomenB
    UPDATE #Tmp_Medal SET F_TotalT = F_TotalG + F_TotalS + F_TotalB

    --总排名
    INSERT INTO #Tmp_Rank(F_DelegationID, F_Rank)
    SELECT F_DelegationID, RANK() OVER (order by F_TotalG DESC, F_TotalS DESC, F_TotalB DESC, F_TotalT DESC) FROM #Tmp_Medal-- ORDER BY F_TotalG, F_TotalS, F_TotalB, F_TotalT, F_NOC
    
    UPDATE #Tmp_Medal SET F_Rank = B.F_Rank FROM #Tmp_Medal AS A LEFT JOIN #Tmp_Rank AS B ON A.F_DelegationID = B.F_DelegationID

    --按奖牌总数排名
    DELETE FROM #Tmp_Rank
    INSERT INTO #Tmp_Rank(F_DelegationID, F_Rank)
    SELECT F_DelegationID, RANK() OVER (order by F_TotalT DESC) FROM #Tmp_Medal
    
    UPDATE #Tmp_Medal SET F_RankByTotal = B.F_Rank FROM #Tmp_Medal AS A LEFT JOIN #Tmp_Rank AS B ON A.F_DelegationID = B.F_DelegationID

    INSERT INTO #Tmp_RankByTotal(F_RankByTotal, F_Number)
    SELECT F_RankByTotal, COUNT(F_RankByTotal) FROM #Tmp_Medal GROUP BY F_RankByTotal

    UPDATE #Tmp_Medal SET F_RankByTotal = '=' + A.F_RankByTotal FROM #Tmp_Medal AS A RIGHT JOIN #Tmp_RankByTotal AS B ON A.F_RankByTotal = B.F_RankByTotal
    AND B.F_Number > 1

    SELECT * FROM #Tmp_Medal ORDER BY F_Rank, F_NOC

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


