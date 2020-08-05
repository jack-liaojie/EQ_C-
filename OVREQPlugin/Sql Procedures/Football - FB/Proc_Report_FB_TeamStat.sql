IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_TeamStat]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_TeamStat]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--��    �ƣ�[Proc_Report_FB_TeamStat]
--��    �����õ��ó�Match�Ķ��鼼��ͳ��
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2010��10��28��


CREATE PROCEDURE [dbo].[Proc_Report_FB_TeamStat](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @DisciplineID  INT
	DECLARE @HTeamID       INT
	DECLARE @VTeamID       INT
	
	SELECT @DisciplineID = D.F_DisciplineID  
	     FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID 
	           LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	     WHERE M.F_MatchID = @MatchID
	     
	SELECT @HTeamID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
	SELECT @VTeamID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
             
    CREATE TABLE #Tmp_Table(
                            F_StatOrder        Int,
                            F_StatName         NVARCHAR(50),
                            F_HStatValue       NVARCHAR(50),
                            F_VStatValue       NVARCHAR(50),
                            
                            )


		INSERT INTO #Tmp_Table (F_StatName, F_StatOrder)
           --SELECT		--'Shots', 1 
           --UNION SELECT 'Shots on Goal', 2  
           --UNION SELECT 'Fouls', 3
           --UNION SELECT 'Coner Kicks', 4
           --UNION SELECT 'Free Kicks' , 5 
           --UNION 
           SELECT 'Penalty Kicks', 6
           --UNION SELECT 'Offisides', 7
           UNION SELECT 'Own Goals', 8
           UNION SELECT 'Cautions (Yellow Cards)', 9
           UNION SELECT 'Expulsions (2nd Yellow)', 10
           UNION SELECT 'Expulsions (Red Cards)', 11 
           --UNION SELECT 'Ball Possession', 12
           --UNION SELECT 'Actual Playing Time',13 
     
     
      UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = a.F_MatchID AND TMSI.F_MatchSplitID = a.F_MatchSplitID
					   WHERE C.F_MatchID=@MatchID 
					   AND  C.F_CompetitionPosition = 1 
					    AND TMSI.F_MatchSplitCode <>'51' 
					   AND X.F_StatisticCode IN  ('Player_ShotNoGoal','Player_Goal','Player_ShotOnGoal','Player_PShotNoGoal','Player_PGoal','Player_PShotOnGoal','Player_FCShotNoGoal','Player_FCGoal','Player_FCShotOnGoal') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Shots'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = a.F_MatchID AND TMSI.F_MatchSplitID = a.F_MatchSplitID
					   WHERE C.F_MatchID=@MatchID 
					   AND  C.F_CompetitionPosition = 2
					    AND TMSI.F_MatchSplitCode <>'51' 
					   AND X.F_StatisticCode IN  ('Player_ShotNoGoal','Player_Goal','Player_ShotOnGoal','Player_PShotNoGoal','Player_PGoal','Player_PShotOnGoal','Player_FCShotNoGoal','Player_FCGoal','Player_FCShotOnGoal') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Shots'	   
     
     UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = a.F_MatchID AND TMSI.F_MatchSplitID = a.F_MatchSplitID
					   WHERE C.F_MatchID=@MatchID
					    AND  C.F_CompetitionPosition = 1
					     AND TMSI.F_MatchSplitCode <>'51' 
					    AND X.F_StatisticCode IN  ('Player_Goal','Player_ShotOnGoal','Player_PGoal','Player_PShotOnGoal','Player_FCGoal','Player_FCShotOnGoal') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Shots on Goal'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = a.F_MatchID AND TMSI.F_MatchSplitID = a.F_MatchSplitID
					   WHERE C.F_MatchID=@MatchID 
					   AND  C.F_CompetitionPosition = 2
					    AND TMSI.F_MatchSplitCode <>'51' 
					   AND X.F_StatisticCode IN  ('Player_Goal','Player_ShotOnGoal','Player_PGoal','Player_PShotOnGoal','Player_FCGoal','Player_FCShotOnGoal') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Shots on Goal'
     
     UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					   WHERE C.F_MatchID=@MatchID 
					   AND  C.F_CompetitionPosition = 1
					   AND X.F_StatisticCode IN  ('Player_FC') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Fouls'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND X.F_StatisticCode IN  ('Player_FC') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Fouls'
     
     
     UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					   WHERE C.F_MatchID=@MatchID 
					   AND  C.F_CompetitionPosition = 1
					   AND X.F_StatisticCode IN  ('Team_CornerClick') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Coner Kicks'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					    AND X.F_StatisticCode IN  ('Team_CornerClick') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Coner Kicks'
      
       UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					   AND X.F_StatisticCode IN  ('Player_FCShotNoGoal','Player_FCGoal','Player_FCShotOnGoal') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Free Kicks'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND X.F_StatisticCode IN  ('Player_FCShotNoGoal','Player_FCGoal','Player_FCShotOnGoal') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Free Kicks'
      
     UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					    LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID 
					    LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = a.F_MatchID AND TMSI.F_MatchSplitID = a.F_MatchSplitID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					    AND TMSI.F_MatchSplitCode <>'51' 
					   AND X.F_StatisticCode IN  ('Player_PShotNoGoal','Player_PGoal','Player_PShotOnGoal') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Penalty Kicks'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					    LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					    LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSI.F_MatchID = a.F_MatchID AND TMSI.F_MatchSplitID = a.F_MatchSplitID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND TMSI.F_MatchSplitCode <>'51' 
					   AND X.F_StatisticCode IN  ('Player_PShotNoGoal','Player_PGoal','Player_PShotOnGoal') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Penalty Kicks' 
      
       UPDATE #Tmp_Table
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID
					   AND C.F_CompetitionPosition = 1
					   AND X.F_StatisticCode IN  ('Team_Offiside') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Offisides'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					    LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					    AND X.F_StatisticCode IN  ('Team_Offiside') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Offisides' 
      
     UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					    AND X.F_StatisticCode IN  ('Player_OwnGoal') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Own Goals'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int)) 
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND X.F_StatisticCode IN  ('Player_OwnGoal') 
					   group by C.F_CompetitionPosition),0)
      WHERE F_StatName = 'Own Goals'   
      
      UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					   AND X.F_StatisticCode IN  ('Player_YCard') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Cautions (Yellow Cards)'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					  LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND X.F_StatisticCode IN  ('Player_YCard') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Cautions (Yellow Cards)'   
      
      
       UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					   AND X.F_StatisticCode IN  ('Player_2YCard') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Expulsions (2nd Yellow)'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					  LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND X.F_StatisticCode IN  ('Player_2YCard') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Expulsions (2nd Yellow)'   
      
       UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					  LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					    AND X.F_StatisticCode IN  ('Player_RCard') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Expulsions (Red Cards)'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					   AND X.F_StatisticCode IN  ('Player_RCard') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Expulsions (Red Cards)' 
      
      UPDATE #Tmp_Table 
      SET F_HStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					    LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 1
					    AND X.F_StatisticCode IN  ('Team_PNO') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Actual Playing Time'
     
      UPDATE #Tmp_Table 
      SET F_VStatValue = 
					   ISNULL((select sum(cast(a.F_StatisticValue as int))
					   from TS_Match_Result As C LEFT JOIN  TS_Match_Statistic as a 
					   ON C.F_CompetitionPosition = a.F_CompetitionPosition 
					   AND C.F_MatchID = a.F_MatchID 
					   LEFT JOIN TD_Statistic AS X ON X.F_StatisticID = a.F_StatisticID
					   WHERE C.F_MatchID=@MatchID AND  C.F_CompetitionPosition = 2
					    AND X.F_StatisticCode IN  ('Team_PNO') 
					   group by C.F_CompetitionPosition),0) 
      WHERE F_StatName = 'Actual Playing Time'
      
      
       if not exists(select F_HStatValue from #Tmp_Table WHERE F_StatName = 'Actual Playing Time' AND F_HStatValue = 0)
       AND not exists(select F_VStatValue from #Tmp_Table WHERE F_StatName = 'Actual Playing Time' AND F_VStatValue = 0)
	 BEGIN
		    UPDATE #Tmp_Table 
			SET F_HStatValue = 100*CONVERT(INT,(SELECT F_HStatValue FROM #Tmp_Table WHERE F_StatName = 'Actual Playing Time'))/(CONVERT(INT,(SELECT F_HStatValue FROM #Tmp_Table WHERE F_StatName = 'Actual Playing Time'))+CONVERT(INT,(SELECT F_VStatValue FROM #Tmp_Table WHERE F_StatName = 'Actual Playing Time')))
			WHERE F_StatName = 'Ball Possession'
			
		
		 UPDATE #Tmp_Table 
			SET F_VStatValue = 100- CONVERT(INT,F_HStatValue)
			WHERE F_StatName = 'Ball Possession'
	 END
	 ELSE
	 BEGIN
		 UPDATE #Tmp_Table 
		 SET F_HStatValue = 0,F_VStatValue = 0
		 WHERE F_StatName = 'Ball Possession'
	 END
	 
	 UPDATE #Tmp_Table SET  F_HStatValue = F_HStatValue +'%',F_VStatValue = F_VStatValue + '%'
	 WHERE F_StatName = 'Ball Possession'
     
           
	UPDate #Tmp_Table SET F_StatName = CASE F_StatName WHEN 'Shots' THEN'����'
													   WHEN 'Shots on Goal'THEN '����'
													    WHEN 'Fouls'THEN '����'
													     WHEN 'Coner Kicks'THEN '����'
													      WHEN 'Free Kicks'THEN '������'
													       WHEN 'Penalty Kicks'THEN '����'
													        WHEN 'Offisides'THEN 'Խλ'
													         WHEN 'Own Goals'THEN '������'
													          WHEN 'Cautions (Yellow Cards)'THEN '����'
													           WHEN 'Expulsions (2nd Yellow)'THEN '�ڶ��Ż���'
													            WHEN 'Expulsions (Red Cards)'THEN '����'
													             WHEN 'Ball Possession'THEN '������'
													            WHEN 'Actual Playing Time'THEN '����ʱ��'
														END
	WHERE @LanguageCode='CHN'
	
	SELECT * FROM #Tmp_Table ORDER BY  F_StatOrder
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO