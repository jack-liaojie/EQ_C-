
/****** Object:  StoredProcedure [dbo].[Proc_HB_GetPenalytPlayer]    Script Date: 08/30/2012 08:40:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetPenalytPlayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetPenalytPlayer]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_GetPenalytPlayer]    Script Date: 08/30/2012 08:40:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_HB_GetPenalytPlayer]
--描    述：得到该场Match的点球队员技术统计
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月21日


CREATE PROCEDURE [dbo].[Proc_HB_GetPenalytPlayer](
												@MatchID		    INT,
												@MatchSplitID       INT,
												@TeamPos            INT,
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
	             
    CREATE TABLE #Tmp_Table(
                                F_ActionID      INT, 
                                F_RegisterID    INT,
                                F_PrintLN       NVARCHAR(100),
                                F_Bib           INT,
                                F_PResult       INT,
                                F_ResultDes     NVARCHAR(10),
                                F_Comment       NVARCHAR(50),
                                F_Order         INT,
                                F_ActionOrder   INT,
                                F_PositionCode  NVARCHAR(50),
                                )


		INSERT INTO #Tmp_Table (F_ActionID, F_RegisterID, F_PrintLN, F_Bib,  F_Order, F_PositionCode)
           SELECT -1, A.F_RegisterID, B.F_LongName, A.F_ShirtNumber, A.F_Order, C.F_PositionCode
              FROM TS_Match_Split_Member AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
                   LEFT JOIN TD_Position AS C ON A.F_PositionID = C.F_PositionID
               WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @MatchSplitID AND A.F_CompetitionPosition = @TeamPos
      
        DELETE FROM #Tmp_Table WHERE F_PositionCode = 'GK' 
       
     -----计算技术统计    
    UPDATE #Tmp_Table SET F_ActionID =  B.F_ActionNumberID , F_PResult = B.F_ActionDetail4, F_Comment = B.F_ActionHappenTimeSpan, F_ActionOrder = B.F_ActionOrder
           FROM  #Tmp_Table AS A LEFT JOIN TS_Match_ActionList AS B ON A.F_RegisterID = B.F_RegisterID 
                 LEFT JOIN TD_ActionType AS C ON B.F_ActionTypeID = C.F_ActionTypeID
            WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitID = @MatchSplitID AND ( C.F_ActionCode = 'PShotOnGoal' OR C.F_ActionCode = 'PShotNoGoal' OR C.F_ActionCode = 'PenaltyGoal') AND B.F_CompetitionPosition = @TeamPos

     UPDATE #Tmp_Table SET F_ResultDes = B.Des FROM #Tmp_Table AS A 
            LEFT JOIN ( (SELECT 1 AS Result, 'Goal' AS Des) UNION (SELECT 2 AS Result, 'Block' AS Des) UNION (SELECT 3 AS Result, 'Crossbar' AS Des) UNION (SELECT 4 AS Result, 'Missed' AS Des)) AS B     
            ON A.F_PResult = B.Result   
	
	SELECT F_RegisterID, F_Bib AS CapNo, F_PrintLN AS Name, F_ResultDes AS ResultDes,  F_ActionID FROM #Tmp_Table ORDER BY F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


