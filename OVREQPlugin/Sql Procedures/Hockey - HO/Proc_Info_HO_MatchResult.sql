IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_HO_MatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_HO_MatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_HO_MatchResult]
----功   能：比赛成绩、单场或者多场
----作	 者：张翠霞
----日   期：2012-09-07 

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

CREATE PROCEDURE [dbo].[Proc_Info_HO_MatchResult]
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
	
	
	-----对阵数据
	CREATE TABLE #tmp_Duel(
								F_RegisterIDA         INT,
								F_RegisterIDB         INT,
								F_MatchID             INT,
								Match				  NVARCHAR(100),
								Phase				  NVARCHAR(100),
								StartTime             NVARCHAR(100),
								DelegationName_A	  NVARCHAR(100),
								DelegationName_B	  NVARCHAR(100),
								Result1				  NVARCHAR(100),
								Result2				  NVARCHAR(100),
								Result3				  NVARCHAR(100),
								Result4 			  NVARCHAR(100),
								Result                NVARCHAR(100),
								[Status]			  NVARCHAR(100)
							)	
							
	CREATE TABLE #TableScore(
                                        F_MatchID             INT,
                                        F_HHalf1               INT,
                                        F_VHalf1               INT,
                                        F_HHalf2               INT,
                                        F_VHalf2               INT,
                                        F_HExtra1             INT,
                                        F_VExtra1             INT,
                                        F_HExtra2             INT,
                                        F_VExtra2             INT,
                                        F_HPso                INT,
                                        F_VPso                INT,
                                        F_HExtraScore         INT,
                                        F_VExtraScore         INT                               
                                 )                                
                             
    INSERT INTO #TableScore(F_MatchID, F_HHalf1, F_VHalf1, F_HHalf2, F_VHalf2, F_HExtra1, F_VExtra1, F_HExtra2, F_VExtra2, F_HPso, F_VPso)
        SELECT M.F_MatchID
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 1)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 1)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 2)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 2)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 3)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 3)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 4)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 4)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 5)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 5)
        FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
        
        UPDATE #TableScore SET F_HExtraScore = ISNULL(F_HExtra1, 0) + ISNULL(F_HExtra2, 0), F_VExtraScore = ISNULL(F_VExtra1, 0) + ISNULL(F_VExtra2, 0)					   
   
	INSERT INTO #tmp_Duel(F_MatchID, F_RegisterIDA, F_RegisterIDB, [Status], StartTime, Result, Result1, Result2, Result3, Result4)
		SELECT TM.F_MatchID, TMRA.F_RegisterID, TMRB.F_RegisterID 
		       , TS.F_StatusCode
		       , RIGHT(LEFT(CONVERT(NVARCHAR(30), TM.F_StartTime, 20), 16), 5)
		       , (CAST(TMRA.F_Points AS NVARCHAR(3)) + ' - ' + CAST(TMRB.F_Points AS NVARCHAR(3)))
		       , (SELECT CAST (F_HHalf1 AS NVARCHAR(5)) + ' - ' + CAST (F_VHalf1 AS NVARCHAR(5)) FROM #TableScore)
		       , (SELECT CAST (F_HHalf2 AS NVARCHAR(5)) + ' - ' + CAST (F_VHalf2 AS NVARCHAR(5)) FROM #TableScore)
		       , (SELECT CAST (F_HExtraScore AS NVARCHAR(5)) + ' - ' + CAST (F_VExtraScore AS NVARCHAR(5)) FROM #TableScore)
		       , (SELECT CAST (F_HPso AS NVARCHAR(5)) + ' - ' + CAST (F_VPso AS NVARCHAR(5)) FROM #TableScore)
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
           	                 	
    -- Produce @Content		
	
	UPDATE A SET A.Phase = C.F_PhaseLongName, A.Match = D.F_MatchLongName FROM #tmp_Duel AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Match_Des AS D ON B.F_MatchID = D.F_MatchID AND D.F_LanguageCode = @LanguageCode

	UPDATE #tmp_Duel SET [Status] = ISNULL([Status], N'')

	UPDATE #tmp_Duel SET Match = ISNULL(Match, N''), Phase = ISNULL(Phase, N''), DelegationName_A = ISNULL(DelegationName_A, N'')
		, DelegationName_B = ISNULL(DelegationName_B, N''), Result4 = ISNULL(Result4, N'')
		
	UPDATE #tmp_Duel SET Result3 = '' WHERE Result3 = '0 - 0'
		
    UPDATE A SET A.DelegationName_A = C.F_DelegationLongName FROM #tmp_Duel AS A LEFT JOIN TR_Register AS B ON A.F_RegisterIDA = B.F_RegisterID LEFT JOIN TC_Delegation_Des AS C
					ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TR_Register_Des AS D
					ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode

	UPDATE A SET A.DelegationName_B = C.F_DelegationLongName FROM #tmp_Duel AS A LEFT JOIN TR_Register AS B ON A.F_RegisterIDB = B.F_RegisterID LEFT JOIN TC_Delegation_Des AS C
					ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TR_Register_Des AS D
					ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode

	SET		@Content = (SELECT [Row].[Match], [Row].[Phase], [Row].StartTime, [Row].[DelegationName_A]
							, [Row].[DelegationName_B], [Row].[Result1], [Row].[Result2], [Row].[Result3], [Row].[Result4], [Row].[Result], [Row].[Status]
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

/*EXEC Proc_Info_HO_MatchResult 18*/


