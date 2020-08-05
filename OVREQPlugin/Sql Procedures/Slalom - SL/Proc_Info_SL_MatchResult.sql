IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_SL_MatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_SL_MatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_SL_MatchResult]
----功   能：比赛成绩、单场或者多场
----作	 者：吴定昉
----日   期：2012-09-11 

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

CREATE PROCEDURE [dbo].[Proc_Info_SL_MatchResult]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

    DECLARE @DisciplineCode AS NVARCHAR(50)
    DECLARE @GenderCode     AS NVARCHAR(50)
    DECLARE @EventCode      AS NVARCHAR(50)
    DECLARE @EventID        AS INT
    DECLARE @PhaseCode      AS NVARCHAR(50)
    DECLARE @UnitCode       AS NVARCHAR(50)
    DECLARE @VunueCode      AS NVARCHAR(50)
	DECLARE @LanguageCode   AS CHAR(3)	
	DECLARE @MatchStatusID  INT
	
	SELECT @DisciplineCode = D.F_DisciplineCode, @GenderCode = S.F_GenderCode
	, @EventCode = E.F_EventCode, @EventID = E.F_EventID
	, @PhaseCode = P.F_PhaseCode, @UnitCode = M.F_MatchCode
	, @VunueCode = V.F_VenueCode, @MatchStatusID = M.F_MatchStatusID
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
	WHERE F_MatchID = @MatchID
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	DECLARE @Content AS NVARCHAR(MAX)
	
	---当比赛为试划项目，则不发消息
	if(@EventCode = '000')
	BEGIN
	    RETURN
	END
	
	
	CREATE TABLE #Temp_Table
	(
	    [RegisterID]        INT,
        [DelegationName]    NVARCHAR(100),
        [START_ORDER]       INT,
        [TEAM_BIB]          INT,
        [RANK]              INT,
        [RANKPO]            INT,
        [RACE_TIME]         NVARCHAR(100),
        [PENALTY_SECONDS]   NVARCHAR(3),
        [TOTAL_RACE_TIME]   NVARCHAR(100), 
	)

	CREATE TABLE #Temp_SubTable
	(
	    [RegisterID]        INT,
		[RegisterMemberID]	INT,  
        [BIB]               INT,
        [AthleteName]       NVARCHAR(100),
	)


    INSERT #Temp_Table([RegisterID],[DelegationName],
	[START_ORDER],[TEAM_BIB],
    [RANK],[RANKPO],[RACE_TIME],[PENALTY_SECONDS],[TOTAL_RACE_TIME])
	(
		SELECT MR.F_RegisterID
		    , DD.F_DelegationLongName AS [DelegationName]
            , CONVERT(INT,MR.F_CompetitionPositionDes1)
            , CONVERT(INT,(case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum 
            else R.F_Bib end))
            , MR.F_Rank
            , MR.F_DisplayPosition
            , '' + MR.F_PointsCharDes1 + ''
            , MR.F_Points
            , case when MR.F_IRMID is not null then '' + (SELECT REPLACE(ID.F_IRMLongName,'-','')) + '' 
                   else '' + MR.F_PointsCharDes2 + '' end
		FROM TS_Match_Result AS MR
        LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
		LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation_Des DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
		--LEFT JOIN TR_Register_Member AS RM ON R.F_RegisterID = RM.F_RegisterID		
		LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND E.F_EventID = I.F_EventID 
        LEFT JOIN TS_Phase_Result AS PR ON M.F_PhaseID = PR.F_PhaseID AND MR.F_RegisterID = PR.F_RegisterID
		LEFT JOIN TC_IRM_Des AS ID ON MR.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'eng' 
		WHERE D.F_DisciplineCode = @DisciplineCode
		    AND E.F_EventCode IS NOT NULL AND E.F_EventCode <> '000'
			AND MR.F_RegisterID IS NOT NULL
			AND M.F_MatchID = @MatchID
	)
	
    --select * from #Temp_Table
    
    DECLARE @PlayerRegTypeID AS INT
    SELECT @PlayerRegTypeID = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
    
    IF @PlayerRegTypeID = 1
    BEGIN
		INSERT INTO #Temp_SubTable([RegisterID],[RegisterMemberID],[BIB],[AthleteName])
		SELECT TT.RegisterID,R.F_RegisterID,TT.TEAM_BIB,RD.F_LongName FROM #Temp_Table TT
		LEFT JOIN TR_Register AS R ON TT.RegisterID = R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    END
    ELSE
    BEGIN
		INSERT INTO #Temp_SubTable([RegisterID],[RegisterMemberID],[BIB],[AthleteName])
		SELECT MR.F_RegisterID,RM.F_MemberRegisterID,TT.TEAM_BIB,RD.F_LongName FROM TS_Match_Result MR
		LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
		LEFT JOIN TR_Register_Member AS RM ON R.F_RegisterID = RM.F_RegisterID		    
		LEFT JOIN TR_Register_Des AS RD ON RM.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
		LEFT JOIN #Temp_Table TT ON MR.F_RegisterID = TT.RegisterID 
		WHERE MR.F_MatchID = @MatchID
    END
    
    --select * from #Temp_SubTable
    
	SET @Content = ( SELECT [Row].[RANK] AS [Rank],
	                     [Row].[DelegationName] AS [DelegationName],
	                     [Row].[RACE_TIME] AS [Result1],
	                     [Row].[PENALTY_SECONDS] AS [Result2],
	                     [Row].[TOTAL_RACE_TIME] AS [Result3],
	                     N'' AS [Status],
	                        [Row1].[BIB] AS [Bib],
	                        [Row1].[AthleteName] AS [AthleteName]	                        
	            FROM (SELECT [RegisterID],[RANK],[DelegationName],
	            [RACE_TIME],[PENALTY_SECONDS],[TOTAL_RACE_TIME],[RANKPO] FROM #Temp_Table) AS [Row] 
				LEFT JOIN (SELECT [RegisterID],[RegisterMemberID],[BIB],[AthleteName] FROM #Temp_SubTable) AS [Row1]
				ON [Row].[RegisterID] = [Row1].[RegisterID] ORDER BY [RANKPO],[Bib]
			FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
		RETURN 
	END

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
    
	IF @DisciplineCode = 'SL'
		SET @DisciplineCode = 'CS'
	
	DECLARE @OutputEventCode	AS NVARCHAR(10)
	DECLARE @FileName	AS NVARCHAR(100)
	
	SET @OutputEventCode = [dbo].[Func_SL_GetOutputEventCode](@GenderCode, @EventCode)
	SET @FileName =	@DisciplineCode + @GenderCode + @OutputEventCode + @PhaseCode + @UnitCode + N'.0.CHI.1.0'
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC [Proc_Info_SL_MatchResult] 1
--EXEC [Proc_Info_SL_MatchResult] 803