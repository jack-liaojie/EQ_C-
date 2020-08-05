IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_TE_MatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_TE_MatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_TE_MatchResult]
----功   能：比赛成绩、单场或者多场
----作	 者：郑金勇
----日   期：2010-08-20 

/*
	参数说明：
	序号	参数名称	参数说明
	1		@MatchID	指定的比赛ID
*/

/*
	功能描述：按照交换协议规范，组织数据。
			  此存储过程遵照内部的MS SQL SERVER编码规范。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_TE_MatchResult]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

    DECLARE @Discipline AS NVARCHAR(50)
    DECLARE @Gender AS NVARCHAR(50)
    DECLARE @SexCode AS INT
    DECLARE @Event AS NVARCHAR(50)
    DECLARE @EventID AS INT
    DECLARE @Phase AS NVARCHAR(50)
    DECLARE @Unit AS NVARCHAR(50)
    DECLARE @Vunue AS NVARCHAR(50)
	DECLARE @LanguageCode AS CHAR(3)
	
	
	DECLARE @MatchStatus    INT
	DECLARE @CriticalPoint  INT
	DECLARE @CriticalPos    INT
	DECLARE @ServePos       INT
	
	SELECT @Discipline = D.F_DisciplineCode, @SexCode = E.F_SexCode, @Event = E.F_EventCode, @EventID = E.F_EventID
	, @Phase = P.F_PhaseCode, @Unit = M.F_MatchCode, @Vunue = V.F_VenueCode, @MatchStatus = M.F_MatchStatusID
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
	WHERE F_MatchID = @MatchID
	
	SELECT @Gender = F_GenderCode FROM TC_Sex WHERE F_SexCode = @SexCode
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	DECLARE @Content AS NVARCHAR(MAX)
	
	---当比赛为团体比赛的虚拟比赛，则不发消息
	if(@Event = '003' OR @Event = '103')
	BEGIN
	    RETURN
	END
	
	
	-----对阵数据
	CREATE TABLE #tmp_Duel(
								[Reg_IDA]             NVARCHAR(10),
								[Reg_IDB]             NVARCHAR(10),
								[WLA]                 INT,
								[WLB]                 INT,
								[WinsA]               INT,
								[WinsB]               INT,
								[Win_Mark]            INT,
								[StatusA]             NVARCHAR(5),
								[StatusB]             NVARCHAR(5),
								[Elapsed_Time]        NVARCHAR(8),
								[Match_Status]        INT,
								F_RegisterIDA         INT,
								F_RegisterIDB         INT,
								F_MatchID             INT,
								Match				  NVARCHAR(100),
								Phase				  NVARCHAR(100),
								DelegationName_A	  NVARCHAR(100),
								AthleteName_A		  NVARCHAR(100),
								DelegationName_B	  NVARCHAR(100),
								AthleteName_B	      NVARCHAR(100),
								Result1				  NVARCHAR(100),
								Result2				  NVARCHAR(100),
								Result3				  NVARCHAR(100),
								Result 				  NVARCHAR(100),
								Winner				  NVARCHAR(100),
								[Status]			  NVARCHAR(100)
							)
							
	
	CREATE TABLE #tmp_Set(
	                      [Set_No]         INT,
	                      [Status]         INT,
	                      [WinsA]          INT,
	                      [WinsB]          INT,
	                      [Win_Mark]       INT,
	                      [Elapsed_Time]   NVARCHAR(8),
	                      F_MatchID        INT,
	                      F_MatchSplitID   INT,
	                      )
	                      
	 CREATE TABLE #tmp_Game(
	                        [Game_No]              INT,
	                        [Status]               INT,
	                        [Server]               INT,
	                        [PointsA]              INT,
	                        [PointsB]              INT,
	                        [Win_Mark]             INT,
	                        [Elapsed_Time]         NVARCHAR(8),
	                        F_MatchID              INT,
	                        F_MatchSplitID         INT,
	                        F_FatherMatchSplitID   INT,
	                        F_SetNo                INT,
	                        F_AD                   INT,
	                        F_TieBreak             INT,
	                        F_DecidingTB           INT,
	                        )
   
   
	INSERT INTO #tmp_Duel(F_MatchID, F_RegisterIDA, F_RegisterIDB, [Elapsed_Time], [Match_Status],  [Reg_IDA], [WinsA], [WLA], [StatusA], [Reg_IDB], [WinsB], [WLB], [StatusB], [Win_Mark])
		SELECT TM.F_MatchID, TMRA.F_RegisterID, TMRB.F_RegisterID 
		       ,(CASE WHEN TM.F_SpendTime <> 0 THEN (CAST(CAST(TM.F_SpendTime AS INT)/3600 AS NVARCHAR(8) ) + ':' + RIGHT(N'00' + CAST(((TM.F_SpendTime % 3600)/60) AS NVARCHAR(8)), 2)+ ':' + '00') ELSE ''END)
		       ,TS.F_StatusCode
		       ,TRA.F_RegisterCode, ISNULL(TMRA.F_Points, 0), ISNULL(TMRA.F_Rank, 0), ISNULL(TIA.F_IRMCode, '')
		       ,TRB.F_RegisterCode, ISNULL(TMRB.F_Points, 0), ISNULL(TMRB.F_Rank, 0), ISNULL(TIB.F_IRMCode, '')	
		       , 0	
		   FROM TS_Match AS TM 
		     LEFT JOIN TS_Match_Result AS TMRA ON TM.F_MatchID = TMRA.F_MatchID AND TMRA.F_CompetitionPosition = 1 
		     LEFT JOIN TS_Match_Result AS TMRB ON TM.F_MatchID = TMRB.F_MatchID AND TMRB.F_CompetitionPosition = 2
		     LEFT JOIN TR_Register AS TRA ON TMRA.F_RegisterID = TRA.F_RegisterID
		     LEFT JOIN TR_Register AS TRB ON TMRB.F_RegisterID = TRB.F_RegisterID
		     LEFT JOIN TC_IRM AS TIA ON TMRA.F_IRMID = TIA.F_IRMID
		     LEFT JOIN TC_IRM AS TIB ON TMRB.F_IRMID = TIB.F_IRMID
		     LEFT JOIN TC_Status AS TS ON TM.F_MatchStatusID = TS.F_StatusID 
		    WHERE TM.F_MatchID = @MatchID AND (TMRA.F_RegisterID IS NOT NULL OR TMRA.F_RegisterID <> -1 )AND (TMRB.F_RegisterID IS NOT NULL OR TMRB.F_RegisterID <> -1 )
		         
	 
	 IF NOT EXISTS(SELECT * FROM #tmp_Duel)
		RETURN
		
	
	INSERT INTO	#tmp_Set ([Set_No], [Status], [WinsA], [WinsB], [Elapsed_Time], [Win_Mark], F_MatchID, F_MatchSplitID)
	     SELECT CAST(TMS.F_MatchSplitCode AS INT), TMS.F_MatchSplitStatusID
	            ,TMSRA.F_Points, TMSRB.F_Points
	            ,CASE WHEN TMS.F_SpendTime <> 0 THEN CAST(CAST(TMS.F_SpendTime AS INT)/3600 AS NVARCHAR(8) ) + ':' + RIGHT(N'00' + CAST(((TMS.F_SpendTime % 3600)/60) AS NVARCHAR(8)), 2) + ':' + '00' ELSE ''END
	            ,0
	            ,TMS.F_MatchID, TMS.F_MatchSplitID
	        FROM TS_Match_Split_info AS TMS 
	          LEFT JOIN TS_Match_Split_Result AS TMSRA ON TMS.F_MatchID = TMSRA.F_MatchID AND TMS.F_MatchSplitID = TMSRA.F_MatchSplitID AND TMSRA.F_CompetitionPosition = 1
	          LEFT JOIN TS_Match_Split_Result AS TMSRB ON TMS.F_MatchID = TMSRB.F_MatchID AND TMS.F_MatchSplitID = TMSRB.F_MatchSplitID AND TMSRB.F_CompetitionPosition = 2
	        WHERE TMS.F_MatchID = @MatchID AND TMS.F_MatchSplitType = 1
	  
	  DELETE FROM #tmp_Set WHERE [Status] IS NULL 
	  UPDATE #tmp_Set SET [Status] = (CASE WHEN [Status] = 0 THEN 0 ELSE (CASE WHEN [Status] = 50 THEN 1 ELSE 2 END)END)
	  DELETE FROM #tmp_Set WHERE [Status] = 0

	           
	 INSERT INTO #tmp_Game ( [Game_No], [Status], [Win_Mark], [PointsA], [PointsB], F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_SetNo, F_AD, F_TieBreak, F_DecidingTB)
	       SELECT CAST(TMS.F_MatchSplitCode AS INT), (CASE WHEN TMS.F_MatchSplitStatusID  = 0 THEN 0 ELSE (CASE WHEN TMS.F_MatchSplitStatusID = 50 THEN 1 ELSE 2 END) END)
	            ,0
	            ,(CASE WHEN TMSRA.F_Rank = 1 THEN 1 ELSE 0 END)
	            ,(CASE WHEN TMSRB.F_Rank = 1 THEN 1 ELSE 0 END)
	            ,TMS.F_MatchID, TMS.F_MatchSplitID
	            ,TMS.F_FatherMatchSplitID
	            ,CAST(TMSF.F_MatchSplitCode AS INT)
	            ,CAST(TMSF.F_MatchSplitComment AS INT)
	            ,CAST(TMSF.F_MatchSplitComment1 AS INT)
	            ,CAST(TMSF.F_MatchSplitComment2 AS INT)
	        FROM TS_Match_Split_info AS TMS LEFT JOIN TS_Match_Split_Info AS TMSF ON TMS.F_MatchID = TMSF.F_MatchID AND TMS.F_FatherMatchSplitID = TMSF.F_MatchSplitID
	             LEFT JOIN TS_Match_Split_Result AS TMSRA ON TMS.F_MatchID = TMSRA.F_MatchID AND TMS.F_MatchSplitID = TMSRA.F_MatchSplitID AND TMSRA.F_CompetitionPosition = 1
	             LEFT JOIN TS_Match_Split_Result AS TMSRB ON TMS.F_MatchID = TMSRB.F_MatchID AND TMS.F_MatchSplitID = TMSRB.F_MatchSplitID AND TMSRB.F_CompetitionPosition = 2
	        WHERE TMS.F_MatchID = @MatchID AND TMS.F_MatchSplitType = 2   AND TMS.F_MatchSplitStatusID = 110 AND TMSRA.F_Rank <> TMSRB.F_Rank
	  
	  
	  ----抢十进行修改，PointA，PointB是直接小比分
	  UPDATE A SET PointsA = MSR1.F_Points, PointsB = MSR2.F_Points
	      FROM #tmp_Game AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_FatherMatchSplitID = B.F_MatchSplitID  AND A.F_MatchID = B.F_MatchID
	           LEFT JOIN TS_Match_Split_Info AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID 
	           LeFT JOIN TS_Match_Split_Result AS MSR1 ON C.F_MatchID = MSR1.F_MatchID AND C.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON C.F_MatchID = MSR2.F_MatchID AND C.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	      WHERE B.F_MatchSplitComment2 = 1 AND B.F_MatchSplitCode = '3' AND C.F_MatchSplitCode = '1'
	        
	 DELETE FROM #tmp_Game WHERE [Status] = 0
	 --UPDATE #tmp_Game SET [PointsA] = F_ActionXMLComment.value('(/MatchResult/Set[@SetNum=sql:column("F_SetNo")]/Competitor[@Position=1]/@Games)[1]','int')
	 --          FROM TS_Match_ActionList AS TMA WHERE TMA.F_MatchID = @MatchID AND TMA.F_ActionDetail2 = [Game_No]  AND TMA.F_ActionDetail1 = F_SetNo
	 --                  AND TMA.F_ActionTypeID = -1 AND F_ScoreDes LIKE ('%60%') 
	
	                  
	 --UPDATE #tmp_Game SET [PointsB] =F_ActionXMLComment.value('(/MatchResult/Set[@SetNum=sql:column("F_SetNo")]/Competitor[@Position=2]/@Games)[1]','int')
	 --          FROM TS_Match_ActionList AS TMA WHERE TMA.F_MatchID = @MatchID AND TMA.F_ActionDetail2 = [Game_No]  AND TMA.F_ActionDetail1 = F_SetNo
	 --                  AND TMA.F_ActionTypeID = -1 AND F_ScoreDes LIKE ('%60%')
	 
	 UPDATE #tmp_Game SET [Server] = CASE WHEN Y.AService = 1 THEN 1 ELSE CASE WHEN Y.BService = 1 THEN 2 ELSE NULL END END
	         FROM #tmp_Game AS X 
	         LEFT JOIN (SELECT B.F_MatchSplitID, C.F_Service AS AService, D.F_Service AS BService FROM #tmp_Game AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchSplitID = B.F_MatchSplitID 
	                           LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
	                           LEFT JOIN TS_Match_Split_Result AS D ON B.F_MatchID = D.F_MatchID AND B.F_MatchSplitID = D.F_MatchSplitID AND D.F_CompetitionPosition = 2
	                         WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitType = 2) AS Y ON X.F_MatchSplitID = Y.F_MatchSplitID
	         
	         
	         --FROM TS_Match_ActionList AS TMA WHERE TMA.F_MatchID = @MatchID AND TMA.F_ActionDetail2 = [Game_No]  AND TMA.F_ActionDetail1 = F_SetNo  
	         --          AND (TMA.F_ActionTypeID = -1 OR TMA.F_ActionTypeID = -2)  AND F_ScoreDes LIKE ('%60%')
	              

	 --更新Win_Mark
	 SELECT @CriticalPoint = F_CriticalPoint, @CriticalPos = F_CriticalPointPosition, @ServePos = F_ServerPosition FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_ActionNumberID in (select max(F_ActionNumberID) FROM TS_Match_ActionList WHERE F_MatchID = @MatchID)
	 UPDATE #tmp_Duel SET [Win_Mark] = @CriticalPos WHERE @CriticalPoint = 3
	 UPDATE #tmp_Set  SET [Win_Mark] = @CriticalPos WHERE @CriticalPoint = 2 AND [Status] = 1
	 UPDATE #tmp_Game SET [Win_Mark] = @CriticalPos WHERE @CriticalPoint = 1 AND [Status] = 1
	 --UPDATE #tmp_Game SET [Server] = @ServePos WHERE [Status] = 1
	 
	 UPDATE #tmp_Game SET [Server] = 3 WHERE (F_TieBreak = 1 AND [Game_No] = 13) OR (F_DecidingTB = 1 AND [Game_No] = 1)
	 
	 UPDATE #tmp_Game SET [PointsA] = ISNULL([PointsA], ''), [PointsB] = ISNULL([PointsB], ''), [Server] = ISNULL([Server], ''), [Elapsed_Time] = ISNULL([Elapsed_Time], '')
     	
    -- Produce @Content		
	
	UPDATE A SET A.Phase = C.F_PhaseLongName, A.Match = D.F_MatchLongName FROM #tmp_Duel AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Match_Des AS D ON B.F_MatchID = D.F_MatchID AND D.F_LanguageCode = @LanguageCode

	UPDATE A SET A.AthleteName_A = D.F_PrintLongName, A.DelegationName_A = C.F_DelegationLongName FROM #tmp_Duel AS A LEFT JOIN TR_Register AS B ON A.F_RegisterIDA = B.F_RegisterID LEFT JOIN TC_Delegation_Des AS C
					ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TR_Register_Des AS D
					ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode

	UPDATE A SET A.AthleteName_B = D.F_PrintLongName, A.DelegationName_B = C.F_DelegationLongName FROM #tmp_Duel AS A LEFT JOIN TR_Register AS B ON A.F_RegisterIDB = B.F_RegisterID LEFT JOIN TC_Delegation_Des AS C
					ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TR_Register_Des AS D
					ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode

	UPDATE #tmp_Duel SET Winner = AthleteName_A WHERE WLA = 1
	UPDATE #tmp_Duel SET Winner = AthleteName_B WHERE WLB = 1


	DECLARE @Result1 AS NVARCHAR(100)
	DECLARE @Result2 AS NVARCHAR(100)
	DECLARE @Result3 AS NVARCHAR(100)

	SELECT @Result1 = CAST(WinsA AS NVARCHAR(100)) + N'-' + CAST(WinsB AS NVARCHAR(100)) FROM #tmp_Set WHERE Set_No = 1
	SELECT @Result2 = CAST(WinsA AS NVARCHAR(100)) + N'-' + CAST(WinsB AS NVARCHAR(100)) FROM #tmp_Set WHERE Set_No = 2
	SELECT @Result3 = CAST(WinsA AS NVARCHAR(100)) + N'-' + CAST(WinsB AS NVARCHAR(100)) FROM #tmp_Set WHERE Set_No = 3
	UPDATE #tmp_Duel SET Result = CAST(WinsA AS NVARCHAR(100)) + N'-' + CAST(WinsB AS NVARCHAR(100))
	UPDATE #tmp_Duel SET Result1 = ISNULL(@Result1, N''), Result2 = ISNULL(@Result2, N''), Result3 = ISNULL(@Result3, N'') , Result = ISNULL(Result, N'')

	UPDATE #tmp_Duel SET [Status] = ISNULL(Match_Status, N'')


	UPDATE #tmp_Duel SET Match = ISNULL(Match, N''), Phase = ISNULL(Phase, N''), DelegationName_A = ISNULL(DelegationName_A, N''), AthleteName_A = ISNULL(AthleteName_A, N'')
		, DelegationName_B = ISNULL(DelegationName_B, N''), AthleteName_B = ISNULL(AthleteName_B, N''), Winner = ISNULL(Winner, N'')

	SET		@Content = (SELECT [Row].[Match], [Row].[Phase], [Row].[DelegationName_A], [Row].[AthleteName_A]
							, [Row].[DelegationName_B], [Row].[AthleteName_B], [Row].[Result1], [Row].[Result2], [Row].[Result3], [Row].[Result], [Row].[Winner], [Row].[Status]
						FROM #tmp_Duel AS [Row]  FOR XML AUTO)

   --SELECT cast( @Content AS XML )
	
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), 5), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'

	DECLARE @FileName	AS NVARCHAR(100)
	SET @FileName =	@Discipline + @Gender + @Event + @Phase + @Unit + N'.0.CHI.1.0'
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


