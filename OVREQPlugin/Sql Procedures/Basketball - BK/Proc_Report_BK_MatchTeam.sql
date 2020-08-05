IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_MatchTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_MatchTeam]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_Report_WP_MatchTeam]
--描    述：得到该场Match的队伍信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月21日


CREATE PROCEDURE [dbo].[Proc_Report_BK_MatchTeam](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @DisciplineID  INT
	SELECT @DisciplineID = D.F_DisciplineID  
	     FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID 
	           LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	     WHERE M.F_MatchID = @MatchID
	 
	 DECLARE @PSplitOrder  INT
	 SELECT @PSplitOrder = F_Order FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType = 2            
    CREATE TABLE #Tmp_Table(
                                F_TeamID        INT,
                                F_TeamPos       INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_UniformID     INT,
                                F_Uniform       NVARCHAR(100),
                                F_HomeNOC       NVARCHAR(10),
                                F_HomeDes       NVARCHAR(100),
                                F_VisitNOC      NVARCHAR(10),
                                F_VisitDes      NVARCHAR(100),
                                F_HScore        INT,
                                F_VScore        INT,
                                F_ScoreDes     NVARCHAR(50),  ------正常比分
                                F_ExtraDes     NVARCHAR(50),  -----加时比分
                                F_PScoreDes    NVARCHAR(50),  -----点球比分
                                )


		INSERT INTO #Tmp_Table (F_TeamID, F_TeamPos,  F_NOC, F_NOCDes,  F_UniformID)
           SELECT B.F_RegisterID, B.F_CompetitionPosition,  E.F_DelegationCode, F.F_DelegationLongName, B.F_UniformID2
           FROM TS_Match_Result AS B 
				LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID
				LEFT JOIN TC_Delegation AS E ON C.F_DelegationID = E.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS F ON E.F_DelegationID = F.F_DelegationID AND F.F_LanguageCode = @LanguageCode
            WHERE B.F_MatchID = @MatchID
       
        UPDATE #Tmp_Table SET F_HomeNOC = C.F_DelegationCode, F_HomeDes = D.F_DelegationLongName 
             FROM TS_Match_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                   LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
                   LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
                 WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
                 
        UPDATE #Tmp_Table SET F_VisitNOC = C.F_DelegationCode, F_VisitDes = D.F_DelegationLongName 
             FROM TS_Match_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                   LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
                   LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
                 WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
   
       UPDATE #Tmp_Table SET F_Uniform = C.F_ColorLongName FROM #Tmp_Table AS A LEFT JOIN TR_Uniform AS B ON A.F_UniformID = B.F_UniformID
                           LEFT JOIN TC_Color_Des AS C ON B.F_Shirt = C.F_ColorID AND C.F_LanguageCode = @LanguageCode   
                            
       UPDATE #Tmp_Table 
       SET F_Uniform = 
       CASE WHEN @LanguageCode = 'ENG' AND A.F_TeamPos = 1 THEN 'White'
       WHEN @LanguageCode = 'ENG' AND A.F_TeamPos = 2 THEN 'Blue'
       WHEN @LanguageCode = 'CHN' AND A.F_TeamPos = 1 THEN '白'
       WHEN @LanguageCode = 'CHN' AND A.F_TeamPos = 2 THEN '蓝'
       END
       FROM #Tmp_Table AS A 
                          
                                               
       UPDATE #Tmp_Table SET F_HScore = MR.F_Points  FROM TS_Match_Result AS MR WHERE MR.F_MatchID = @MatchID AND MR.F_CompetitionPosition = 1
       UPDATE #Tmp_Table SET F_VScore = MR.F_Points  FROM TS_Match_Result AS MR WHERE MR.F_MatchID = @MatchID AND MR.F_CompetitionPosition = 2
       
       UPDATE #Tmp_Table SET F_ScoreDes = dbo.Fun_Report_WP_GetSplitScoreDes (@MatchID, 1)
       UPDATE #Tmp_Table SET F_ScoreDes = '(' + F_ScoreDes + ')' WHERE F_ScoreDes IS NOT NULL AND LEN(F_ScoreDes) <>0
       
       UPDATE #Tmp_Table SET F_ExtraDes = dbo.Fun_Report_WP_GetSplitScoreDes (@MatchID, 2)
       UPDATE #Tmp_Table SET F_ExtraDes = '(' + F_ExtraDes + ')' WHERE F_ExtraDes IS NOT NULL AND LEN(F_ExtraDes) <>0
       
       
       UPDATE #Tmp_Table SET F_PScoreDes = dbo.Fun_Report_WP_GetSplitScoreDes (@MatchID, 3)  
       UPDATE #Tmp_Table SET F_PScoreDes = '(' + F_PScoreDes + ')' WHERE F_PScoreDes IS NOT NULL AND LEN(F_PScoreDes) <>0
	
	SELECT * FROM #Tmp_Table 
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO