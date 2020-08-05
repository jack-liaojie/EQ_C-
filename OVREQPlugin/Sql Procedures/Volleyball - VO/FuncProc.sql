
IF ( OBJECT_ID('proc_VB_BV_RPT_GetEntryDataCheckListCompetitors') IS NOT NULL )
DROP PROCEDURE [proc_VB_BV_RPT_GetEntryDataCheckListCompetitors]
GO

IF ( OBJECT_ID('proc_VB_BV_RPT_GetEventMedallists') IS NOT NULL )
DROP PROCEDURE [proc_VB_BV_RPT_GetEventMedallists]
GO

IF ( OBJECT_ID('proc_VB_BV_RPT_MedalStanding') IS NOT NULL )
DROP PROCEDURE [proc_VB_BV_RPT_MedalStanding]
GO

IF ( OBJECT_ID('proc_VB_CreateGroupResult') IS NOT NULL )
DROP PROCEDURE [proc_VB_CreateGroupResult]
GO

IF ( OBJECT_ID('proc_VB_EXT_AvailableOfficialGetList') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_AvailableOfficialGetList]
GO

IF ( OBJECT_ID('proc_VB_EXT_FunctionsGetList') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_FunctionsGetList]
GO

IF ( OBJECT_ID('proc_VB_EXT_GetFunctions') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_GetFunctions]
GO

IF ( OBJECT_ID('proc_VB_EXT_GetIRMList') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_GetIRMList]
GO

IF ( OBJECT_ID('proc_VB_EXT_GetPosition') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_GetPosition]
GO

IF ( OBJECT_ID('proc_VB_EXT_GetTeamAvailable') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_GetTeamAvailable]
GO

IF ( OBJECT_ID('proc_VB_EXT_GetUniform') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_GetUniform]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchMemberAdd') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchMemberAdd]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchMemberFunctionUpdate') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchMemberFunctionUpdate]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchMemberGetList') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchMemberGetList]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchMemberPositionUpdate') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchMemberPositionUpdate]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchMemberRemove') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchMemberRemove]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchOfficialAdd') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchOfficialAdd]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchOfficialFunctionUpdate') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchOfficialFunctionUpdate]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchOfficialGetList') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchOfficialGetList]
GO

IF ( OBJECT_ID('proc_VB_EXT_MatchOfficialRemove') IS NOT NULL )
DROP PROCEDURE [proc_VB_EXT_MatchOfficialRemove]
GO

IF ( OBJECT_ID('proc_VB_INFO_RealTimeScore') IS NOT NULL )
DROP PROCEDURE [proc_VB_INFO_RealTimeScore]
GO

IF ( OBJECT_ID('proc_VB_INFO_ReportList') IS NOT NULL )
DROP PROCEDURE [proc_VB_INFO_ReportList]
GO

IF ( OBJECT_ID('proc_VB_PRG_CalGroupResult') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_CalGroupResult]
GO

IF ( OBJECT_ID('proc_VB_PRG_GetMatchInfo') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_GetMatchInfo]
GO

IF ( OBJECT_ID('proc_VB_PRG_MatchCreate') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_MatchCreate]
GO

IF ( OBJECT_ID('proc_VB_PRG_MatchSetScore') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_MatchSetScore]
GO

IF ( OBJECT_ID('proc_VB_PRG_MatchStartList') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_MatchStartList]
GO

IF ( OBJECT_ID('proc_VB_PRG_StatActionAdd') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_StatActionAdd]
GO

IF ( OBJECT_ID('proc_VB_PRG_StatActionGetList') IS NOT NULL )
DROP PROCEDURE [proc_VB_PRG_StatActionGetList]
GO

IF ( OBJECT_ID('proc_VB_RPT_CompetitionSchedule') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_CompetitionSchedule]
GO

IF ( OBJECT_ID('proc_VB_RPT_EventMedallists') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_EventMedallists]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetCommonInfo') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetCommonInfo]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetEntryDataCheckListCompetitors') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetEntryDataCheckListCompetitors]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetEntryDataCheckListOfficials') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetEntryDataCheckListOfficials]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetEventInfo') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetEventInfo]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetGroupStatics') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetGroupStatics]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetMatchInfo') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetMatchInfo]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetMatchMemberLineUp') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetMatchMemberLineUp]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetMatchStartList') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetMatchStartList]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetMatchStat_Athlete_C83') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetMatchStat_Athlete_C83]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetMatchStat_Team_C83') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetMatchStat_Team_C83]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetMatchTeamInfo') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetMatchTeamInfo]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetNocListByDiscipline') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetNocListByDiscipline]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetPhaseResult') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetPhaseResult]
GO

IF ( OBJECT_ID('Proc_VB_RPT_GetPictures') IS NOT NULL )
DROP PROCEDURE [Proc_VB_RPT_GetPictures]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetRSCCode') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetRSCCode]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetTeamMember') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetTeamMember]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetTeamUniformsInPhase') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetTeamUniformsInPhase]
GO

IF ( OBJECT_ID('proc_VB_RPT_GetTournamentChart') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_GetTournamentChart]
GO

IF ( OBJECT_ID('proc_VB_RPT_NumberOfEntries') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_NumberOfEntries]
GO

IF ( OBJECT_ID('proc_VB_RPT_TeamRosterInfo') IS NOT NULL )
DROP PROCEDURE [proc_VB_RPT_TeamRosterInfo]
GO

IF ( OBJECT_ID('proc_VB_TEST_BackupScriptsToFile') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_BackupScriptsToFile]
GO

IF ( OBJECT_ID('proc_VB_TEST_CreateTestActionList') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_CreateTestActionList]
GO

IF ( OBJECT_ID('proc_VB_TEST_CreateTestAthlete') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_CreateTestAthlete]
GO

IF ( OBJECT_ID('proc_VB_TEST_CreateTestData') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_CreateTestData]
GO

IF ( OBJECT_ID('proc_VB_TEST_CreateTestTeam') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_CreateTestTeam]
GO

IF ( OBJECT_ID('proc_VB_TEST_GetInsertSQL') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_GetInsertSQL]
GO

IF ( OBJECT_ID('proc_VB_TEST_WriteTxtToFile') IS NOT NULL )
DROP PROCEDURE [proc_VB_TEST_WriteTxtToFile]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/************************proc_VB_BV_RPT_GetEntryDataCheckListCompetitors Start************************/GO







--为了沙排使用
--与排球区别是需要显示Team

--2011-10-17	Created
--2011-11-02	Add team's gender
CREATE PROCEDURE [dbo].[proc_VB_BV_RPT_GetEntryDataCheckListCompetitors](
												@DisciplineID		INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_DelegationID  INT,
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(100),
                                F_RegTypeID     INT,
                                F_RegDes        NVARCHAR(100),
                                F_FimalyName    NVARCHAR(100),
                                F_GivenName     NVARCHAR(100),
								F_SexCode	    INT,
								F_Gender		NVARCHAR(100),
                                F_Birth_Date    NVARCHAR(100),
                                F_Height        INT,
                                F_Weight        INT,
                                F_RegisterCode  NVARCHAR(100),
                                F_UCICode       NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(100),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(100),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(100),
                                F_WNPALN        NVARCHAR(100),
                                F_WNPASN        NVARCHAR(100),
                                F_HeightDes     NVARCHAR(100),
                                F_WeightDes     NVARCHAR(100),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100),
                                F_Events        NVARCHAR(100),
                                F_Handedness    NVARCHAR(100)
							)

    CREATE TABLE #Tmp_Events(
                              F_Event       NVARCHAR(100)
                             )

    IF @DelegationID = -1
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, 
		
		( SELECT TOP 1 F_ShirtNumber from TR_Register_Member where F_MemberRegisterID = A.F_RegisterID ),
		A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, dbo.func_VB_GetDateTimeStr(A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID 
		LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID IN (1, 2, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY C.F_DelegationCode, A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, 
		( SELECT TOP 1 F_ShirtNumber from TR_Register_Member where F_MemberRegisterID = A.F_RegisterID ),
		A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, dbo.func_VB_GetDateTimeStr(A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID 
		LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_DelegationID = @DelegationID AND A.F_RegTypeID IN (1, 2, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END

    UPDATE #Tmp_Table SET F_Handedness = B.F_Comment FROM #Tmp_Table AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_Title = 'Hand'
    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode
    UPDATE #Tmp_Table SET F_HeightDes = dbo.func_VB_RPT_GetHeightDes(F_Height)
    UPDATE #Tmp_Table SET F_WeightDes = dbo.func_VB_RPT_GetWeightDes(F_Weight)

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode AND F_RegTypeID = 5
    UPDATE #Tmp_Table SET F_Function = 'Athlete' WHERE F_RegTypeID = 1 AND @LanguageCode = 'ENG'
    UPDATE #Tmp_Table SET F_Function = '运动员' WHERE F_RegTypeID = 1 AND @LanguageCode = 'CHN'

    DECLARE @RegisterID INT
    DECLARE @Events NVARCHAR(100)
    DECLARE ONE_CURSOR CURSOR FOR SELECT F_RegisterID FROM #Tmp_Table WHERE F_RegTypeID = 1
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @RegisterID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		BEGIN
        DELETE FROM #Tmp_Events
        INSERT INTO #Tmp_Events (F_Event)
        SELECT C.F_EventComment FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
        LEFT JOIN TS_Event_Des AS C ON B.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
        WHERE B.F_DisciplineID = @DisciplineID AND A.F_RegisterID = @RegisterID

        INSERT INTO #Tmp_Events (F_Event)
        SELECT D.F_EventComment FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS D ON C.F_EventID = D.F_EventID AND D.F_LanguageCode = @LanguageCode
        WHERE C.F_DisciplineID = @DisciplineID AND A.F_MemberRegisterID = @RegisterID

        SET @Events = ''
        DECLARE @EventName NVARCHAR(10)
        DECLARE TWO_CURSOR CURSOR FOR SELECT F_Event FROM #Tmp_Events
		OPEN TWO_CURSOR
		FETCH NEXT FROM TWO_CURSOR INTO @EventName
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @Events = @Events + @EventName + ','
			FETCH NEXT FROM TWO_CURSOR INTO @EventName
		END
		CLOSE TWO_CURSOR
		DEALLOCATE TWO_CURSOR
		--END

        IF LEN(@Events) > 0
        SET @Events = LEFT(@Events, LEN(@Events) - 1)
        UPDATE #Tmp_Table SET F_Events = @Events WHERE F_RegisterID = @RegisterID
        
        END
        
		FETCH NEXT FROM ONE_CURSOR INTO @RegisterID
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END
    
	UPDATE #Tmp_Table SET 
		  F_Function = 'Double'
		  , F_Events = (SELECT F_SexShortName FROM TC_Sex_Des WHERE F_LanguageCode = @LanguageCode AND F_SexCode = (SELECT F_SexCode FROM TC_Sex WHERE F_GenderCode = F_Gender) )
	WHERE F_RegTypeID = 2

	SELECT F_DelegationID, F_RegisterID, F_RegTypeID, F_NOC, F_NOCDes, F_Function, F_Bib, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_HeightDes, F_WeightDes, F_RegisterCode, F_UCICode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_Events, F_Handedness FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF







GO
/************************proc_VB_BV_RPT_GetEntryDataCheckListCompetitors OVER*************************/


/************************proc_VB_BV_RPT_GetEventMedallists Start************************/GO







--2011-10-18	为了兼容BV，添加TeamName
CREATE PROCEDURE [dbo].[proc_VB_BV_RPT_GetEventMedallists](
			@EventID		    INT,
			@LangCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 	
	
	SELECT F_DispPos, F_Rank, F_MedalCode
	, (SELECT F_MedalShortName FROM TC_Medal_Des WHERE F_MedalID = A.F_MedalID AND F_LanguageCode = @LangCode) AS F_MedalName
	, (SELECT dbo.func_VB_GetNocFromRegID(A.F_RegisterID )) AS F_Noc
	, (SELECT dbo.func_VB_GetNocDesFromRegID(A.F_RegisterID )) AS F_NocDes
	, (SELECT dbo.func_VB_GetTeamNameFromRegID(A.F_RegisterID, @LangCode)) AS F_TeamName
	, (SELECT F_PrintLongName + (SELECT F_Player1FuncCodeBracket FROM dbo.func_VB_BV_GetTeamInfo(A.F_RegisterID)) FROM TR_Register_Des WHERE F_LanguageCode = @LangCode AND F_RegisterID = (SELECT F_Player1RegID FROM dbo.func_VB_BV_GetTeamInfo(A.F_RegisterID))) AS F_PlayerRptNameL1
	, (SELECT F_PrintLongName + (SELECT F_Player2FuncCodeBracket FROM dbo.func_VB_BV_GetTeamInfo(A.F_RegisterID)) FROM TR_Register_Des WHERE F_LanguageCode = @LangCode AND F_RegisterID = (SELECT F_Player2RegID FROM dbo.func_VB_BV_GetTeamInfo(A.F_RegisterID))) AS F_PlayerRptNameL2
	FROM dbo.func_VB_GetEventMedalList(@EventID) AS A
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF








GO
/************************proc_VB_BV_RPT_GetEventMedallists OVER*************************/


/************************proc_VB_BV_RPT_MedalStanding Start************************/GO


--获取以国家为单位的奖牌获取个数排名

--2011-10-19	Created
CREATE PROCEDURE [dbo].[proc_VB_BV_RPT_MedalStanding](
			@LangCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 	


	--找出有奖牌的国家
	SELECT 
		F_DelegationID 
	INTO #TmpTbl1
	FROM TC_Delegation AS A
	WHERE F_DelegationID IN
	(
		SELECT F_DelegationID FROM TR_Register WHERE F_RegisterID IN
		(
			SELECT F_RegisterID FROM TS_Event_Result WHERE F_MedalID IS NOT NULL
		)
	)
	
	--填入基本数值
	SELECT
		  A.F_DelegationID
		, (SELECT COUNT(*) FROM TS_Event_Result WHERE F_RegisterID IN ( SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_DelegationID = A.F_DelegationID ) AND F_EventID = 31 AND F_MedalID = 1 ) AS F_MG
		, (SELECT COUNT(*) FROM TS_Event_Result WHERE F_RegisterID IN ( SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_DelegationID = A.F_DelegationID ) AND F_EventID = 31 AND F_MedalID = 2 ) AS F_MS
		, (SELECT COUNT(*) FROM TS_Event_Result WHERE F_RegisterID IN ( SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_DelegationID = A.F_DelegationID ) AND F_EventID = 31 AND F_MedalID = 3 ) AS F_MB
		
		, (SELECT COUNT(*) FROM TS_Event_Result WHERE F_RegisterID IN ( SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_DelegationID = A.F_DelegationID ) AND F_EventID = 32 AND F_MedalID = 1 ) AS F_WG
		, (SELECT COUNT(*) FROM TS_Event_Result WHERE F_RegisterID IN ( SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_DelegationID = A.F_DelegationID ) AND F_EventID = 32 AND F_MedalID = 2 ) AS F_WS
		, (SELECT COUNT(*) FROM TS_Event_Result WHERE F_RegisterID IN ( SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_DelegationID = A.F_DelegationID ) AND F_EventID = 32 AND F_MedalID = 3 ) AS F_WB		
	INTO #TmpTbl2
	FROM #TmpTbl1 AS A
	
	--SELECT * FROM #TmpTbl2 RETURN


	--计算每个国家总计值
	SELECT
		  A.F_DelegationID
		, F_MG
		, F_MS
		, F_MB
		, A.F_MG + A.F_MS + A.F_MB AS F_M_TOT
		
		, F_WG
		, F_WS
		, F_WB
		, A.F_WG + A.F_WS + A.F_WB AS F_W_TOT
		
		, F_MG + F_WG AS F_G
		, F_MS + F_WS AS F_S
		, F_MB + F_WB AS F_B
		, A.F_MG + A.F_MS + A.F_MB + A.F_WG + A.F_WS + A.F_WB AS F_TOT
		
	INTO #TmpTbl3	
	FROM #TmpTbl2 AS A

	--SELECT * FROM #TmpTbl3 RETURN

	--计算每个项目总计值，排序
	SELECT 
		  *
		, CAST( (RANK() OVER(ORDER BY F_Tot DESC, F_G DESC, F_S DESC, F_B DESC)) AS NVARCHAR(100)) AS F_Rank	--总奖牌，金牌。。。
		, CAST( (RANK() OVER(ORDER BY F_Tot DESC)) AS NVARCHAR(100)) AS F_RankMark
		, ROW_NUMBER() OVER(ORDER BY F_Tot DESC, F_G DESC, F_S DESC, F_B DESC) AS F_DispPos
		
		, ( SELECT SUM(F_MG) FROM #TmpTbl3 ) AS F_TOT_MG
		, ( SELECT SUM(F_MS) FROM #TmpTbl3 ) AS F_TOT_MS
		, ( SELECT SUM(F_MB) FROM #TmpTbl3 ) AS F_TOT_MB
		, ( SELECT SUM(F_M_TOT) FROM #TmpTbl3 ) AS F_TOT_M
		
		, ( SELECT SUM(F_WG) FROM #TmpTbl3 ) AS F_TOT_WG
		, ( SELECT SUM(F_WS) FROM #TmpTbl3 ) AS F_TOT_WS
		, ( SELECT SUM(F_WB) FROM #TmpTbl3 ) AS F_TOT_WB
		, ( SELECT SUM(F_W_TOT) FROM #TmpTbl3 ) AS F_TOT_W
		
		, ( SELECT SUM(F_G) FROM #TmpTbl3 ) AS F_TOT_G
		, ( SELECT SUM(F_S) FROM #TmpTbl3 ) AS F_TOT_S
		, ( SELECT SUM(F_B) FROM #TmpTbl3 ) AS F_TOT_B
		, ( SELECT SUM(F_TOT) FROM #TmpTbl3 ) AS F_TOT_TOT
		
	INTO #TmpTbl4
	FROM #TmpTbl3 AS A

	--生成排序的'='
	UPDATE A SET
		 F_RankMark = CASE WHEN (SELECT COUNT(*) FROM #TmpTbl4 WHERE F_RankMark = A.F_RankMark ) > 1 THEN '=' + F_RankMark ELSE F_RankMark END
	FROM #TmpTbl4 AS A
	
	--SELECT * FROM #TmpTbl4 RETURN
	
	--将0变为-
	SELECT 
		  (SELECT F_DelegationCode FROM TC_Delegation WHERE F_DelegationID = A.F_DelegationID) AS F_Noc
		, (SELECT F_DelegationShortName FROM TC_Delegation_Des WHERE F_DelegationID = A.F_DelegationID AND F_LanguageCode = @LangCode) AS F_NocDes
		, dbo.func_VB_GetZeroValue(A.F_MG) AS F_MG
		, dbo.func_VB_GetZeroValue(A.F_MS) AS F_MS
		, dbo.func_VB_GetZeroValue(A.F_MB) AS F_MB
		, dbo.func_VB_GetZeroValue(A.F_M_TOT) AS F_M_TOT
		, dbo.func_VB_GetZeroValue(A.F_WG) AS F_WG
		, dbo.func_VB_GetZeroValue(A.F_WS) AS F_WS
		, dbo.func_VB_GetZeroValue(A.F_WB) AS F_WB		
		, dbo.func_VB_GetZeroValue(A.F_W_TOT) AS F_W_TOT
		, dbo.func_VB_GetZeroValue(A.F_G) AS F_G
		, dbo.func_VB_GetZeroValue(A.F_S) AS F_S
		, dbo.func_VB_GetZeroValue(A.F_B) AS F_B
		, dbo.func_VB_GetZeroValue(A.F_TOT) AS F_TOT
		, A.F_Rank
		, A.F_DispPos
		, A.F_RankMark
		
		, dbo.func_VB_GetZeroValue(A.F_TOT_MG) AS F_TOT_MG
		, dbo.func_VB_GetZeroValue(A.F_TOT_MS) AS F_TOT_MS
		, dbo.func_VB_GetZeroValue(A.F_TOT_MB) AS F_TOT_MB
		, dbo.func_VB_GetZeroValue(A.F_TOT_M) AS F_TOT_M
		
		, dbo.func_VB_GetZeroValue(A.F_TOT_WG) AS F_TOT_WG
		, dbo.func_VB_GetZeroValue(A.F_TOT_WS) AS F_TOT_WS
		, dbo.func_VB_GetZeroValue(A.F_TOT_WB) AS F_TOT_WB
		, dbo.func_VB_GetZeroValue(A.F_TOT_W) AS F_TOT_W
		
		, dbo.func_VB_GetZeroValue(A.F_TOT_G) AS F_TOT_G
		, dbo.func_VB_GetZeroValue(A.F_TOT_S) AS F_TOT_S
		, dbo.func_VB_GetZeroValue(A.F_TOT_B) AS F_TOT_B
		, dbo.func_VB_GetZeroValue(A.F_TOT_TOT) AS F_TOT_TOT
		
	FROM #TmpTbl4 AS A
	ORDER BY F_DispPos
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF








GO
/************************proc_VB_BV_RPT_MedalStanding OVER*************************/


/************************proc_VB_CreateGroupResult Start************************/GO


----功		  能：计算小组的积分和排名
----作		  者：王征
----日		  期: 2010-10-28

--2011-06-17	对于BYE,计算完成后放在最后,并且Rank没有值
--2011-06-17	对于积分相同,分,局都相同,那么名次就相同,需要手动晋级
--2011-08-04	@Result为可选参数
CREATE PROCEDURE [dbo].[proc_VB_CreateGroupResult] (	
	@PhaseID			INT,
	@Result 			AS INT = NULL OUTPUT 
)	
AS
BEGIN
SET NOCOUNT ON

   set @Result =0;		-- @Result = -1; 更新失败，标示没有做任何操作！
						-- @Result =  0; 非小组赛, 没有做任何操作
						-- @Result =  1; 更新成功！
	
	DECLARE @PhaseType	AS INT
	SELECT @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID

    --非小组赛，不能统计小组赛积分, 退出
	IF (@PhaseType != 2 OR @PhaseType IS NULL)
	BEGIN
	    SET @Result = 0
		RETURN
	END

	DECLARE	@tmpWonMatchPoint	AS INT
	DECLARE	@tmpDrawMatchPoint	AS INT
	DECLARE	@tempLostMatchPoint AS INT
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	--无论有无设置积分规则,都强制设置 2,0,1
	--此处暂时这样
	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID)
	BEGIN
		INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint) VALUES (@PhaseID, 2, 0, 1)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result= -1
			RETURN
		END
	END
	ELSE
	BEGIN
	    UPDATE TS_Phase_MatchPoint SET F_WonMatchPoint = 2, F_DrawMatchPoint = 0, F_LostMatchPoint = 1 WHERE F_PhaseID = @PhaseID
	    
	    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result= -1 
			RETURN
		END
	END


	--把胜负平的分值取出来
	SELECT	@tmpWonMatchPoint = F_WonMatchPoint, 
			@tmpDrawMatchPoint = F_DrawMatchPoint, 
			@tempLostMatchPoint = F_LostMatchPoint
	FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID

	--如果Result的签位和Position里边的签位不一样的话，就删除。Position里边的签位是正确的
	--就怕Result里边跟Position表里存的不一样
	DELETE FROM TS_Phase_Result WHERE 
		F_PhaseID = @PhaseID AND 
		F_PhaseResultNumber NOT IN (SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID)
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result= -1
			RETURN
		END


	INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber)
	SELECT F_PhaseID, F_PhasePosition AS F_PhaseResultNumber FROM TS_Phase_Position 
	WHERE F_PhaseID = @PhaseID AND F_PhasePosition NOT IN (SELECT F_PhaseResultNumber FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID)
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result= -1
			RETURN
		END


	UPDATE TS_Phase_Result SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Result AS A
	LEFT JOIN TS_Phase_Position AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhasePosition WHERE B.F_RegisterID IS NOT NULL
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result= -1
			RETURN
		END


	CREATE TABLE #tmp_GroupResult(
								[F_PhaseID]					[int],
								[F_PhaseResultNumber]		[int],
								[F_RegisterID]				[int],
								[F_PhasePoints]				[int],
								[F_MatchesWin]				[int],
								[F_MatchesLost]				[int],
								[F_PointsWin]               [int],
								[F_PointsLost]              [int],
								[F_PointsRatio]             DECIMAL(18,4),
								[F_SetsWin]					[int],
								[F_SetsLost]				[int],
								[F_SetsRatio]               DECIMAL(18,4),
								[F_PhaseRank]				[int],
								[F_PhaseDisplayPosition]	[int],
								) 
								
	CREATE TABLE #tmp_Table(
                                F_RegisterID               int,
                                F_OppRegisterID            int,
                                F_Rank                     int,
                                F_DisplayPos               int,
                                F_Pos                      int                        
	                        )
	                        
	--把所有Group内队伍填入表格
	INSERT INTO #tmp_GroupResult (F_PhaseID, F_PhaseResultNumber, F_RegisterID)
	SELECT A.F_PhaseID, A.F_PhaseResultNumber, A.F_RegisterID
	FROM TS_Phase_Result AS A 
	LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
	WHERE A.F_PhaseID = @PhaseID 
	--AND A.F_RegisterID > 0 

	--select * from #tmp_GroupResult


	--将每个Register的局,分胜负信息填入表格
    UPDATE #tmp_GroupResult SET 
    F_MatchesWin = [dbo].[func_VB_GetRegisterWinLostInGroup](F_PhaseID, F_RegisterID, 1, 1), 
	F_MatchesLost = [dbo].[func_VB_GetRegisterWinLostInGroup](F_PhaseID, F_RegisterID, 1, 2),
	F_SetsWin = [dbo].[func_VB_GetRegisterWinLostInGroup](F_PhaseID, F_RegisterID, 2, 1), 
	F_SetsLost = [dbo].[func_VB_GetRegisterWinLostInGroup](F_PhaseID, F_RegisterID, 2, 2),
	F_PointsWin = [dbo].[func_VB_GetRegisterWinLostInGroup](F_PhaseID, F_RegisterID, 3, 1), 
	F_PointsLost = [dbo].[func_VB_GetRegisterWinLostInGroup](F_PhaseID, F_RegisterID, 3, 2)
	WHERE F_RegisterID > 0

	--计算积分,Z值,C值
	UPDATE #tmp_GroupResult SET 
	F_PhasePoints = @tmpWonMatchPoint * F_MatchesWin + @tempLostMatchPoint * F_MatchesLost, --积分
	F_PointsRatio = CAST(F_PointsWin AS DECIMAL(18,4)) / CAST((CASE F_PointsLost WHEN 0 THEN 0.0001 ELSE F_PointsLost END) as DECIMAL(18,4)), --Z值
	F_SetsRatio = CAST(F_SetsWin AS DECIMAL(18,4)) / CAST((CASE F_SetsLost WHEN 0 THEN 0.0001 ELSE F_SetsLost END) as DECIMAL(18,4)) --C值
	WHERE F_RegisterID > 0
	
	/*
	--生成排序
    UPDATE #tmp_GroupResult SET F_RankPts = B.RankPts, F_PhaseRank = B.RankPoints, F_PhaseDisplayPosition = B.RankTotal
	FROM #tmp_GroupResult AS A 
	LEFT JOIN (SELECT 
	RANK() OVER(ORDER BY F_PhasePoints DESC, F_PointsRatio DESC, F_SetsRatio DESC) AS RankPts, --排序,如果按照排序条件后,还是相同,就是相同
	RANK() OVER(ORDER BY F_PhasePoints DESC, F_PointsRatio DESC, F_SetsRatio DESC) AS RankPoints, 
	RANK() OVER(ORDER BY F_PhasePoints DESC, F_PointsRatio DESC, F_SetsRatio DESC) AS RankTotal, 
	* FROM #tmp_GroupResult)
	AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	*/
	
	--生成排序
    UPDATE #tmp_GroupResult SET F_PhaseRank = B.F_Rank, F_PhaseDisplayPosition= B.F_DispPos
	FROM #tmp_GroupResult AS A 
	LEFT JOIN 
		(
			SELECT 
				RANK() OVER(ORDER BY F_PhasePoints DESC, F_PointsRatio DESC, F_SetsRatio DESC) AS F_Rank, --排序,如果按照排序条件后,还是相同,就是相同
				ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC, F_PointsRatio DESC, F_SetsRatio DESC) AS F_DispPos, 
				* 
				FROM #tmp_GroupResult
		)
	AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	
	UPDATE #tmp_GroupResult SET F_PhaseRank = NULL
	WHERE NOT F_RegisterID > 0 
	
	--select * from #tmp_GroupResult
	
	/*
	DECLARE @DisplayPos AS INT
	DECLARE @SameCount AS INT
	
	--循环所有内容,查找排序有两个相同的
	WHILE EXISTS(
	SELECT DisposCount FROM (
						SELECT COUNT(F_RankPts) AS DisposCount, F_RankPts FROM #tmp_GroupResult GROUP BY F_RankPts
							) AS B WHERE B.DisposCount = 2 AND B.F_RankPts > 0
				)
	BEGIN
		    
	    SELECT TOP 1 @DisplayPos = F_RankPts FROM (
											SELECT F_RankPts, COUNT(F_RankPts) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankPts
												  )
											AS B WHERE B.DisposCount = 2 AND B.F_RankPts > 0

	    DELETE FROM #tmp_Table
	        INSERT INTO #tmp_Table(F_RegisterID, F_NOC, F_Pos)
	          SELECT F_RegisterID, F_NOC, F_PhaseResultNumber FROM #tmp_GroupResult WHERE F_RankPts = @DisplayPos
	          
        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS 
			A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A 
        LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
        UPDATE A SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
		  FROM #tmp_Table AS A 
		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_NOC, F_Pos) AS DisplayPos, * FROM #tmp_Table)
		      AS B ON A.F_Pos = B.F_Pos
        
        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankPts = B.F_DisplayPos + @DisplayPos - 1 FROM #tmp_GroupResult AS A
          INNER JOIN #tmp_Table AS B ON A.F_PhaseResultNumber = B.F_Pos AND A.F_RegisterID = B.F_RegisterID
	END
	*/
	
	UPDATE TS_Phase_Result SET 
		  F_PhasePoints = A.F_PhasePoints
		, F_PhaseRank = A.F_PhaseRank
		, F_PhaseDisplayPosition = A.F_PhaseDisplayPosition 
	FROM #tmp_GroupResult AS A 
		LEFT JOIN TS_Phase_Result AS B 
	ON 
		A.F_PhaseID = B.F_PhaseID AND 
		A.F_PhaseResultNumber = B.F_PhaseResultNumber AND 
		A.F_RegisterID = B.F_RegisterID
			
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result= -1
			RETURN
		END
		
	--select * from #tmp_GroupResult

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END

/*
go

DECLARE @abc as int
exec [proc_VB_CreateGroupResult] 32, @abc output
select @abc
*/









GO
/************************proc_VB_CreateGroupResult OVER*************************/


/************************proc_VB_EXT_AvailableOfficialGetList Start************************/GO
























--名    称：[Proc_WP_GetAvailableOfficial]
--描    述：得到Match下可选的裁判信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_AvailableOfficialGetList](
                                                @DisciplineID       INT,
												@MatchID		    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100)
							)

    DECLARE @EventID INT
    SELECT @EventID = B.F_EventID FROM TS_Match AS A 
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    IF(@DisciplineID <> 0)
    BEGIN
        INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
        SELECT F_RegisterID, F_FunctionID FROM TR_Register 
        WHERE F_DisciplineID = @DisciplineID AND F_RegTypeID = 4 AND F_RegisterID NOT IN 
        (SELECT F_RegisterID FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL)
    END
    ELSE
    BEGIN
       	INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
           SELECT A.F_RegisterID, B.F_FunctionID FROM TR_Inscription AS A 
           LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_EventID = @EventID AND B.F_RegTypeID = 4
              AND A.F_RegisterID NOT IN 
              (SELECT F_RegisterID FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL)
    END
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName FROM #Tmp_Table AS A 
    LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A 
    LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Function AS [Function], F_RegisterID, F_FunctionID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



















GO
/************************proc_VB_EXT_AvailableOfficialGetList OVER*************************/


/************************proc_VB_EXT_FunctionsGetList Start************************/GO





















--名    称: [Proc_WP_GetFunctions]
--描    述: 获取指定项目所有的Function类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/




CREATE PROCEDURE [dbo].[proc_VB_EXT_FunctionsGetList]
	@DisciplineID				INT,
    @CategoryCode               NVARCHAR(20),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT B.F_FunctionLongName, A.F_FunctionID 
	FROM TD_Function AS A
	LEFT JOIN TD_Function_Des AS B
		ON A.F_FunctionID = b.F_FunctionID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID AND A.F_FunctionCategoryCode = @CategoryCode

SET NOCOUNT OFF
END


















GO
/************************proc_VB_EXT_FunctionsGetList OVER*************************/


/************************proc_VB_EXT_GetFunctions Start************************/GO






















--名    称: [Proc_WP_GetFunctions]
--描    述: 获取指定项目所有的Function类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/




CREATE PROCEDURE [dbo].[proc_VB_EXT_GetFunctions]
	@DisciplineID				INT,
    @CategoryCode               NVARCHAR(20),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT B.F_FunctionLongName, A.F_FunctionID 
	FROM TD_Function AS A
	LEFT JOIN TD_Function_Des AS B
		ON A.F_FunctionID = b.F_FunctionID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID AND A.F_FunctionCategoryCode = @CategoryCode

SET NOCOUNT OFF
END



















GO
/************************proc_VB_EXT_GetFunctions OVER*************************/


/************************proc_VB_EXT_GetIRMList Start************************/GO



























--名    称：[Proc_WP_GetIRMList]
--描    述：得到可选IRM列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月18日


CREATE PROCEDURE [dbo].[proc_VB_EXT_GetIRMList](
												@MatchID		    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Table(
                                F_IRMID                 INT,
                                F_IRM                   NVARCHAR(4)
							)

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID

	INSERT INTO #Tmp_Table (F_IRMID, F_IRM)
    SELECT F_IRMID, F_IRMCODE FROM TC_IRM WHERE F_DisciplineID = @DisciplineID

    INSERT INTO #Tmp_Table (F_IRMID, F_IRM)
    VALUES (-1, 'NONE')

	SELECT F_IRM, F_IRMID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_GetIRMList OVER*************************/


/************************proc_VB_EXT_GetPosition Start************************/GO






















--名    称: [Proc_WP_GetPosition]
--描    述: 获取指定项目所有的Position类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/




CREATE PROCEDURE [dbo].[proc_VB_EXT_GetPosition]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT B.F_PositionLongName, A.F_PositionID 
	FROM TD_Position AS A
	LEFT JOIN TD_Position_Des AS B
		ON A.F_PositionID = b.F_PositionID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID 

SET NOCOUNT OFF
END



















GO
/************************proc_VB_EXT_GetPosition OVER*************************/


/************************proc_VB_EXT_GetTeamAvailable Start************************/GO

























--名    称：[Proc_WP_GetTeamAvailable]
--描    述：得到Match下得队的可选运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_GetTeamAvailable](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @TeamPos            INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_MemberID      INT,
                                F_FunctionID    INT,
                                F_MemberName    NVARCHAR(100),
                                F_FunctionName  NVARCHAR(50),
                                F_ShirtNumber   INT,
                                F_Comment       NVARCHAR(50),
                                F_DSQ           INT,    ----0,  无DSQ， 1, DSQ
							)

	INSERT INTO #Tmp_Table (F_MemberID, F_FunctionID, F_ShirtNumber, F_Comment, F_DSQ)
    SELECT A.F_MemberRegisterID, A.F_FunctionID,  A.F_ShirtNumber, A.F_Comment, 0  
       FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID
            WHERE A.F_RegisterID = @RegisterID AND A.F_MemberRegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos) AND B.F_RegTypeID = 1

    UPDATE #Tmp_Table SET F_DSQ = 1 FROM #Tmp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_Comment = CAST(B.F_IRMID AS NVARCHAR(50)) WHERE B.F_IRMCODE = 'DSQ' 
    
    UPDATE #Tmp_Table SET F_MemberName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_FunctionName = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
	
    SELECT F_MemberID, F_FunctionID, F_ShirtNumber AS [ShirtNumber], F_MemberName AS [LongName], F_FunctionName AS [Function], F_DSQ AS [DSQ] FROM #Tmp_Table ORDER BY F_DSQ

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_GetTeamAvailable OVER*************************/


/************************proc_VB_EXT_GetUniform Start************************/GO
























----存储过程名称：[Proc_WP_GetUniform]
----功		  能：得到一个队的服装信息
----作		  者：李燕
----日		  期: 2010-03-15

CREATE PROCEDURE [dbo].[proc_VB_EXT_GetUniform](
                            @TeamID	        INT,
                            @LanguageCode   NVARCHAR(3)					  
)
	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_Uniform(
                                 F_UniformID        INT,
                                 F_RegisterID       INT,
                                 F_Shirt            INT,
                                 F_Shorts           INT,
                                 F_Socks            INT,
                                 F_ShirtName        NVARCHAR(50),
                                 F_ShortsName       NVARCHAR(50),
                                 F_SocksName        NVARCHAR(50),
                                 F_Order            INT,
                                 F_UiformName       NVARCHAR(200)
                                )

    INSERT INTO #table_Uniform (F_UniformID, F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order)
      SELECT F_UniformID, F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order FROM TR_Uniform
        WHERE F_RegisterID = @TeamID

    UPDATE #table_Uniform SET F_ShirtName = B.F_ColorLongName FROM #table_Uniform AS A LEFT JOIN
    TC_Color_Des AS B ON A.F_Shirt = B.F_ColorID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Uniform SET F_ShortsName = B.F_ColorLongName FROM #table_Uniform AS A LEFT JOIN
    TC_Color_Des AS B ON A.F_Shorts = B.F_ColorID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Uniform SET F_SocksName = B.F_ColorLongName FROM #table_Uniform AS A LEFT JOIN
    TC_Color_Des AS B ON A.F_Socks = B.F_ColorID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Uniform SET F_UiformName = (CASE WHEN F_ShirtName IS NULL THEN '' ELSE F_ShirtName END) + ', ' + (CASE WHEN F_ShortsName IS NULL THEN '' ELSE F_ShortsName END) + ', ' + (CASE WHEN F_SocksName IS NULL THEN '' ELSE F_SocksName END)

    SELECT F_UniformID AS UniformID, F_UiformName AS UniformName FROM #table_Uniform ORDER BY F_Order

SET NOCOUNT OFF
END




















GO
/************************proc_VB_EXT_GetUniform OVER*************************/


/************************proc_VB_EXT_MatchMemberAdd Start************************/GO

























--名    称：[Proc_WP_AddMatchMember]
--描    述：给Match选择队员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchMemberAdd](
												@MatchID		    INT,
                                                @MemberID           INT,
                                                @TeamPos            INT,
                                                @FunctionID         INT,
                                                @ShirtNumber        INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！


    SET @FunctionID = (CASE WHEN @FunctionID = -1 THEN NULL ELSE @FunctionID END)
    SET @ShirtNumber = (CASE WHEN @ShirtNumber = -1 THEN NULL ELSE @ShirtNumber END)

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	

    INSERT INTO TS_Match_Member(F_MatchID, F_CompetitionPosition, F_RegisterID, F_FunctionID, F_ShirtNumber)
    VALUES (@MatchID, @TeamPos, @MemberID, @FunctionID, @ShirtNumber)

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
   
    
    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_MatchMemberAdd OVER*************************/


/************************proc_VB_EXT_MatchMemberFunctionUpdate Start************************/GO

























--名    称：[Proc_WP_UpdateMatchMemberFunction]
--描    述：更新Match下的官员Function
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchMemberFunctionUpdate](
												@MatchID		    INT,
                                                @MemberID           INT,
                                                @TeamPos            INT,
                                                @FunctionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    UPDATE TS_Match_Member SET F_FunctionID = (CASE WHEN @FunctionID = -1 THEN NULL ELSE @FunctionID END) WHERE F_MatchID = @MatchID AND F_RegisterID = @MemberID AND F_CompetitionPosition = @TeamPos

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_MatchMemberFunctionUpdate OVER*************************/


/************************proc_VB_EXT_MatchMemberGetList Start************************/GO

























--名    称：[Proc_WP_GetMatchMember]
--描    述：得到Match下得队的运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchMemberGetList](
												@MatchID		    INT,
                                                @TeamPos            INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_MemberID      INT,
                                F_FunctionID    INT,
                                F_MemberName    NVARCHAR(100),
                                F_FunctionName  NVARCHAR(50),
                                F_ShirtNumber   INT,
                                F_PositionID    INT,
                                F_Position      NVARCHAR(50),
                                F_Order         INT,
                                F_Comment       NVARCHAR(50),
                                F_Startup        INT,
                                F_StartupNum     INT,
                                F_RegisterID    INT,
							)

   INSERT INTO #Tmp_Table(F_MemberID, F_FunctionID, F_ShirtNumber, F_PositionID, F_Order, F_Startup, F_StartupNum)
          SELECT F_RegisterID, F_FunctionID, F_ShirtNumber, F_PositionID, F_Order, F_Startup, 0 FROM TS_Match_Member
           WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos
  
   UPDATE #Tmp_Table SET F_RegisterID = A.F_RegisterID FROM TS_Match_Result AS A WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos
   
   UPDATE #Tmp_Table SET F_Startup = 0 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos AND F_Startup IS NULL
   
   UPDATE #Tmp_Table SET F_Comment = B.F_Comment FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS B ON A.F_MemberID = B.F_MemberRegisterID AND A.F_RegisterID = B.F_RegisterID

   UPDATE #Tmp_Table SET F_MemberName = B.F_LongName FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	 
   UPDATE #Tmp_Table SET F_FunctionName = B.F_FunctionLongName FROM #Tmp_Table AS A 
		LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
  
   UPDATE #Tmp_Table SET F_Position = B.F_PositionLongName FROM #Tmp_Table AS A 
		LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode

   UPDATE #Tmp_Table SET F_StartupNum = B.F_StartupNum 
          FROM (SELECT COUNT(F_RegisterID) AS F_StartupNum FROM TS_Match_Member 
          WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos AND F_StartUp = 1 )  AS B
  
  SELECT F_Startup AS [Startup], F_ShirtNumber AS [ShirtNumber], F_MemberName AS [LongName], 
	F_FunctionName AS [Function],  F_Position AS [Position], F_Comment AS [DSQ], F_Order AS [Order], 
	F_MemberID, F_StartupNum FROM #Tmp_Table ORDER BY F_Order, F_ShirtNumber
  
  DELETE #Tmp_Table
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_MatchMemberGetList OVER*************************/


/************************proc_VB_EXT_MatchMemberPositionUpdate Start************************/GO

























--名    称：[Proc_WP_UpdateMatchMemberPosition]
--描    述：更新Match下的官员Position
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchMemberPositionUpdate](
												@MatchID		    INT,
                                                @MemberID           INT,
                                                @TeamPos            INT,
                                                @PositionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    UPDATE TS_Match_Member SET F_PositionID = (CASE WHEN @PositionID = -1 THEN NULL ELSE @PositionID END) WHERE F_MatchID = @MatchID AND F_RegisterID = @MemberID AND F_CompetitionPosition = @TeamPos

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_MatchMemberPositionUpdate OVER*************************/


/************************proc_VB_EXT_MatchMemberRemove Start************************/GO

























--名    称：[Proc_WP_RemoveMatchMember]
--描    述：删除Match下的队员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchMemberRemove](
												@MatchID		    INT,
                                                @MemberID           INT,
                                                @TeamPos            INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！


    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    DELETE FROM  TS_Match_Member WHERE F_MatchID = @MatchID AND F_RegisterID = @MemberID AND F_CompetitionPosition = @TeamPos

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


    COMMIT TRANSACTION --成功提交事务


	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




















GO
/************************proc_VB_EXT_MatchMemberRemove OVER*************************/


/************************proc_VB_EXT_MatchOfficialAdd Start************************/GO
























--名    称：[Proc_WP_AddMatchOfficial]
--描    述：给Match选择官员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchOfficialAdd](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @FunctionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH
    CREATE TABLE #table_Tmp(
                             F_MatchID      INT,
                             F_ServantNum   INT,
                             F_RowCount     INT
                            )

    DECLARE @ServantNum INT
    SELECT @ServantNum = (CASE WHEN MAX(F_ServantNum) IS NULL THEN 0 ELSE MAX(F_ServantNum) END) + 1 
    FROM TS_Match_Servant WHERE F_MatchID = @MatchID

    SET @FunctionID = (CASE WHEN @FunctionID = -1 THEN NULL ELSE @FunctionID END)

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    INSERT INTO TS_Match_Servant(F_MatchID, F_ServantNum, F_RegisterID, F_FunctionID)
    VALUES (@MatchID, @ServantNum, @RegisterID, @FunctionID)

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    INSERT INTO #table_Tmp(F_MatchID, F_ServantNum, F_RowCount)
    SELECT F_MatchID, F_ServantNum, ROW_NUMBER() OVER (ORDER BY F_ServantNum) FROM TS_Match_Servant WHERE F_MatchID = @MatchID

    UPDATE TS_Match_Servant SET F_Order = B.F_RowCount FROM TS_Match_Servant AS A 
    LEFT JOIN #table_Tmp AS B ON A.F_MatchID = B.F_MatchID
    AND A.F_ServantNum = B.F_ServantNum WHERE A.F_MatchID = @MatchID
  
    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



















GO
/************************proc_VB_EXT_MatchOfficialAdd OVER*************************/


/************************proc_VB_EXT_MatchOfficialFunctionUpdate Start************************/GO
























--名    称：[Proc_WP_UpdateMatchOfficialFunction]
--描    述：更新Match下的官员Function
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchOfficialFunctionUpdate](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @FunctionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    UPDATE TS_Match_Servant SET F_FunctionID = (CASE WHEN @FunctionID = -1 THEN NULL ELSE @FunctionID END) 
    WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



















GO
/************************proc_VB_EXT_MatchOfficialFunctionUpdate OVER*************************/


/************************proc_VB_EXT_MatchOfficialGetList Start************************/GO

























--名    称：[Proc_WP_GetMatchOfficial]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchOfficialGetList](
												@MatchID		    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100)
							)

	INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
    SELECT F_RegisterID, F_FunctionID FROM TS_Match_Servant 
    WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL ORDER BY F_ServantNum
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName 
    FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName 
    FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Function AS [Function], F_RegisterID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



















GO
/************************proc_VB_EXT_MatchOfficialGetList OVER*************************/


/************************proc_VB_EXT_MatchOfficialRemove Start************************/GO
























--名    称：[Proc_WP_RemoveMatchOfficial]
--描    述：删除Match下的官员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[proc_VB_EXT_MatchOfficialRemove](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

    CREATE TABLE #table_Tmp(
                             F_MatchID      INT,
                             F_ServantNum   INT,
                             F_RowCount     INT
                            )

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    DELETE FROM  TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    INSERT INTO #table_Tmp(F_MatchID, F_ServantNum, F_RowCount)
    SELECT F_MatchID, F_ServantNum, ROW_NUMBER() OVER (ORDER BY F_ServantNum) FROM TS_Match_Servant WHERE F_MatchID = @MatchID

    UPDATE TS_Match_Servant SET F_Order = B.F_RowCount 
    FROM TS_Match_Servant AS A LEFT JOIN #table_Tmp AS B ON A.F_MatchID = B.F_MatchID
    AND A.F_ServantNum = B.F_ServantNum WHERE A.F_MatchID = @MatchID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



















GO
/************************proc_VB_EXT_MatchOfficialRemove OVER*************************/


/************************proc_VB_INFO_RealTimeScore Start************************/GO


--参数说明： 
--说    明：
--创 建 人：王征
--日    期：2010年10月12日


--2012-09-10	Modify it
CREATE PROCEDURE [dbo].[proc_VB_INFO_RealTimeScore](
	@MatchID		INT,
	@LangCode		NVARCHAR(100)
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @XmlRow			NVARCHAR(1000) = ''
	DECLARE @RscCode		NVARCHAR(100) = ''
	DECLARE @MessageHeader	NVARCHAR(1000) = ''
	DECLARE @Content		NVARCHAR(1000) = ''
	
	--Prepare a table that include matches
	SET @XmlRow =
	(SELECT * FROM 
	(SELECT 
		  ISNULL(B.F_MatchCode, '') AS Match
		, ISNULL(B.F_PhaseDes, '') AS Phase
		, ISNULL(dbo.func_VB_GetDateTimeStr(B.F_MatchTime, 3), '') AS StartTime
		, B.F_VenueDes AS Venue
		, ISNULL(D.F_Noc, '') AS DelegationName_A
		, ISNULL(E.F_Noc, '') AS DelegationName_B
		
		, C.F_Pts1Des AS Result1
		, C.F_Pts1Des AS Result2
		, C.F_Pts1Des AS Result3
		, C.F_Pts1Des AS Result4
		, C.F_Pts1Des AS Result5
		, C.F_PtsTotDes AS Result0
		, C.F_PtsSetDes AS Result
		, C.F_RankTot AS Winner
		, B.F_MatchStatusCode AS [Status]
	
	FROM TS_Match AS A
	OUTER APPLY dbo.func_VB_GetMatchInfo(A.F_MatchID, @LangCode) AS B
	OUTER APPLY dbo.func_VB_GetMatchScoreOneRow(A.F_MatchID, @LangCode) AS C
	OUTER APPLY dbo.func_VB_GetTeamNameByRegID(B.F_TeamARegID, @LangCode) AS D
	OUTER APPLY dbo.func_VB_GetTeamNameByRegID(B.F_TeamBRegID, @LangCode) AS E
	WHERE A.F_MatchID = @MatchID) AS Row
	FOR XML AUTO )
	
	SELECT @RscCode = F_RscCode FROM dbo.func_VB_GetMatchInfo(@MatchID, @LangCode)
	
	SET @MessageHeader =
	'<Message' + 
	' Language="CHI"' +
	' Date="' + dbo.func_VB_GetDateTimeStr(GETDATE(), 13) + '"' +
	' Time="' + dbo.func_VB_GetDateTimeStr(GETDATE(), 14) + '"' +
	'>'

	Set @Content = 
	'<?xml version="1.0" encoding="UTF-8"?>' + 
	CHAR(13) + CHAR(10) + 
	@MessageHeader + 
	CHAR(13) + CHAR(10) + 
	@XmlRow + 
	CHAR(13) + CHAR(10) + 
	N'</Message>'
	
	SELECT @Content AS OutputXML, @RscCode AS RscCode
  
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
go
exec [proc_VB_INFO_RealTimeScore] 1, 'ENG'
*/




GO
/************************proc_VB_INFO_RealTimeScore OVER*************************/


/************************proc_VB_INFO_ReportList Start************************/GO


--参数说明： 
--说    明：
--创 建 人：王征
--日    期：2010年10月12日


--2012-09-17	Created
CREATE PROCEDURE [dbo].[proc_VB_INFO_ReportList](
	@LangCode	NVARCHAR(100)
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @XmlRow			NVARCHAR(MAX) = ''
	DECLARE @MessageHeader	NVARCHAR(MAX) = ''
	DECLARE @Content		NVARCHAR(MAX) = ''
	
	SELECT  
		  A.F_MatchDay
		, A.F_MatchDate
		, A.F_MatchTime
		, B.F_RscCode
		, B.F_MatchDes
		, B.F_VenueCode
		, A.F_Order
	INTO #tblMatchList
	FROM dbo.func_VB_GetMatchSchedule(NULL) AS A
	OUTER APPLY dbo.func_VB_GetMatchInfo(A.F_MatchID, @LangCode) AS B
	
	SET @XmlRow = 
	(
		SELECT 
			  F_RscCode AS Code
			, ISNULL(F_MatchDes, '') AS Name
			, ISNULL(dbo.func_VB_GetDateTimeStr(F_MatchDate, 13), '') AS StartDate 
			, ISNULL(dbo.func_VB_GetDateTimeStr(F_MatchTime, 14), '') AS StartTime
			, ISNULL(F_Order, '') AS [Order]
			, ISNULL(F_VenueCode, '') AS VenueCode
			, ( SELECT 'C83A' AS TYPE, F_RscCode + '.C83A.CHI' AS [FileName] FROM TS_Discipline AS Detail FOR XML AUTO, TYPE )
			, ( SELECT 'C83B' AS TYPE, F_RscCode + '.C83A.CHI' AS [FileName] FROM TS_Discipline AS Detail FOR XML AUTO, TYPE )
		FROM #tblMatchList AS Schedule 
		FOR XML AUTO
	)
	
	SET @MessageHeader =
	'<Message' + 
	' DisciplineCode = "' + (SELECT TOP 1 F_DisciplineCode FROM TS_Discipline WHERE F_Active = 1 ) + '"' +
	' Date = "' + dbo.func_VB_GetDateTimeStr(GETDATE(), 13) + '"' +
	' Time = "' + dbo.func_VB_GetDateTimeStr(GETDATE(), 14) + '"' +
	' Language = "CHI"' +
	'>'

	Set @Content = 
	'<?xml version="1.0" encoding="UTF-8"?>' + 
	CHAR(13) + CHAR(10) + 
	@MessageHeader + 
	CHAR(13) + CHAR(10) + 
	@XmlRow + 
	CHAR(13) + CHAR(10) + 
	N'</Message>'
	
	SELECT @Content AS OutputXML, 'ReportList' AS FileName
  
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
go
exec [proc_VB_INFO_ReportList] 'ENG'
*/

GO
/************************proc_VB_INFO_ReportList OVER*************************/


/************************proc_VB_PRG_CalGroupResult Start************************/GO











----功		  能：计算小组的积分和排名
----作		  者：王征
----日		  期: 2010-10-28

--每场比赛点击Official是计算小组排名

--2011-08-04	proc_VB_CreateGroupResult来进行计算
CREATE PROCEDURE [dbo].[proc_VB_PRG_CalGroupResult] (	
	@MatchID			INT,
	@Result 			AS INT OUTPUT
)	
AS
BEGIN
SET NOCOUNT ON

    DECLARE @PhaseID    AS INT
	
	--获取此Match所属Phase和PhaseType
	SELECT 
	@PhaseID = A.F_PhaseID 
	FROM TS_Match AS A 
	LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
	WHERE A.F_MatchID = @MatchID
    
	exec [dbo].[proc_VB_CreateGroupResult] @PhaseID, @Result OUTPUT
    
  
	RETURN
	
SET NOCOUNT OFF
END



/*
go
DECLARE @abc as int
exec [dbo].[proc_VB_PRG_CalGroupResult] 123, @abc output
select @abc

*/













GO
/************************proc_VB_PRG_CalGroupResult OVER*************************/


/************************proc_VB_PRG_GetMatchInfo Start************************/GO

 
--说    明：Provide Match for program
--创 建 人：王征


--2012-09-07	Create
CREATE PROCEDURE [dbo].[proc_VB_PRG_GetMatchInfo]
(
		@MatchID		    INT,
		@LangCode			NVARCHAR(100)
)
AS
Begin
SET NOCOUNT ON 
	
	SELECT 
		  E.F_DisciplineID
		, E.F_DisciplineCode
		, A.F_EventID
		, A.F_MatchID
		, A.F_TeamARegID
		, A.F_TeamBRegID
		, B.F_Noc AS F_TeamANoc
		, C.F_Noc AS F_TeamBNoc
		, B.F_TeamNameS AS F_TeamAName
		, C.F_TeamNameS AS F_TeamBName
		, A.F_VenueDes
		, A.F_MatchDes
		, A.F_RscCode
		, D.F_IRMCodeA
		, D.F_IRMCodeB
		
		, D.F_CurSet
		, D.F_Serve
		, D.F_PtsA1
		, D.F_PtsA2
		, D.F_PtsA3
		, D.F_PtsA4
		, D.F_PtsA5
		, D.F_PtsB1
		, D.F_PtsB2
		, D.F_PtsB3
		, D.F_PtsB4
		, D.F_PtsB5
		, D.F_SetTime1
		, D.F_SetTime2
		, D.F_SetTime3
		, D.F_SetTime4
		, D.F_SetTime5
		
	FROM 
	dbo.func_VB_GetMatchInfo(@MatchID, @langCode) AS A
	
	OUTER APPLY dbo.func_VB_GetTeamNameByRegID(A.F_TeamARegID, @LangCode) AS B
	OUTER APPLY dbo.func_VB_GetTeamNameByRegID(A.F_TeamBRegID, @LangCode) AS C
	OUTER APPLY dbo.func_VB_GetMatchScoreOneRow(A.F_MatchID, @LangCode) AS D
	LEFT JOIN TS_Discipline AS E ON E.F_Active = 1
SET NOCOUNT OFF
End	


/*
go
exec [proc_VB_PRG_GetMatchInfo] 1, 'ENG'
*/


GO
/************************proc_VB_PRG_GetMatchInfo OVER*************************/


/************************proc_VB_PRG_MatchCreate Start************************/GO





















----存储过程名称：[proc_VO_CreateMatch]
----功		  能：创建MatchSplit和MatchInfo
----作		  者：王征 
----日		  期: 2010-09-20 

CREATE PROCEDURE [dbo].[proc_VB_PRG_MatchCreate]
	@MatchID				INT,
	@SetCount				INT,			--一共几局
	@DeleteBeforeCreate		INT,			--1 or 0
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	创建失败，标示没有做任何操作！
					  -- @Result=1; 	创建成功
					  -- @Result=2; 	已存在,未创建

	--先判断SplitInfo是否有此MatchID数据,如有,表示已经创建过此比赛. 根据参数决定是否删掉重新创建
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	BEGIN TRY
	
		IF @DeleteBeforeCreate > 0 
		BEGIN
			Delete from TS_Match_Split_Result where F_MatchID = @MatchID
			Delete from TS_Match_Split_Info where F_MatchID = @MatchID
		END
	
		IF EXISTS ( select * from TS_Match_Split_Info where F_MatchID = @MatchID ) 
		BEGIN
			COMMIT TRANSACTION --成功提交事务
			SET @Result = 2
			RETURN
		END	
			
		DECLARE @CurSet INT = 1
		
		WHILE( @CurSet <= @SetCount )
		BEGIN
			insert into TS_Match_Split_Info(F_MatchID, F_FatherMatchSplitID, F_MatchSplitID) values (@MatchID, 0, @CurSet)
			
			insert into TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition) 
						values(@MatchID, @CurSet, 1) -- TeamA
						
			insert into TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition) 
						values(@MatchID, @CurSet, 2) -- TeamB
						
			SET @CurSet = @CurSet + 1
		END
		
	END TRY
	BEGIN CATCH
		ROLLBACK
		SET @Result=0
		RETURN
		
	END CATCH
		
	COMMIT TRANSACTION --成功提交事务
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END






















GO
/************************proc_VB_PRG_MatchCreate OVER*************************/


/************************proc_VB_PRG_MatchSetScore Start************************/GO















----存储过程名称：[proc_VO_SetMatchScore]
----功		  能：把一场比赛的比分数据写入数据库
----作		  者：王征 
----日		  期: 2010-09-20 

--2010-12-16	在比赛未出结果时, TS_MATCH_RESULT中 F_Rank 填0，不再填NULL
--2011-02-18	计算总获胜局，总获胜分，只计算当前局之前的
--2011-03-17	添加记录修改时间功能，利用TS_Match-F_MatchCommment2
--2011-04-02	支持Point信息写入
CREATE PROCEDURE [dbo].[proc_VB_PRG_MatchSetScore]
	@MatchID				INT,
	@SetCount				INT,			--
	@CurSet					INT,			--
	@ServeTeamB				INT,			--0:A 1:B
	@PointInfo				NVARCHAR(100),	--1,2,3	文本型，第一位：PointType, 0:None 1:SetPoint 2:MatchPoint 第二位 PointTeam 0:None 1:TeamA 2:TeamB 第三位 PointCount 0:None 1~N
	@SetWinList				NVARCHAR(100),	--总的在第一位,剩下为每局的,最后一位要求也为","
	@SetTimeList			NVARCHAR(100),	--
	@SetScoreListA			NVARCHAR(100),	--3,25,14,25,25,, 数值型,保存用
	@SetScoreListB			NVARCHAR(100),	--1,23,25,3,2,,
	@SetScoreListStrA		NVARCHAR(100),	--3,25,14,25,25,, 文本型,打印报表用
	@SetScoreListStrB		NVARCHAR(100),	--1,23,25,3,2,,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result= 0; 	刷新比分时失败，标示没有做任何操作！
					  -- @Result= 1; 	操作成功
		
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	BEGIN TRY
	
		DECLARE @CycSet INT = 0 --0代表总比分,总时间,在第一位
			
		WHILE( @CycSet <= @SetCount )		
		BEGIN
		
			DECLARE @IndexSetWin	INT = CharIndex(',', @SetWinList)	
			DECLARE @IndexSetTime	INT = CharIndex(',', @SetTimeList)
			DECLARE @IndexSetA		INT = CharIndex(',', @SetScoreListA)
			DECLARE @IndexSetB		INT = CharIndex(',', @SetScoreListB)
			DECLARE @IndexSetStrA	INT = CharIndex(',', @SetScoreListStrA)
			DECLARE @IndexSetStrB	INT = CharIndex(',', @SetScoreListStrB)
	
			DECLARE @SetWin    NVARCHAR(30) = SubString(@SetWinList, 0, @IndexSetWin)
			DECLARE @SetTime   NVARCHAR(30) = SubString(@SetTimeList, 0, @IndexSetTime)
			DECLARE @SetScoreStrA NVARCHAR(30) = SubString(@SetScoreListStrA, 0, @IndexSetStrA)
			DECLARE @SetScoreStrB NVARCHAR(30) = SubString(@SetScoreListStrB, 0, @IndexSetStrB)
			
			declare @SetScoreIntA int
			declare @SetScoreIntB int
			select  @SetScoreIntA  = cast (SubString(@SetScoreListA, 0, @IndexSetA) as int )
			select  @SetScoreIntB  = cast (SubString(@SetScoreListB, 0, @IndexSetB) as int )

			Set @SetWinList = SubString(@SetWinList, @IndexSetWin+1, LEN(@SetWinList))
			Set @SetTimeList = SubString(@SetTimeList, @IndexSetTime+1, LEN(@SetTimeList))
			Set @SetScoreListA = SubString(@SetScoreListA, @IndexSetA+1, LEN(@SetScoreListA))
			Set @SetScoreListB = SubString(@SetScoreListB, @IndexSetB+1, LEN(@SetScoreListB))
			Set @SetScoreListStrA = SubString(@SetScoreListStrA, @IndexSetStrA+1, LEN(@SetScoreListStrA))
			Set @SetScoreListStrB = SubString(@SetScoreListStrB, @IndexSetStrB+1, LEN(@SetScoreListStrB))
					
					
					
			--Rank:		W:1	L:2 other:0	
			--ResultID:	W:1 L:2 other:NULL
			
			if ( @CycSet = 0 )
			BEGIN --总比分
				
				Update TS_Match_Result Set --A
				F_Points = @SetScoreIntA,
				F_PointsCharDes1 = @SetScoreStrA,
				F_Rank = CASE @SetWin WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END,
				F_ResultID = CASE @SetWin WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE NULL END,
				F_Service = CASE @ServeTeamB WHEN 0 THEN 0 ELSE 1 END
				Where F_MatchID = @MatchID and F_CompetitionPosition = 1
				
				Update TS_Match_Result Set --B
				F_Points = @SetScoreIntB,
				F_PointsCharDes1 = @SetScoreStrB,
				F_Rank = CASE @SetWin WHEN 1 THEN 2 WHEN 2 THEN 1 ELSE 0 END,
				F_ResultID = CASE @SetWin WHEN 1 THEN 2 WHEN 2 THEN 1 ELSE NULL END,
				F_Service = CASE @ServeTeamB WHEN 1 THEN 1 ELSE 0 END
				Where F_MatchID = @MatchID and F_CompetitionPosition = 2
				
				Update TS_Match Set		--公共
				F_SpendTime = @SetTime,
				F_MatchComment1 = cast(@CurSet as  nvarchar(20)) 
				Where F_MatchID = @MatchID 
				
			END
			ELSE
			BEGIN --每局比分
				
				UPDATE TS_Match_Split_Result Set --A
				F_Points = @SetScoreIntA,
				F_PointsCharDes1 = @SetScoreStrA,
				F_Rank = CASE @SetWin WHEN 1 THEN 1 WHEN 2 THEN 2 ELSE 0 END
				WHERE F_MatchID = @MatchID and F_MatchSplitID = @CycSet and F_CompetitionPosition = 1		
				
				UPDATE TS_Match_Split_Result Set --B
				F_Points = @SetScoreIntB,
				F_PointsCharDes1 = @SetScoreStrB,
				F_Rank = CASE @SetWin WHEN 1 THEN 2 WHEN 2 THEN 1 ELSE 0 END
				WHERE F_MatchID = @MatchID and F_MatchSplitID = @CycSet and F_CompetitionPosition = 2			
				
				Update TS_Match_Split_Info Set	--公共
				F_SpendTime = @SetTime
				Where F_MatchID = @MatchID and F_MatchSplitID = @CycSet 
				
			END 
			
			set @CycSet = @CycSet + 1
					
		END
		
		--总计比分,总计局胜负
		Update TS_Match_Result Set --A Win
			F_WinPoints = 
			(select SUM(F_Points) From TS_Match_Split_Result 
			Where F_MatchID = @MatchID and F_CompetitionPosition = 1 and F_MatchSplitID <= @CurSet),
			F_WinSets = 
			(Select Count(*) From TS_Match_Split_Result 
			Where F_Rank = 1 and F_MatchID = @MatchID and F_CompetitionPosition = 1 and F_MatchSplitID <= @CurSet)
		Where F_MatchID = @MatchID and F_CompetitionPosition = 1
		
		Update TS_Match_Result Set --B Win
			F_WinPoints = 
			(select SUM(F_Points) From TS_Match_Split_Result 
			Where F_MatchID = @MatchID and F_CompetitionPosition = 2 and F_MatchSplitID <= @CurSet),
			F_WinSets = 
			(Select Count(*) From TS_Match_Split_Result 
			Where F_Rank = 1 and F_MatchID = @MatchID and F_CompetitionPosition = 2 and F_MatchSplitID <= @CurSet)
		Where F_MatchID = @MatchID and F_CompetitionPosition = 2
		
		Update TS_Match_Result Set --A Lost,Draw
			F_LosePoints = (select F_WinPoints From TS_Match_Result Where F_MatchID = @MatchID and F_CompetitionPosition = 2),
			F_LoseSets   = (select F_WinSets   From TS_Match_Result Where F_MatchID = @MatchID and F_CompetitionPosition = 2)
		Where F_MatchID = @MatchID and F_CompetitionPosition = 1
		
		Update TS_Match_Result Set --B Lost,Draw
			F_LosePoints = (select F_WinPoints From TS_Match_Result Where F_MatchID = @MatchID and F_CompetitionPosition = 1),
			F_LoseSets   = (select F_WinSets   From TS_Match_Result Where F_MatchID = @MatchID and F_CompetitionPosition = 1)
		Where F_MatchID = @MatchID and F_CompetitionPosition = 2
		
		--Point Info
			DECLARE @IndexPoint	INT 
			DECLARE @PointType NVARCHAR(100)
			DECLARE @PointTeam NVARCHAR(100)
			DECLARE @PointCount NVARCHAR(100)
			
			SET @IndexPoint	 = CharIndex(',', @PointInfo)
			SET @PointType = SubString(@PointInfo, 0, @IndexPoint)
			SET @PointInfo = SubString(@PointInfo, @IndexPoint+1, LEN(@PointInfo))
			
			SET @IndexPoint	 = CharIndex(',', @PointInfo)
			SET @PointTeam = SubString(@PointInfo, 0, @IndexPoint)
			SET @PointInfo = SubString(@PointInfo, @IndexPoint+1, LEN(@PointInfo))
			
			SET @IndexPoint	 = CharIndex(',', @PointInfo)
			SET @PointCount = SubString(@PointInfo, 0, @IndexPoint)
			SET @PointInfo = SubString(@PointInfo, @IndexPoint+1, LEN(@PointInfo))
		
			UPDATE TS_Match SET
				  F_MatchComment4 = @PointType
				, F_MatchComment5 = @PointTeam
				, F_MatchComment6 = @PointCount
			WHERE F_MatchID = @MatchID
			
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION --出错回滚事务
		SET @Result = 0
		RETURN
	END CATCH

	COMMIT TRANSACTION --成功提交事务
	SET @Result = 1
	
	--设置修改时间
	UPDATE TS_Match SET F_MatchComment3 = CONVERT(NVARCHAR(100), GETDATE(), 21) WHERE F_MatchID = @MatchID
	
	RETURN

SET NOCOUNT OFF
END






















GO
/************************proc_VB_PRG_MatchSetScore OVER*************************/


/************************proc_VB_PRG_MatchStartList Start************************/GO










--参数说明： 
--说    明：
--创 建 人：王征
--日    期：2010年10月12日

--2011-03-21	Add FuncName
--2011-08-11	支持不同局的在场位置
CREATE PROCEDURE [dbo].[proc_VB_PRG_MatchStartList](
												@MatchID		    INT,
                                                @CompPos            INT,
												@LanguageCode		NVARCHAR(3),
												@SetNum				INT = 0
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
							F_RegisterID		INT,
                            F_NameS				NVARCHAR(100),
                            F_ShirtNumber		INT,
                            F_FuncID			INT,
                            F_Order				INT,
                            F_IsOnCourt			INT,
							)

	IF(@SetNum=0) 
	SET @SetNum = NULL
	
	
	INSERT INTO #Tmp_Table
	SELECT 
	  F_RegisterID
	, NULL
	, F_ShirtNumber
	, F_FuncID
	, F_Order
	, NULL
	FROM [dbo].[func_VB_GetMatchStartList](@MatchID, 0)
	WHERE F_CompPos = @CompPos

   UPDATE #Tmp_Table SET F_NameS = B.F_ShortName FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode


	--为了StartList能显示在场信息，将站位图导入，并且合并到StartList中
	DECLARE @tblOnCourt	TABLE
	(
		F_CompPos			INT,
		F_Position			INT,
		F_RegID				INT,
		F_IsSetter			INT
	)
	
	INSERT @tblOnCourt 
	SELECT F_CompPos, F_Position, F_RegID, F_IsSetter
	FROM dbo.func_VB_GetMatchStatActionList_Step2_ActionList(@MatchID, @SetNum)
	WHERE F_CompPos = @CompPos AND F_Order IS NULL
	ORDER BY F_CompPos, F_Position

	UPDATE A 
	SET F_IsOnCourt = CASE WHEN (SELECT COUNT(*) FROM @tblOnCourt WHERE F_RegID = A.F_RegisterID ) > 0 THEN 1 ELSE 0 END
	FROM #Tmp_Table AS A

  SELECT 
	F_Order
  ,	F_RegisterID
  , F_NameS
  , F_NameS + CASE F_FuncID WHEN 1 THEN '(C)' WHEN 2 THEN '(L)' ELSE '' END AS F_NameFunc
  , CASE F_FuncID WHEN 1 THEN '(C)' WHEN 2 THEN '(L)' ELSE '' END + F_NameS AS F_FuncName
  , F_ShirtNumber
  , CASE WHEN F_FuncID = 2 THEN 1 ELSE 0 END AS F_IsLibero
  , F_IsOnCourt
  FROM #Tmp_Table
  
  DELETE #Tmp_Table
  
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


/*
go
exec [proc_VB_PRG_MatchStartList] 1, 1, 'ENG'
*/









GO
/************************proc_VB_PRG_MatchStartList OVER*************************/


/************************proc_VB_PRG_StatActionAdd Start************************/GO






















----功		  能：创建一个技术统计动作
----作		  者：王征 
----日		  期: 2010-09-20 

--2011-03-02	使用ActionCode插入
--2011-03-17	添加设置修改时间功能
CREATE PROCEDURE [dbo].[proc_VB_PRG_StatActionAdd]
	@MatchID				INT,
	@CurSet					INT,			--第几局
	@CompetitionPos			INT,			--TeamA:1 TeamB:2
	@RegisterID				INT,			--选手的RegIsterID 队的就是-1
	@BeforeActionID			INT,			--0 在最后,其余表示插入在某一条之前,此条后的会自动后移
	@ActionCode				NVARCHAR(100),	--技术统计项ID
	@Result 				AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	创建失败，标示没有做任何操作！
					  -- @Result=1; 	创建成功

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	BEGIN TRY
	
		DECLARE @TmpOrder		INT
		DECLARE @TmpActionID	INT
		
		SELECT @TmpActionID = F_ActionTypeID FROM TD_ActionType WHERE F_ActionCode = @ActionCode
		
		IF @BeforeActionID = 0
		BEGIN
			Select @TmpOrder = case When MAX(F_ActionOrder) IS NULL THEN 1 ELSE MAX(F_ActionOrder)+1 End 
			From TS_Match_ActionList
			Where F_MatchID = @MatchID and F_MatchSplitID = @CurSet
		END
		ELSE
		BEGIN
			Select @TmpOrder = f_ActionOrder From TS_Match_ActionList
			Where F_MatchID = @MatchID and F_MatchSplitID = @CurSet and F_ActionNumberID = @BeforeActionID
			
			IF @TmpOrder = 0
			BEGIN
				
				ROLLBACK
				SET @Result=0
				RETURN
			END
			
			--把插入点后面的往后移动
			Update TS_Match_ActionList Set F_ActionOrder = F_ActionOrder + 1 
			Where F_MatchID = @MatchID and F_MatchSplitID = @CurSet and F_ActionOrder >= @TmpOrder
		END
	
		--插入
		Insert into TS_Match_ActionList( 
		F_ActionOrder, F_MatchID, F_MatchSplitID, F_CompetitionPosition, F_RegisterID, F_ActionTypeID)
		values(@TmpOrder, @MatchID, @CurSet, @CompetitionPos, @RegisterID, @TmpActionID)
		
	END TRY
	BEGIN CATCH
		ROLLBACK
		SET @Result=0
		RETURN
		
	END CATCH
		
	COMMIT TRANSACTION --成功提交事务
	SET @Result = 1
	
	--设置修改时间
	UPDATE TS_Match SET F_MatchComment3 = CONVERT(NVARCHAR(100), GETDATE(), 21) WHERE F_MatchID = @MatchID
	
	RETURN

SET NOCOUNT OFF
END






















GO
/************************proc_VB_PRG_StatActionAdd OVER*************************/


/************************proc_VB_PRG_StatActionGetList Start************************/GO


















--描    述：程序使用,获取技术统计列表
--参数说明：返回3个记录集，1:ActionList 2:A方站位图 3:B方站位图
--说    明：
--创 建 人：王征
--日    期：2011-01-16

--F_ActionKindID_A把Null转为0，为了程序里方便对应数组
--从TS_Match_Member 中获取人时筛选CompPos
CREATE PROCEDURE [dbo].[proc_VB_PRG_StatActionGetList](
					@MatchID		    INT,
					@CurSet				INT,
					@LangCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 
SET LANGUAGE ENGLISH


	CREATE TABLE #tblAction (

				F_Order				INT,			--序号,正常下,前7行应该是双方首发,Rally值为0
				F_IsLastRowInRally	INT,			--此行是一个Rally的最后一行，Rally信息只在此行存在
				F_RallyNum			INT,			--回合数,只在每回合最后一个动作,显示,其余为NULL
				F_RallyServe		INT,			--1: A发球 2: B发球	NULL:首发或此回合有错
				F_RallyEffect		INT,			--此回合结果, 1:A胜, 2:B胜, -1:错误   0:首发正确
				F_ScoreA_A			INT,			--此回合后,从A方技术统计推算出A的比分
				F_ScoreB_A			INT,			--此回合后,从A方技术统计推算出B的比分
				F_ScoreA_B			INT,			--此回合后,从B方技术统计推算出A的比分
				F_ScoreB_B			INT,			--此回合后,从B方技术统计推算出B的比分
				
				F_ActionNumID_A		INT,			--动作所对应的ActionNumberID,就是在TS_Match_ActionList中主键, 无动作为NULL
				F_ActionRegID_A		INT,			--产生动作的运动员ID,如果为队伍类别,为NULL
				F_ActionTypeID_A	INT,			--此动作类别,无动作为NULL
				F_ActionKindID_A	INT,			--此动作详细类别,主要为了显示颜色用, 1:未得失分 2:得分，3:失分 4:队员上场 5:队员下场 6:自由人上场 7:自由人下场 8:有错误的 NULL:空行位置
				F_ActionEffect_A	INT,			--此动作对比分的影响 -1,0,1  对于换人:NULL
				F_ActionIsError_A	INT,			--此动作是否有错，经上下文检查，发现此动作有问题,就是1,否则为NULL
					
				F_ActionNumID_B		INT,
				F_ActionRegID_B		INT,
				F_ActionTypeID_B	INT,
				F_ActionKindID_B	INT,
				F_ActionEffect_B	INT,
				F_ActionIsError_B	INT,
				
				F_CompPos			INT,
				F_Position			INT,
				F_RegID				INT,
				F_IsSetter			INT			--1:为二传手，NULL:正常
			)


	INSERT INTO #tblAction 
	SELECT * FROM func_VB_GetMatchStatActionList_step2_ActionList(@MatchID, @CurSet)

	--返回的第一个记录集，ActionList
	SELECT 
		  A.F_Order
		, F_RallyNum
		, F_IsLastRowInRally
		, A.F_rallyEffect
		, CAST(F_ScoreA_A AS NVARCHAR(10))+ '-' + CAST(F_ScoreB_A AS NVARCHAR(10)) as F_ScoreAccord_A
		, CAST(F_ScoreA_B AS NVARCHAR(10))+ '-' + CAST(F_ScoreB_B AS NVARCHAR(10)) as F_ScoreAccord_B
		, CASE WHEN F_RallyNum IS NULL OR F_RallyNum = 0 THEN NULL WHEN F_ScoreA_A = F_ScoreA_B AND F_ScoreB_A = F_ScoreB_B THEN 1 ELSE 0 END AS F_ScoreAbEquel
		, A.F_ActionNumID_A
		, A.F_ActionNumID_B
		, A.F_ActionEffect_A
		, A.F_ActionEffect_B
		, A.F_ActionIsError_A
		, A.F_ActionIsError_B
		, CASE WHEN A.F_ActionKindID_A IS NULL THEN 0 ELSE A.F_ActionKindID_A END AS F_ActionKindID_A
		, CASE WHEN A.F_ActionKindID_B IS NULL THEN 0 ELSE A.F_ActionKindID_B END AS F_ActionKindID_B
		, (SELECT F_ActionCode FROM TD_ActionType WHERE F_ActionTypeID = A.F_ActionTypeID_A) AS F_ActionCode_A
		, (SELECT F_ActionCode FROM TD_ActionType WHERE F_ActionTypeID = A.F_ActionTypeID_B) AS F_ActionCode_B
		, CASE WHEN A.F_ActionRegID_A < 0 THEN NULL ELSE ( SELECT CAST(F_ShirtNumber AS NVARCHAR(100) ) FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_RegisterID = A.F_ActionRegID_A AND F_CompetitionPosition = 1 ) END AS F_Bib_A
		, CASE WHEN A.F_ActionRegID_B < 0 THEN NULL ELSE ( SELECT CAST(F_ShirtNumber AS NVARCHAR(100) ) FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_RegisterID = A.F_ActionRegID_B AND F_CompetitionPosition = 2 ) END AS F_Bib_B
		, CASE WHEN A.F_ActionRegID_A < 0 THEN NULL ELSE ( SELECT F_ShortName FROM TR_Register_Des WHERE F_RegisterID = A.F_ActionRegID_A AND F_LanguageCode = @LangCode ) END AS F_ShortName_A
		, CASE WHEN A.F_ActionRegID_B < 0 THEN NULL ELSE ( SELECT F_ShortName FROM TR_Register_Des WHERE F_RegisterID = A.F_ActionRegID_B AND F_LanguageCode = @LangCode ) END AS F_ShortName_B
		
	FROM #tblAction AS A
	WHERE F_Order IS NOT NULL
	ORDER BY F_Order
	
	--返回的第2个记录集，TeamA站位
	SELECT F_CompPos, F_Position AS F_Position, F_RegID 
	, ( SELECT F_ShirtNumber FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_RegisterID = F_RegID AND F_CompetitionPosition = 1 ) AS F_Bib
	, ( SELECT F_ShortName FROM TR_Register_Des WHERE F_RegisterID = F_RegID AND F_LanguageCode = @LangCode ) AS F_ShortName
	FROM #tblAction
	WHERE F_Order IS NULL AND F_CompPos = 1
	ORDER BY F_CompPos, F_Position
	
	--返回的第3个记录集，TeamB站位
	SELECT F_CompPos, F_Position AS F_Position, F_RegID 
	, ( SELECT F_ShirtNumber FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_RegisterID = F_RegID AND F_CompetitionPosition = 2 ) AS F_Bib
	, ( SELECT F_ShortName FROM TR_Register_Des WHERE F_RegisterID = F_RegID AND F_LanguageCode = @LangCode ) AS F_ShortName
	FROM #tblAction
	WHERE F_Order IS NULL AND F_CompPos = 2
	ORDER BY F_CompPos, F_Position
 
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
go
exec [proc_VB_PRG_StatActionGetList] 1, 1, ENG
*/
















GO
/************************proc_VB_PRG_StatActionGetList OVER*************************/


/************************proc_VB_RPT_CompetitionSchedule Start************************/GO


----存储过程名称：[proc_vb_rpt_CompetitionSchedule]
----功		  能：一个大项目中所有比赛列表,按时间排序,按日期Group
----作		  者：王征 
----日		  期: 2010-09-20 



--2011-03-10	Add MatchDay
--2011-03-10	Eliminate 'MatchDay'
--2011-04-14	Add ',' between PhaseDes1 adn PhaseDes2
--2011-07-18	Use Competitor from desc
--2011-07-20	Don't display matches without venue
--2011-08-17	C08A,C08C,添加DateID
--2011-10-16	Fix an error about the DateID
--2011-10-17	Add some other info
--2012-08-27	For BV, add two player info

--2012-09-10	Add @EventID
CREATE PROCEDURE [dbo].[proc_VB_RPT_CompetitionSchedule]
			(
				@LangCode	NVARCHAR(100),
				@EventID	INT = NULL,
				@DateID		INT = NULL
			)
AS
BEGIN
SET NOCOUNT ON

		
		SELECT 
			  A.F_MatchID
			, B.F_RaceNum AS F_MatchRace
			, B.F_VenueDes
			, B.F_GenderCode
			, CASE WHEN T_PosA.F_RegisterID IS NOT NULL THEN T_TeamA.F_Noc ELSE T_PosA.F_PositionDes END AS F_NocA
			, CASE WHEN T_PosB.F_RegisterID IS NOT NULL THEN T_TeamB.F_Noc ELSE T_PosB.F_PositionDes END AS F_NocB
			, CASE WHEN T_PosA.F_RegisterID IS NOT NULL THEN T_TeamA.F_TeamNameS ELSE T_PosA.F_PositionDes END AS F_TeamNameSA
			, CASE WHEN T_PosB.F_RegisterID IS NOT NULL THEN T_TeamB.F_TeamNameS ELSE T_PosB.F_PositionDes END AS F_TeamNameSB
			, CASE WHEN T_PosA.F_RegisterID IS NOT NULL THEN T_TeamA.F_TeamNameL ELSE T_PosA.F_PositionDes END AS F_TeamNameLA
			, CASE WHEN T_PosB.F_RegisterID IS NOT NULL THEN T_TeamB.F_TeamNameL ELSE T_PosB.F_PositionDes END AS F_TeamNameLB
			, dbo.func_VB_GetDateTimeStr(A.F_MatchDate, 7) AS F_MatchDateDes
			, dbo.func_VB_GetDateTimeStr(A.F_MatchTime, 3) AS F_MatchTimeDes
			, B.F_PhaseDes
			, ( Select F_DisciplineDateID from TS_DisciplineDate WHERE F_Date = A.F_MatchDate ) AS F_DiscDateID
			, B.F_EventDes
			, B.F_EventID
			, dbo.func_VB_GetDateTimeStr(A.F_MatchDate, 7) + ' ' + dbo.func_VB_GetDateTimeStr(A.F_MatchTime, 3) AS F_TimeOfFirstMatch
		INTO #tblTemp
		FROM dbo.func_VB_GetMatchSchedule(NULL) AS A
		OUTER APPLY dbo.func_VB_GetMatchInfo(A.F_MatchID, @LangCode) AS B
		OUTER APPLY dbo.func_VB_GetPositionSourceInfo(A.F_MatchID, 1, @LangCode) AS T_PosA
		OUTER APPLY dbo.func_VB_GetPositionSourceInfo(A.F_MatchID, 2, @LangCode) AS T_PosB
		OUTER APPLY dbo.func_VB_GetTeamNameByRegID(T_PosA.F_RegisterID, @langCode) AS T_TeamA
		OUTER APPLY dbo.func_VB_GetTeamNameByRegID(T_PosB.F_RegisterID, @langCode) AS T_TeamB
		WHERE B.F_VenueID IS NOT NULL

		IF ( @DateID > 0 )
		DELETE FROM #tblTemp WHERE F_DiscDateID <> @DateID
		
		IF ( @EventID > 0 )
		DELETE FROM #tblTemp WHERE F_EventID <> @EventID
		
		SELECT * FROM #tblTemp

		--, ( SELECT F_Player1RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdA, @LangCode) ) AS F_PlayerA1
		--, ( SELECT F_Player2RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdA, @LangCode) ) AS F_PlayerA2
		--, ( SELECT F_Player1RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdB, @LangCode) ) AS F_PlayerB1
		--, ( SELECT F_Player2RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdB, @LangCode) ) AS F_PlayerB2
/*
		Select 
			  F_MatchID
			, F_MatchRace
			, tVenueDes.F_VenueShortName as F_VenueS
			, A.F_SexCode
			, dbo.func_VB_GetCompetitorFromDes(F_MatchID, 1, 0, 2, @LangCode) AS F_TeamA
			, dbo.func_VB_GetCompetitorFromDes(F_MatchID, 2, 0, 2, @LangCode) AS F_TeamB
			
			--, dbo.func_VB_GetDateTimeStr(F_MatchDate, 5) + ' Day' + CAST(F_MatchDay AS NVARCHAR(100)) as F_MatchDateDes
			, dbo.func_VB_GetDateTimeStr(F_MatchDate, 7) as F_MatchDateDes
			, dbo.func_VB_GetDateTimeStr(F_MatchTime, 3) as F_MatchTimeDes
			, F_PhaseDes1 + ', ' +F_PhaseDes2 as F_PhaseDes
			, ( Select F_DisciplineDateID from TS_DisciplineDate WHERE F_Date = A.F_MatchDate ) AS F_DiscDateID
			, ( SELECT F_Player1RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdA, @LangCode) ) AS F_PlayerA1
			, ( SELECT F_Player2RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdA, @LangCode) ) AS F_PlayerA2
			, ( SELECT F_Player1RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdB, @LangCode) ) AS F_PlayerB1
			, ( SELECT F_Player2RptNameS FROM dbo.func_VB_BV_GetTeamInfo(F_RegIdB, @LangCode) ) AS F_PlayerB2
		INTO #tblTemp
		FROM
		dbo.func_VB_GetMatchSchedule(NULL, @LangCode) AS A
		LEFT JOIN TC_Venue_DES AS tVenueDes ON tVenueDes.F_VenueID = a.F_VenueID AND tVenueDes.F_LanguageCode = @LangCode
		WHERE A.F_VenueID IS NOT NULL
		ORDER BY
		case when F_MatchDate IS NULL then 1 else 0 end, 
		F_MatchDate, 
		case when F_MatchTime IS NULL then 1 else 0 end, 
		F_MatchTime, 
		F_MatchRace	
		
		IF ( @DateID > 0 )
		DELETE FROM #tblTemp WHERE F_DiscDateID <> @DateID
		
		SELECT * FROM #tblTemp
*/
SET NOCOUNT OFF
END


/*
GO
exec [proc_VB_RPT_CompetitionSchedule] 'CHN', NULL, NULL
*/


GO
/************************proc_VB_RPT_CompetitionSchedule OVER*************************/


/************************proc_VB_RPT_EventMedallists Start************************/GO







--2011-10-18	为了兼容BV，添加TeamName
--2012-09-05	Recreate
CREATE PROCEDURE [dbo].[proc_VB_RPT_EventMedallists](
												@EventID		    INT,
												@OnlyNeedNoc		INT, -- 0: All Team 1:Just NOC 2:Pair
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

		SELECT 
			  A.F_DispPos
			, A.F_Rank
			, A.F_RegisterID
			, B.F_Noc
			, B.F_TeamNameS 
			, C.F_MedalShortName
		INTO #TblTemp
		FROM dbo.func_VB_GetEventRankList(@EventID) AS A
		CROSS APPLY dbo.func_VB_GetTeamNameByRegID(A.F_RegisterID, @LanguageCode) AS B
		LEFT JOIN TC_Medal_Des AS C ON A.F_MedalID = C.F_MedalID AND C.F_LanguageCode = @LanguageCode
  
    IF @OnlyNeedNoc = 1
		SELECT * FROM #TblTemp
	ELSE --For Pair & Team
		SELECT 
		  A.*
		, B.F_ShirtNumber AS F_PlayerBib
		, D.F_PrintShortName AS F_PlayerRptNameS
		, B.F_Order AS F_PlayerOrder
		FROM #TblTemp AS A
		LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID
		LEFT JOIN TR_Register AS C ON C.F_RegisterID = B.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS D ON D.F_LanguageCode = @LanguageCode AND D.F_RegisterID = B.F_MemberRegisterID
	    WHERE C.F_RegTypeID = 1
	    ORDER BY A.F_DispPos, B.F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO
/************************proc_VB_RPT_EventMedallists OVER*************************/


/************************proc_VB_RPT_GetCommonInfo Start************************/GO


----存储过程名称：[Proc_Report_SQ_GetDisciplineInfo]
----功		  能：得到Discipline公共信息
----作		  者：王征
----日		  期: 2010-09-20 

--2011-03-22	因为有时出现DiscID为空，所以直接在过程里写死 DiscID
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetCommonInfo]
             @VenueCode		NVARCHAR(100),
             @LangCode		NVARCHAR(100)
AS
BEGIN
	
SET NOCOUNT ON

	SELECT TOP 1 
	  A.F_DisciplineID AS F_DispID 
	, A.F_DisciplineCode AS F_DispCode
	, b.F_DisciplineShortName AS F_DispName
	, (SELECT TOP 1 F_VenueShortName FROM TC_Venue_Des WHERE F_LanguageCode = @LangCode AND F_VenueID IN
		(SELECT F_VenueID FROM TC_Venue WHERE F_VenueCode = @VenueCode)) AS F_VenueName
	, dbo.func_VB_GetDateTimeStr(GETDATE(), 10) AS F_CreateDate
	  FROM TS_Discipline AS A 

LEFT JOIN TS_Discipline_Des AS B ON B.F_DisciplineID = A.F_DisciplineID AND B.F_LanguageCode = @LangCode
WHERE A.F_Active = 1

Set NOCOUNT OFF
End

/*
go
exec [proc_VB_RPT_GetCommonInfo] 21, 'F20', 'ENG'
*/




GO
/************************proc_VB_RPT_GetCommonInfo OVER*************************/


/************************proc_VB_RPT_GetEntryDataCheckListCompetitors Start************************/GO







--名    称：[Proc_Report_SQ_GetCompetitorsList]
--描    述：得到Discipline下得Competitors列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月21日

--2011-04-04	增加ShirtNumber输出
--2011-04-08	ShirtNumber 从队伍里找，随便一个队伍
--2011-12-05	Add Class sport (ParaOnly)
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetEntryDataCheckListCompetitors](
												@DisciplineID		INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_DelegationID  INT,
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(100),
                                F_RegTypeID     INT,
                                F_RegDes        NVARCHAR(100),
                                F_FimalyName    NVARCHAR(100),
                                F_GivenName     NVARCHAR(100),
								F_SexCode	    INT,
								F_Gender		NVARCHAR(100),
                                F_Birth_Date    NVARCHAR(100),
                                F_Height        INT,
                                F_Weight        INT,
                                F_RegisterCode  NVARCHAR(100),
                                F_UCICode       NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(100),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(100),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(100),
                                F_WNPALN        NVARCHAR(100),
                                F_WNPASN        NVARCHAR(100),
                                F_HeightDes     NVARCHAR(100),
                                F_WeightDes     NVARCHAR(100),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100),
                                F_Events        NVARCHAR(100),
                                F_Handedness    NVARCHAR(100),
                                F_ClassSport	NVARCHAR(100),
							)

    CREATE TABLE #Tmp_Events(
                              F_Event       NVARCHAR(100)
                             )

    IF @DelegationID = -1
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, 
		
		( SELECT TOP 1 F_ShirtNumber from TR_Register_Member where F_MemberRegisterID = A.F_RegisterID ),
		A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, dbo.func_VB_GetDateTimeStr(A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID 
		LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID IN (1, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY C.F_DelegationCode, A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, 
		( SELECT TOP 1 F_ShirtNumber from TR_Register_Member where F_MemberRegisterID = A.F_RegisterID ),
		A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, dbo.func_VB_GetDateTimeStr(A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID 
		LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_DelegationID = @DelegationID AND A.F_RegTypeID IN (1, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END

    UPDATE #Tmp_Table SET F_Handedness = B.F_Comment FROM #Tmp_Table AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_Title = 'Hand'
    UPDATE #Tmp_Table SET F_ClassSport = B.F_Comment FROM #Tmp_Table AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_Title = 'Class Sport'
    
    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode
    UPDATE #Tmp_Table SET F_HeightDes = dbo.func_VB_RPT_GetHeightDes(F_Height)
    UPDATE #Tmp_Table SET F_WeightDes = dbo.func_VB_RPT_GetWeightDes(F_Weight)

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode AND F_RegTypeID = 5
    UPDATE #Tmp_Table SET F_Function = 'Athlete' WHERE F_RegTypeID = 1 AND @LanguageCode = 'ENG'
    UPDATE #Tmp_Table SET F_Function = '运动员' WHERE F_RegTypeID = 1 AND @LanguageCode = 'CHN'

    DECLARE @RegisterID INT
    DECLARE @Events NVARCHAR(100)
    DECLARE ONE_CURSOR CURSOR FOR SELECT F_RegisterID FROM #Tmp_Table WHERE F_RegTypeID = 1
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @RegisterID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		BEGIN
        DELETE FROM #Tmp_Events
        INSERT INTO #Tmp_Events (F_Event)
        SELECT C.F_EventComment FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
        LEFT JOIN TS_Event_Des AS C ON B.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
        WHERE B.F_DisciplineID = @DisciplineID AND A.F_RegisterID = @RegisterID

        INSERT INTO #Tmp_Events (F_Event)
        SELECT D.F_EventComment FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS D ON C.F_EventID = D.F_EventID AND D.F_LanguageCode = @LanguageCode
        WHERE C.F_DisciplineID = @DisciplineID AND A.F_MemberRegisterID = @RegisterID

        SET @Events = ''
        DECLARE @EventName NVARCHAR(10)
        DECLARE TWO_CURSOR CURSOR FOR SELECT F_Event FROM #Tmp_Events
		OPEN TWO_CURSOR
		FETCH NEXT FROM TWO_CURSOR INTO @EventName
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @Events = @Events + @EventName + ','
			FETCH NEXT FROM TWO_CURSOR INTO @EventName
		END
		CLOSE TWO_CURSOR
		DEALLOCATE TWO_CURSOR
		--END

        IF LEN(@Events) > 0
        SET @Events = LEFT(@Events, LEN(@Events) - 1)
        UPDATE #Tmp_Table SET F_Events = @Events WHERE F_RegisterID = @RegisterID
        
        END
        
		FETCH NEXT FROM ONE_CURSOR INTO @RegisterID
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_Bib, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_HeightDes, F_WeightDes, F_RegisterCode, F_UCICode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_Events, F_Handedness, F_ClassSport FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF









GO
/************************proc_VB_RPT_GetEntryDataCheckListCompetitors OVER*************************/


/************************proc_VB_RPT_GetEntryDataCheckListOfficials Start************************/GO







CREATE PROCEDURE [dbo].[proc_VB_RPT_GetEntryDataCheckListOfficials](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_DelegationID  INT,
                                F_RegisterID    INT,
                                F_NOC           CHAR(10) collate database_default,
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(100),
                                F_RegTypeID     INT,
                                F_RegDes        NVARCHAR(100),
                                F_FimalyName    NVARCHAR(100),
                                F_GivenName     NVARCHAR(100),
								F_SexCode	    INT,
								F_Gender		NVARCHAR(100),
                                F_Birth_Date    NVARCHAR(100),
                                F_RegisterCode  NVARCHAR(100),
                                F_ISTAFCode     NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(100),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(100),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(100),
                                F_WNPAFN        NVARCHAR(100),
                                F_WNPAGN        NVARCHAR(100),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100)
							)

    INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_RegisterCode, F_ISTAFCode, F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPAFN, F_WNPAGN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, A.F_NOC, D.F_CountryLongName, A.F_Bib, A.F_RegTypeID, B.F_LastName, B.F_FirstName, A.F_SexCode, UPPER(LEFT(CONVERT (NVARCHAR(100), A.F_Birth_Date, 113), 11)), A.F_RegisterCode, A.F_RegisterNum, B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Country_Des AS D ON A.F_NOC = D.F_NOC AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID = 4 AND A.F_DisciplineID = @DisciplineID
		

    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode

    UPDATE #Tmp_Table SET F_Birth_Date = RIGHT(F_Birth_Date, 10) WHERE LEFT(F_Birth_Date, 1) = '0' 

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode AND F_RegTypeID = 4

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_RegisterCode, F_ISTAFCode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPAFN, F_WNPAGN FROM #Tmp_Table ORDER BY F_NOC, F_SexCode, F_Function, F_FimalyName,F_GivenName

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



















GO
/************************proc_VB_RPT_GetEntryDataCheckListOfficials OVER*************************/


/************************proc_VB_RPT_GetEventInfo Start************************/GO
















----存储过程名称：[Proc_Report_SE_GetEventInfo]
----功		  能：得到当前Event信息
----作		  者：张翠霞
----日		  期: 2010-03-02 

CREATE PROCEDURE [dbo].[proc_VB_RPT_GetEventInfo]
             @EventID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Event(
		F_DisciplineName	NVARCHAR(50),
        F_VenueName         NVARCHAR(100),
        F_EventName         NVARCHAR(100),
        F_GenderCode        NVARCHAR(10),
        F_EventCode         NVARCHAR(10),
        F_DisciplineCode    NVARCHAR(2),
        F_ReportName        NVARCHAR(9),
        F_DisciplineID      INT,
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
    )

    INSERT INTO #table_Event(F_DisciplineName, F_GenderCode, F_EventCode, F_DisciplineID)
    SELECT D.F_DisciplineLongName, E.F_GenderCode, A.F_EventCode, A.F_DisciplineID FROM TS_Event AS A
    LEFT JOIN TS_Discipline_Des AS D ON A.F_DisciplineID = D.F_DisciplineID
    AND D.F_LanguageCode = @LanguageCode LEFT JOIN TC_Sex AS E ON A.F_SexCode = E.F_SexCode WHERE A.F_EventID = @EventID

    UPDATE #table_Event SET F_EventName = F_EventLongName FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode
    
    UPDATE #table_Event SET F_VenueName = UPPER(B.F_VenueShortName) FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN #table_Event AS C ON A.F_DisciplineID = C.F_DisciplineID

    UPDATE #table_Event SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Event
    AS A ON B.F_DisciplineID = A.F_DisciplineID

    UPDATE #table_Event SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000'

    UPDATE #table_Event SET F_Report_TitleDate = [dbo].[func_VB_GetDateTimeStr](GETDATE(), 4)
    UPDATE #table_Event SET F_Report_CreateDate = [dbo].[func_VB_GetDateTimeStr](GETDATE(), 1)
    
    SELECT F_DisciplineName, F_VenueName, F_EventName, F_ReportName, F_Report_TitleDate, F_Report_CreateDate FROM #table_Event

Set NOCOUNT OFF
End




















GO
/************************proc_VB_RPT_GetEventInfo OVER*************************/


/************************proc_VB_RPT_GetGroupStatics Start************************/GO


--供 C76A，C76C使用

--2011-04-14	Add ShirtDes
--2012-09-05	Edit
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetGroupStatics]
                     (
	                   @EventID     INT,
                       @LangCode	NVARCHAR(100)
                      )
AS
BEGIN
	
SET NOCOUNT ON

	SELECT 
	  A.F_PhaseID		
	, A.F_PhaseCode		
	, C.F_PhaseShortName AS F_PhaseName
	, CAST(A.F_Rank AS NVARCHAR(100)) AS F_Rank
	, CAST(A.F_GroupPoints AS NVARCHAR(100)) AS F_GroupPoints
	, CAST(A.F_MatchesCount AS NVARCHAR(100)) AS F_MatchesCount
	, CAST(A.F_MatchesWin AS NVARCHAR(100)) AS F_MatchesWin
	, CAST(A.F_MatchesLost AS NVARCHAR(100)) AS F_MatchesLost
	, CAST(A.F_PointsWin AS NVARCHAR(100)) AS F_PointsWin
	, CAST(A.F_PointsLost AS NVARCHAR(100)) AS F_PointsLost
	, CAST(A.F_PointsRadio AS NVARCHAR(100)) AS F_PointsRadio
	, CAST(A.F_SetsWin AS NVARCHAR(100)) AS F_SetsWin
	, CAST(A.F_SetsLost AS NVARCHAR(100)) AS F_SetsLost
	, CAST(A.F_SetsRadio AS NVARCHAR(100)) AS F_SetsRadio
	, CAST(A.F_DisplayPos AS NVARCHAR(100)) AS F_DisplayPos
	, A.F_RegisterID	
	, B.F_Noc AS F_Noc
	, B.F_TeamNameS AS F_TeamNameS
	, B.F_TeamNameL AS F_TeamNameL	
	, A.F_MemberCount
	, A.F_Score1
	, A.F_Score2
	, A.F_Score3
	, A.F_Score4
	, A.F_Score5
	, A.F_Score6
	FROM 
	dbo.func_VB_GetGroupStatistics(@EventID, @LangCode) AS A
	CROSS APPLY dbo.func_VB_GetTeamNameByRegID(A.F_RegisterID, @LangCode) AS B
	LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LangCode

SET NOCOUNT OFF
END
/*
go
[proc_VB_RPT_GetGroupStatics] 31, 'CHN'
*/

GO
/************************proc_VB_RPT_GetGroupStatics OVER*************************/


/************************proc_VB_RPT_GetMatchInfo Start************************/GO


--2012-09-06	Create
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetMatchInfo]
             @MatchID		INT,
             @LangCode		NVARCHAR(100)
AS
BEGIN
	
SET NOCOUNT ON
	
	SELECT * FROM dbo.func_VB_GetMatchInfo(@MatchID, @LangCode) AS A
	OUTER APPLY dbo.func_VB_GetTeamNameByRegID(A.F_TeamARegID, @LangCode) AS B
	OUTER APPLY dbo.func_VB_GetTeamNameByRegID(A.F_TeamBRegID, @LangCode) AS C
	
	
Set NOCOUNT OFF
End

/*
go
exec [proc_VB_RPT_GetMatchInfo] 1, 'ENG'
*/




GO
/************************proc_VB_RPT_GetMatchInfo OVER*************************/


/************************proc_VB_RPT_GetMatchMemberLineUp Start************************/GO
















--名    称：[PROC_VB_GetMatchMember]
--描    述：得到Match下的运动员列表 主要供C73首发名单
--参数说明： 
--说    明：
--创 建 人：王征
--日    期：2010年10月12日

--2011-07-25	强制自由人上场显示为L
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetMatchMemberLineUp](
												@MatchID		    INT,
                                                @CompPos            INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
								F_Order					INT,
                                F_RegisterID			INT,
                                F_ShirtNumber			INT,
                                F_PlayerShortName		NVARCHAR(100),
                                F_FunctionShortName		NVARCHAR(50),
                                F_TOT_SUC				INT,		--得分总数
                                F_GoingInNumSet1		NVARCHAR(10), --上场标示,可能为L,1-6，或被替换人号码
                                F_GoingInNumSet2		NVARCHAR(10), 
                                F_GoingInNumSet3		NVARCHAR(10), 
                                F_GoingInNumSet4		NVARCHAR(10), 
                                F_GoingInNumSet5		NVARCHAR(10), 
                                F_GoingInTypeSet1		INT,		-- -1:未上场 0:自由人 1:首发  2:替换别人
                                F_GoingInTypeSet2		INT,
                                F_GoingInTypeSet3		INT,
                                F_GoingInTypeSet4		INT,
                                F_GoingInTypeSet5		INT,
							)

	--插入所有属于这场比赛的队员
  INSERT INTO #Tmp_Table(F_RegisterID, F_ShirtNumber, F_Order, F_FunctionShortName )
  SELECT tMatchMember.F_RegisterID, tMatchMember.F_ShirtNumber, 
  ROW_NUMBER() over(order by F_ShirtNumber) as F_Order,
  tFuncDes.F_FunctionShortName
  FROM TS_Match_Member as tMatchMember
  left join TD_Function_Des as tFuncDes on tFuncDes.F_FunctionID = tMatchMember.F_FunctionID and tFuncDes.F_LanguageCode = @LanguageCode
  WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
  Order by F_ShirtNumber

  UPDATE #Tmp_Table SET F_PlayerShortName = B.F_PrintShortName FROM #Tmp_Table AS A 
  LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		
  
	DECLARE @TmpPlayerRegID			INT
	DECLARE ONE_COUSOR CURSOR FOR SELECT F_RegisterID
	FROM #Tmp_Table
	OPEN ONE_COUSOR
	FETCH NEXT FROM ONE_COUSOR INTO @TmpPlayerRegID
	
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			DECLARE @PlayerLineUp		INT
			DECLARE @PlayerChangeUpID	INT		
			DECLARE @PlayerChangeUpNum	NVARCHAR(100)		
			Declare @GoingInNum			NVARCHAR(100)	--首发队员号码或换人时被换下的号码
			Declare @GoingInType		INT
			Declare @Sql				NVARCHAR(999)
			
			--循环5局
			DECLARE @CycSet INT = 1		
			WHILE( @CycSet <= 5 )
			BEGIN
				Set @PlayerLineUp = dbo.func_VB_GetPositionLineUp(@MatchID, @CycSet, @CompPos, @TmpPlayerRegID)			--此人是否为首发
				Set @PlayerChangeUpID = dbo.[func_VB_GetPositionChangeUp](@MatchID, @CycSet, @CompPos, @TmpPlayerRegID) --被换下人的ID
				
				if @PlayerLineUp is not null
				begin
					if @PlayerLineUp = 0 
					begin
						--自由人
						set @GoingInNum = 'L'
						set @GoingInType = 0
					end
					else
					begin
						--首发
						set @GoingInNum = cast( @PlayerLineUp as nvarchar(10) )
						set @GoingInType = 1
					end	
				end
				else
				if @PlayerChangeUpID is not null
				begin
					--被换人
					SELECT @GoingInNum = F_ShirtNumber FROM TS_Match_Member where F_MatchID = @MatchID and F_RegisterID = @PlayerChangeUpID
					set @GoingInType = 2
				end
				else
				begin
					set @GoingInNum = null
					set @GoingInType = null
				end 
				
				set @Sql = 'Update #Tmp_Table Set ' +
				'F_GoingInNumSet'  + CAST(@CycSet as nvarchar(10)) + ' = ''' + CAST(@GoingInNum as nvarchar(20)) + ''', ' + 
				'F_GoingInTypeSet' + CAST(@CycSet as nvarchar(10)) + ' = ' + CAST(@GoingInType as nvarchar(10)) + ' ' +
				'Where F_RegisterID = ' + CAST(@TmpPlayerRegID as nvarchar(10))
				exec(@Sql)
				
				Set @CycSet = @CycSet + 1
			END
		END
		FETCH NEXT FROM ONE_COUSOR INTO @TmpPlayerRegID
	END

	CLOSE ONE_COUSOR
	DEALLOCATE ONE_COUSOR
		
	UPDATE A SET
		F_TOT_SUC = B.F_TOT_SUC
	FROM #Tmp_Table AS A
	LEFT JOIN (SELECT * FROM dbo.func_VB_GetStatMatchAthlete(@MatchID, @CompPos, DEFAULT)) AS B ON B.F_RegisterID = A.F_RegisterID
  
	--只要队员是自由人，并且上过场，无论自由人首发，还是自由人换人，都显示L，再通过GoingInType来判断
	UPDATE #Tmp_Table 
	SET F_GoingInNumSet1 = 'L' 
	WHERE F_FunctionShortName = 'L' AND F_GoingInNumSet1 IS NOT NULL
	
	UPDATE #Tmp_Table 
	SET F_GoingInNumSet2 = 'L' 
	WHERE F_FunctionShortName = 'L' AND F_GoingInNumSet2 IS NOT NULL
	
	UPDATE #Tmp_Table 
	SET F_GoingInNumSet3 = 'L' 
	WHERE F_FunctionShortName = 'L' AND F_GoingInNumSet3 IS NOT NULL
	
	UPDATE #Tmp_Table 
	SET F_GoingInNumSet4 = 'L' 
	WHERE F_FunctionShortName = 'L' AND F_GoingInNumSet4 IS NOT NULL
	
	UPDATE #Tmp_Table 
	SET F_GoingInNumSet5 = 'L' 
	WHERE F_FunctionShortName = 'L' AND F_GoingInNumSet5 IS NOT NULL
	  
    SELECT * FROM #Tmp_Table
  
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
















GO
/************************proc_VB_RPT_GetMatchMemberLineUp OVER*************************/


/************************proc_VB_RPT_GetMatchStartList Start************************/GO


















--描    述：得到Match单队的运动员列表
--参数说明： 
--说    明：
--创 建 人：王征
--日    期：2010年10月12日

--2011-03-10	修改stat部分
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetMatchStartList](
												@MatchID		    INT,
                                                @CompPos            INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
							F_RegisterID		INT,
                            F_FuncID			INT,
                            F_NamePrtLong		NVARCHAR(100),
                            F_FuncTitle			NVARCHAR(50),
                            F_ShirtNumber		INT,
                            F_Order				INT,
                            
                            F_HeightDes			NVARCHAR(100),
                            F_WeightDes			NVARCHAR(100),
                            F_BirthDateDes		NVARCHAR(100),
                            F_Spike				NVARCHAR(100),
                            F_Block				NVARCHAR(100),
                            F_ATK_SUC			NVARCHAR(100),
                            F_BLO_SUC			NVARCHAR(100),
                            F_SRV_SUC			NVARCHAR(100),
                            F_SUC_TOT			NVARCHAR(100),
                            F_PER_TEM			NVARCHAR(100),
                            F_ClassSport		NVARCHAR(100),
							)


	INSERT INTO #Tmp_Table
	SELECT 
	  F_RegisterID
	, F_FuncID
	, NULL
	, NULL
	, F_ShirtNumber
	, F_Order
	, dbo.func_VB_RPT_GetHeightDes(F_Height) as F_HeightDes
	, dbo.func_VB_RPT_GetWeightDes(F_Weight) as F_WeightDes
	, dbo.func_VB_GetDateTimeStr(F_DateOfBirth, 4) as F_BirthDateDes
	, F_SpikeHigh
	, F_BlockHigh
	, CASE WHEN F_ATK_SUC <= 0 THEN '-' ELSE CAST(F_ATK_SUC AS NVARCHAR(100)) END
	, CASE WHEN F_BLO_SUC <= 0 THEN '-' ELSE CAST(F_BLO_SUC AS NVARCHAR(100)) END
	, CASE WHEN F_SRV_SUC <= 0 THEN '-' ELSE CAST(F_SRV_SUC AS NVARCHAR(100)) END
	, CASE WHEN F_SUC_TOT <= 0 THEN '-' ELSE CAST(F_SUC_TOT AS NVARCHAR(100)) END
	, CASE WHEN F_PER_TEM <= 0 THEN '-' ELSE CAST( CAST(F_PER_TEM*100 AS Decimal(25,0)) AS NVARCHAR(100) ) END
	, (SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_RegisterID = A.F_RegisterID AND F_Title = 'Class Sport')
	FROM [dbo].[func_VB_GetMatchStartList](@MatchID, 1) AS A
	WHERE F_CompPos = @CompPos

   UPDATE #Tmp_Table SET F_NamePrtLong = B.F_PrintLongName FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	 
   UPDATE #Tmp_Table SET F_FuncTitle = B.F_FunctionShortName FROM #Tmp_Table AS A 
		LEFT JOIN TD_Function_Des AS B ON A.F_FuncID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
    
  SELECT * FROM #Tmp_Table
  
  DELETE #Tmp_Table
  
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


/*
go
exec [proc_VB_RPT_GetMatchStartList] 1, 1, 'ENG'
*/
















GO
/************************proc_VB_RPT_GetMatchStartList OVER*************************/


/************************proc_VB_RPT_GetMatchStat_Athlete_C83 Start************************/GO














----功能：单场比赛技术统计 主要供C83使用
----依靠: 依靠 func_VB_GetMatchStatAthlete 函数
----作者：王征
----日期: 2011-01-01

--2011-01-26	CAST( CAST( @RCV_RANK_VALUE*100 AS Decimal(25,2)) AS NVARCHAR(100) )
--2011-02-15	配合func_StatMatchAthlete 添加 F_Order列
--2011-02-24	配合func_StatMatchAthlete 添加 F_Function列
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetMatchStat_Athlete_C83] 
                   (	
					@MatchID			INT,
					@CompPos			INT,
					@LanguageCode       CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON
SET LANGUAGE ENGLISH

--为了提高速度,建立临时表
 CREATE TABLE  #tblStatAthlete( 
				F_TeamRegID		INT,		--
				F_RegisterID    INT,
				F_CompPos		INT,
				F_Bib			NVARCHAR(100),
				F_Function		INT,
				F_Order			INT,
				
				F_ATK_SUC		INT,		--扣球得分
				F_ATK_CNT		INT,		--扣球一般
				F_ATK_FLT		INT,		--扣球丢分
				F_ATK_TOT		INT,		--* 总数	= SUC + CNT + FLT
				F_ATK_EFF		FLOAT,		--* 扣球有效率	= SUC / TOT
				F_ATK_SUC_RANK	INT,		--* 扣球得分排名 Order by SUC
				F_ATK_SUC_DPOS	INT,				
				F_ATK_EFF_RANK	INT,		--* 扣球排名 Order by EFF
				F_ATK_EFF_DPOS	INT,
				
				F_BLO_SUC		INT,		--拦网得分
				F_BLO_CNT		INT,		--拦网过网
				F_BLO_FLT		INT,		--拦网丢分
				F_BLO_TOT		INT,		--* 扣球总数	= SUC + CNT + FLT
				F_BLO_AVG		FLOAT,		--* 扣球平均值	= SUC / Set count
				F_BLO_SUC_RANK	INT,		--* 扣球得分排名 Order by SUC
				F_BLO_SUC_DPOS	INT,
				F_BLO_AVG_RANK	INT,		--* 扣球排名 Order by AVG
				F_BLO_AVG_DPOS	INT,
				
				F_SRV_SUC		INT,		--发球得分
				F_SRV_CNT		INT,		--发球过网
				F_SRV_FLT		INT,		--发球丢分
				F_SRV_TOT		INT,		--* 发球总数	= SUC + CNT + FLT
				F_SRV_AVG		FLOAT,		--* 发球平均值	= SUC / Set count
				F_SRV_SUC_RANK	INT,		--* 发球得分排名 Order by SUC
				F_SRV_SUC_DPOS	INT,
				F_SRV_AVG_RANK	INT,		--* 发球排名 Order by AVG
				F_SRV_AVG_DPOS	INT,
				
				F_DIG_EXC		INT,		--防守好
				F_DIG_CNT		INT,		--防守一般
				F_DIG_FLT		INT,		--防守丢分
				F_DIG_TOT		INT,		--* 防守总数	= EXC + CNT + FLT
				F_DIG_AVG		FLOAT,		--* 防守平均值	= EXC / Set count
				F_DIG_AVG_RANK	INT,		--* 防守排名 Order by AVG
				F_DIG_AVG_DPOS	INT,
				
				F_SET_EXC		INT,		--二传好
				F_SET_CNT		INT,		--二传一般
				F_SET_FLT		INT,		--二传丢分
				F_SET_TOT		INT,		--* 二传总数	= EXC + CNT + FLT
				F_SET_AVG		FLOAT,		--* 二传平均值	= EXC / Set count
				F_SET_AVG_RANK	INT,		--* 二传排名 Order by AVG
				F_SET_AVG_DPOS	INT,
				
				F_RCV_EXC		INT,		--接发到位
				F_RCV_CNT		INT,		--接发一般
				F_RCV_FLT		INT,		--接发丢分
				F_RCV_TOT		INT,		--* 接发总数	= EXC + CNT + FLT
				F_RCV_SUCC		FLOAT,		--* 接发成功率	= EXC / RCV TOT
				F_RCV_SUCC_RANK	INT,		--* 接发排名 Order by SUCC
				F_RCV_SUCC_DPOS	INT,
				
				F_TOT_SUC		INT,		--* 总得分		= ATK_SUC + BLO_SUC + SRV_SUC
				F_TOT_SUC_RANK	INT,		
				F_TOT_SUC_DPOS	INT,		
				
				F_TOT_ATP		INT,		--* 总出手		= ATK_TOT + BLO_TOT + SRV_TOT
				F_TOT_ATP_RANK	INT,		
				F_TOT_ATP_DPOS	INT		
				)

	--向临时表插入数据
	INSERT INTO #tblStatAthlete 
		SELECT * FROM dbo.func_VB_GetStatMatchAthlete(@MatchID, @CompPos, DEFAULT)


	--显示排名的门限值,作为划线,显示Rank的依据
	DECLARE	@ATK_EFF_CNT	INT = 0
	DECLARE @BLO_AVG_CNT	INT = 0
	DECLARE @SRV_AVG_CNT	INT = 0
	DECLARE	@DIG_AVG_CNT	INT = 0
	DECLARE @SET_AVG_CNT	INT = 0
	DECLARE @RCV_SUCC_CNT	INT = 0
	
	--门限标准
	DECLARE @ATK_RANK_VALUE FLOAT = 0.15
	DECLARE @RCV_RANK_VALUE FLOAT = 0.25

	--计算达到门限标准的行数
	SELECT @ATK_EFF_CNT = COUNT(*) FROM #tblStatAthlete WHERE F_ATK_EFF >= @ATK_RANK_VALUE
	SELECT @BLO_AVG_CNT = COUNT(*) FROM #tblStatAthlete WHERE F_BLO_TOT > 0
	SELECT @SRV_AVG_CNT = COUNT(*) FROM #tblStatAthlete WHERE F_SRV_TOT > 0
	SELECT @DIG_AVG_CNT = COUNT(*) FROM #tblStatAthlete WHERE F_DIG_TOT > 0
	SELECT @SET_AVG_CNT = COUNT(*) FROM #tblStatAthlete WHERE F_SET_TOT > 0
	SELECT @RCV_SUCC_CNT = COUNT(*) FROM #tblStatAthlete WHERE F_RCV_SUCC >= @RCV_RANK_VALUE


	--需要返回的主语句
	SELECT 
	  A.F_CompPos, A.F_Bib
	, B.F_PrintShortName as RptNameS, B.F_PrintLongName as RptNameL
	
	--ATK
	, CAST( CAST( @ATK_RANK_VALUE*100 AS Decimal(25,2)) AS NVARCHAR(100) ) + '%' AS ATK_RANK_VALUE
	, @ATK_EFF_CNT AS ATK_RANK_CNT
	, dbo.func_VB_GetZeroValue(A.F_ATK_SUC) AS ATK_SUC
	, dbo.func_VB_GetZeroValue(A.F_ATK_CNT) AS ATK_CNT
	, dbo.func_VB_GetZeroValue(A.F_ATK_FLT) AS ATK_FLT
	, dbo.func_VB_GetZeroValue(A.F_ATK_TOT) AS ATK_TOT
	, CASE WHEN A.F_ATK_EFF_DPOS <= @ATK_EFF_CNT THEN 
		CAST( CAST( A.F_ATK_EFF*100 AS Decimal(25,2)) AS NVARCHAR(100) ) ELSE '' END AS ATK_EFF
	, CASE WHEN A.F_ATK_EFF_DPOS <= @ATK_EFF_CNT THEN
		CAST( A.F_ATK_EFF_RANK AS NVARCHAR(100) ) ELSE '' END AS ATK_RANK
	, A.F_ATK_EFF_DPOS AS ATK_DPOS
	
	--BLO
	, @BLO_AVG_CNT AS BLO_RANK_CNT
	, dbo.func_VB_GetZeroValue(A.F_BLO_SUC) AS BLO_SUC
	, dbo.func_VB_GetZeroValue(A.F_BLO_CNT) AS BLO_CNT
	, dbo.func_VB_GetZeroValue(A.F_BLO_FLT) AS BLO_FLT
	, dbo.func_VB_GetZeroValue(A.F_BLO_TOT) AS BLO_TOT
	, CASE WHEN A.F_BLO_AVG_DPOS <= @BLO_AVG_CNT THEN 
		CAST( CAST( A.F_BLO_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) ELSE '' END AS BLO_AVG
	, CASE WHEN A.F_BLO_AVG_DPOS <= @BLO_AVG_CNT THEN
		CAST( A.F_BLO_AVG_RANK AS NVARCHAR(100) ) ELSE '' END AS BLO_RANK
	, A.F_BLO_AVG_DPOS AS BLO_DPOS
	  		
	--SRV
	, @SRV_AVG_CNT AS SRV_RANK_CNT
	, dbo.func_VB_GetZeroValue(A.F_SRV_SUC) AS SRV_SUC
	, dbo.func_VB_GetZeroValue(A.F_SRV_CNT) AS SRV_CNT
	, dbo.func_VB_GetZeroValue(A.F_SRV_FLT) AS SRV_FLT
	, dbo.func_VB_GetZeroValue(A.F_SRV_TOT) AS SRV_TOT
	, CASE WHEN A.F_SRV_AVG_DPOS <= @SRV_AVG_CNT THEN 
		CAST( CAST( A.F_SRV_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) ELSE '' END AS SRV_AVG
	, CASE WHEN A.F_SRV_AVG_DPOS <= @SRV_AVG_CNT THEN
		CAST( A.F_SRV_AVG_RANK AS NVARCHAR(100) ) ELSE '' END AS SRV_RANK
	, A.F_SRV_AVG_DPOS AS SRV_DPOS
	  		 		
	--DIG
	, @DIG_AVG_CNT AS DIG_RANK_CNT
	, dbo.func_VB_GetZeroValue(A.F_DIG_EXC) AS DIG_EXC
	, dbo.func_VB_GetZeroValue(A.F_DIG_CNT) AS DIG_CNT
	, dbo.func_VB_GetZeroValue(A.F_DIG_FLT) AS DIG_FLT
	, dbo.func_VB_GetZeroValue(A.F_DIG_TOT) AS DIG_TOT
	, CASE WHEN A.F_DIG_AVG_DPOS <= @DIG_AVG_CNT THEN 
		CAST( CAST( A.F_DIG_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) ELSE '' END AS DIG_AVG
	, CASE WHEN A.F_DIG_AVG_DPOS <= @DIG_AVG_CNT THEN
		CAST( A.F_DIG_AVG_RANK AS NVARCHAR(100) ) ELSE '' END AS DIG_RANK
	, A.F_DIG_AVG_DPOS AS DIG_DPOS  		
	  		
	--SET
	, @SET_AVG_CNT AS SET_RANK_CNT
	, dbo.func_VB_GetZeroValue(A.F_SET_EXC) AS SET_EXC
	, dbo.func_VB_GetZeroValue(A.F_SET_CNT) AS SET_CNT
	, dbo.func_VB_GetZeroValue(A.F_SET_FLT) AS SET_FLT
	, dbo.func_VB_GetZeroValue(A.F_SET_TOT) AS SET_TOT
	, CASE WHEN A.F_SET_AVG_DPOS <= @SET_AVG_CNT THEN 
		CAST( CAST( A.F_SET_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) ELSE '' END AS SET_AVG
	, CASE WHEN A.F_SET_AVG_DPOS <= @SET_AVG_CNT THEN
		CAST( A.F_SET_AVG_RANK AS NVARCHAR(100) ) ELSE '' END AS SET_RANK
	, A.F_SET_AVG_DPOS AS SET_DPOS   		
	
	--RCV
	, CAST( CAST( @RCV_RANK_VALUE*100 AS Decimal(25,2)) AS NVARCHAR(100) ) + '%' AS RCV_RANK_VALUE
	, @RCV_SUCC_CNT AS RCV_RANK_CNT
	, dbo.func_VB_GetZeroValue(A.F_RCV_EXC) AS RCV_EXC
	, dbo.func_VB_GetZeroValue(A.F_RCV_CNT) AS RCV_CNT
	, dbo.func_VB_GetZeroValue(A.F_RCV_FLT) AS RCV_FLT
	, dbo.func_VB_GetZeroValue(A.F_RCV_TOT) AS RCV_TOT
	, CASE WHEN A.F_RCV_SUCC_DPOS <= @RCV_SUCC_CNT THEN 
		CAST( CAST( A.F_RCV_SUCC*100 AS Decimal(25,2)) AS NVARCHAR(100) ) ELSE '' END AS RCV_SUCC
	, CASE WHEN A.F_RCV_SUCC_DPOS <= @RCV_SUCC_CNT THEN
		CAST( A.F_RCV_SUCC_RANK AS NVARCHAR(100) ) ELSE '' END AS RCV_RANK
	, A.F_RCV_SUCC_DPOS AS RCV_DPOS   	
	  		
	FROM #tblStatAthlete AS A
	LEFT JOIN TR_REGISTER_DES AS B ON B.F_RegisterID = A.F_RegisterID and B.F_languageCode = @LanguageCode
			
        
SET NOCOUNT OFF
END

/*
go
exec proc_VB_RPT_GetMatchStat_Athlete_C83 1, 1, 'ENG'
*/






GO
/************************proc_VB_RPT_GetMatchStat_Athlete_C83 OVER*************************/


/************************proc_VB_RPT_GetMatchStat_Team_C83 Start************************/GO














----功能：单场比赛技术统计 主要供C83使用
----依靠: 依靠 func_VB_GetMatchStatTeam 函数
----作者：王征
----日期: 2011-01-01

CREATE PROCEDURE [dbo].[proc_VB_RPT_GetMatchStat_Team_C83] 
                   (	
					@MatchID			INT,
					@CompPos			INT
                   )	
AS
BEGIN
SET NOCOUNT ON
SET LANGUAGE ENGLISH

        
	SELECT

	--ATK
	  dbo.func_VB_GetZeroValue(F_ATK_SUC) AS ATK_SUC
	, dbo.func_VB_GetZeroValue(F_ATK_CNT) AS ATK_CNT
	, dbo.func_VB_GetZeroValue(F_ATK_FLT) AS ATK_FLT
	, dbo.func_VB_GetZeroValue(F_ATK_TOT) AS ATK_TOT
	, CAST( CAST(F_ATK_EFF*100 AS Decimal(25,2)) AS NVARCHAR(100) ) AS ATK_EFF

	--BLO
	, dbo.func_VB_GetZeroValue(F_BLO_SUC) AS BLO_SUC
	, dbo.func_VB_GetZeroValue(F_BLO_CNT) AS BLO_CNT
	, dbo.func_VB_GetZeroValue(F_BLO_FLT) AS BLO_FLT
	, dbo.func_VB_GetZeroValue(F_BLO_TOT) AS BLO_TOT
	, CAST( CAST(F_BLO_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) AS BLO_AVG
	
	--SRV
	, dbo.func_VB_GetZeroValue(F_SRV_SUC) AS SRV_SUC
	, dbo.func_VB_GetZeroValue(F_SRV_CNT) AS SRV_CNT
	, dbo.func_VB_GetZeroValue(F_SRV_FLT) AS SRV_FLT
	, dbo.func_VB_GetZeroValue(F_SRV_TOT) AS SRV_TOT
	, CAST( CAST(F_SRV_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) AS SRV_AVG
	
	--DIG
	, dbo.func_VB_GetZeroValue(F_DIG_EXC) AS DIG_EXC
	, dbo.func_VB_GetZeroValue(F_DIG_CNT) AS DIG_CNT
	, dbo.func_VB_GetZeroValue(F_DIG_FLT) AS DIG_FLT
	, dbo.func_VB_GetZeroValue(F_DIG_TOT) AS DIG_TOT
	, CAST( CAST(F_DIG_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) AS DIG_AVG

	--SET
	, dbo.func_VB_GetZeroValue(F_SET_EXC) AS SET_EXC
	, dbo.func_VB_GetZeroValue(F_SET_CNT) AS SET_CNT
	, dbo.func_VB_GetZeroValue(F_SET_FLT) AS SET_FLT
	, dbo.func_VB_GetZeroValue(F_SET_TOT) AS SET_TOT
	, CAST( CAST(F_SET_AVG AS Decimal(25,2)) AS NVARCHAR(100) ) AS SET_AVG
	
	--RCV
	, dbo.func_VB_GetZeroValue(F_RCV_EXC) AS RCV_EXC
	, dbo.func_VB_GetZeroValue(F_RCV_CNT) AS RCV_CNT
	, dbo.func_VB_GetZeroValue(F_RCV_FLT) AS RCV_FLT
	, dbo.func_VB_GetZeroValue(F_RCV_TOT) AS RCV_TOT
	, CAST( CAST(F_RCV_SUCC*100 AS Decimal(25,2)) AS NVARCHAR(100) ) AS RCV_SUCC
	
	--TOT
	, dbo.func_VB_GetZeroValue(F_OPP_ERR) AS OPP_ERR
	, dbo.func_VB_GetZeroValue(F_TEM_FLT) AS TEM_FLT
	
	FROM  dbo.func_VB_GetStatMatchTeam(@MatchID, @CompPos, default)       
        
SET NOCOUNT OFF
END

/*
go
exec proc_VB_RPT_GetMatchStat_Team_C83 1, 1
*/





GO
/************************proc_VB_RPT_GetMatchStat_Team_C83 OVER*************************/


/************************proc_VB_RPT_GetMatchTeamInfo Start************************/GO


--描    述：得到Match单队的运动员列表
--参数说明： 
--说    明：
--创 建 人：王征
--日    期：2010年10月12日

--2011-03-10	修改stat部分
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetMatchTeamInfo](
			@MatchID		INT,
			@CompPos        INT,
			@LangCode		NVARCHAR(100)
)
As
Begin
SET NOCOUNT ON 

	SELECT 
		  C.F_Noc AS F_NocA
		, C.F_TeamNameS AS F_TeamNameSA
		
		, D.F_Noc AS F_NocB
		, D.F_TeamNameS AS F_TeamNameSB
		
		, E.F_Noc AS F_Noc
		, E.F_TeamNameS AS F_TeamName
	FROM 
	[func_VB_GetMatchTeamInfo](@MatchID, @CompPos, @LangCode) AS A
	OUTER APPLY func_VB_GetMatchInfo(@MatchID, @LangCode) AS B
	OUTER APPLY func_vb_GetTeamNameByRegID(B.F_TeamARegID, @LangCode) AS C
	OUTER APPLY func_vb_GetTeamNameByRegID(B.F_TeamBRegID, @LangCode) AS D
	OUTER APPLY func_VB_GetTeamNameByRegID(CASE WHEN @CompPos = 1 THEN B.F_TeamARegID ELSE B.F_TeamBRegID END, @LangCode) AS E
	
	
  
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


/*
go
exec [proc_VB_RPT_GetMatchTeamInfo] 1, 1, 'CHN'
*/


GO
/************************proc_VB_RPT_GetMatchTeamInfo OVER*************************/


/************************proc_VB_RPT_GetNocListByDiscipline Start************************/GO















--描    述：得到Discipline下男女参赛国家列表, RPT C38使用
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月21日


CREATE PROCEDURE [dbo].[proc_VB_RPT_GetNocListByDiscipline](
												@DisciplineID	    INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
SELECT 

	  A.F_DelegationID 
	, C.F_DelegationShortName
	, C.F_DelegationLongName
	, D.F_RegisterID AS F_TeamRegID
	, E.F_PlayerRegId1 AS F_RegA
	, E.F_PlayerRegId2 AS F_RegB
	, E.*
FROM 
TS_ActiveDelegation AS A
INNER JOIN TS_Discipline AS B ON B.F_DisciplineID = A.F_DisciplineID AND B.F_Active = 1 
LEFT JOIN TC_Delegation_Des AS C ON C.F_DelegationID = A.F_DelegationID AND C.F_LanguageCode = 'CHN'
INNER JOIN TR_Register AS D ON D.F_DelegationID = A.F_DelegationID AND D.F_RegTypeID = 2
OUTER APPLY dbo.func_VB_BV_GetTeamMember(D.F_RegisterID) AS E
OUTER APPLY dbo.func_vb_getteam

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




GO
/************************proc_VB_RPT_GetNocListByDiscipline OVER*************************/


/************************proc_VB_RPT_GetPhaseResult Start************************/GO


----存储过程名称：[Proc_Report_SE_GetGroupResult], 供C76A, C76B使用
----功		  能：得到一个Event下一个组的比赛信息
----作		  者：Garfield Wang
----日		  期: 2010-01-03

--2010-12-30 王征修改,支持RaceNum为字母
--2011-03-04	No long Use func_VBt_RPT_GetmatchResult but Fun_GetmatchResult
--2011-03-10	RaceNum = M32
--2011-03-24	RaceNum 不带性别
--2011-04-06	Add MatchRank, PtsSet*
--2011-04-08	修改TeamName获取方式
--2011-04-12	Add ShirtDes
--2011-06-16	删除未指人的比赛
--2011-07-20	淘汰赛只显示Official之后的比赛
--2011-08-01	Match during 为0时改为''
--2011-08-12	删除不为Official的比赛
--2012-08-27	modify to CHN

CREATE PROCEDURE [dbo].[proc_VB_RPT_GetPhaseResult] 
                   (	
						@EventID		INT,
						@PoolOrTour		INT, -- 1 or 2
						@LangCode		NVARCHAR(100)		
                   )	
AS
BEGIN
SET NOCOUNT ON
		
		SELECT 
			  A.F_PhaseID AS F_PhaseID
			, D.F_PhaseShortName AS F_PhaseName
			, NULL AS F_ChartNum
			, A.F_MatchID AS F_MatchID
			, dbo.func_VB_GetDateTimeStr(B.F_MatchDate, 7) AS F_MatchDate
			, B.F_RaceNum AS F_MatchRace
			, B.F_MatchNum AS F_MatchNum
			, T_TeamNameA.F_Noc AS F_NocA
			, T_TeamNameB.F_Noc AS F_NocB
			, T_TeamNameA.F_TeamNameS AS F_TeamNameSA
			, T_TeamNameB.F_TeamNameS AS F_TeamNameSB
			, T_TeamNameA.F_TeamNameL AS F_TeamNameLA
			, T_TeamNameB.F_TeamNameL AS F_TeamNameLB
			
			, C.F_TimeTotalDes AS F_MatchDuration
			, C.F_PtsSetDes AS F_ScoreSets
			, C.F_Pts1Des AS F_ScoreSet1
			, C.F_Pts2Des AS F_ScoreSet2
			, C.F_Pts3Des AS F_ScoreSet3
			, C.F_Pts4Des AS F_ScoreSet4
			, C.F_Pts5Des AS F_ScoreSet5
			, C.F_PtsTotDes AS F_ScoreTotal
		INTO #tblTemp
		FROM dbo.func_VB_GetGroupMatch(@EventID, @PoolOrTour) AS A
		OUTER APPLY dbo.func_VB_GetMatchInfo(A.F_MatchID, @LangCode) AS B
		OUTER APPLY dbo.func_VB_GetMatchScoreOneRow(A.F_MatchID, @LangCode) AS C
		OUTER APPLY dbo.func_VB_GetTeamNameByRegID(B.F_TeamARegID, @LangCode) AS T_TeamNameA
		OUTER APPLY dbo.func_VB_GetTeamNameByRegID(B.F_TeamBRegID, @LangCode) AS T_TeamNameB		
		LEFT JOIN TS_Phase_Des AS D ON D.F_LanguageCode = @LangCode AND D.F_PhaseID = A.F_PhaseID
		
		
		--Delete matches the competitor is null or -1
		DELETE #tblTemp 
		WHERE F_NocA IS NULL OR F_NocB IS NULL
		
		--比赛时间不为0
		UPDATE #tblTemp SET F_MatchDuration = '' WHERE F_MatchDuration = '0'	

		--如果是淘汰赛，将F_PhaseID变为ChartNum，就是第几个金字塔，从MatchNum判断
		IF (@PoolOrTour = 2)
			UPDATE #tblTemp SET F_ChartNum = F_MatchNum / 100
		
		--Output
		SELECT * FROM #tblTemp
		
/*
        CREATE TABLE #Temp_table(
                                   F_PhaseID		INT,
                                   F_PhaseName		NVARCHAR(100),
                                   F_MatchID		INT,
                                   F_MatchStatusID	INT,                                   
                                   F_Date			NVARCHAR(100),
                                   F_StartTime		NVARCHAR(100),
                                   F_RaceNum		NVARCHAR(100),
                                   F_MatchNum		NVARCHAR(100),
                                   F_TeamNameA		NVARCHAR(100),
                                   F_NocA			NVARCHAR(100),
                                   F_TeamNameB		NVARCHAR(100),
                                   F_NocB			NVARCHAR(100),
                                   F_Sets			NVARCHAR(100),
                                   F_PtsTotal		NVARCHAR(100),
                                   F_PtsDetailed	NVARCHAR(100),
                                   F_MatchDuration	NVARCHAR(100),
                                   F_Spectators		NVARCHAR(100),
                                   F_MatchRank		INT,			--最后比赛结果
                                   F_ShirtDesA		NVARCHAR(100),
                                   F_ShirtDesB		NVARCHAR(100),
                                   F_PtsSet1		NVARCHAR(100),
                                   F_PtsSet2		NVARCHAR(100),
                                   F_PtsSet3		NVARCHAR(100),
                                   F_PtsSet4		NVARCHAR(100),
                                   F_PtsSet5		NVARCHAR(100)
                                )

        INSERT INTO #Temp_Table(F_PhaseID, F_MatchID, F_MatchStatusID, F_Date, F_StartTime, F_PhaseName, F_RaceNum, F_MatchNum, 
					F_TeamNameA, F_NocA, F_TeamNameB, F_NocB, F_Sets, F_MatchDuration, F_PtsDetailed, F_Spectators)
        SELECT A.F_PhaseID, A.F_MatchID, A.F_MatchStatusID,
			[dbo].[func_VB_GetDateTimeStr](A.F_MatchDate, 7), 
			[dbo].[func_VB_GetDateTimeStr](A.F_StartTime, 3), 
			C.F_PhaseShortName, 
			--(SELECT F_GenderCode FROM TC_Sex WHERE F_SexCode = D.F_SexCode) + A.F_RaceNum,
			A.F_RaceNum,
			A.F_MatchNum
			,(SELECT dbo.func_VB_GetTeamNameFromRegID(F_RegisterID, @LangCode) FROM TS_Match_Result AS X 
				WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
			,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X 
				LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID 
				LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID 
			WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
			,(SELECT dbo.func_VB_GetTeamNameFromRegID(F_RegisterID, @LangCode) FROM TS_Match_Result AS X 
				WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
			,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X 
				LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID 
				LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID 
				WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        
			,[dbo].[func_VB_RPT_GetMatchResultIRM](A.F_MatchID)
			,[dbo].[func_VB_GetFormatTimeStr](A.F_SpendTime*60, 1, @LangCode)
			,dbo.fun_GetMatchResultDes(A.F_MatchID)
			,F_MatchComment2
        FROM TS_Match AS A 
			LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
			LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LangCode
			LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
			LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LangCode
        WHERE D.F_EventID = @EventID AND 
        (	--相当于当@PoolOrTour=1时,只要IsPool=1的值，当@PoolOrTour=2时,只要IsPool<>1的值
			( @PoolOrTour = 1 AND B.F_PhaseIsPool = 1 )
			OR
			( @PoolOrTour = 2 AND B.F_PhaseIsPool = 0 AND F_MatchNum > 100 )
		)
        ORDER BY B.F_Order, A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), 
		--如果能转换成INT,就按INT排序
		CASE WHEN ISNUMERIC(A.F_RaceNum) = 1 THEN 
			CAST(A.F_RaceNum AS INT)
		ELSE
			0
		END
		
		
		
		
--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
		
		--删除未指定人的比赛
		DELETE FROM #Temp_Table WHERE F_NocA IS NULL OR F_NocB IS NULL
	
	
		--Delete the matches which is not official
		DELETE FROM #Temp_table WHERE F_MatchStatusID < 110
	
		--比赛时间不为0
		UPDATE #Temp_table SET F_MatchDuration = '' WHERE F_MatchDuration = '0'	

		--继续UPDATE比分
		UPDATE A SET
		    F_PtsTotal = (SELECT CAST(F_PtsTotA AS NVARCHAR(10))+ ' - ' + CAST(F_PtsTotB AS NVARCHAR(10)) FROM dbo.func_VB_GetMatchScoreOneRow(A.F_MatchID, @LangCode))
		FROM #Temp_table AS A
		
		--如果是淘汰赛，将F_PhaseID变为ChartNum，就是第几个金字塔，从MatchNum判断
		IF (@PoolOrTour = 2)
		BEGIN
			UPDATE #Temp_table SET F_PhaseID = 1 WHERE F_MatchNum > 100 AND F_MatchNum < 200
			UPDATE #Temp_table SET F_PhaseID = 2 WHERE F_MatchNum > 200 AND F_MatchNum < 300
			UPDATE #Temp_table SET F_PhaseID = 3 WHERE F_MatchNum > 300 AND F_MatchNum < 400
		END
		
		UPDATE #Temp_table SET 
		  F_MatchRank = (SELECT F_Rank FROM dbo.func_VB_GetMatchInfo(F_MatchID, 'ENG'))
		, F_PtsSet1 = ( SELECT CASE WHEN F_PtsA1 IS NOT NULL AND F_PtsB1 IS NOT NULL THEN F_PtsA1Des + '-' + F_PtsB1Des ELSE '' END FROM dbo.func_VB_GetMatchScoreOneRow(F_MatchID, @LangCode) )
		, F_PtsSet2 = ( SELECT CASE WHEN F_PtsA2 IS NOT NULL AND F_PtsB2 IS NOT NULL THEN F_PtsA2Des + '-' + F_PtsB2Des ELSE '' END FROM dbo.func_VB_GetMatchScoreOneRow(F_MatchID, @LangCode) )
		, F_PtsSet3 = ( SELECT CASE WHEN F_PtsA3 IS NOT NULL AND F_PtsB3 IS NOT NULL THEN F_PtsA3Des + '-' + F_PtsB3Des ELSE '' END FROM dbo.func_VB_GetMatchScoreOneRow(F_MatchID, @LangCode) )
		, F_PtsSet4 = ( SELECT CASE WHEN F_PtsA4 IS NOT NULL AND F_PtsB4 IS NOT NULL THEN F_PtsA4Des + '-' + F_PtsB4Des ELSE '' END FROM dbo.func_VB_GetMatchScoreOneRow(F_MatchID, @LangCode) )
		, F_PtsSet5 = ( SELECT CASE WHEN F_PtsA5 IS NOT NULL AND F_PtsB5 IS NOT NULL THEN F_PtsA5Des + '-' + F_PtsB5Des ELSE '' END FROM dbo.func_VB_GetMatchScoreOneRow(F_MatchID, @LangCode) )
		
			
		
		UPDATE A SET
			  F_ShirtDesA = ( SELECT F_UniformColor FROM dbo.func_VB_GetMatchTeamInfo(A.F_MatchID, 1, @LangCode ) )
			, F_ShirtDesB = ( SELECT F_UniformColor FROM dbo.func_VB_GetMatchTeamInfo(A.F_MatchID, 2, @LangCode ) )
		FROM #Temp_table AS A
		
		IF (@PoolOrTour = 1)
		BEGIN
			SELECT * FROM #Temp_Table
		END
		ELSE
		BEGIN
			SELECT * FROM #Temp_table WHERE F_MatchNum > 100 AND F_MatchStatusID >= 110
			ORDER BY F_PhaseID, F_MatchNum
		END
		
		
		*/
		

		
SET NOCOUNT OFF
END

/*
go
exec [proc_VB_RPT_GetPhaseResult] 31, 1, 'CHN'
*/


GO
/************************proc_VB_RPT_GetPhaseResult OVER*************************/


/************************Proc_VB_RPT_GetPictures Start************************/GO



--VB自己整理一下，默认为Active的Discipline

--2011-12-05 Create
create PROCEDURE [dbo].[Proc_VB_RPT_GetPictures]
	@DiscCode	CHAR(2) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @DiscCode IS NULL
		Select TOP 1 @DiscCode = F_DisciplineCode from TS_Discipline WHERE F_Active = 1
	
	exec dbo.Proc_Report_GetPictures @DiscCode

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_GetPictures] 'RO'

*/

GO
/************************Proc_VB_RPT_GetPictures OVER*************************/


/************************proc_VB_RPT_GetRSCCode Start************************/GO















--生成报表RSCCode用
--2011-02-24	整体从GF拷贝
--2011-03-10	根据VB项目，写了一个
--2011-03-20	将GenderCode提到EventCode之前
--2011-04-19	添加列名
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetRSCCode]
	@DisciplineID INT = -1,
	@EventID	  INT = -1,
	@PhaseID	  INT = -1,			
	@MatchID	  INT = -1,
	@DateID		  INT = -1,
	@DelegationID INT = -1,
	@ReportType   NVARCHAR(10) = 'NONE'
AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH

	SELECT dbo.func_VB_GetRscCode(@EventID, @PhaseID, @MatchID) AS F_RscCode

SET NOCOUNT OFF
END

/*
go
exec proc_VB_RPT_GetRSCCode DEFAULT, DEFAULT, 14, 21, DEFAULT, DEFAULT
*/















GO
/************************proc_VB_RPT_GetRSCCode OVER*************************/


/************************proc_VB_RPT_GetTeamMember Start************************/GO


----功		  能：供TeamRoster使用

--2011-03-08	创建
--2011-08-08	Add Print long name
--2011-12-05	Add ClassSport (ParaOnly)
--2012-08-27	modify to chn
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetTeamMember]
             @TeamRegID         INT,
             @LangCode		    NVARCHAR(100)
AS
BEGIN
	
SET NOCOUNT ON
SET LANGUAGE ENGLISH

	SELECT 
		  A.F_Order
		, A.F_ShirtNumber
		, (SELECT F_FunctionShortName FROM TD_Function_Des WHERE TD_Function_Des.F_FunctionID = A.F_FunctionID AND TD_Function_Des.F_LanguageCode = @LangCode) AS F_FuncTitle
		, (SELECT F_PrintShortName FROM TR_Register_Des WHERE F_RegisterID = B.F_RegisterID AND F_LanguageCode = @LangCode ) AS F_PrtNameS
		, (SELECT F_PrintLongName FROM TR_Register_Des WHERE F_RegisterID = B.F_RegisterID AND F_LanguageCode = @LangCode ) AS F_PrtNameL
		, dbo.func_VB_GetDateTimeStr(F_Birth_Date, 7) AS F_BirthDay
		, dbo.func_VB_GetHeightDes(F_Height, 2) AS F_HeightDes
		, dbo.func_VB_GetWeightDes(F_Weight, 2) AS F_WeightDes
		,( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Spike' AND F_RegisterID = B.F_RegisterID ) AS F_SpikeHigh
		,( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Block' AND F_RegisterID = B.F_RegisterID ) AS F_BlockHigh
		,( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Class Sport' AND F_RegisterID = B.F_RegisterID ) AS F_ClassSport
	FROM TR_Register_Member AS A
	INNER JOIN TR_Register AS B ON b.F_RegisterID = A.F_MemberRegisterID AND B.F_RegTypeID = 1
	WHERE A.F_RegisterID = @TeamRegID

SET NOCOUNT OFF
END

/*
go
[proc_VB_RPT_GetTeamMember] 1, 'CHN'
*/


GO
/************************proc_VB_RPT_GetTeamMember OVER*************************/


/************************proc_VB_RPT_GetTeamUniformsInPhase Start************************/GO








--供 C76A，C76C使用
--应该只供C08B使用
--2011-04-17	Created
--2011-08-16	显示同PhaseCode的所有比赛的衣服
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetTeamUniformsInPhase]
                     (
	                   @PhaseID		INT,
                       @LangCode	CHAR(3)
                      )
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @Tbl TABLE (
			F_TeamRegID			INT,
			F_TeamRptName		NVARCHAR(100),
			ShirtDes1			NVARCHAR(100),
			ShirtDes2			NVARCHAR(100),
			ShirtDes3			NVARCHAR(100)
		)
	
	--插入此Phase中所有比赛的参赛队	
	------------
	
	IF ( (SELECT F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID) = 2 ) --小组赛类型为2
	BEGIN
		INSERT INTO @Tbl(F_TeamRegID)
		SELECT DISTINCT F_RegisterID FROM TS_Match_Result WHERE F_MatchID 
		IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID )		
		
		
	END
	ELSE
	BEGIN		
		INSERT INTO @Tbl(F_TeamRegID)
		SELECT DISTINCT F_RegisterID FROM TS_Match_Result WHERE F_MatchID 
		IN 
		(
			SELECT F_MatchID FROM TS_Match WHERE F_PhaseID 
			IN
			(
				SELECT A.F_PhaseID FROM TS_Phase AS A 
				INNER JOIN TS_Phase AS B ON A.F_PhaseCode = B.F_PhaseCode AND A.F_EventID = B.F_EventID AND B.F_PhaseID = @PhaseID
			)
		)
	END
	
	--把这些参赛队所有球衣颜色都添加进去 Order1
	UPDATE A SET 
		  F_TeamRptName = dbo.func_VB_GetTeamNameFromRegID(A.F_TeamRegID, @LangCode)
		, ShirtDes1 = ( SELECT F_ColorShortName FROM TC_Color_Des 
						WHERE F_LanguageCode = @LangCode AND F_ColorID = 
						( SELECT F_Shirt FROM TR_Uniform WHERE F_RegisterID = A.F_TeamRegID AND F_Order = 1 ) )
	FROM @Tbl AS A 
		
	--把这些参赛队所有球衣颜色都添加进去 Order2
	UPDATE A SET 
		  F_TeamRptName = dbo.func_VB_GetTeamNameFromRegID(A.F_TeamRegID, @LangCode)
		, ShirtDes2 = ( SELECT F_ColorShortName FROM TC_Color_Des 
						WHERE F_LanguageCode = @LangCode AND F_ColorID = 
						( SELECT F_Shirt FROM TR_Uniform WHERE F_RegisterID = A.F_TeamRegID AND F_Order = 2 ) )
	FROM @Tbl AS A 
		
	--把这些参赛队所有球衣颜色都添加进去 Order3
	UPDATE A SET 
		  F_TeamRptName = dbo.func_VB_GetTeamNameFromRegID(A.F_TeamRegID, @LangCode)
		, ShirtDes3 = ( SELECT F_ColorShortName FROM TC_Color_Des 
						WHERE F_LanguageCode = @LangCode AND F_ColorID = 
						( SELECT F_Shirt FROM TR_Uniform WHERE F_RegisterID = A.F_TeamRegID AND F_Order = 3 ) )
	FROM @Tbl AS A 
	

	
	--输出结果
	SELECT * FROM @Tbl
	
SET NOCOUNT OFF
END








GO
/************************proc_VB_RPT_GetTeamUniformsInPhase OVER*************************/


/************************proc_VB_RPT_GetTournamentChart Start************************/GO


--2011-06-13	Created
--2011-10-14	Add more info
--2012-09-04	Add RankTitle
--2012-09-06	Rearrange
--2012-09-12	accord to VO & BV, output NOC & TeamName
CREATE PROCEDURE [dbo].[proc_VB_RPT_GetTournamentChart]
             @EventID		INT,
             @ChartNum		INT,
             @LangCode		CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @StrRank NVARCHAR(100)
	IF @LangCode = 'CHN'
	BEGIN
		SET @StrRank = '名次'
	END
	ELSE
	BEGIN
		SET @StrRank = 'Rank'
	END
	
	--通过MatchID把所有所需信息以行存在临时表中
	DECLARE @TmpTable TABLE
	(
		F_ChartNum		INT,
		F_MatchPos		INT,			--1
		F_NocA			NVARCHAR(100),	--CHN
		F_NocB			NVARCHAR(100),	--CAD
		F_RaceDes		NVARCHAR(100),	--第41场 
		F_WinnerDes		NVARCHAR(100),	--河北(3:1)
		F_RankTitle		NVARCHAR(100),
		F_RankNoc		NVARCHAR(100)
	)
	
	INSERT INTO @TmpTable
	SELECT 
		  @ChartNum
		, A.F_MatchPos	
		, CASE WHEN G.F_DisciplineCode = 'BV' THEN D.F_TeamNameL ELSE D.F_Noc END
		, CASE WHEN G.F_DisciplineCode = 'BV' THEN E.F_TeamNameL ELSE E.F_Noc END
		, 'M' + B.F_RaceNum
		, CASE 
			WHEN C.F_RankTot = 1 THEN (CASE WHEN G.F_DisciplineCode = 'BV' THEN D.F_TeamNameL ELSE D.F_Noc END) + ' ' + C.F_PtsASetDes + ':' + F_PtsBSetDes + '' 
			WHEN C.F_RankTot = 2 THEN (CASE WHEN G.F_DisciplineCode = 'BV' THEN E.F_TeamNameL ELSE E.F_Noc END) + ' ' + C.F_PtsBSetDes + ':' + F_PtsASetDes + '' 
			ELSE NULL 
		  END
		, @StrRank + CAST(A.F_Rank AS NVARCHAR(100))
		, CASE WHEN G.F_DisciplineCode = 'BV' THEN F.F_TeamNameL ELSE F.F_Noc END
	FROM dbo.func_VB_GetTournamentChart(@EventID) AS A
	OUTER APPLY dbo.func_VB_GetMatchInfo(A.F_MatchID, @LangCode) AS B 
	OUTER APPLY dbo.func_VB_GetMatchScoreOneRow(A.F_MatchID,   @LangCode) AS C
	OUTER APPLY dbo.func_vb_getTeamNameByRegID(B.F_TeamARegID, @LangCode) AS D
	OUTER APPLY dbo.func_vb_getTeamNameByRegID(B.F_TeamBRegID, @LangCode) AS E
	OUTER APPLY dbo.func_vb_getTeamNameByRegID(A.F_RankRegID,  @LangCode) AS F
	OUTER APPLY dbo.func_VB_GetEventInfo(@EventID, @LangCode) AS G
	WHERE A.F_ChartNum = @ChartNum
	
	--select * from @TmpTable

	--把多行变为1行	
	SELECT
		  (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 1 ) AS F_NocA_1
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 1 ) AS F_NocB_1
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 1 ) AS F_RaceDes_1
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 1 ) AS F_WinnerDes_1
	
		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 2 ) AS F_NocA_2
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 2 ) AS F_NocB_2	
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 2 ) AS F_RaceDes_2
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 2 ) AS F_WinnerDes_2	

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 3 ) AS F_NocA_3
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 3 ) AS F_NocB_3			
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 3 ) AS F_RaceDes_3
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 3 ) AS F_WinnerDes_3	

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 4 ) AS F_NocA_4
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 4 ) AS F_NocB_4				
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 4 ) AS F_RaceDes_4
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 4 ) AS F_WinnerDes_4

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 5 ) AS F_NocA_5
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 5 ) AS F_NocB_5				
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 5 ) AS F_RaceDes_5
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 5 ) AS F_WinnerDes_5	

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 6 ) AS F_NocA_6
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 6 ) AS F_NocB_6				
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 6 ) AS F_RaceDes_6
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 6 ) AS F_WinnerDes_6		

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 7 ) AS F_NocA_7
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 7 ) AS F_NocB_7				
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 7 ) AS F_RaceDes_7
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 7 ) AS F_WinnerDes_7	

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 8 ) AS F_NocA_8
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 8 ) AS F_NocB_8				
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 8 ) AS F_RaceDes_8
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 8 ) AS F_WinnerDes_8	

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 9 ) AS F_NocA_9
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 9 ) AS F_NocB_9				
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos = 9 ) AS F_RaceDes_9
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos = 9 ) AS F_WinnerDes_9

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 10 ) AS F_NocA_10
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 10 ) AS F_NocB_10			
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos =10 ) AS F_RaceDes_10
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos =10 ) AS F_WinnerDes_10	

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 11 ) AS F_NocA_11
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 11 ) AS F_NocB_11			
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos =11 ) AS F_RaceDes_11
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos =11 ) AS F_WinnerDes_11		

		, (SELECT F_NocA FROM @TmpTable WHERE F_MatchPos = 12 ) AS F_NocA_12
		, (SELECT F_NocB FROM @TmpTable WHERE F_MatchPos = 12 ) AS F_NocB_12			
		, (SELECT F_RaceDes	  FROM @TmpTable WHERE F_MatchPos =12 ) AS F_RaceDes_12
		, (SELECT F_WinnerDes FROM @TmpTable WHERE F_MatchPos =12 ) AS F_WinnerDes_12		
			
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  1) AS F_RankTitle_1
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  2) AS F_RankTitle_2
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  3) AS F_RankTitle_3
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  4) AS F_RankTitle_4
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  5) AS F_RankTitle_5
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  6) AS F_RankTitle_6
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  7) AS F_RankTitle_7
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  8) AS F_RankTitle_8
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos =  9) AS F_RankTitle_9
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos = 10) AS F_RankTitle_10
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos = 11) AS F_RankTitle_11
		, (SELECT F_RankTitle FROM @TmpTable WHERE F_MatchPos = 12) AS F_RankTitle_12
		
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  1) AS F_RankNoc_1
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  2) AS F_RankNoc_2
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  3) AS F_RankNoc_3
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  4) AS F_RankNoc_4
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  5) AS F_RankNoc_5
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  6) AS F_RankNoc_6
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  7) AS F_RankNoc_7
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  8) AS F_RankNoc_8
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos =  9) AS F_RankNoc_9
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos = 10) AS F_RankNoc_10
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos = 11) AS F_RankNoc_11
		, (SELECT F_RankNoc FROM @TmpTable WHERE F_MatchPos = 12) AS F_RankNoc_12
			
SET NOCOUNT OFF
END

/*
go
[proc_VB_RPT_GetTournamentChart] 31, 1, 'ENG'
*/


GO
/************************proc_VB_RPT_GetTournamentChart OVER*************************/


/************************proc_VB_RPT_NumberOfEntries Start************************/GO







--显示每个国家报名人数	C30

--2011-10-18	Created
CREATE PROCEDURE [dbo].[proc_VB_RPT_NumberOfEntries]
		(
				@LangCode	CHAR(3)
		)
AS
BEGIN
SET NOCOUNT ON
		
	SELECT 
		  (SELECT F_DelegationCode FROM TC_Delegation WHERE F_DelegationID = A.F_DelegationID) AS F_Noc
		, (SELECT F_DelegationShortName FROM TC_Delegation_Des WHERE F_DelegationID = A.F_DelegationID AND F_LanguageCode = @LangCode ) AS F_NocDes
		, (SELECT COUNT(*) FROM TR_Register WHERE F_DelegationID = A.F_DelegationID AND F_SexCode = 1 AND F_RegTypeID = 3) AS F_TeamMenCntInNoc  
		, (SELECT COUNT(*) FROM TR_Register WHERE F_DelegationID = A.F_DelegationID AND F_SexCode = 2 AND F_RegTypeID = 3) AS F_TeamWomenCntInNoc  
		, (SELECT COUNT(*) FROM TR_Register WHERE F_DelegationID = A.F_DelegationID AND F_RegTypeID = 3) AS F_TeamCntInNoc
		, (SELECT COUNT(*) FROM TR_Register WHERE F_DelegationID = A.F_DelegationID AND F_SexCode = 1 AND F_RegTypeID = 1) AS F_AthleteMenCntInNoc  
		, (SELECT COUNT(*) FROM TR_Register WHERE F_DelegationID = A.F_DelegationID AND F_SexCode = 2 AND F_RegTypeID = 1) AS F_AthleteWomenCntInNoc
		, (SELECT COUNT(*) FROM TR_Register WHERE F_DelegationID = A.F_DelegationID AND F_RegTypeID = 1) AS F_AthleteCntInNoc
	
	INTO #Tbl
	FROM TS_ActiveDelegation AS A
	WHERE F_DisciplineID  = (SELECT F_DisciplineID FROM TS_Discipline WHERE F_Active = 1) -- 只要当前项目的
	ORDER BY F_Noc
	
	--生成总计行
	SELECT 
		  *
		, (SELECt COUNT(*) FROM #Tbl ) AS F_NocCnt
		, (SELECT SUM(F_TeamMenCntInNoc) FROM #Tbl ) AS F_TeamMenCnt
		, (SELECT SUM(F_TeamWomenCntInNoc) FROM #Tbl ) AS F_TeamWomenCnt
		, (SELECT SUM(F_TeamCntInNoc) FROM #Tbl ) AS F_TeamCnt
		, (SELECT SUM(F_AthleteMenCntInNoc) FROM #Tbl ) AS F_AthleteMenCnt
		, (SELECT SUM(F_AthleteWomenCntInNoc) FROM #Tbl ) AS F_AthleteWomenCnt
		, (SELECT SUM(F_AthleteCntInNoc) FROM #Tbl ) AS F_AthleteCnt
	
	FROM #Tbl



SET NOCOUNT OFF
END


/*
GO
exec[proc_VB_RPT_NumberOfEntries] 'ENG'
*/







GO
/************************proc_VB_RPT_NumberOfEntries OVER*************************/


/************************proc_VB_RPT_TeamRosterInfo Start************************/GO








----功		  能：供TeamRoster使用

--2011-03-08	创建
--2011-03-10	Add CoachStat
--2011-04-04	Add Statistican2 and Trainer
--2011-04-08	修改TeamName获取方式
--2011-06-09	修正服装后面得逗号
--2011-08-08	如果没有服装，也输出空行
CREATE PROCEDURE [dbo].[proc_VB_RPT_TeamRosterInfo]
             @TeamRegID         INT,
             @LangCode		    CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON
SET LANGUAGE ENGLISH

    CREATE TABLE #Result(
		F_EventID				INT,
		F_EventNameENG			NVARCHAR(100),
		F_EventNameCHN			NVARCHAR(100),
		F_EventName				NVARCHAR(100),
		F_TeamNOC				NVARCHAR(100),
		F_TeamName				NVARCHAR(100),
		F_Coach1PrtNameS		NVARCHAR(100),
		F_Coach2PrtNameS		NVARCHAR(100),
		F_CoachStat1PrtNameS	NVARCHAR(100),
		F_CoachStat2PrtNameS	NVARCHAR(100),
		F_CoachTrainerPrtNameS	NVARCHAR(100),
		F_ShirtOrder			INT,
		F_ShirtDes				NVARCHAR(100),
		F_ShortDes				NVARCHAR(100),
		F_SocksDes				NVARCHAR(100),
		F_ShirtString			NVARCHAR(100),	--颜色列表
		F_ShortString			NVARCHAR(100)
    )
    
	INSERT INTO #Result(F_ShirtOrder, F_ShirtDes, F_ShortDes, F_SocksDes)
	SELECT 
	  F_Order AS F_ShirtColorOrder
	, (SELECT F_ColorShortName FROM TC_Color_Des WHERE F_ColorID = F_Shirt AND F_LanguageCode = @LangCode) AS F_ShirtColorDes
	, (SELECT F_ColorShortName FROM TC_Color_Des WHERE F_ColorID = F_Shorts AND F_LanguageCode = @LangCode) AS F_ShortDes
	, (SELECT F_ColorShortName FROM TC_Color_Des WHERE F_ColorID = F_Socks AND F_LanguageCode = @LangCode) AS F_SocksDes
	FROM TR_Uniform WHERE F_RegisterID = @TeamRegID ORDER BY F_Order
	
	--如果没有服装，就添加空行
	IF ( (SELECT COUNT(*) FROM #Result ) = 0 )
	INSERT INTO #Result(F_ShirtOrder) VALUES(NULL)
	
	
	UPDATE #Result 
	SET F_EventID = (SELECT F_EventID FROM TR_Inscription WHERE F_RegisterID = @TeamRegID)
	
	UPDATE A SET
	  F_EventName = (SELECT F_EventShortName FROM TS_Event_Des WHERE F_EventID = A.F_EventID AND F_LanguageCode = @LangCode)
	, F_EventNameENG = (SELECT F_EventShortName FROM TS_Event_Des WHERE F_EventID = A.F_EventID AND F_LanguageCode = 'ENG')
	, F_EventNameCHN = (SELECT F_EventShortName FROM TS_Event_Des WHERE F_EventID = A.F_EventID AND F_LanguageCode = 'CHN')
	FROM #Result AS A
	 
	UPDATE A SET
		  A.F_TeamNOC = B.F_Noc
		, A.F_TeamName = B.F_TeamNameS
	FROM #Result AS A
	CROSS APPLY dbo.func_vb_GetTeamNameByRegID(@TeamRegID, @LangCode) AS B
	 
    --获取主教练
    UPDATE #Result SET
		F_Coach1PrtNameS = tRegDes.F_PrintShortName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LangCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 3
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID
    
    --获取助理教练
    UPDATE #Result SET
		F_Coach2PrtNameS = tRegDes.F_PrintShortName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LangCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 4
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID
        
    --获取训练师
    UPDATE #Result SET
		F_CoachTrainerPrtNameS = tRegDes.F_PrintShortName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LangCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 6
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID
    
    
    DECLARE @RegStat1 INT
    DECLARE @RegStat2 INT
    
    
    
	--获取技术统计人员,排前面的
    UPDATE #Result SET
		F_CoachStat1PrtNameS = ( SELECT top 1 tRegDes.F_PrintShortName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LangCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 5
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID 
    ORDER BY tRegMember.F_Order 
    )
    
    --获取技术统计人员,排后面的，当然如果两个一样，把后面的置为NULL
    UPDATE #Result SET
		F_CoachStat2PrtNameS = ( SELECT top 1 tRegDes.F_PrintShortName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LangCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 5
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID 
    ORDER BY tRegMember.F_Order DESC
    )
    
    --如果Stat1，Stat2一样，就把后面的删掉
    UPDATE #Result SET
		F_CoachStat2PrtNameS = 
		CASE WHEN F_CoachStat1PrtNameS = F_CoachStat2PrtNameS THEN NULL 
		ELSE F_CoachStat2PrtNameS
		END
		
		
	DECLARE @ShirtStr NVARCHAR(100)	= ''
	DECLARE @ShortStr NVARCHAR(100)	= ''
		
	
	SELECT @ShirtStr = @ShirtStr + F_ShirtDes + ', ' FROM #Result
	SELECT @ShortStr = @ShortStr + F_ShortDes + ', ' FROM #Result
	
	IF ( RIGHT(@ShirtStr, 2) = ',' ) SET @ShirtStr = Left(@ShirtStr, LEN(@ShirtStr)-1)
	IF ( RIGHT(@ShortStr, 2) = ',' ) SET @ShortStr = Left(@ShortStr, LEN(@ShortStr)-1)
	
	UPDATE #Result SET 
	  F_ShirtString = @ShirtStr
	, F_ShortString = @ShortStr
	
	
	DECLARE @CmtTnr		NVARCHAR(100)
	DECLARE @CmtSt1		NVARCHAR(100)
	DECLARE @CmtSt2		NVARCHAR(100)
	
	select @CmtTnr = F_Comment from TR_Register_Comment where F_RegisterID = @TeamRegID AND F_Title = 'Tnr'
	select @CmtSt1 = F_Comment from TR_Register_Comment where F_RegisterID = @TeamRegID AND F_Title = 'St1'
	select @CmtSt2 = F_Comment from TR_Register_Comment where F_RegisterID = @TeamRegID AND F_Title = 'St2'
	
	SELECT *, 
	   ISNULL(F_CoachStat1PrtNameS, @CmtSt1) AS F_CoachStat1PrtNameCmtS
	 , ISNULL(F_CoachStat2PrtNameS, @CmtSt2) AS F_CoachStat2PrtNameCmtS 
	 , ISNULL(F_CoachTrainerPrtNameS, @CmtTnr) AS F_CoachTrainerPrtNameCmtS
	  FROM #Result
	 
SET NOCOUNT OFF
END




/*
go
[proc_VB_RPT_TeamRosterInfo] 1, 'CHN'
*/


GO
/************************proc_VB_RPT_TeamRosterInfo OVER*************************/


/************************proc_VB_TEST_BackupScriptsToFile Start************************/GO


CREATE PROCEDURE [dbo].[proc_VB_TEST_BackupScriptsToFile]
As
Begin
SET NOCOUNT ON 

	DECLARE @tblScript TABLE 
	(
		F_ObjectID	INT,
		F_Name		NVARCHAR(100),
		F_Type		NVARCHAR(100)
	)

	--将所有VB的函数，存储过程名称，ID号填入临时表
	INSERT INTO @tblScript
	SELECT [object_id], [Name], [Type] FROM sys.objects 
	WHERE type IN ('P', 'FN', 'TF') AND LEFT([Name], 8) IN ('proc_VB_', 'func_VB_')
	ORDER BY [Name]
	
	DECLARE @TextScrpFuncValAdd		NVARCHAR(MAX)=N''
	DECLARE @TextScrpFuncValDel		NVARCHAR(MAX)=N''
	
	DECLARE @TextScrpFuncTblAdd		NVARCHAR(MAX)=N''
	DECLARE @TextScrpFuncTblDel		NVARCHAR(MAX)=N''

	DECLARE @TextScrpProcAdd		NVARCHAR(MAX)=N''
	DECLARE @TextScrpProcDel		NVARCHAR(MAX)=N''
	
	DECLARE @TmpObjID	INT
	DECLARE @TmpName	NVARCHAR(100) 
	DECLARE @TmpType	NVARCHAR(100)
	
	DECLARE CSR_CSR CURSOR STATIC FOR 
	SELECT F_ObjectID, F_Name, F_Type FROM @tblScript 
	ORDER BY F_Type, F_Name
	
	OPEN CSR_CSR	
	FETCH NEXT FROM CSR_CSR INTO @TmpObjID, @TmpName, @TmpType
	
	WHILE(@@FETCH_STATUS =0)
	BEGIN
		DECLARE @TmpScrp	NVARCHAR(MAX)=''
		
		PRINT @TmpName
		
		IF ( @TmpType = 'FN' ) --值函数
		BEGIN
			SELECT @TmpScrp = @TmpScrp + [Text] FROM dbo.syscomments where id = @TmpObjID ORDER BY [colid]
			
			SET @TextScrpFuncValAdd = @TextScrpFuncValAdd + 
			CHAR(10)+CHAR(13)+CHAR(10)+CHAR(13)+ 
			
			'/************************' + @TmpName + ' Start************************/' +
			'GO' + CHAR(10)+CHAR(13) + 
			LTRIM(RTRIM(@TmpScrp)) + 
			'GO' + CHAR(10)+CHAR(13) + 
			'/************************' + @TmpName + ' OVER*************************/' +
			CHAR(10)+CHAR(13) 
			
			SELECT @TextScrpFuncValDel = @TextScrpFuncValDel + 
			CHAR(10)+CHAR(13)+ 
			'IF ( OBJECT_ID(''' + @TmpName + ''') IS NOT NULL )' +
			CHAR(10) +
			'DROP Function [' + @TmpName + ']' +
			CHAR(10) +
			'GO' +
			CHAR(10)
		END
		
		IF ( @TmpType = 'TF') --表函数
		BEGIN
			SELECT @TmpScrp = @TmpScrp + [Text] FROM dbo.syscomments where id = @TmpObjID ORDER BY [colid]
			
			SET @TextScrpFuncTblAdd = @TextScrpFuncTblAdd + 
			CHAR(10)+CHAR(13)+CHAR(10)+CHAR(13)+ 
			'/************************' + @TmpName + ' Start************************/' +
			+ 'GO' + CHAR(10)+CHAR(13) + 
			+ LTRIM(RTRIM(@TmpScrp)) + 
			+ 'GO' + CHAR(10)+CHAR(13) + 
			'/************************' + @TmpName + ' OVER*************************/' +
			CHAR(10)+CHAR(13)
			
			SELECT @TextScrpFuncTblDel = @TextScrpFuncTblDel + 
			CHAR(10)+CHAR(13)+ 
			'IF ( OBJECT_ID(''' + @TmpName + ''') IS NOT NULL )' +
			CHAR(10) +
			'DROP Function [' + @TmpName + ']' +
			CHAR(10) +
			'GO' +
			CHAR(10)
		END
		
		IF ( @TmpType = 'P') --存储过程
		BEGIN
			SELECT @TmpScrp = @TmpScrp + [Text] FROM dbo.syscomments where id = @TmpObjID ORDER BY [colid]
			
			SET @TextScrpProcAdd = @TextScrpProcAdd + 
			CHAR(10)+CHAR(13)+CHAR(10)+CHAR(13)+ 
			'/************************' + @TmpName + ' Start************************/' +
			+ 'GO' + CHAR(10)+CHAR(13) + 
			+ LTRIM(RTRIM(@TmpScrp)) + 
			+ 'GO' + CHAR(10)+CHAR(13) + 
			'/************************' + @TmpName + ' OVER*************************/' +
			CHAR(10)+CHAR(13) 
			
			SELECT @TextScrpProcDel = @TextScrpProcDel + 
			CHAR(10)+CHAR(13)+ 
			'IF ( OBJECT_ID(''' + @TmpName + ''') IS NOT NULL )' +
			CHAR(10) +
			'DROP PROCEDURE [' + @TmpName + ']' +
			CHAR(10) +
			'GO' +
			CHAR(10)
		END
		
		FETCH NEXT FROM CSR_CSR INTO @TmpObjID, @TmpName, @TmpType
	END
	
	CLOSE CSR_CSR
	DEALLOCATE CSR_CSR


	SET @TextScrpFuncValAdd = @TextScrpFuncValDel +
		CHAR(10) +
		'SET ANSI_NULLS ON' +
		CHAR(10) +
		'GO' +
		CHAR(10) +
		'SET QUOTED_IDENTIFIER ON' +
		CHAR(10) +
		'GO' +
		CHAR(10) +
		@TextScrpFuncValAdd

	SET @TextScrpFuncTblAdd = @TextScrpFuncTblDel +
		CHAR(10) +
		'SET ANSI_NULLS ON' +
		CHAR(10) +
		'GO' +
		CHAR(10) +
		'SET QUOTED_IDENTIFIER ON' +
		CHAR(10) +
		'GO' +
		CHAR(10) +
		@TextScrpFuncTblAdd

	SET @TextScrpProcAdd = @TextScrpProcDel +
		CHAR(10) +
		'SET ANSI_NULLS ON' +
		CHAR(10) +
		'GO' +
		CHAR(10) +
		'SET QUOTED_IDENTIFIER ON' +
		CHAR(10) +
		'GO' +
		CHAR(10) +
		@TextScrpProcAdd

	--select @TextScriptAdd
	exec proc_VB_TEST_WriteTxtToFile 'C:\\FuncVal.sql', @TextScrpFuncValAdd 
	exec proc_VB_TEST_WriteTxtToFile 'C:\\FuncTbl.sql', @TextScrpFuncTblAdd 
	exec proc_VB_TEST_WriteTxtToFile 'C:\\FuncProc.sql', @TextScrpProcAdd 
	print 'OVER'

	
	
			
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
[proc_VB_TEST_BackupScriptsToFile]
*/

GO
/************************proc_VB_TEST_BackupScriptsToFile OVER*************************/


/************************proc_VB_TEST_CreateTestActionList Start************************/GO














CREATE PROCEDURE [dbo].[proc_VB_TEST_CreateTestActionList]
As
Begin
SET NOCOUNT ON 

		--循环所有Match 
		DECLARE @TmpMatchID	INT
		DECLARE CSR_MatchID CURSOR STATIC FOR 
		SELECT F_MatchID FROM TS_Match ORDER BY F_MatchDate
		OPEN CSR_MatchID	
		FETCH NEXT FROM CSR_MatchID INTO @TmpMatchID
		WHILE( @@FETCH_STATUS =0 )
		BEGIN
				
			--循环所有Action
			DECLARE @TmpActionCode NVARCHAR(100)
			DECLARE CSR_ActionCode CURSOR STATIC FOR
			SELECT F_ActionCode FROM TD_ActionType
			OPEN CSR_ActionCode	
			FETCH NEXT FROM CSR_ActionCode INTO @TmpActionCode
			WHILE( @@FETCH_STATUS =0 )
			BEGIN
						
				DECLARE @TmpReg INT
				DECLARE CSR_Reg CURSOR STATIC FOR
				SELECT F_MemberRegisterID from TR_Register_Member
				OPEN CSR_Reg	
				FETCH NEXT FROM CSR_Reg INTO @TmpReg
				WHILE( @@FETCH_STATUS =0 )
				BEGIN
					DECLARE @Result INT		
					DECLARE @CYC	INT=0
					IF(@CYC<1)
					BEGIN
						exec proc_VB_PRG_StatActionAdd  @TmpMatchID, 1, 1, @TmpReg, 0, @TmpActionCode, @Result output
						exec proc_VB_PRG_StatActionAdd  @TmpMatchID, 2, 1, @TmpReg, 0, @TmpActionCode, @Result output
						exec proc_VB_PRG_StatActionAdd  @TmpMatchID, 3, 1, @TmpReg, 0, @TmpActionCode, @Result output
						exec proc_VB_PRG_StatActionAdd  @TmpMatchID, 4, 1, @TmpReg, 0, @TmpActionCode, @Result output
						exec proc_VB_PRG_StatActionAdd  @TmpMatchID, 5, 1, @TmpReg, 0, @TmpActionCode, @Result output
						SET @CYC = @CYC+1
					END
					
				FETCH NEXT FROM CSR_Reg INTO @TmpReg
				END
				CLOSE CSR_Reg
				DEALLOCATE CSR_Reg	
			
			FETCH NEXT FROM CSR_ActionCode INTO @TmpActionCode	
			END
			CLOSE CSR_ActionCode
			DEALLOCATE CSR_ActionCode		
		
		FETCH NEXT FROM CSR_MatchID INTO @TmpMatchID	
		END
		CLOSE CSR_MatchID
		DEALLOCATE CSR_MatchID		
			
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF














GO
/************************proc_VB_TEST_CreateTestActionList OVER*************************/


/************************proc_VB_TEST_CreateTestAthlete Start************************/GO





--描述：创建测试队员使用
--使用：根据参数,自动生成队员,并且身高,体重,拦网高度等,随机生成
--创 建 人：王征
--日    期：2010年10月12日

--2011-12-05	For Para, Add "Class Sport" information

--2012-08-24	加入'人'，为了测试中文信息 插入TS_Register时F_NOC = null,国内比赛只用Delegation
CREATE PROCEDURE [dbo].[proc_VB_TEST_CreateTestAthlete](
								@Name			    NVARCHAR(100),
								@DelegationCode		CHAR(3),
								@GenerCode			CHAR(1),		--M,W
								@RegType			INT,			--1:Athlete 4:CompOfficial 5：UnCompOfficial
								@FuncID				INT,			--Null:For Athlete
								@Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DelegationID	INT
	DECLARE @SexCode		INT

	DECLARE @RegisterTmpID	INT=0
	DECLARE @RegCode		NVARCHAR(100)
	DECLARE @NameAdd		NVARCHAR(100)
	DECLARE @BirthDate		DATETIME

	SELECT @SexCode = F_SexCode FROM TC_Sex WHERE F_GenderCode = @GenerCode
	SELECT @DelegationID = F_DelegationID FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode

	--RC_KOR_M01
	SET @RegCode = 'RC' + @DelegationCode + '' + @GenerCode + @Name	

	--_KOR_M01
	SET @NameAdd = '' + @DelegationCode + '' + @GenerCode + @Name + '名'

	--BirthDate
	SET @BirthDate = CAST(CAST(RAND()*30+1960 AS INT) AS CHAR(4)) + '-' +CAST(CAST(RAND()*11+1 AS INT) as NVARCHAR(2)) + '-' + CAST(CAST(RAND()*28+1 AS INT) as NVARCHAR(2)) 

	INSERT INTO TR_Register(F_RegisterCode, F_NOC, F_SexCode, F_DisciplineID, F_DelegationID, F_RegTypeID, F_FunctionID, F_Height, F_Weight, F_Birth_Date)
	VALUES(@RegCode, NULL, @SexCode, 21, @DelegationID, @RegType, @FuncID, 
	CAST(CAST(RAND()*40+150 AS INT) AS NVARCHAR(20)), 
	CAST(CAST(RAND()*70+20 AS INT) AS NVARCHAR(20)),
	@BirthDate)

	SET @RegisterTmpID = @@IDENTITY
	SET @Result = @RegisterTmpID

	--英文名
	INSERT INTO TR_Register_Des(F_RegisterID, F_LanguageCode, F_FirstName, F_LastName, 
	F_LongName,  F_ShortName, F_PrintLongName, F_PrintShortName, F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName, F_WNPA_FirstName, F_WNPA_LastName)
	VALUES(@RegisterTmpID, 'ENG', 'EF'+@NameAdd, 'EL'+@NameAdd,
	'EL'+@NameAdd, 'ES'+@NameAdd, 'EPL'+@NameAdd, 'EPS'+@NameAdd, 'ESL'+@NameAdd, 'ESS'+@NameAdd, 'ETL'+@NameAdd, 'ETS'+@NameAdd, 'EWL'+@NameAdd, 'EWS'+@NameAdd)
  
	--中文名
	INSERT INTO TR_Register_Des(F_RegisterID, F_LanguageCode, F_FirstName, F_LastName, 
	F_LongName,  F_ShortName, F_PrintLongName, F_PrintShortName, F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName, F_WNPA_FirstName, F_WNPA_LastName)
	VALUES(@RegisterTmpID, 'CHN', 'CF'+@NameAdd, 'CL'+@NameAdd,
	'CL'+@NameAdd, 'CS'+@NameAdd, 'CPL'+@NameAdd, 'CPS'+@NameAdd, 'CSL'+@NameAdd, 'CSS'+@NameAdd, 'CTL'+@NameAdd, 'CTS'+@NameAdd, 'CWL'+@NameAdd, 'CWS'+@NameAdd)
	
	--攻击高度
	DECLARE @CommentTopID INT
	Select @CommentTopID = CASE WHEN MAX(F_CommentID) IS NOT NULL THEN MAX(F_CommentID) ELSE 0 END FROM TR_Register_Comment
	
	INSERT INTO TR_Register_Comment(F_CommentID, F_RegisterID, F_Comment_Order, F_Title, F_Comment)
	VALUES(@CommentTopID+1, @RegisterTmpID, 1, 'Spike', CAST(CAST(RAND()*50+50 AS INT) AS NVARCHAR(20)))

	--扣篮高度
	INSERT INTO TR_Register_Comment(F_CommentID, F_RegisterID, F_Comment_Order, F_Title, F_Comment)
	VALUES(@CommentTopID+2, @RegisterTmpID, 2, 'Block', CAST(CAST(RAND()*100+50 AS INT) AS NVARCHAR(20)))
  	
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


















GO
/************************proc_VB_TEST_CreateTestAthlete OVER*************************/


/************************proc_VB_TEST_CreateTestData Start************************/GO




--创建所有国家
--2012-08-24	填入中文内容 为了测试中文报表
--2012-09-11	Can run for BV
CREATE PROCEDURE [dbo].[proc_VB_TEST_CreateTestData]
As
Begin
SET NOCOUNT ON 
		
		--删除
		DELETE TR_Register_Des	
		DELETE TR_Register_Comment
		DELETE TR_Register_Member
		DELETE TR_Register WHERE F_RegisterID > 0
		DELETE TS_ActiveDelegation

		--插入前24个DelegationCode
		DECLARE CSR_NOC CURSOR STATIC FOR 
		select TOP 24 A.F_DelegationID, A.F_DelegationCode from TC_Delegation AS A
		INNER JOIN TC_Delegation_Des AS C ON F_DelegationShortName IS NOT NULL AND C.F_DelegationID = A.F_DelegationID AND F_LanguageCode = 'CHN'

			DECLARE @TmpDelegationID	INT
			DECLARE @TmpDelegationCode	NVARCHAR(100)

			OPEN CSR_NOC
			
				FETCH NEXT FROM CSR_NOC INTO @TmpDelegationID, @TmpDelegationCode
				
				WHILE( @@FETCH_STATUS =0 )
				BEGIN
					DECLARE @Result INT
					
						INSERT INTO TS_ActiveDelegation VALUES(@TmpDelegationID, 21, 1)
						
						if ( @@ERROR = 0 )
						BEGIN
							exec proc_VB_TEST_CreateTestTeam  @TmpDelegationID, @TmpDelegationCode, 'M', @Result output
							exec proc_VB_TEST_CreateTestTeam  @TmpDelegationID, @TmpDelegationCode, 'W', @Result output
						END
						
						print @TmpDelegationCode
					FETCH NEXT FROM CSR_NOC INTO @TmpDelegationID, @TmpDelegationCode
				END
				
			CLOSE CSR_NOC
			DEALLOCATE CSR_NOC
			
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
go
[proc_VB_TEST_CreateTestData]
*/




GO
/************************proc_VB_TEST_CreateTestData OVER*************************/


/************************proc_VB_TEST_CreateTestTeam Start************************/GO


--描述：创建测试队伍和整个队员使用
--使用：根据参数,自动生成队员,并且身高,体重,拦网高度等,随机生成
--创 建 人：王征
--日    期：2010年10月12日


--2011-02-16	自动设置1号为队长，2号，3号为自由人, 自动添加衣服
--2012-09-11	Can run for BV
CREATE PROCEDURE [dbo].[proc_VB_TEST_CreateTestTeam](
								@DelegationID		CHAR(3),
								@DelegationCode		CHAR(3),
								@GenerCode			CHAR(1),
								@Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

	DECLARE @TmpTeamRegisterID	INT
	DECLARE @TmpRegisterID		INT
	
	DECLARE @IsBV INT = CASE (SELECT TOP 1 F_DisciplineCode FROM TS_Discipline WHERE F_Active = 1) WHEN 'BV' THEN 1 ELSE 0 END
	DECLARE @RegType INT = CASE WHEN @IsBV = 1 THEN 2 ELSE 3 END
	
	--创建队伍
	exec proc_VB_TEST_CreateTestAthlete '', @DelegationCode, @GenerCode, @RegType, NULL, @TmpTeamRegisterID OUTPUT
	if @TmpTeamRegisterID < 1 
	BEGIN
		SET @Result = 0
		return
	END
	
	--队伍报项
	if ( @GenerCode = 'M' )
	BEGIN
		INSERT TR_Inscription(F_EventID, F_RegisterID)
		VALUES(31, @TmpTeamRegisterID)
	END
	ELSE
	BEGIN
		INSERT TR_Inscription(F_EventID, F_RegisterID)
		VALUES(32, @TmpTeamRegisterID)
	END
	
	--创建队伍衣服
	
	INSERT TR_Uniform(F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order)
	VALUES(@TmpTeamRegisterID, 1, 1, 1, 1)

	INSERT TR_Uniform(F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order)
	VALUES(@TmpTeamRegisterID, 2, 2, 2, 2)

	INSERT TR_Uniform(F_RegisterID, F_Shirt, F_Shorts, F_Socks, F_Order)
	VALUES(@TmpTeamRegisterID, 3, 3, 3, 3)
		
	--插入人
	DECLARE @Player1RegID INT
	DECLARE @Player2RegID INT
	
	exec proc_VB_TEST_CreateTestAthlete '01', @DelegationCode, @GenerCode, 1, NULL, @Player1RegID output
	INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
	VALUES(@TmpTeamRegisterID, @Player1RegID, 1, '1', 1)
	
	exec proc_VB_TEST_CreateTestAthlete '02', @DelegationCode, @GenerCode, 1, NULL, @Player2RegID output
	INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
	VALUES(@TmpTeamRegisterID, @Player2RegID, 2, '2', 2)
	
	--排球才插入那么多人
	IF @IsBV <> 1 
	BEGIN
		exec proc_VB_TEST_CreateTestAthlete '03', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 3, '3', 2)
		
		exec proc_VB_TEST_CreateTestAthlete '04', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 4, '4', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '05', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 5, '5', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '06', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 6, '6', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '07', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 7, '7', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '08', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 8, '8', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '09', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 9, '9', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '10', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 10, '10', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '11', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 11, '11', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '12', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 12, '12', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '13', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 13, '13', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '14', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 14, '14', NULL)
		
		exec proc_VB_TEST_CreateTestAthlete '15', @DelegationCode, @GenerCode, 1, NULL, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 15, '15', NULL)
	END
	
	--Head coach
	exec proc_VB_TEST_CreateTestAthlete 'HC', @DelegationCode, @GenerCode, 5, 3, @TmpRegisterID output
	INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
	VALUES(@TmpTeamRegisterID, @TmpRegisterID, 16, NULL, 3)
	
	--Ast coach
	exec proc_VB_TEST_CreateTestAthlete 'AC', @DelegationCode, @GenerCode, 5, 4, @TmpRegisterID output
	INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
	VALUES(@TmpTeamRegisterID, @TmpRegisterID, 17, NULL, 4)
	
	IF @IsBV = 1 
	BEGIN
		--stat1
		exec proc_VB_TEST_CreateTestAthlete 'STA1', @DelegationCode, @GenerCode, 5, 5, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 18, NULL, 5)
		
		--stat2
		exec proc_VB_TEST_CreateTestAthlete 'STA2', @DelegationCode, @GenerCode, 5, 5, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 19, NULL, 5)

		--Trainer
		exec proc_VB_TEST_CreateTestAthlete 'TRN', @DelegationCode, @GenerCode, 5, 6, @TmpRegisterID output
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_ShirtNumber, F_FunctionID)
		VALUES(@TmpTeamRegisterID, @TmpRegisterID, 20, NULL, 6)
	END
	
	--Head Referee
	exec proc_VB_TEST_CreateTestAthlete 'R1', @DelegationCode, @GenerCode, 4, 11, @TmpRegisterID output
	
	--Ast Referee
	exec proc_VB_TEST_CreateTestAthlete 'R2', @DelegationCode, @GenerCode, 4, 12, @TmpRegisterID output
	
	IF @IsBV <> 1
	BEGIN
		--Line Referee
		exec proc_VB_TEST_CreateTestAthlete 'LJ', @DelegationCode, @GenerCode, 4, 13, @TmpRegisterID output
		
		--Score Keeper
		exec proc_VB_TEST_CreateTestAthlete 'SK', @DelegationCode, @GenerCode, 4, 14, @TmpRegisterID output
	  
		--Ast Score Keeper
		exec proc_VB_TEST_CreateTestAthlete 'ASK', @DelegationCode, @GenerCode, 4, 15, @TmpRegisterID output
		
  		--Reserve Referee
		exec proc_VB_TEST_CreateTestAthlete 'RRE', @DelegationCode, @GenerCode, 4, 16, @TmpRegisterID output
	  
		--Reserve Line Referee
		exec proc_VB_TEST_CreateTestAthlete 'RLJ', @DelegationCode, @GenerCode, 4, 17, @TmpRegisterID output
	END
	
	--If BV	rename the Team name to Player1 / Player2
	IF @IsBV = 1
	BEGIN
		
		UPDATE A SET
			  A.F_PrintLongName = B.F_PrintLongName + '/' + C.F_PrintLongName
			, A.F_PrintShortName = B.F_PrintShortName + '/' + C.F_PrintShortName
			, A.F_FirstName = B.F_FirstName + '/' + C.F_FirstName
			, A.F_LastName = B.F_LastName + '/' + C.F_LastName
			, A.F_LongName = B.F_LongName + '/' + C.F_LongName
			, A.F_ShortName = B.F_ShortName + '/' + C.F_ShortName
			, A.F_SBLongName = B.F_SBLongName + '/' + C.F_SBLongName
			, A.F_SBShortName = B.F_SBShortName + '/' + C.F_SBShortName
			, A.F_TvLongName = B.F_TvLongName + '/' + C.F_TvLongName
			, A.F_TvShortName = B.F_TvShortName + '/' + C.F_TvShortName
			
			
		FROM TR_Register_Des AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = @Player1RegID AND B.F_LanguageCode = 'CHN'
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = @Player2RegID AND C.F_LanguageCode = 'CHN'
		WHERE A.F_RegisterID = @TmpTeamRegisterID AND A.F_LanguageCode = 'CHN'
		
	END
	
	SET @Result = 1
  
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


















GO
/************************proc_VB_TEST_CreateTestTeam OVER*************************/


/************************proc_VB_TEST_GetInsertSQL Start************************/GO






















CREATE   proc [dbo].[proc_VB_TEST_GetInsertSQL] (@tablename varchar(256))

as

begin

declare @sql varchar(8000)

declare @sqlValues varchar(8000)

set @sql =' ('

set @sqlValues = 'values (''+'

select @sqlValues = @sqlValues + cols + ' + '','' + ' ,@sql = @sql + '[' + name + '],' 

  from 

      (select case 

                when xtype in (48,52,56,59,60,62,104,106,108,122,127)                                

                     then 'case when '+ name +' is null then ''NULL'' else ' + 'cast('+ name + ' as varchar)'+' end'

                when xtype in (58,61)

                     then 'case when '+ name +' is null then ''NULL'' else '+''''''''' + ' + 'cast('+ name +' as varchar)'+ '+'''''''''+' end'

               when xtype in (167)

                     then 'case when '+ name +' is null then ''NULL'' else '+''''''''' + ' + 'replace('+ name+','''''''','''''''''''')' + '+'''''''''+' end'

                when xtype in (231)

                     then 'case when '+ name +' is null then ''NULL'' else '+'''N'''''' + ' + 'replace('+ name+','''''''','''''''''''')' + '+'''''''''+' end'

                when xtype in (175)

                     then 'case when '+ name +' is null then ''NULL'' else '+''''''''' + ' + 'cast(replace('+ name+','''''''','''''''''''') as Char(' + cast(length as varchar)  + '))+'''''''''+' end'

                when xtype in (239)

                     then 'case when '+ name +' is null then ''NULL'' else '+'''N'''''' + ' + 'cast(replace('+ name+','''''''','''''''''''') as Char(' + cast(length as varchar)  + '))+'''''''''+' end'

                else '''NULL'''

              end as Cols,name

         from syscolumns  

        where id = object_id(@tablename) 

      ) T 

print @sql
print @sqlValues
set @sql ='select ''INSERT INTO ['+ @tablename + ']' + left(@sql,len(@sql)-1)+') ' + left(@sqlValues,len(@sqlValues)-4) + ')'' from '+@tablename

print @sql

exec (@sql)

end




















GO
/************************proc_VB_TEST_GetInsertSQL OVER*************************/


/************************proc_VB_TEST_WriteTxtToFile Start************************/GO


			
CREATE proc [dbo].[proc_VB_TEST_WriteTxtToFile]
	@FilePathName	NVARCHAR(1000),	
	@Text			NVARCHAR(MAX)
AS
	DECLARE @Err INT
	DECLARE @src NVARCHAR(255)
	DECLARE @desc NVARCHAR(255)
	DECLARE @obj INT
	
	exec @Err = sp_oacreate 'Scripting.FileSystemObject', @obj out
	if @Err<>0 goto lbErr
	
	exec @Err = sp_oamethod @obj,'OpenTextFile', @obj out, @FilePathName, 8, 1
	if @Err<>0 goto lbErr
	
	exec @Err = sp_oamethod @obj,'WriteLine', null, @text
	if @Err<>0 goto lbErr
	
	exec @Err=sp_oadestroy @obj
	
RETURN
	lbErr:
	 exec sp_oageterrorinfo 0, @src out, @desc out
	 SELECT CAST(@Err as varbinary(4)) as 错误号, @src as 错误源, @desc as 错误描述
 


















GO
/************************proc_VB_TEST_WriteTxtToFile OVER*************************/

