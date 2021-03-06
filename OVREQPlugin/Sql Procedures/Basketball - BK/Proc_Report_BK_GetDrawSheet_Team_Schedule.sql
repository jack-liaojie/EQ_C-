IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetDrawSheet_Team_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetDrawSheet_Team_Schedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_Report_BK_GetDrawSheet_Team_Schedule]
--描    述：得到Event下分组抽签表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年06月07日
--修	改：2010年10月19日 管仁良 添加组的F_PhaseID,@PoolOrder=-1, 取出所有组


CREATE PROCEDURE [dbo].[Proc_Report_BK_GetDrawSheet_Team_Schedule](
                       @EventID         INT,
                       @PoolOrder       INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
    --SET LANGUAGE N'简体中文'
	
    CREATE TABLE #Tmp_Table(
							 F_PhaseID			  INT,
                             F_MatchID            INT,
                             F_RegisterAID        INT,
                             F_RegisterBID        INT,
                             F_MatchDate          NVARCHAR(100),
                             F_MatchCourt         NVARCHAR(100),
                             F_MatchNum           NVARCHAR(10),
                             F_ContestResult      NVARCHAR(100),
                             F_MatchResult        NVARCHAR(100),
                             F_MatchStatus        INT
                           )

    DECLARE @EventCode NVARCHAR(10)
    DECLARE @PhaseID INT
    
    DECLARE GroupIDCur CURSOR FOR     
			SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND (F_PhaseIsPool = 1 OR F_PhaseType=2) 
			AND (F_Order = CASE @PoolOrder WHEN -1 THEN F_Order ELSE @PoolOrder END) --- 如果为-1则取出所有的组
			ORDER BY F_Order
	OPEN GroupIDCur
	FETCH NEXT FROM GroupIDCur INTO @PhaseID
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		SELECT @EventCode = B.F_EventComment FROM TS_Phase AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID = @PhaseID

		INSERT INTO #Tmp_Table(F_PhaseID, F_MatchID, F_RegisterAID, F_RegisterBID, F_MatchDate, F_MatchCourt, F_MatchNum, F_MatchStatus)
		SELECT A.F_PhaseID, A.F_MatchID
		,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1)
		,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
		,(cast( cast( substring(CONVERT (NVARCHAR(100),GETDATE(), 23),6,2) as int) as NVARCHAR(100)) + '月' 
		  + cast( cast( substring(CONVERT (NVARCHAR(100),GETDATE(), 23),9,2) as int) as NVARCHAR(100)) + '日'
		  + ' ' + cast( cast( substring(CONVERT (NVARCHAR(100),A.F_StartTime, 108),1,2) as int) as NVARCHAR(100)) + ':' 
		  + substring(CONVERT (NVARCHAR(100),A.F_StartTime, 108),4,2))
		,B.F_CourtShortName
		,(@EventCode + A.F_RaceNum)
		,A.F_MatchStatusID
		FROM TS_Match AS A
		LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID = @PhaseID


		INSERT INTO #Tmp_Table(A.F_PhaseID, F_MatchID, F_RegisterAID, F_RegisterBID, F_MatchDate, F_MatchCourt, F_MatchNum, F_MatchStatus)
		SELECT A.F_PhaseID, A.F_MatchID
		,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
		,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1)
		, (cast( cast( substring(CONVERT (NVARCHAR(100),GETDATE(), 23),6,2) as int) as NVARCHAR(100)) + '月' 
		  + cast( cast( substring(CONVERT (NVARCHAR(100),GETDATE(), 23),9,2) as int) as NVARCHAR(100)) + '日'
		  + ' ' + cast( cast( substring(CONVERT (NVARCHAR(100),A.F_StartTime, 108),1,2) as int) as NVARCHAR(100)) + ':' 
		  + substring(CONVERT (NVARCHAR(100),A.F_StartTime, 108),4,2))
		,B.F_CourtShortName
		,(@EventCode + A.F_RaceNum)
		,A.F_MatchStatusID
		FROM TS_Match AS A
		LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID = @PhaseID

		UPDATE #Tmp_Table SET F_MatchResult = [dbo].[Fun_City_Report_BB_GetMatchResult](F_MatchID, F_RegisterAID, F_RegisterBID, 2)
		--UPDATE #Tmp_Table SET F_ContestResult = [dbo].[Fun_City_Report_BB_GetMatchResult](F_MatchID, F_RegisterBID, F_RegisterAID, 1) WHERE F_MatchID is not null
		UPDATE #Tmp_Table SET F_ContestResult = F_MatchDate --WHERE F_MatchStatus <> 110
		UPDATE #Tmp_Table SET F_MatchResult = F_MatchCourt + ',' + F_MatchNum WHERE F_MatchStatus <> 110

	FETCH NEXT FROM GroupIDCur INTO @PhaseID		
	END
	CLOSE GroupIDCur
	DEALLOCATE GroupIDCur
    
	UPDATE  TT SET TT.F_ContestResult = ' ' 
	FROM #Tmp_Table as TT
	WHERE  (select f_phaseposition from TS_Phase_Position as pp 
		    where pp.F_PhaseID = TT.F_PhaseID and pp.F_RegisterID = TT.F_RegisterAID)
		    <
		   (select f_phaseposition from TS_Phase_Position as pp
		    where pp.F_PhaseID = TT.F_PhaseID and pp.F_RegisterID = TT.F_RegisterBID) 
    
    
	SELECT * FROM #Tmp_Table where F_RegisterAID <> -1 and F_RegisterBID <> -1

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

