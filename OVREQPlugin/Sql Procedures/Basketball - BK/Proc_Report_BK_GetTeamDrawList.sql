IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetTeamDrawList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetTeamDrawList]
GO


GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_BK_GetTeamDrawList]
--描    述：得到Event下小组成员表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年06月08日
--修	改：2010年10月19日 管仁良 添加组的F_PhaseID,@PoolOrder=-1, 取出所有组


CREATE PROCEDURE [dbo].[Proc_Report_BK_GetTeamDrawList](
                       @EventID         INT,
                       @PoolOrder       INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
    
    CREATE TABLE #Tmp_Table(
							F_PhaseID		 INT,
                            F_Pos            INT,
                            F_PhaseRank      INT,
                            F_PhaseDisPos    INT,
                            F_EventRank      INT,
                            F_EventDisPos    INT,
                            F_RegisterID     INT,
                            F_RegisterLN     NVARCHAR(150), 
                            F_RegisterSN     NVARCHAR(50),
                            F_Win            INT,
                            F_Loss           INT,
                            F_Pts            INT,
                            F_WinLoss        NVARCHAR(50),
                            F_WinLoss1       NVARCHAR(50),
                            F_WinLoss2       NVARCHAR(50)
                            )


    CREATE TABLE #Tmp_PhasePts(
							F_PhaseID		 INT,
							F_PhasePts       INT,
							F_PtsCount       INT)

    CREATE TABLE #Tmp_Match(
							F_PhaseID		 INT,
							F_MatchID        INT)

    DECLARE @PhaseID INT
    
    DECLARE GroupIDCur CURSOR FOR     
			SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND (F_PhaseIsPool = 1 OR F_PhaseType=2) 
			AND (F_Order = CASE @PoolOrder WHEN -1 THEN F_Order ELSE @PoolOrder END) --- 如果为-1则取出所有的组
			ORDER BY F_Order
	OPEN GroupIDCur
	FETCH NEXT FROM GroupIDCur INTO @PhaseID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #Tmp_Table(A.F_PhaseID, F_Pos, F_PhaseRank, F_PhaseDisPos, F_EventRank, F_EventDisPos,
		F_RegisterID, F_RegisterLN, F_RegisterSN,F_Win,F_Loss,F_Pts,F_WinLoss)
		SELECT PP.F_PhaseID, PP.F_PhasePosition, PR.F_PhaseRank, PR.F_PhaseDisplayPosition, ER.F_EventRank, ER.F_EventDisplayPosition, 
		PP.F_RegisterID, C.F_ShortName, D.F_DelegationCode,
		(select count(*) from TS_Match_Result where F_MatchID in (select F_MatchID from TS_Match where F_PhaseID = @PhaseID) 
		and F_RegisterID = PP.F_RegisterID and F_ResultID = 1), 
		(select count(*) from TS_Match_Result where F_MatchID in (select F_MatchID from TS_Match where F_PhaseID = @PhaseID) 
		and F_RegisterID = PP.F_RegisterID and F_ResultID = 2),
		PR.F_PhasePoints,
		NULL
		/*
		cast(cast(100*cast((select sum(f_points) from TS_Match_Result where F_MatchID in (select F_MatchID from TS_Match where F_PhaseID = @PhaseID) 
		and F_RegisterID = PP.F_RegisterID) as float)/cast( 
		(select sum(f_points) from TS_Match_Result where F_MatchID in
		(select distinct F_MatchID from TS_Match_Result where F_MatchID in (select F_MatchID from TS_Match where F_PhaseID = @PhaseID) 
		and F_RegisterID = PP.F_RegisterID) and F_RegisterID <> PP.F_RegisterID) as float) as int ) as float)/100
		*/
		FROM TS_Phase_Position AS PP 
		LEFT JOIN TS_Phase_Result AS PR ON PP.F_PhaseID = PR.F_PhaseID AND PP.F_RegisterID = PR.F_RegisterID 
		LEFT JOIN TS_Phase AS P ON PP.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event_Result AS ER ON P.F_EventID = ER.F_EventID AND PP.F_RegisterID = ER.F_RegisterID 
		LEFT JOIN TR_Register AS B ON PP.F_RegisterID = B.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
		WHERE PP.F_PhaseID = @PhaseID AND PP.F_RegisterID > 0 ORDER BY PP.F_PhasePosition

	    update #Tmp_Table set F_Pts = F_Win*2 + F_Loss
 
        delete from #Tmp_PhasePts
        insert into #Tmp_PhasePts(F_PhaseID,F_PhasePts,F_PtsCount)
        select distinct @PhaseID, F_Pts, NULL FROM #Tmp_Table where F_PhaseID = @PhaseID 
        
        update #Tmp_PhasePts set F_PtsCount = (select COUNT(*) from #Tmp_Table as t where F_PhaseID = @PhaseID and t.F_Pts = F_PhasePts)
        
        delete from #Tmp_PhasePts where F_PtsCount < 2
        
        DECLARE @PhasePtsIdx INT
        DECLARE @PhaseMaxPts INT
        select @PhasePtsIdx = MIN(F_PhasePts) from #Tmp_PhasePts
        select @PhaseMaxPts = MAX(F_PhasePts) from #Tmp_PhasePts
       
        if @PhasePtsIdx is not null 
        begin
	        while @PhasePtsIdx <= @PhaseMaxPts
	        begin
	        
				--select F_RegisterID from #Tmp_Table as t where t.F_PhaseID = @PhaseID and t.F_Pts = @PhasePtsIdx
		        
				--select * from TS_Match_Result where F_RegisterID in(select F_RegisterID from #Tmp_Table as t where t.F_PhaseID = @PhaseID and t.F_Pts = @PhasePtsIdx)
				delete from #Tmp_Match
				insert into #Tmp_Match(F_PhaseID,F_MatchID)
				select @PhaseID, T1.f_matchid from (
				select distinct F_MatchID from TS_Match_Result where F_CompetitionPosition = 1 and F_RegisterID in (select F_RegisterID from #Tmp_Table as t where t.F_PhaseID = @PhaseID and t.F_Pts = @PhasePtsIdx)
				and F_MatchID in (select F_MatchID from TS_Match where F_PhaseID = @PhaseID)) as T1
				where T1.F_MatchID in (
				select distinct F_MatchID from TS_Match_Result where F_CompetitionPosition = 2 and F_RegisterID in (select F_RegisterID from #Tmp_Table as t where t.F_PhaseID = @PhaseID and t.F_Pts = @PhasePtsIdx)
				and F_MatchID in (select F_MatchID from TS_Match where F_PhaseID = @PhaseID))
		        
				update #Tmp_Table set F_WinLoss1 = cast((select sum(f_points) from TS_Match_Result as mr where F_MatchID 
				in (select F_MatchID from #Tmp_Match) and mr.F_RegisterID = TT.F_RegisterID) as float) 
				from #Tmp_Table as TT where TT.F_PhaseID = @PhaseID and TT.F_Pts = @PhasePtsIdx

				update #Tmp_Table set F_WinLoss2 = cast((select sum(f_points) from TS_Match_Result as mr where F_MatchID 
				in (select distinct F_MatchID from TS_Match_Result as mr where F_MatchID 
				in (select F_MatchID from #Tmp_Match) and mr.F_RegisterID = TT.F_RegisterID) and mr.F_RegisterID <> TT.F_RegisterID) as float) 
				from #Tmp_Table as TT where TT.F_PhaseID = @PhaseID and TT.F_Pts = @PhasePtsIdx
				
				update #Tmp_Table set F_WinLoss = cast(cast(cast(F_WinLoss1 as float)/cast( F_WinLoss2 as float) as float) as numeric(10,4))
			    
			    set @PhasePtsIdx = @PhasePtsIdx + 1
            end
        end

		DECLARE @MinPos INT
		SELECT @MinPos = Min(F_Pos) FROM #Tmp_Table where F_PhaseID = @PhaseID
		update #Tmp_Table set F_Pos = (F_Pos - @MinPos + 1) where F_PhaseID = @PhaseID
    
    FETCH NEXT FROM GroupIDCur INTO @PhaseID		
	END
	CLOSE GroupIDCur
	DEALLOCATE GroupIDCur
/*
    UPDATE #Tmp_Table SET F_PhaseDisPos = B.DisPos
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY F_PhaseID ORDER BY F_Pts desc, cast(F_WinLoss as float) desc) AS DisPos
		, * FROM #Tmp_Table)
		AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_Pos = B.F_Pos
    update #Tmp_Table set F_PhaseRank = F_PhaseDisPos
*/		

    update #Tmp_Table set F_Win = 0 where F_Win is null
    
	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

