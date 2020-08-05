
IF ( OBJECT_ID('func_VB_BV_GetTeamMember') IS NOT NULL )
DROP Function [func_VB_BV_GetTeamMember]
GO

IF ( OBJECT_ID('func_VB_GetChangeUpList') IS NOT NULL )
DROP Function [func_VB_GetChangeUpList]
GO

IF ( OBJECT_ID('func_VB_GetEventInfo') IS NOT NULL )
DROP Function [func_VB_GetEventInfo]
GO

IF ( OBJECT_ID('func_VB_GetEventRankList') IS NOT NULL )
DROP Function [func_VB_GetEventRankList]
GO

IF ( OBJECT_ID('func_VB_GetGroupMatch') IS NOT NULL )
DROP Function [func_VB_GetGroupMatch]
GO

IF ( OBJECT_ID('func_VB_GetGroupMember') IS NOT NULL )
DROP Function [func_VB_GetGroupMember]
GO

IF ( OBJECT_ID('func_VB_GetGroupStatistics') IS NOT NULL )
DROP Function [func_VB_GetGroupStatistics]
GO

IF ( OBJECT_ID('func_VB_GetIRMList') IS NOT NULL )
DROP Function [func_VB_GetIRMList]
GO

IF ( OBJECT_ID('func_VB_GetLineUpList') IS NOT NULL )
DROP Function [func_VB_GetLineUpList]
GO

IF ( OBJECT_ID('func_VB_GetMatchInfo') IS NOT NULL )
DROP Function [func_VB_GetMatchInfo]
GO

IF ( OBJECT_ID('func_VB_GetMatchSchedule') IS NOT NULL )
DROP Function [func_VB_GetMatchSchedule]
GO

IF ( OBJECT_ID('func_VB_GetMatchScoreOneRow') IS NOT NULL )
DROP Function [func_VB_GetMatchScoreOneRow]
GO

IF ( OBJECT_ID('func_VB_GetMatchStartList') IS NOT NULL )
DROP Function [func_VB_GetMatchStartList]
GO

IF ( OBJECT_ID('func_VB_GetMatchStatActionList_Step1_OriginList') IS NOT NULL )
DROP Function [func_VB_GetMatchStatActionList_Step1_OriginList]
GO

IF ( OBJECT_ID('func_VB_GetMatchStatActionList_Step2_ActionList') IS NOT NULL )
DROP Function [func_VB_GetMatchStatActionList_Step2_ActionList]
GO

IF ( OBJECT_ID('func_VB_GetMatchStatActionList_Step3_PlayByPlay') IS NOT NULL )
DROP Function [func_VB_GetMatchStatActionList_Step3_PlayByPlay]
GO

IF ( OBJECT_ID('func_VB_GetMatchTeamInfo') IS NOT NULL )
DROP Function [func_VB_GetMatchTeamInfo]
GO

IF ( OBJECT_ID('func_VB_GetPositionSourceInfo') IS NOT NULL )
DROP Function [func_VB_GetPositionSourceInfo]
GO

IF ( OBJECT_ID('func_VB_GetStatEventAthlete') IS NOT NULL )
DROP Function [func_VB_GetStatEventAthlete]
GO

IF ( OBJECT_ID('func_VB_GetStatEventTeam') IS NOT NULL )
DROP Function [func_VB_GetStatEventTeam]
GO

IF ( OBJECT_ID('func_VB_GetStatMatchAthlete') IS NOT NULL )
DROP Function [func_VB_GetStatMatchAthlete]
GO

IF ( OBJECT_ID('func_VB_GetStatMatchTeam') IS NOT NULL )
DROP Function [func_VB_GetStatMatchTeam]
GO

IF ( OBJECT_ID('func_VB_GetTeamMatchHistoryList') IS NOT NULL )
DROP Function [func_VB_GetTeamMatchHistoryList]
GO

IF ( OBJECT_ID('func_VB_GetTeamNameByRegID') IS NOT NULL )
DROP Function [func_VB_GetTeamNameByRegID]
GO

IF ( OBJECT_ID('func_VB_GetTournamentChart') IS NOT NULL )
DROP Function [func_VB_GetTournamentChart]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/************************func_VB_BV_GetTeamMember Start************************/GO


--获取两个队员的ID
--为了沙排使用

--2011-10-16	Created
--2011-10-19	Don't need the langcode any more
--2012-09-11	Rewrite
CREATE function [dbo].[func_VB_BV_GetTeamMember]
	(
			@TeamRegID			INT
	)
RETURNS @Result TABLE ( 
        F_PlayerRegId1				INT,
        F_PlayerRegId2				INT
	)
As
BEGIN
	
	DECLARE @tblTemp TABLE 
		(
			F_PlayerRegID	INT,
			F_Order			INT
		)
	
	INSERT INTO @tblTemp
	SELECT TOP 2
		  A.F_MemberRegisterID AS F_RegisterID 
		, ROW_NUMBER() OVER(ORDER BY A.F_Order) AS F_Order
	FROM TR_Register_Member AS A
	INNER JOIN TR_Register AS B ON B.F_RegisterID = A.F_MemberRegisterID AND B.F_RegTypeID = 1 	--只要运动员
	WHERE A.F_RegisterID = @TeamRegID
	ORDER BY A.F_Order
	
	INSERT INTO @Result
	SELECT 
		  (SELECT F_PlayerRegID FROM @tblTemp WHERE F_Order = 1)
		, (SELECT F_PlayerRegID FROM @tblTemp WHERE F_Order = 2)
	
	RETURN
END

/*
go
select * from [func_VB_BV_GetTeamMember](1, 'ENG')
*/

GO
/************************func_VB_BV_GetTeamMember OVER*************************/


/************************func_VB_GetChangeUpList Start************************/GO


----功  能：获取一场比赛一局的换人列表 
----日	期: 2011-02-18
----每一个换人，利用一行
----根据实际设置，返回的有可能是不正确的

--2011-04-02	Created
CREATE function [dbo].[func_VB_GetChangeUpList]
	(
		@MatchID		INT,		--比赛号
		@CompPos		INT,		-- 1:A方  2:B方
		@CurSet			INT=NULL	--默认当前局
	)
Returns @Result TABLE ( 
				F_Order				INT,
				F_OrderInActionList	INT,	--此下场信息在ActionList表中的Order，以此为标识来查找上场信息
				F_InShirtNumber		INT,      
				F_InRegisterID		INT,
				F_OutShirtNumber	INT,
				F_OutRegisterID		INT
			)
As
BEGIN

	if ( @CurSet IS NULL )
	BEGIN
		SELECT @CurSet = F_CurSet FROM dbo.func_VB_GetMatchInfo(@MatchID, 'ENG')
	END

	--参数检测
	IF @MatchID < 1 OR @CurSet < 1 OR @CurSet > 5 OR @CompPos < 1 or @CompPos > 2 
	BEGIN
		RETURN
	END
	
	DECLARE @TempActionList TABLE 
	(
		F_Order			INT,
		F_RegisterID	INT,
		F_ActionTypeID	INT
	)
	
	--将本局所有换人信息填入临时表
	INSERT INTO @TempActionList
	SELECT F_ActionOrder, F_RegisterID, F_ActionTypeID From TS_Match_ActionList 
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurSet AND F_CompetitionPosition = @CompPos
		AND F_ActionTypeID IN ( 19, 20, 21, 22) AND F_ActionOrder > 7 
	ORDER BY F_ActionOrder
	
	--将所有下场信息插入
	INSERT INTO @Result(F_OutRegisterID, F_OrderInActionList, F_Order)
	SELECT 
		  F_RegisterID 
		, F_Order
		, ROW_NUMBER() OVER(ORDER BY F_Order)
	FROM @TempActionList WHERE F_ActionTypeID IN ( 20, 22 )
	
	--在动作列表中，往下找，紧靠下场动作的上场动作，即为此人的上场信息
	UPDATE A SET	
		A.F_InRegisterID = ( SELECT TOP 1 F_RegisterID FROM @TempActionList WHERE F_ActionTypeID IN ( 19, 21 ) AND F_Order > A.F_OrderInActionList ORDER BY F_Order )
	FROM @Result AS A
	
	UPDATE A SET 
		  A.F_InShirtNumber = ( SELECT F_ShirtNumber FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos AND F_RegisterID = A.F_InRegisterID )
		, A.F_OutShirtNumber = ( SELECT F_ShirtNumber FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos AND F_RegisterID = A.F_OutRegisterID )
	FROM @Result AS A
	
	
		
	RETURN
END

/*
go
select * from func_VB_GetChangeUpList(1, 2, 2)
*/




GO
/************************func_VB_GetChangeUpList OVER*************************/


/************************func_VB_GetEventInfo Start************************/GO


--2011-03-15	Add RscCode
--2011-03-20	RscCode中GenderCode提到EventCode前
--2011-03-21	获取RscCode通过统一函数func_VB_GetRscCode
--2011-10-28	Add F_DisciplineCode
CREATE function [dbo].[func_VB_GetEventInfo]
			(
				@EventID		INT,
	            @LangCode		NVARCHAR(3)
			)
Returns @Result TABLE ( 
				F_SportID			INT,
				F_EventID			INT,
				F_RscCode			NVARCHAR(100),
				F_EventStatusID		INT,
				F_EventDes			NVARCHAR(100),
				F_EventCode			NVARCHAR(100),
				F_EventLongName		NVARCHAR(100),
				F_EventShortName	NVARCHAR(100),
				
				F_DisciplineCode	NVARCHAR(100),
				F_SexCode			INT,
				F_GenderCode		NVARCHAR(100),
				F_StartDate			DATETIME
		)
						
As
BEGIN

	INSERT INTO @Result(F_EventID) VALUES(@EventID)
       
    --Event,Discipline,Sport
    UPDATE @Result SET 
    F_SportID = E.F_SportID,
    F_EventID = B.F_EventID,
    F_EventCode = B.F_EventCode,
    F_StartDate = B.F_OpenDate,
    F_EventStatusID = B.F_EventStatusID,
    F_EventDes = tEventDes.F_EventShortName,
    F_SexCode = tSex.F_SexCode,
    F_GenderCode = tSex.F_GenderCode,
    F_EventLongName = tEventDes.F_EventLongName,
    F_EventShortName = tEventDes.F_EventShortName,
    F_DisciplineCode = d.F_DisciplineCode
    
    FROM @Result AS A 
    LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
    LEFT JOIN TS_Event_Des as tEventDes on A.F_EventID = tEventDes.F_EventID and tEventDes.F_LanguageCode = @LangCode
    LEFT JOIN TS_Discipline_Des AS C ON B.F_DisciplineID = C.F_DisciplineID  and C.F_LanguageCode = @LangCode
    LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = B.F_DisciplineID 
    LEFT JOIN TS_Sport_Des AS E ON E.F_SportID = D.F_SportID and e.F_LanguageCode = @LangCode
    LEFT JOIN TC_Sex as tSex ON tSex.F_SexCode = b.F_SexCode
    WHERE C.F_LanguageCode = @LangCode AND E.F_LanguageCode = @LangCode

	UPDATE A SET
		F_RscCode = dbo.func_VB_GetRscCode(F_EventID, DEFAULT, DEFAULT)
	FROM @Result AS A

	RETURN
END







GO
/************************func_VB_GetEventInfo OVER*************************/


/************************func_VB_GetEventRankList Start************************/GO


--功能：获取一个单项奖牌信息,公共函数，所有奖牌列表都从此获取
--注意：只返回有奖牌的

--2011-05-20	修正写死EventID的错误
--2011-06-23	强制排序
--2012-09-05	改为返回赛事排序信息,包含不含奖牌的内容
--				Rename from [func_VB_GetEventMedalList]
CREATE function [dbo].[func_VB_GetEventRankList]
			(
				@EventID		INT
			)
Returns @Result TABLE ( 
				F_DispPos			INT,
				F_Rank				INT,
				F_MedalID			INT,
				F_MedalCode			NVARCHAR(100),
				F_RegisterID		INT,
				F_RegisterCode		NVARCHAR(100)
		)
						
As
BEGIN

	INSERT INTO @Result 
    SELECT F_EventResultNumber, F_EventRank, F_MedalID, NULL, F_RegisterID, NULL 
    FROM TS_Event_Result 
    WHERE F_EventID = @EventID --AND F_MedalID IS NOT NULL
    ORDER BY F_EventDisplayPosition

	UPDATE A SET
	  F_MedalCode = (SELECT F_MedalCode FROM TC_Medal WHERE F_MedalID = A.F_MedalID)
	, F_RegisterCode = (SELECT F_RegisterCode FROM TR_Register WHERE F_RegisterID = A.F_RegisterID)
	FROM @Result AS A
	
	RETURN
END

/*
GO
SELECT * FROM [func_VB_GetEventMedalList](31)
*/


GO
/************************func_VB_GetEventRankList OVER*************************/


/************************func_VB_GetGroupMatch Start************************/GO


--Provide All matches in all groups

--2012-09-06	Created
CREATE FUNCTION [dbo].[func_VB_GetGroupMatch]
			(
				@EventID		INT,
				@PoolOrTour		INT  -- 1 or 2
			)
Returns @Result TABLE( 
				F_PhaseID			INT,
				F_PhaseOrder		INT,
				F_MatchID			INT,
				F_MatchOrder		INT
			)
As
BEGIN

     INSERT INTO @Result
        SELECT 
			  B.F_PhaseID
			, B.F_Order
			, A.F_MatchID
			, ROW_NUMBER() OVER(PARTITION BY B.F_PhaseID ORDER BY A.F_MatchDate, A.F_StartTime)
	    FROM TS_Match AS A 
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        WHERE D.F_EventID = @EventID AND 
        (	--相当于当@PoolOrTour=1时,只要IsPool=1的值，当@PoolOrTour=2时,只要IsPool<>1的值
			( @PoolOrTour = 1 AND B.F_PhaseIsPool = 1 )
			OR
			( @PoolOrTour = 2 AND B.F_PhaseIsPool = 0 AND F_MatchNum > 100 )
		)
    
		ORDER BY B.F_Order, A.F_MatchDate, A.F_StartTime
		
    /*    ORDER BY B.F_Order, A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), 
		--如果能转换成INT,就按INT排序
		CASE WHEN ISNUMERIC(A.F_RaceNum) = 1 THEN 
			CAST(A.F_RaceNum AS INT)
		ELSE
			0
		END
	*/
	
	RETURN
END

/*
go
select * from dbo.[func_VB_GetGroupMatch](31, 1)
*/


GO
/************************func_VB_GetGroupMatch OVER*************************/


/************************func_VB_GetGroupMember Start************************/GO


--Provide GroupList in event

--2011-06-17	Created
--2011-06-23	Modify error
--2012-09-05	Add PhaseCode
CREATE FUNCTION [dbo].[func_VB_GetGroupMember]
						(
							@EventID       INT
						)
Returns @Result TABLE( 
						F_PhaseOrder		INT,
						F_PhaseID			INT,
						F_PhaseCode			NVARCHAR(100),
						F_MemberOrder		INT,
						F_MemRegID			INT
					 )
As
BEGIN

    INSERT INTO @Result
	SELECT B.F_Order, A.F_PhaseID, F_PhaseCode, F_PhasePosition, F_RegisterID FROM TS_Phase_Position AS A
	INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
	WHERE B.F_EventID = @EventID AND B.F_PhaseIsPool = 1
	ORDER BY B.F_Order, A.F_PhasePosition

	RETURN
END

/*
go
select * from dbo.func_VB_GetGroupMember(31)
*/


GO
/************************func_VB_GetGroupMember OVER*************************/


/************************func_VB_GetGroupStatistics Start************************/GO






----作		  者：王征
----日		  期: 2010-12-20
----使用者:			REPORT,INFO			

--2011-03-16	修改自己对自己的比赛结果为''
--2011-04-08	Modify TeamName
--2011-04-12	delete match stats when it have no matches
--				Add shirt colors\
--2011-06-08	Add RegOrder,此队伍在小组中的签位号
--2011-06-17	Delete whom is 'BYE'
--2012-09-05	Delete NOC,PhaseName
CREATE FUNCTION [dbo].[func_VB_GetGroupStatistics]
						(
						@EventID       INT,
						@LangCode  CHAR(3)
						)
Returns @Result TABLE( 
						F_PhaseOrder		INT,
						F_PhaseID			INT,
						F_PhaseCode			NVARCHAR(100),
						F_DisplayPos		INT,
						
						F_RegOrder			INT,			--Add
						F_RegisterID		INT,
						F_RegisterCode		NVARCHAR(100),
						
						F_Rank				INT,
						F_GroupPoints		INT,
						F_MatchesCount		INT,
						F_MatchesWin		INT,
						F_MatchesLost		INT,
						F_PointsWin			INT,
						F_PointsLost		INT,
						F_PointsRadio		NVARCHAR(10),
						F_SetsWin			INT,
						F_SetsLost		    INT,
						F_SetsRadio			NVARCHAR(10),

						F_MemberCount		INT,			--成员数量
						F_Score1			NVARCHAR(100),
						F_Score2			NVARCHAR(100),
						F_Score3			NVARCHAR(100),
						F_Score4			NVARCHAR(100),
						F_Score5			NVARCHAR(100),
						F_Score6			NVARCHAR(100)
						
					--	F_ShirtDes1			NVARCHAR(100),
					--	F_ShirtDes2			NVARCHAR(100),
					--	F_ShirtDes3			NVARCHAR(100)
					 )
As
BEGIN

    INSERT INTO @Result(F_PhaseOrder, F_PhaseID, F_PhaseCode, F_Rank, F_GroupPoints, 
    F_MatchesWin, F_MatchesLost, F_PointsWin, F_PointsLost, F_SetsWin, F_SetsLost, 
    F_DisplayPos, F_RegisterID, F_RegOrder, F_RegisterCode)
    SELECT F.F_Order, A.F_PhaseID, F.F_PhaseCode,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE A.F_PhaseRank END, 
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE A.F_PhasePoints END,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE [dbo].[func_VB_GetRegisterWinLostInGroup](A.F_PhaseID, A.F_RegisterID, 1, 1) END,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE [dbo].[func_VB_GetRegisterWinLostInGroup](A.F_PhaseID, A.F_RegisterID, 1, 2) END,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE [dbo].[func_VB_GetRegisterWinLostInGroup](A.F_PhaseID, A.F_RegisterID, 3, 1) END,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE [dbo].[func_VB_GetRegisterWinLostInGroup](A.F_PhaseID, A.F_RegisterID, 3, 2) END,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE [dbo].[func_VB_GetRegisterWinLostInGroup](A.F_PhaseID, A.F_RegisterID, 2, 1) END,
    CASE WHEN A.F_RegisterID IS NULL THEN NULL ELSE [dbo].[func_VB_GetRegisterWinLostInGroup](A.F_PhaseID, A.F_RegisterID, 2, 2) END,
    A.F_PhaseDisplayPosition, A.F_RegisterID, G.F_PhasePosition, B.F_RegisterCode
    
    
    FROM TS_Phase_Result AS A
    LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TS_Phase AS F ON A.F_PhaseID = F.F_PhaseID
    LEFT JOIN TS_Phase_Position AS G ON A.F_PhaseID = G.F_PhaseID AND A.F_RegisterID = G.F_RegisterID
    WHERE F.F_EventID = @EventID AND F.F_PhaseIsPool = 1 AND A.F_RegisterID > 0 
    ORDER BY F.F_Order, A.F_PhaseDisplayPosition
    
    UPDATE @Result SET F_MatchesCount = F_MatchesWin + F_MatchesLost
    UPDATE @Result SET F_PointsRadio = CASE WHEN F_PointsLost = 0 THEN 'Max' ELSE CAST(CAST(CAST(F_PointsWin AS DECIMAL(12,3))/ CAST(F_PointsLost AS DECIMAL(12,3)) AS DECIMAL(12,2)) AS NVARCHAR(10)) END
    UPDATE @Result SET F_SetsRadio   = CASE WHEN F_SetsLost   = 0 THEN 'Max' ELSE CAST(CAST(CAST(F_SetsWin   AS DECIMAL(12,3))/ CAST(F_SetsLost   AS DECIMAL(12,3)) AS DECIMAL(12,2)) AS NVARCHAR(10)) END
    
    /*
    UPDATE A SET 
		  F_ShirtDes1 = ( SELECT F_ColorShortName FROM TC_Color_Des WHERE F_ColorID = 
						( SELECT F_Shirt FROM TR_Uniform WHERE F_RegisterID = A.F_RegisterID AND F_Order = 1 ) AND F_LanguageCode = @LangCode )
		, F_ShirtDes2 = ( SELECT F_ColorShortName FROM TC_Color_Des WHERE F_ColorID = 
						( SELECT F_Shirt FROM TR_Uniform WHERE F_RegisterID = A.F_RegisterID AND F_Order = 2 ) AND F_LanguageCode = @LangCode )
		, F_ShirtDes3 = ( SELECT F_ColorShortName FROM TC_Color_Des WHERE F_ColorID = 
						( SELECT F_Shirt FROM TR_Uniform WHERE F_RegisterID = A.F_RegisterID AND F_Order = 3 ) AND F_LanguageCode = @LangCode )
    FROM @Result AS A
    */
    
    --处理轮空
	UPDATE @Result SET
	  F_Rank = NULL
	, F_GroupPoints = NULL
	, F_MatchesCount = NULL
	, F_MatchesWin = NULL
	, F_MatchesLost = NULL
	, F_PointsWin = NULL
	, F_PointsLost = NULL
	, F_PointsRadio = NULL
	, F_SetsWin = NULL
	, F_SetsLost = NULL
	, F_SetsRadio = NULL
--	, F_NOC = 'BYE'
	WHERE F_RegisterID = -1
	
    --处理还没有进行比赛的
	UPDATE @Result SET
	  F_Rank = NULL
	, F_GroupPoints = NULL
	, F_MatchesCount = NULL
	, F_MatchesWin = NULL
	, F_MatchesLost = NULL
	, F_PointsWin = NULL
	, F_PointsLost = NULL
	, F_PointsRadio = NULL
	, F_SetsWin = NULL
	, F_SetsLost = NULL
	, F_SetsRadio = NULL
	WHERE F_MatchesCount = 0
	
	--成员数量
	UPDATE A SET 
		F_MemberCount = (SELECT COUNT(*) FROM @Result WHERE F_PhaseID = A.F_PhaseID AND F_RegisterID > 0 )
	FROM @Result AS A
 

	--处理对阵成绩
	DECLARE @TmpPhaseID		INT
	DECLARE @FetchStatus	INT
	DECLARE CSR_Action CURSOR STATIC FOR 
	SELECT DISTINCT F_PhaseID FROM @Result
	OPEN CSR_Action
	
	FETCH NEXT FROM CSR_Action INTO @TmpPhaseID
	SET @FetchStatus = @@FETCH_STATUS
	
	WHILE( @FetchStatus = 0 )
	BEGIN
		
		--此组中6个位的RegisterID，不足6位的后面为空
		DECLARE @DispPosReg1	INT = NULL
		DECLARE @DispPosReg2	INT = NULL
		DECLARE @DispPosReg3	INT = NULL
		DECLARE @DispPosReg4	INT = NULL
		DECLARE @DispPosReg5	INT = NULL
		DECLARE @DispPosReg6	INT = NULL
						
		SELECT @DispPosReg1 = F_RegisterID FROM @Result WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 1
		SELECT @DispPosReg2 = F_RegisterID FROM @Result WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 2
		SELECT @DispPosReg3 = F_RegisterID FROM @Result WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 3
		SELECT @DispPosReg4 = F_RegisterID FROM @Result WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 4
		SELECT @DispPosReg5 = F_RegisterID FROM @Result WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 5
		SELECT @DispPosReg6 = F_RegisterID FROM @Result WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 6
		
		--DispPos1 将签位1与其他签位的每场比赛比分填入
		UPDATE @Result SET 
		  F_Score1 = ''
		, F_Score2 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg2, @LangCode )
		, F_Score3 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg3, @LangCode )
		, F_Score4 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg4, @LangCode )
		, F_Score5 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg5, @LangCode )
		, F_Score6 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg6, @LangCode )
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 1
		
		--DispPos2 将签位2与其他签位的每场比赛比分填入
		UPDATE @Result SET 
		  F_Score1 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg2, @DispPosReg1, @LangCode )
		, F_Score2 = ''
		, F_Score3 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg2, @DispPosReg3, @LangCode )
		, F_Score4 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg2, @DispPosReg4, @LangCode )
		, F_Score5 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg2, @DispPosReg5, @LangCode )
		, F_Score6 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg2, @DispPosReg6, @LangCode )
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 2
		
		--DispPos3
		UPDATE @Result SET 
		  F_Score1 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg3, @DispPosReg1, @LangCode )
		, F_Score2 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg3, @DispPosReg2, @LangCode )
		, F_Score3 = ''
		, F_Score4 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg3, @DispPosReg4, @LangCode )
		, F_Score5 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg3, @DispPosReg5, @LangCode )
		, F_Score6 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg3, @DispPosReg6, @LangCode )
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 3
		
		--DispPos4
		UPDATE @Result SET 
		  F_Score1 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg4, @DispPosReg1, @LangCode )
		, F_Score2 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg4, @DispPosReg2, @LangCode )
		, F_Score3 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg4, @DispPosReg3, @LangCode )
		, F_Score4 = ''
		, F_Score5 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg4, @DispPosReg5, @LangCode )
		, F_Score6 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg4, @DispPosReg6, @LangCode )
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 4
		
		--DispPos5
		UPDATE @Result SET 
		  F_Score1 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg5, @DispPosReg1, @LangCode )
		, F_Score2 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg5, @DispPosReg2, @LangCode )
		, F_Score3 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg5, @DispPosReg3, @LangCode )
		, F_Score4 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg5, @DispPosReg4, @LangCode )
		, F_Score5 = ''
		, F_Score6 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg5, @DispPosReg6, @LangCode )
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 5
		
		--DispPos6
		UPDATE @Result SET 
		  F_Score1 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg6, @DispPosReg1, @LangCode )
		, F_Score2 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg6, @DispPosReg2, @LangCode )
		, F_Score3 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg6, @DispPosReg3, @LangCode )
		, F_Score4 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg6, @DispPosReg4, @LangCode )
		, F_Score5 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg6, @DispPosReg5, @LangCode )
		, F_Score6 = ''
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 6
		
		FETCH NEXT FROM CSR_Action INTO @TmpPhaseID
		SET @FetchStatus = @@FETCH_STATUS

	END


	RETURN
END

/*
go
select * from dbo.func_VB_GetGroupStatistics(31, 'ENG')
*/


GO
/************************func_VB_GetGroupStatistics OVER*************************/


/************************func_VB_GetIRMList Start************************/GO


----功  能：获取VB的IRM信息,特意在第一行插入了NULL,代表无IRM信息
----使用者: 
----作者：王征 
----日   期: 2011-01-27

--供程序使用
--2011-10-24	Fix an error that just for VB
CREATE function [dbo].[func_VB_GetIRMList]
			(
			
			)
Returns @Result TABLE ( 
				F_IRMID			INT,
				F_IRMCODE		NVARCHAR(20)
		)
						
As
BEGIN
	
	INSERT INTO @Result
	VALUES(NULL, NULL)
	
	--各种ID
	INSERT INTO @Result
	SELECT tIRM.F_IRMID, tIRM.F_IRMCODE FROM TC_IRM AS tIRM
	INNER JOIN TS_Discipline AS tDisc ON tDisc.F_DisciplineID = tIRM.F_DisciplineID AND tDisc.F_Active = 1
	ORDER BY tIRM.F_Order

	RETURN
END

/*
go
select * from func_VB_GetIRMList()
*/






GO
/************************func_VB_GetIRMList OVER*************************/


/************************func_VB_GetLineUpList Start************************/GO


----功  能：获取一场比赛一局的首发名单，返回为7行，最后一行为自由人
----日	期: 2011-02-18
----正确的话，返回7行，前6个为6个位，第7个为自由人
----根据实际设置，返回的有可能是不正确的

--2011-03-04	调换 @ComPos和CurSet参数位置，@CurSet添加默认值
CREATE function [dbo].[func_VB_GetLineUpList]
	(
		@MatchID		INT,		--比赛号
		@CompPos		INT,		-- 1:A方  2:B方
		@CurSet			INT=NULL	--默认当前局
	)
Returns @Result TABLE ( 
				F_Order			INT,
				F_ShirtNumber   INT,      
				F_RegisterID    INT,
				F_RegisterCode	NVARCHAR(100),
				F_ActionTypeID	INT,		--应为19或21
				F_Position		CHAR(1)		--位置， 1-6或L
			)
As
BEGIN

	if ( @CurSet IS NULL )
	BEGIN
		SELECT @CurSet = F_CurSet FROM dbo.func_VB_GetMatchInfo(@MatchID, 'ENG')
	END

	--参数检测
	IF @MatchID < 1 OR @CurSet < 1 OR @CurSet > 5 OR @CompPos < 1 or @CompPos > 2 
	BEGIN
		RETURN
	END
	
	DECLARE @ActPlyInID AS INT --选手上场的ActionID
	SELECT @ActPlyInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Ply_In'
	
	DECLARE @ActLibInID AS INT --自由人上场的ActionID
	SELECT @ActLibInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Lib_In'
	
	IF @ActPlyInID IS NULL OR @ActLibInID IS NULL
	BEGIN
		RETURN
	END
	
	--将技术统计前7行插入此表
	INSERT INTO @Result
	SELECT TOP 7 
	ROW_NUMBER() OVER(ORDER BY F_ActionOrder),
	NULL, F_RegisterID, NULL, F_ActionTypeID, NULL
	
	FROM TS_Match_ActionList
	WHERE	F_MatchID = @MatchID AND 
			F_MatchSplitID = @CurSet AND 
			F_CompetitionPosition = @CompPos AND
			( F_ActionTypeID = @ActPlyInID OR F_ActionTypeID = @ActLibInID )
	ORDER BY F_ActionOrder
	
	UPDATE @Result SET
		F_Position = F_Order
	WHERE F_Order < 7 AND F_ActionTypeID = @ActPlyInID
	
	UPDATE @Result SET
		F_Position = 'L'
	WHERE F_ActionTypeID = @ActLibInID
	
	--填充Code,ShirtNumber	
	UPDATE A SET 
	  F_ShirtNumber = (SELECT F_ShirtNumber FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos AND F_RegisterID = A.F_RegisterID )
	, F_RegisterCode = (SELECT F_RegisterCode FROM TR_Register WHERE F_RegisterID = A.F_RegisterID )
	FROM @Result AS A
		
	RETURN
END

/*
go
select * from func_VB_GetLineUpList(1, 2, 2)
*/


GO
/************************func_VB_GetLineUpList OVER*************************/


/************************func_VB_GetMatchInfo Start************************/GO


----功  能：获取一场比赛基本信息
----使用者: 任何外界使用者,都应该用此函数
----作者：王征 
----日   期: 2010-12-17

--2011-01-13	加RscCode
--2011-01-27	Add IRM_Code, IRMA->IRMIDA, Delete WinTpe
--2011-02-21	Add PhaseDes
--2011-03-04	Modify Referees
--2011-03-08	Add EventInfo
--2011-03-10	Add Speratator
--				Modify Referee funcID
--2011-03-20	RscCode提前
--2011-03-21	获取RscCode通过统一函数
--2011-04-14	Add ',' between PhaseDes1 and PhaseDes2
--2011-04-21	决赛显示"Play off"	
--2011-06-13	Add Week info
--2011-07-25	Add F_WinSetsIrmA
--2011-08-12	match num 为 RaceNum

--2011-10-15	Delete something

--2011-11-02    为了沙排，增加成员名字
--2011-12-05	不再限制RSC code 位数
--2012-08-27	NOC从同一函数获取
--2012-09-06	只保留基本信息
CREATE function [dbo].[func_VB_GetMatchInfo]
			(
				@MatchID		INT,
	            @LangCode		NVARCHAR(3)
			)
Returns @Result TABLE ( 
				F_EventID			INT,
				F_PhaseID			INT,
				F_MatchID			INT,
				F_VenueID			INT,
				F_CourtID			INT,
				F_MatchTypeID		INT,
				F_MatchStatusID		INT,

				F_TeamARegID		INT,
				F_TeamBRegID		INT,
				F_TeamARegCode		NVARCHAR(100),
				F_TeamBRegCode		NVARCHAR(100),

				F_EventDes			NVARCHAR(100),		--Men's
				F_EventDesENG		NVARCHAR(100),		--Men's
				F_EventDesCHN		NVARCHAR(100),		--Men's
				F_EventCode			NVARCHAR(100),		--001
				F_SexCode			INT,				--1,2
				F_GenderCode		NVARCHAR(100),		--M,W
				F_PhaseCode			NVARCHAR(100),
				F_RaceNum			NVARCHAR(100),
				F_MatchNum			NVARCHAR(100),
				F_MatchCode			NVARCHAR(100),
				F_VenueCode			NVARCHAR(100),		--AAC
				F_VenueDes			NVARCHAR(100),		--Aoti Aquatics Centre
				F_CourtDes			NVARCHAR(100),
				F_PhaseDes			NVARCHAR(100),		--GroupA, Final
				F_MatchDes			NVARCHAR(100),		--Men's RoundRobin GroupA Match3
				F_MatchDesENG		NVARCHAR(100),		
				F_MatchDesCHN		NVARCHAR(100),		
				F_MatchStatusCode	INT,				--7
				F_MatchStatusDes	NVARCHAR(100),		--Official
				F_RscCode			NVARCHAR(100),		--VB001MA03
					
				F_MatchDate			DATETIME,		
				F_MatchTime			DATETIME,			--Date & time
				F_Serve				INT,				-- 0:TeamA, 1:TeamB
				F_CurSet			INT,

				F_Order				INT,
				F_SpendTime			INT,
				F_Spectators		NVARCHAR(100),		-- 观众人数

				F_Referee1RegID		INT,
				F_Referee1RegCode	NVARCHAR(100),
				F_Referee1Noc		NVARCHAR(100),
				F_Referee1PrtNameS	NVARCHAR(100),
				F_Referee2RegID		INT,
				F_Referee2RegCode	NVARCHAR(100),
				F_Referee2Noc		NVARCHAR(100),
				F_Referee2PrtNameS	NVARCHAR(100),
				
				
				F_PlayerA1RegID		INT,
				F_PlayerA2RegID		INT,
				F_PlayerB1RegID		INT,
				F_PlayerB2RegID		INT		

		/*		F_Rank				INT,				-- 0:未决 1: A胜, 2: B胜
				F_WinType			INT,				-- 0:未决 1:比分胜 2:因对方IRM而胜利
				F_IRMIDA			INT,				-- 正常: NULL 或 IRM_ID
				F_IRMIDB			INT,
				F_IRMCodeA			NVARCHAR(100),		-- NULL 或 DNS,DNF,DSQ
				F_IRMCodeB			NVARCHAR(100),
				
				F_WinPtsA			INT,
				F_WinPtsB			INT,
				F_WinSetsA			INT,
				F_WinSetsB			INT,
				F_MatchResult		NVARCHAR(100),		-- 3-0
				F_MatchResultSet	NVARCHAR(100),		-- 25:20 3:25
				
				F_WinSetsIrmA		NVARCHAR(100),		--0(DNS)
				F_WinSetsIrmB		NVARCHAR(100), 
		*/
		)
						
As
BEGIN
	
	--各种ID
	INSERT INTO @Result (F_RaceNum, F_EventID, F_MatchID, F_MatchNum, F_MatchCode, F_PhaseID, F_PhaseCode, 
						F_MatchDate, F_MatchTime, F_VenueID, F_CourtID, F_MatchTypeID, F_Order, 
						F_MatchStatusID, F_MatchStatusDes, F_MatchStatusCode, F_SpendTime, F_CurSet, F_Spectators)
    SELECT a.F_RaceNum, b.F_EventID, @MatchID AS F_MatchID, A.F_MatchNum, A.F_MatchCode, A.F_PhaseID, b.F_PhaseCode, 
						A.F_MatchDate, A.F_StartTime, A.F_VenueID, A.F_CourtID, A.F_MatchTypeID, A.F_Order, 
						A.F_MatchStatusID, c.F_StatusShortName, d.F_StatusCode, F_SpendTime, F_MatchComment1, F_MatchComment2
    FROM TS_Match AS A 
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TC_Status AS D ON a.F_MatchStatusID = d.F_StatusID
    LEFT JOIN TC_Status_Des as C on a.F_MatchStatusID = c.F_StatusID and c.F_LanguageCode = @LangCode
    WHERE A.F_MatchID = @MatchID
	 
	--Venue
    UPDATE @Result SET F_VenueDes = C.F_VenueLongName, F_VenueCode = B.F_VenueCode FROM @Result AS A 
    LEFT JOIN TC_Venue AS B ON A.F_VenueID = B.F_VenueID 
    LEFT JOIN TC_Venue_Des AS C ON A.F_VenueID = C.F_VenueID 
    WHERE C.F_LanguageCode = @LangCode
    
    --Court
    UPDATE @Result SET F_CourtDes = B.F_CourtLongName FROM @Result AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID WHERE B.F_LanguageCode = @LangCode
    
    
    --Referee1
    Update @Result Set 
    F_Referee1RegID = tRegister.F_RegisterID,
    F_Referee1RegCode = tRegister.F_RegisterCode,
    F_Referee1Noc = tRegister.F_NOC,
    F_Referee1PrtNameS = tRegDes.F_PrintShortName
    From dbo.TS_Match_Servant as tServant
	Left Join TR_Register as tRegister on tRegister.F_RegisterID = tServant.F_RegisterID
	Left Join TR_Register_Des as tRegDes on tRegDes.F_RegisterID = tServant.F_RegisterID and tRegDes.F_LanguageCode = @LangCode
    Where tServant.F_MatchID = @MatchID and tServant.F_FunctionID = 11
 
	--Referee2
    Update @Result Set 
    F_Referee2RegID = tRegister.F_RegisterID,
    F_Referee2RegCode = tRegister.F_RegisterCode,
    F_Referee2Noc = tRegister.F_NOC,
    F_Referee2PrtNameS = tRegDes.F_PrintShortName
    From dbo.TS_Match_Servant as tServant
	Left Join TR_Register as tRegister on tRegister.F_RegisterID = tServant.F_RegisterID
	Left Join TR_Register_Des as tRegDes on tRegDes.F_RegisterID = tServant.F_RegisterID and tRegDes.F_LanguageCode = @LangCode
    Where tServant.F_MatchID = @MatchID and tServant.F_FunctionID = 12
       
    --Event,Discipline,Sport
    UPDATE @Result SET 
      F_EventID = B.F_EventID
    , F_EventCode = B.F_EventCode
    , F_EventDes = (SELECT F_EventShortName FROM TS_Event_Des WHERE F_EventID = A.F_EventID AND F_LanguageCode = @LangCode)
    , F_EventDesENG = (SELECT F_EventShortName FROM TS_Event_Des WHERE F_EventID = A.F_EventID AND F_LanguageCode = 'ENG')
    , F_EventDesCHN = (SELECT F_EventShortName FROM TS_Event_Des WHERE F_EventID = A.F_EventID AND F_LanguageCode = 'CHN')
    , F_SexCode = tSex.F_SexCode
    , F_GenderCode = tSex.F_GenderCode
    FROM @Result AS A 
    LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
    LEFT JOIN TC_Sex as tSex ON tSex.F_SexCode = b.F_SexCode


	--双方NOC,Name,RscCode
	update @Result Set 
	F_TeamARegID = A.F_RegisterID, 
	F_TeamARegCode = B.F_RegisterCode
	From TS_Match_Result as A 
	Left Join TR_Register as B on b.F_RegisterID = a.F_RegisterID
	Where A.F_MatchID = @MatchID and A.F_CompetitionPosition = 1
	
		
	--Register
	update @Result Set 
	F_TeamBRegID = A.F_RegisterID, 
	F_TeamBRegCode = B.F_RegisterCode
	From TS_Match_Result as A 
	Left Join TR_Register as B on b.F_RegisterID = a.F_RegisterID
	Where A.F_MatchID = @MatchID and A.F_CompetitionPosition = 2
	
	
	--FOR BV
	UPDATE @Result SET
	  F_PlayerB1RegID = B1.F_MemberRegisterID
	, F_PlayerB2RegID = B2.F_MemberRegisterID
	FROM @Result AS A 
	LEFT JOIN TR_Register_Member as B1 on B1.F_RegisterID = A.F_TeamBRegID AND B1.F_Order = 1
	LEFT JOIN TR_Register_Member as B2 on B2.F_RegisterID = A.F_TeamBRegID AND B2.F_Order = 2
	
	UPDATE @Result SET 
		  F_PlayerA1RegID = B1.F_MemberRegisterID
		, F_PlayerA2RegID = B2.F_MemberRegisterID
	FROM @Result AS A 
	LEFT JOIN TR_Register_Member AS B1 on B1.F_RegisterID = A.F_TeamARegID AND B1.F_Order = 1
	LEFT JOIN TR_Register_Member AS B2 on B2.F_RegisterID = A.F_TeamARegID AND B2.F_Order = 2
	
	
	--RSCCode
	UPDATE A SET
		F_RscCode = dbo.func_VB_GetRscCode(DEFAULT, DEFAULT, F_MatchID)
	FROM @Result AS A

	--MatchDes,PhaseDes,Time,date
	--对于VBMatchDes产生方式，
	--预赛，为FatherPhaseComment + PhaseNameComment + MatchNum,
	--决赛，为PhaseComment + MatchNum
	BEGIN
			DECLARE @PhaseID			NVARCHAR(100)
			DECLARE @MatchNum			NVARCHAR(100)
			DECLARE @PhaseDesENG		NVARCHAR(100)
			DECLARE @PhaseDesCHN		NVARCHAR(100)
			DECLARE @MatchDesENG		NVARCHAR(100)
			DECLARE @MatchDesCHN		NVARCHAR(100)
			
			SELECT @PhaseID = F_PhaseID, @MatchNum = F_RaceNum FROM TS_Match WHERE F_MatchID = @MatchID
			SELECT @PhaseDesENG = F_PhaseShortName FROM TS_Phase_Des WHERE F_PhaseID = @PhaseID AND F_LanguageCode = 'ENG'
			SELECT @PhaseDesCHN = F_PhaseShortName FROM TS_Phase_Des WHERE F_PhaseID = @PhaseID AND F_LanguageCode = 'CHN'
			SET @MatchDesENG = 'Match ' + @MatchNum
			SET @MatchDesCHN = '第' + @MatchNum + '场'
			
			IF ( (SELECT COUNT(*) FROM TS_Phase WHERE F_PhaseID = @PhaseID AND F_PhaseIsPool = 1) > 0 )
			BEGIN
				DECLARE @FatherPhaseID INT
				DECLARE @FatherPhaseDesENG NVARCHAR(100)
				DECLARE @FatherPhaseDesCHN NVARCHAR(100)
				
				SELECT @FatherPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID 
				SELECT @FatherPhaseDesENG = F_PhaseShortName FROM TS_Phase_Des WHERE F_PhaseID = @FatherPhaseID AND F_LanguageCode = 'ENG'
				SELECT @FatherPhaseDesCHN = F_PhaseShortName FROM TS_Phase_Des WHERE F_PhaseID = @FatherPhaseID AND F_LanguageCode = 'CHN'
				
				SET @PhaseDesENG = @FatherPhaseDesENG + ', ' + @PhaseDesENG
				SET @PhaseDesCHN = @FatherPhaseDesCHN + ', ' + @PhaseDesCHN
			END
			
			SET @MatchDesENG = @PhaseDesENG + ' ' + @MatchDesENG
			SET @MatchDesCHN = @PhaseDesCHN + ' ' + @MatchDesCHN
			
			UPDATE @Result SET
			  F_MatchDesENG = @MatchDesENG
			, F_MatchDesCHN = @MatchDesCHN
			, F_MatchDes = CASE WHEN @LangCode = 'ENG' THEN @MatchDesENG ELSE @MatchDesCHN END
			, F_PhaseDes = CASE WHEN @LangCode = 'ENG' THEN @PhaseDesENG ELSE @PhaseDesCHN END	
	END
	

	
	RETURN
END

/*
go
select * from [func_VB_GetMatchInfo](1, 'CHN')
*/


GO
/************************func_VB_GetMatchInfo OVER*************************/


/************************func_VB_GetMatchSchedule Start************************/GO


----功  能：获取整个比赛日程, 只获取已编排好之后的比赛
----用  途：所有外围用Competition Schedule的东西,都应从此获取, RPT,INFO,CIS等
----作  者：王征 
----日  期：2011-01-10

--2011-02-18	改名 以前叫getCompetition Sehedule
--				增加天数筛选功能

--2011-02-22	支持按制定第几天获取内容
--2011-03-21	Rsc从统一函数获取
--2011-06-17	修改语言筛选的错误
--2011-12-05	修改RscCode类型，超长不会出错
--2012-09-05	only output needed field
CREATE function [dbo].[func_VB_GetMatchSchedule]
			(
				@IsCurDate	INT = NULL		--0:表示只要当天赛程	NULL:所有赛程	1-N:第N天赛程
			)
Returns @Result TABLE ( 
			F_Order			INT,
			F_MatchID		INT,
			
			F_MatchDay		INT,			--比赛在第几天
			F_MatchDate		DATE,
			F_MatchTime		TIME,
			F_MatchStatusID	INT
		)
						
As
BEGIN
	
	--插入了所有比赛,已编排好的, Order by Date,Time
	INSERT INTO @Result (F_MatchID, F_MatchDate, F_MatchTime, F_MatchStatusID)
	SELECT
		  F_MatchID
		, F_MatchDate 
		, F_StartTime as F_MatchTime
		, F_MatchStatusID
	FROM 
		TS_Match where F_MatchStatusID >= 30
	ORDER BY
		CASE WHEN F_MatchDate IS NULL THEN 1 ELSE 0 END, 
		F_MatchDate, 
		CASE WHEN F_StartTime IS NULL THEN 1 ELSE 0 END, 
		F_StartTime, 
		F_MatchNum	
	
	
	--删除非今日赛程,但这个今日最小为第一天,最大为最后一天
	DECLARE @dateCur		DATE
	DECLARE @dateFirst		DATE
	DECLARE @dateLast		DATE
	
	SELECT 
		@dateCur = GETDATE(),
		@dateFirst = MIN(F_MatchDate),
		@dateLast = MAX(F_MatchDate)
	FROM @Result
	
	IF ( @IsCurDate IS NOT NULL)
	BEGIN
		--如果指定了第几天或者当前,就删掉其他天的比赛
		IF ( @IsCurDate > 0 )
		BEGIN
			SET @dateCur = DATEADD(DAY, @IsCurDate-1, @dateFirst)
		END
		
		IF ( @dateCur < @dateFirst )
		BEGIN 
			SET @dateCur = @dateFirst
		END
		
		IF ( @dateCur > @dateLast )
		BEGIN
			SET @dateLast = @dateLast
		END		
		
		DELETE FROM @Result WHERE F_MatchDate <> @dateCur	
	END		
		
		
	--填入第几天比赛
	UPDATE @Result SET
	F_MatchDay = DATEDIFF(DAY, @dateFirst, F_MatchDate) + 1
	
	--Create Order, cause of the old F_Order is NULL, so the new order is the order of rows
	UPDATE A SET
	F_Order = B.F_NewOrder
	FROM @Result AS A
	LEFT JOIN (SELECT *, ROW_NUMBER() OVER(ORDER BY F_ORDER) AS F_NewOrder FROM @Result ) AS B ON A.F_MatchID = B.F_MatchID
	
	RETURN
END

/*
go
select * from func_VB_GetMatchSchedule(NULL)
*/


GO
/************************func_VB_GetMatchSchedule OVER*************************/


/************************func_VB_GetMatchScoreOneRow Start************************/GO


----功		  能：获取一场比赛的比分
----作		  者：王征 
----日		  期: 2010-09-20 

--2011-02-21	Add PtsACurSet,PtsBCurSet
--2011-04-02	Del PtsACurSetDes
--2011-04-02	Add Point info
--2012-08-27	Add language
--2012-09-05	just arrange
--2012-09-06	Add PtsTotDes
--				Rearrange
CREATE function [dbo].[func_VB_GetMatchScoreOneRow]
	(
		@MatchID				INT,
		@Lang					NVARCHAR(100)
	)
Returns @Result TABLE ( 
		F_Serve				INT,			-- 1:TeamA 2:TeamB NULL:当前无球权信息
		F_CurSet			INT,			-- 1-5：NULL:当前无局信息

		F_PtsA1				INT,		
		F_PtsA2	 			INT,							
		F_PtsA3 			INT,
		F_PtsA4 			INT,	
		F_PtsA5 			INT,

		F_PtsB1				INT,		
		F_PtsB2	 			INT,							
		F_PtsB3 			INT,
		F_PtsB4 			INT,	
		F_PtsB5 			INT,
		
		F_SetTime1			INT,			--此局所用时间,如果在当前局后,为NULL
		F_SetTime2			INT,							
		F_SetTime3			INT,
		F_SetTime4			INT,	
		F_SetTime5			INT,
		F_TimeTotal			INT,			--总用时,分钟数
	

		F_PtsA1Des			NVARCHAR(100),		
		F_PtsA2Des			NVARCHAR(100),							
		F_PtsA3Des			NVARCHAR(100),
		F_PtsA4Des			NVARCHAR(100),	
		F_PtsA5Des			NVARCHAR(100),
		F_PtsATotDes		NVARCHAR(100),
		F_PtsASetDes		NVARCHAR(100),
		F_PtsACurSetDes		NVARCHAR(100),		

		F_PtsB1Des			NVARCHAR(100),		
		F_PtsB2Des			NVARCHAR(100),							
		F_PtsB3Des			NVARCHAR(100),
		F_PtsB4Des			NVARCHAR(100),	
		F_PtsB5Des			NVARCHAR(100),
		F_PtsBTotDes		NVARCHAR(100),
		F_PtsBSetDes		NVARCHAR(100),
		F_PtsBCurSetDes		NVARCHAR(100),		
		
		
		F_Pts1Des			NVARCHAR(100),	-- Set 1
		F_Pts2Des			NVARCHAR(100),	
		F_Pts3Des			NVARCHAR(100),	
		F_Pts4Des			NVARCHAR(100),
		F_Pts5Des			NVARCHAR(100),
		F_PtsTotDes			NVARCHAR(100),	-- 75-80
		F_PtsSetDes			NVARCHAR(100),	-- 3-2
		F_PtsDetail			NVARCHAR(100),	-- 25-8,25-7,4-25,25-3
	
		F_SetTime1Des		NVARCHAR(100),
		F_SetTime2Des		NVARCHAR(100),							
		F_SetTime3Des		NVARCHAR(100),
		F_SetTime4Des		NVARCHAR(100),	
		F_SetTime5Des		NVARCHAR(100),
		F_TimeTotalDes		NVARCHAR(100),
		
		F_RankSet1			INT,			--1:TeamA 2:TeamB 0:未决 NULL:不适用
		F_RankSet2			INT,
		F_RankSet3			INT,
		F_RankSet4			INT,
		F_RankSet5			INT,
		F_RankTot			INT,			--总成绩
		
		F_PointType			INT,			--0:None 1:SetPoint 2:MatchPoint
		F_PointTeam			INT,			--0:None 1:TeamA 2:TeamB
		F_PointCount		INT,			--0:None 1~N
		F_PointCountDes		NVARCHAR(100),	-- '' 1st 2nd 3rd
		
		F_WinType			INT,				-- 0:未决 1:比分胜 2:因对方IRM而胜利
		F_IrmIdA			INT,				-- 正常: NULL 或 IRM_ID
		F_IrmIdB			INT,
		F_IrmCodeA			NVARCHAR(100),		-- NULL 或 DNS,DNF,DSQ
		F_IrmCodeB			NVARCHAR(100),
		
		F_PtsASetIrm		NVARCHAR(100),		--0(DNS)
		F_PtsBSetIrm		NVARCHAR(100)
	)
AS
BEGIN
						
		--先插入一空行
		INSERT INTO @Result(F_Serve) VALUES(NULL)
		
		--总分
		DECLARE @Time		INT
		DECLARE @Win		INT
		DECLARE @PtsA		INT
		DECLARE @PtsB		INT
		DECLARE @SetsA		INT
		DECLARE @SetsB		INT
		DECLARE @RankTot	INT
		DECLARE @Serve		INT
		DECLARE @CurSet		INT
		
		SELECT	  
			  @Win = F_Rank
			, @Serve = F_Service
			, @PtsA = F_WinPoints
			, @SetsA = F_WinSets
			, @RankTot = F_Rank
		FROM TS_Match_Result
		WHERE F_MatchID = @MatchID and F_CompetitionPosition = 1
			
		SELECT
			  @PtsB = F_WinPoints
			, @SetsB = F_WinSets 
		FROM TS_Match_Result
		WHERE F_MatchID = @MatchID and F_CompetitionPosition = 2
				
		SELECT	@Time = F_SpendTime,
				@CurSet = CONVERT(INT, F_MatchComment1) 
		FROM TS_Match 
		WHERE F_MatchID = @MatchID
		
		
		UPDATE @Result SET
			F_CurSet = @CurSet
		  , F_Serve = @Serve
		  , F_RankTot = @RankTot
		  , F_TimeTotal = @Time
		  , F_PtsATotDes = CAST(@PtsA AS NVARCHAR(100))
		  , F_PtsBTotDes = CAST(@PtsB AS NVARCHAR(100))
		  , F_PtsASetDes = CAST(@SetsA AS NVARCHAR(100))
		  , F_PtsBSetDes = CAST(@SetsB AS NVARCHAR(100))
		  
		  
		
		--每局利用的变量			
		DECLARE @SetWin			INT
		DECLARE @SetTime		INT
		DECLARE @SetPtsA		INT
		DECLARE @SetPtsB		INT
		DECLARE @SetPtsADes		NVARCHAR(100)
		DECLARE @SetPtsBDes		NVARCHAR(100)
		
		
		--第1局
		SELECT @SetWin = F_RANK, @SetPtsA = F_Points, @SetPtsADes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 1 and F_CompetitionPosition = 1
				
		SELECT @SetPtsB = F_Points, @SetPtsBDes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 1 and F_CompetitionPosition = 2
				
		SELECT @SetTime = F_SpendTime from TS_Match_Split_Info
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 1
					
		UPDATE @Result SET 
		  F_PtsA1 =   @SetPtsA
		, F_PtsB1 =   @SetPtsB
		, F_PtsA1Des = @SetPtsADes
		, F_PtsB1Des = @SetPtsBDes
		, F_SetTime1= @SetTime
		, F_RankSet1= CASE WHEN @CurSet < 1 THEN NULL ELSE @SetWin END
		
		IF @CurSet = 1
			UPDATE @Result SET F_PtsACurSetDes = F_PtsA1Des, F_PtsBCurSetDes = F_PtsB1Des
		
			
		--第2局	
		SELECT @SetWin = F_RANK, @SetPtsA = F_Points, @SetPtsADes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 2 and F_CompetitionPosition = 1
				
		SELECT @SetPtsB = F_Points, @SetPtsBDes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 2 and F_CompetitionPosition = 2
				
		SELECT @SetTime = F_SpendTime from TS_Match_Split_Info
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 2
					
		UPDATE @Result SET 
		  F_PtsA2 =   @SetPtsA
		, F_PtsB2 =   @SetPtsB
		, F_PtsA2Des = @SetPtsADes
		, F_PtsB2Des = @SetPtsBDes
		, F_SetTime2= @SetTime
		, F_RankSet2= CASE WHEN @CurSet < 2 THEN NULL ELSE @SetWin  END
	
		IF @CurSet = 2
			UPDATE @Result SET F_PtsACurSetDes = F_PtsA2Des, F_PtsBCurSetDes = F_PtsB2Des
		
		
		--第3局	
		SELECT @SetWin = F_RANK, @SetPtsA = F_Points, @SetPtsADes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 3 and F_CompetitionPosition = 1
				
		SELECT @SetPtsB = F_Points, @SetPtsBDes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 3 and F_CompetitionPosition = 2
				
		SELECT @SetTime = F_SpendTime from TS_Match_Split_Info
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 3
					
		UPDATE @Result SET 
		  F_PtsA3 =   @SetPtsA
		, F_PtsB3 =   @SetPtsB
		, F_PtsA3Des = @SetPtsADes
		, F_PtsB3Des = @SetPtsBDes
		, F_SetTime3= @SetTime
		, F_RankSet3= CASE WHEN @CurSet < 3 THEN NULL ELSE @SetWin  END
		
		IF @CurSet = 3
			UPDATE @Result SET F_PtsACurSetDes = F_PtsA3Des, F_PtsBCurSetDes = F_PtsB3Des
	
	
		--第4局	
		SELECT @SetWin = F_RANK, @SetPtsA = F_Points, @SetPtsADes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 4 and F_CompetitionPosition = 1
				
		SELECT @SetPtsB = F_Points, @SetPtsBDes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 4 and F_CompetitionPosition = 2
				
		SELECT @SetTime = F_SpendTime from TS_Match_Split_Info
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 4
					
		UPDATE @Result SET 
		  F_PtsA4 =   @SetPtsA
		, F_PtsB4 =   @SetPtsB
		, F_PtsA4Des = @SetPtsADes
		, F_PtsB4Des = @SetPtsBDes
		, F_SetTime4= @SetTime
		, F_RankSet4= CASE WHEN @CurSet < 4 THEN NULL ELSE @SetWin  END
		
		IF @CurSet = 4
			UPDATE @Result SET F_PtsACurSetDes = F_PtsA4Des, F_PtsBCurSetDes = F_PtsB4Des
		
		
		--第5局	
		SELECT @SetWin = F_RANK, @SetPtsA = F_Points, @SetPtsADes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 5 and F_CompetitionPosition = 1
				
		SELECT @SetPtsB = F_Points, @SetPtsBDes = F_PointsCharDes1 FROM TS_Match_Split_Result 
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 5 and F_CompetitionPosition = 2
				
		SELECT @SetTime = F_SpendTime from TS_Match_Split_Info
		WHERE F_MatchID = @MatchID and F_MatchSplitID = 5
					
		UPDATE @Result SET 
		  F_PtsA5 =  @SetPtsA
		, F_PtsB5 =  @SetPtsB
		, F_PtsA5Des = @SetPtsADes
		, F_PtsB5Des = @SetPtsBDes
		, F_SetTime5= @SetTime
		, F_RankSet5= CASE WHEN @CurSet < 5 THEN NULL ELSE @SetWin  END

		IF @CurSet = 5
		BEGIN
			UPDATE @Result SET
			  F_PtsACurSetDes = F_PtsA5Des
			, F_PtsBCurSetDes = F_PtsB5Des
		END
		
		--SetTimeDes
		UPDATE @Result SET
		  F_SetTime1Des = dbo.func_VB_GetFormatTimeStr(F_SetTime1*60, 1, @Lang)
		, F_SetTime2Des = dbo.func_VB_GetFormatTimeStr(F_SetTime2*60, 1, @Lang)
		, F_SetTime3Des = dbo.func_VB_GetFormatTimeStr(F_SetTime3*60, 1, @Lang)
		, F_SetTime4Des = dbo.func_VB_GetFormatTimeStr(F_SetTime4*60, 1, @Lang)
		, F_SetTime5Des = dbo.func_VB_GetFormatTimeStr(F_SetTime5*60, 1, @Lang)
		, F_TimeTotalDes = dbo.func_VB_GetFormatTimeStr(F_TimeTotal*60, 1, @Lang)
		
		
		--Sets 如果第一局比分为空，那么总分和局分也为空
		UPDATE @Result SET
		  F_PtsASetDes = CASE WHEN LEN(F_PtsA1Des) > 0 THEN F_PtsASetDes ELSE NULL END
		, F_PtsATotDes = CASE WHEN LEN(F_PtsA1Des) > 0 THEN F_PtsATotDes ELSE NULL END 
		, F_PtsBSetDes = CASE WHEN LEN(F_PtsB1Des) > 0 THEN F_PtsBSetDes ELSE NULL END
		, F_PtsBTotDes = CASE WHEN LEN(F_PtsB1Des) > 0 THEN F_PtsBTotDes ELSE NULL END 
		
		UPDATE @Result SET
		  F_Pts1Des = CASE WHEN LEN(F_PtsA1Des) > 0 AND LEN(F_PtsB1Des) > 0 THEN F_PtsA1Des + '-' + F_PtsB1Des ELSE NULL END
		, F_Pts2Des = CASE WHEN LEN(F_PtsA2Des) > 0 AND LEN(F_PtsB2Des) > 0 THEN F_PtsA2Des + '-' + F_PtsB2Des ELSE NULL END
		, F_Pts3Des = CASE WHEN LEN(F_PtsA3Des) > 0 AND LEN(F_PtsB3Des) > 0 THEN F_PtsA3Des + '-' + F_PtsB3Des ELSE NULL END
		, F_Pts4Des = CASE WHEN LEN(F_PtsA4Des) > 0 AND LEN(F_PtsB4Des) > 0 THEN F_PtsA4Des + '-' + F_PtsB4Des ELSE NULL END
		, F_Pts5Des = CASE WHEN LEN(F_PtsA5Des) > 0 AND LEN(F_PtsB5Des) > 0 THEN F_PtsA5Des + '-' + F_PtsB5Des ELSE NULL END
		, F_PtsSetDes = CASE WHEN LEN(F_PtsASetDes) > 0 AND LEN(F_PtsBSetDes) > 0 THEN F_PtsASetDes + '-' + F_PtsBSetDes ELSE NULL END
		, F_PtsTotDes = CASE WHEN LEN(F_PtsATotDes) > 0 AND LEN(F_PtsBTotDes) > 0 THEN F_PtsATotDes + '-' + F_PtsBTotDes ELSE NULL END
		
		--PtsDetail
		UPDATE @Result SET
		  F_PtsDetail = CASE WHEN LEN(F_Pts1Des) > 0 THEN  '' + F_Pts1Des ELSE '' END +
						CASE WHEN LEN(F_Pts2Des) > 0 THEN ',' + F_Pts2Des ELSE '' END +
						CASE WHEN LEN(F_Pts3Des) > 0 THEN ',' + F_Pts3Des ELSE '' END +
						CASE WHEN LEN(F_Pts4Des) > 0 THEN ',' + F_Pts4Des ELSE '' END +
						CASE WHEN LEN(F_Pts5Des) > 0 THEN ',' + F_Pts5Des ELSE '' END
		
					
		--Point
		UPDATE A SET 
		 	  F_PointType = B.F_MatchComment4
			, F_PointTeam = B.F_MatchComment5
			, F_PointCount = B.F_MatchComment6
			, F_PointCountDes =
			CASE 
				WHEN B.F_MatchComment6 = '0' THEN ''
				WHEN B.F_MatchComment6 = '1' THEN '1st'
				WHEN B.F_MatchComment6 = '2' THEN '2nd'
				WHEN B.F_MatchComment6 = '3' THEN '3rd'
				ELSE B.F_MatchComment6 + 'th'
			END 
		FROM @Result AS A
		INNER JOIN TS_Match AS B ON B.F_MatchID = @MatchID
					
				
		--写入双方IRM,WinType等信息
		UPDATE A SET 
			  A.F_IrmIdA = B.F_IRMID
			, A.F_IrmCodeA = C.F_IRMCODE
		FROM @Result AS A
		LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 1
		LEFT JOIN TC_IRM AS C ON C.F_IRMID = B.F_IRMID
	
		UPDATE A SET 
			  A.F_IrmIdB = B.F_IRMID
			, A.F_IrmCodeB = C.F_IRMCODE
		FROM @Result AS A
		LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = @MatchID AND b.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM AS C ON C.F_IRMID = B.F_IRMID 
		
		
		--处理WinSetsIrm
		UPDATE @Result SET
			  F_PtsASetIrm = CASE WHEN F_IRMCodeA IS NOT NULL THEN F_PtsASetDes + ' (' + F_IRMCodeA + ')' ELSE F_PtsASetDes END
			, F_PtsBSetIrm = CASE WHEN F_IRMCodeB IS NOT NULL THEN F_PtsBSetDes + ' (' + F_IRMCodeB + ')' ELSE F_PtsBSetDes END
			, F_WinType = CASE WHEN F_RankTot < 1 THEN 0 WHEN F_IrmIdA > 0 OR F_IrmIdA > 0 THEN 2 ELSE 1 END 

	RETURN
END

/*
go
select * FROM dbo.func_VB_GetMatchScoreOneRow(145, 'CHN')
*/


GO
/************************func_VB_GetMatchScoreOneRow OVER*************************/


/************************func_VB_GetMatchStartList Start************************/GO


----功  能：获取一场比赛出场名单,带技术统计,
----使用者: 所有外面需要StartList的,都必须调用此函数实现, RPT,INFO,CIS等
----作	者：王征 
----日	期: 2010-10-14

--2011-01-13	F_Birth_Date -> F_DateOfBirth
--				Add F_Order, 排序方法

--2011-03-22	两队分别统计
--2011-05-25	添加是否需要STAT的开关
--2012-09-05	Only output most needed information
CREATE function [dbo].[func_VB_GetMatchStartList]
	(
		@MatchID	INT,
		@NeedStat	INT=0	--默认不需要技术统计
	)
Returns @Result TABLE ( 
				F_Order			INT,
				F_TeamRegID		INT,
				F_CompPos		INT,
				F_RegisterID    INT,
				F_FuncID		INT,
				F_ShirtNumber   INT,                                
				
				F_Height		INT,
				F_Weight		INT,
				F_DateOfBirth	DATETIME,
				F_SpikeHigh		NVARCHAR(100),
				F_BlockHigh		NVARCHAR(100),
				
				F_ATK_SUC		INT,
				F_BLO_SUC		INT,
				F_SRV_SUC		INT,
				F_SUC_TOT		INT,	--得分总数 F_ATK_SUC+F_BLO_SUC+F_SRV_SUC
				F_PER_TEM		FLOAT	--得分数占全队百分比 F_SUC_TOT / 全队F_SUC_TOT
						)
As
BEGIN
		
	--填充两队队员ID
	INSERT INTO @Result(F_Order, F_TeamRegID, F_CompPos, F_RegisterID, F_FuncID, F_ShirtNumber, F_Height, F_Weight, F_DateOfBirth)
	SELECT 
		  ROW_NUMBER() OVER(PARTITION BY tMatchMember.F_CompetitionPosition ORDER BY 
		  CASE WHEN ISNUMERIC(F_ShirtNumber) = 1 THEN CAST(F_ShirtNumber AS INT) ELSE 0 END )
		, tMatchResult.F_RegisterID
		, tMatchMember.F_CompetitionPosition
		, tMatchMember.F_RegisterID
		, tMatchMember.F_FunctionID
		, tMatchMember.F_ShirtNumber
		, tRegister.F_Height
		, tRegister.F_Weight
		, tRegister.F_Birth_Date
	FROM TS_Match_Member as tMatchMember
	LEFT JOIN TR_Register as tRegister ON tMatchMember.F_RegisterID = tRegister.F_RegisterID
	LEFT JOIN TS_Match_Result as tMatchResult ON tMatchResult.F_MatchID = tMatchMember.F_MatchID AND tMatchResult.F_CompetitionPosition = tMatchMember.F_CompetitionPosition --TeamRegID
	WHERE tMatchMember.F_MatchID = @MatchID 
	ORDER BY F_CompetitionPosition 
	,CASE WHEN ISNUMERIC(F_ShirtNumber) = 1 
		THEN CAST(F_ShirtNumber AS INT)
		ELSE 0
	END
				
	--填充Code,FunctionID, SpikeHigh, BlockHigh
	UPDATE A SET	
	  A.F_SpikeHigh = ( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Spike' AND F_RegisterID = A.F_RegisterID )
	, A.F_BlockHigh = ( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Block' AND F_RegisterID = A.F_RegisterID )
	FROM @Result AS A

	IF(@NeedStat = 1)
	BEGIN
	
		--填充STAT,都是本场比赛前的
		UPDATE @Result SET
		  F_ATK_SUC = dbo.func_VB_GetStatValueByStatCode(1, F_RegisterID, @MatchID, 0, 'ATK_SUC')
		, F_BLO_SUC = dbo.func_VB_GetStatValueByStatCode(1, F_RegisterID, @MatchID, 0, 'BLO_SUC')
		, F_SRV_SUC = dbo.func_VB_GetStatValueByStatCode(1, F_RegisterID, @MatchID, 0, 'SRV_SUC')
		
		--计算STAT总计
		UPDATE @Result SET
		  F_SUC_TOT = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC

		--整个队伍得分,通过这个计算百分比
		DECLARE @TeamSucTotA FLOAT
		DECLARE @TeamSucTotB FLOAT
		SELECT @TeamSucTotA = SUM(F_SUC_TOT) FROM @Result WHERE F_CompPos = 1
		SELECT @TeamSucTotB = SUM(F_SUC_TOT) FROM @Result WHERE F_CompPos = 2
		
		--计算每个人得分的百分比
		UPDATE @Result SET
		  F_PER_TEM = CASE WHEN @TeamSucTotA = 0 THEN 0 ELSE F_SUC_TOT / @TeamSucTotA END
		WHERE F_CompPos = 1
		
		UPDATE @Result SET
		  F_PER_TEM = CASE WHEN @TeamSucTotB = 0 THEN 0 ELSE F_SUC_TOT / @TeamSucTotB END
		WHERE F_CompPos = 2
	END
	
	RETURN

END

/*
go
select * from [func_VB_GetMatchStartList](1, 0)
*/





GO
/************************func_VB_GetMatchStartList OVER*************************/


/************************func_VB_GetMatchStatActionList_Step1_OriginList Start************************/GO


----功  能：获取技术统计类表 Step1:获取列表,并分出回合. 不进行计算
----使用者：此函数只负责获取列表,分出回合; 推算比分,查错,计算轮转在Step2中进行
----作  者：王征 
----日	期: 2010-10-14

--2011-03-23	默认当前局
CREATE function [dbo].[func_VB_GetMatchStatActionList_Step1_OriginList]
	(
		@MatchID				INT,
		@SetNum					INT=NULL
	)
Returns @Result TABLE ( 
							F_Order				INT,			--序号,正常下,前7行应该是双方首发,Rally值为0
							F_RallyNum			INT,			--回合数,只在没回合最后一个动作,显示,其余为NULL
							F_IsLastRowInRally	INT,			--此行为此Rally最后一行
							
							F_ActionNumID_A		INT,			--动作所对应的ActionNumberID, 无动作为NULL
							F_ActionRegID_A		INT,			--产生动作的运动员ID,如果为队伍类别,为NULL
							F_ActionTypeID_A	INT,			--此动作类别,无动作为NULL
							F_ActionEffect_A	INT,			--此动作对比分的影响 -1,0,1  对于换人:NULL
							F_ActionKindID_A	INT,			--此动作详细类别,主要为了显示颜色用, 1:未得失分 2:得分，3:失分 4:队员上场 5:队员下场 6:自由人上场 7:自由人下场 8:有错误的
							
							F_ActionNumID_B		INT,
							F_ActionRegID_B		INT,
							F_ActionTypeID_B	INT,
							F_ActionEffect_B	INT,
							F_ActionKindID_B	INT
						)
As
BEGIN

	--一些常量值
	DECLARE @ActIdPlayIn	INT=19
	DECLARE @ActIdPlayOut	INT=20
	DECLARE @ActIdLibIn		INT=21
	DECLARE @ActIdLibOut	INT=22
	DECLARE @ActIdSrvSuc	INT=7
	DECLARE @ActIdSrvCnt	INT=8
	DECLARE @ActIdSrvFlt	INT=9
	
	--游标用的临时变量	
	DECLARE @TmpActionNumberID_A		INT
    DECLARE @TmpActionTypeID_A			INT
    DECLARE @TmpActionEffect_A			INT
    DECLARE @TmpActionKindID_A			INT
    DECLARE @TmpRegisterID_A			INT
    
    DECLARE @TmpActionNumberID_B		INT
    DECLARE @TmpActionTypeID_B			INT
    DECLARE @TmpActionEffect_B			INT
    DECLARE @TmpActionKindID_B			INT
    DECLARE @TmpRegisterID_B			INT
    
    IF (@SetNum IS NULL) 
		SELECT @SetNum = CAST(F_MatchComment1 AS INT) FROM TS_Match WHERE F_MatchID = @MatchID
    
    --定义TeamA游标
    DECLARE CSR_Action_A CURSOR STATIC FOR 
		SELECT 
		F_ActionNumberID, A.F_ActionTypeID, F_ActionEffect, 
		CASE 
			WHEN A.F_ActionTypeID IS NULL			THEN NULL
			WHEN A.F_ActionTypeID = @ActIdPlayIn	THEN 4
			WHEN A.F_ActionTypeID = @ActIdPlayOut	THEN 5
			WHEN A.F_ActionTypeID = @ActIdLibIn		THEN 6
			WHEN A.F_ActionTypeID = @ActIdLibOut	THEN 7
			WHEN F_ActionEffect = 0					THEN 1
			WHEN F_ActionEffect = 1					THEN 2
			WHEN F_ActionEffect = -1				THEN 3
			ELSE NULL
		END AS F_ActionKindID,
		F_RegisterID
		FROM TS_Match_ActionList AS A
		LEFT JOIN TD_ActionType AS B ON B.F_ActionTypeID = A.F_ActionTypeID
		 WHERE F_CompetitionPosition = 1 AND F_MatchID = @MatchID AND F_MatchSplitID = @SetNum 
		ORDER BY F_ActionOrder
	
	--定义TeamB游标
    DECLARE CSR_Action_B CURSOR STATIC FOR 
		SELECT F_ActionNumberID, A.F_ActionTypeID, F_ActionEffect, 
		CASE 
			WHEN A.F_ActionTypeID IS NULL			THEN NULL
			WHEN A.F_ActionTypeID = @ActIdPlayIn	THEN 4
			WHEN A.F_ActionTypeID = @ActIdPlayOut	THEN 5
			WHEN A.F_ActionTypeID = @ActIdLibIn		THEN 6
			WHEN A.F_ActionTypeID = @ActIdLibOut	THEN 7
			WHEN F_ActionEffect = 0					THEN 1
			WHEN F_ActionEffect = 1					THEN 2
			WHEN F_ActionEffect = -1				THEN 3
			ELSE NULL
		END AS F_ActionKindID,
		F_RegisterID
		FROM TS_Match_ActionList AS A
		LEFT JOIN TD_ActionType AS B ON B.F_ActionTypeID = A.F_ActionTypeID
		 WHERE F_CompetitionPosition = 2 AND F_MatchID = @MatchID AND F_MatchSplitID = @SetNum 
		ORDER BY F_ActionOrder
		
		
	--计数器
    DECLARE @cntRally		INT = 0		--回合计数器
    DECLARE @cntRow			INT = 0		--行计数器
		
	DECLARE @FetchStatusA	INT
	DECLARE @FetchStatusB	INT
		
	OPEN CSR_Action_A
	OPEN CSR_Action_B
	
	FETCH NEXT FROM CSR_Action_A INTO @TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A 
	SET @FetchStatusA = @@FETCH_STATUS
	
	FETCH NEXT FROM CSR_Action_B INTO @TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B 
	SET @FetchStatusB = @@FETCH_STATUS
	
	
	--处理首发,只把A,B平行的首发都读取出来
		--先处理双方都有的部分,一行添加A,B两个内容,首发,自由人都算
			WHILE ( @FetchStatusA = 0 
				AND @FetchStatusB = 0
				AND	( @TmpActionTypeID_A = @ActIdPlayIn OR @TmpActionTypeID_A = @ActIdLibIn ) 
				AND ( @TmpActionTypeID_B = @ActIdPlayIn OR @TmpActionTypeID_B = @ActIdLibIn )) 
			BEGIN
				SET @cntRow = @cntRow + 1
				INSERT INTO @Result(F_Order, 
					F_ActionNumID_A, F_ActionTypeID_A, F_ActionKindID_A, F_ActionRegID_A,
					F_ActionNumID_B, F_ActionTypeID_B, F_ActionKindID_B, F_ActionRegID_B )
				VALUES( @cntRow,
					@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionKindID_A, @TmpRegisterID_A,
					@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionKindID_B, @TmpRegisterID_B )
								
				--往下移动一行
				FETCH NEXT FROM CSR_Action_A INTO 
					@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
				SET @FetchStatusA = @@FETCH_STATUS
				
				FETCH NEXT FROM CSR_Action_B INTO 
					@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
				SET @FetchStatusB = @@FETCH_STATUS				
			END
		
		--如果A比B多出来的,其实这是错误的,每行里只有A的内容
			WHILE( @FetchStatusA = 0 AND ( @TmpActionTypeID_A = @ActIdPlayIn OR @TmpActionTypeID_A = @ActIdLibIn ) )
			BEGIN
				SET @cntRow = @cntRow + 1
				INSERT INTO @Result(F_Order, 
					F_ActionNumID_A, F_ActionTypeID_A, F_ActionKindID_A, F_ActionRegID_A)
				VALUES( @cntRow,
					@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionKindID_A, @TmpRegisterID_A)
					
				FETCH NEXT FROM CSR_Action_A INTO 
					@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
				SET @FetchStatusA = @@FETCH_STATUS
			END
		
		--如果B比A多出来的,其实这是错误的,每行里只有B的内容
			WHILE( @FetchStatusB = 0 AND ( @TmpActionTypeID_B = @ActIdPlayIn OR @TmpActionTypeID_B = @ActIdLibIn ) )
			BEGIN
				SET @cntRow = @cntRow + 1
				INSERT INTO @Result(F_Order, 
					F_ActionNumID_B, F_ActionTypeID_B, F_ActionKindID_B, F_ActionRegID_B)
				VALUES( @cntRow,
					@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionKindID_B, @TmpRegisterID_B)
					
				FETCH NEXT FROM CSR_Action_B INTO 
					@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
				SET @FetchStatusB = @@FETCH_STATUS
			END
		
		UPDATE @Result SET F_RallyNum = @cntRally WHERE F_RallyNum IS NULL
		UPDATE @Result SET F_IsLastRowInRally = 1 WHERE F_Order = @cntRow
	--首发处理完毕 
	
		
	--下面处理技术统计	
	
		--当期Rally的起始行
		DECLARE @CurRallyStartRow		INT = 0		
				
		--当前Action是否对比分有影响,有影响代表了一个Rally的结束
		--每个Rally两队最后影响比分的Action必须都在最后一行
		--所以我们先插入两队非影响比分的Action,直到碰到影响比分的Action后,在同行一起插入,便实现了此要求
		DECLARE @EffectScoreInRallyA	INT = @TmpActionEffect_A
		DECLARE @EffectScoreInRallyB	INT = @TmpActionEffect_B
		
		--循环每个Rally,直到所有记录集都取完
		WHILE( @FetchStatusA = 0 OR @FetchStatusB = 0 )	
		BEGIN
			
			--设置当前Rally的起始行,当整个Rally添加完之后,检索用
			SET @CurRallyStartRow = @cntRow
				
			--先把双方未影响得分的东东,填入@Result
			--利用STAT的得分标志来确定回合的分割,但有时,第一个STAT就是得/失分的,
			--所以每回合第一个技术统计不做得/失分标志的判断			
			
				--先插入双方都有的不影响得/失分的Action
				WHILE
					(	@FetchStatusA = 0 
					AND @FetchStatusB = 0 
					AND @EffectScoreInRallyA = 0 
					AND @EffectScoreInRallyB = 0 
				   )
				BEGIN
					SET @cntRow = @cntRow + 1
					INSERT INTO @Result(F_Order, 
						F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A,
						F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B )
					VALUES( @cntRow,
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A,
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B )
									
					FETCH NEXT FROM CSR_Action_A INTO 
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
					SET @FetchStatusA = @@FETCH_STATUS
					SET @EffectScoreInRallyA = @TmpActionEffect_A
					
					FETCH NEXT FROM CSR_Action_B INTO 
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
					SET @FetchStatusB = @@FETCH_STATUS
					SET @EffectScoreInRallyB = @TmpActionEffect_B
				END
				
				--如果A有比B多出来的非影响得/失分Action,单独插入
				WHILE( @FetchStatusA = 0 AND @EffectScoreInRallyA = 0 )
				BEGIN
					SET @cntRow = @cntRow + 1
					INSERT INTO @Result(F_Order, 
						F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A)
					VALUES( @cntRow,
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A )
						
					FETCH NEXT FROM CSR_Action_A INTO 
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
					SET @FetchStatusA = @@FETCH_STATUS	
					SET @EffectScoreInRallyA = @TmpActionEffect_A
				END
				
				--如果B有比A多出来的非影响得/失分Action,单独插入
				WHILE( @FetchStatusB = 0 AND @EffectScoreInRallyB = 0 )
				BEGIN
					SET @cntRow = @cntRow + 1
					INSERT INTO @Result(F_Order, 
						F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B)
					VALUES( @cntRow,
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B )
						
					FETCH NEXT FROM CSR_Action_B INTO 
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
					SET @FetchStatusB = @@FETCH_STATUS	
					SET @EffectScoreInRallyB = @TmpActionEffect_B
				END
			
			--正常情况下,还剩下的,应该就是双方影响比分的Action,当然,还有A或B记录集到末尾的情况都需要处理
			
				--如果下一条就是双方都有得/失比分的Action,代表一个Rally完整插入,可能还会有错误,但起码双方都有结尾
				--如果至少有一方不是,说明至少有一方到了末尾,还没有出现得失分的Action,只能插入存在Action的一方
				IF 
				(	
						@FetchStatusA = 0 
					AND @FetchStatusB = 0 
					AND @EffectScoreInRallyA <> 0 
					AND @EffectScoreInRallyB <> 0 
				)
				BEGIN
					SET @cntRow = @cntRow + 1
					INSERT INTO @Result(F_Order, 
						F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A,
						F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B )
					VALUES( @cntRow,
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A,
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B )
									
					FETCH NEXT FROM CSR_Action_A INTO 
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
					SET @FetchStatusA = @@FETCH_STATUS
					SET @EffectScoreInRallyA = @TmpActionEffect_A
					
					FETCH NEXT FROM CSR_Action_B INTO 
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
					SET @FetchStatusB = @@FETCH_STATUS
					SET @EffectScoreInRallyB = @TmpActionEffect_B
				END
				ELSE
				IF ( @FetchStatusA = 0 AND @EffectScoreInRallyA <> 0 ) --只有A存在影响比分的Action
				BEGIN 
					SET @cntRow = @cntRow + 1
					INSERT INTO @Result(F_Order, 
						F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A)
					VALUES( @cntRow,
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A )
						
					FETCH NEXT FROM CSR_Action_A INTO 
						@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
					SET @FetchStatusA = @@FETCH_STATUS	
					SET @EffectScoreInRallyA = @TmpActionEffect_A
				END
				ELSE
				IF ( @FetchStatusB = 0 AND @EffectScoreInRallyB <> 0 ) --只有B存在影响比分的Action
				BEGIN
					SET @cntRow = @cntRow + 1
					INSERT INTO @Result(F_Order, 
						F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B)
					VALUES( @cntRow,
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B )
						
					FETCH NEXT FROM CSR_Action_B INTO 
						@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
					SET @FetchStatusB = @@FETCH_STATUS	
					SET @EffectScoreInRallyB = @TmpActionEffect_B
				END
			
			
			--插入Rally信息
			IF ( 
				(	--双方都有得失分信息
					( SELECT COUNT(F_ActionEffect_A) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_A <> 0 ) > 0  AND
					( SELECT COUNT(F_ActionEffect_B) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_B <> 0 ) > 0      
				) 
				OR
				(	--A方有得失分信息，B方没数据了
					( SELECT COUNT(F_ActionEffect_A) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_A <> 0 ) > 0  AND
					@FetchStatusB <> 0    
				)
				OR
				(	--B方有得失分信息，A方没数据了
					( SELECT COUNT(F_ActionEffect_B) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_B <> 0 ) > 0  AND
					@FetchStatusA <> 0    
				)
			   )
			BEGIN 
				SET @cntRally = @cntRally + 1
				UPDATE @Result SET F_RallyNum = @cntRally WHERE F_RallyNum IS NULL
				UPDATE @Result SET F_IsLastRowInRally = 1 WHERE F_Order = @cntRow
			END
						
		END --循环每个Rally
		
	--每个Rally处理完	
	
	CLOSE CSR_Action_A
	CLOSE CSR_Action_B
	DEALLOCATE CSR_Action_A
	DEALLOCATE CSR_Action_B

	RETURN
END

/*
go
select * from func_VB_GetMatchStatActionList_Step1_CreateOriginList(1, 1)
*/















GO
/************************func_VB_GetMatchStatActionList_Step1_OriginList OVER*************************/


/************************func_VB_GetMatchStatActionList_Step2_ActionList Start************************/GO


----功  能：获取某场比赛某局的技术统计列表
----使用者：所有外界获取,必须使用此函数, RPT,INFO,CIS,包括程序界面
----作  者：王征 
----日	期: 2010-10-14

--2011-03-03	修正一首发TeamB错误
--2011-06-02	修正了第一球不轮转
--2011-07-25	强制不轮转
CREATE function [dbo].[func_VB_GetMatchStatActionList_Step2_ActionList](
		@MatchID				INT,
		@SetNum					INT
)RETURNS 
	@tblAction TABLE (

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
				F_IsSetter			INT				--1:为二传手，NULL:正常
			)
	AS
	BEGIN

	--一些常量值
	DECLARE @ActIdSrvSuc	INT=7
	DECLARE @ActIdSrvCnt	INT=8
	DECLARE @ActIdSrvFlt	INT=9
	
	DECLARE @ActIdPlayIn	INT=19
	DECLARE @ActIdPlayOut	INT=20
	DECLARE @ActIdLibIn		INT=21
	DECLARE @ActIdLibOut	INT=22
	DECLARE @ActIdOppErr	INT=23
	DECLARE @ActIdTemFlt	INT=24
	
   	--场上人员站位图
	DECLARE @tblPositon TABLE(
			F_CompPos	INT,
			F_Position	INT,
			F_RegID		INT,
			F_PosTurn	INT		--轮转后此人位置
		)
	
	DECLARE @PosTurnA	INT = 0			--双方轮转次数
	DECLARE @PosTurnB	INT	= 0
	DECLARE @LastRallyEffect INT = NULL	--上一回合输赢信息，用来计算轮转,初始值需为NULL,表示第一回合之前,
										--在第一回合时,会被置为发球的一方,已实现第一球的轮转
    
    --初始化场上人员站位图
    INSERT INTO @tblPositon VALUES(1, 1, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 2, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 3, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 4, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 5, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 6, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 7, NULL, NULL)	--自由人位
    INSERT INTO @tblPositon VALUES(2, 1, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 2, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 3, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 4, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 5, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 6, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 7, NULL, NULL)

	--获取Action列表
	INSERT INTO @tblAction(F_Order, F_RallyNum, F_IsLastRowInRally
		, F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A
		, F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B )
	SELECT 
	  F_Order, F_RallyNum, F_IsLastRowInRally
	, F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A
	, F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B
	 FROM dbo.func_VB_GetMatchStatActionList_Step1_OriginList(@MatchID, @SetNum)
		
	--循环A,B队用的变量,游标
	DECLARE @TmpOrder				INT	--第几行
	DECLARE @TmpRallyNum			INT	--第几回合
	DECLARE @TmpIsLastRowInRally	INT --是回合的最后一行
	
	DECLARE @TmpActionID_A			INT	--技术统计动作ID
	DECLARE @TmpActionTypeID_A		INT	--技术统计类型ID
	DECLARE @TmpRegID_A				INT	--队员ID
	DECLARE @TmpActionID_B			INT
	DECLARE @TmpActionTypeID_B		INT	--技术统计类型ID
	DECLARE @TmpRegID_B				INT
	DECLARE @FetchStatus			INT	--游标状态
	
	DECLARE CSR_Action CURSOR STATIC FOR 
	SELECT F_Order, F_RallyNum, F_IsLastRowInRally, 
	F_ActionTypeID_A, F_ActionKindID_A, F_ActionRegID_A, 
	F_ActionTypeID_B, F_ActionKindID_B, F_ActionRegID_B FROM @tblAction

	OPEN CSR_Action
	
	FETCH NEXT FROM CSR_Action INTO @TmpOrder, @TmpRallyNum, @TmpIsLastRowInRally, 
								@TmpActionID_A, @TmpActionTypeID_A, @TmpRegID_A, 
								@TmpActionID_B, @TmpActionTypeID_B, @TmpRegID_B
	SET @FetchStatus = @@FETCH_STATUS
			
	--将首发信息装入站位图	
		--DECLARE @LastRowInRally	INT = 0
	
		--将首发信息填入站位图,就是只处理首发部分内容,RallyNum=0	
		WHILE( @FetchStatus = 0 AND @TmpRallyNum = 0 )
		BEGIN
		
			--判断TeamA上场动作是否合法,是:填入站位图,否:不填入首发图并设为错误
			IF ( 
					( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A) > 0 --站位图中已有此人，说明重复上场
				 OR ( @TmpActionID_A <> @ActIdPlayIn AND @TmpActionID_A <> @ActIdLibIn ) --不是队员上场，也不是自由人上场
				 OR ( @TmpActionID_A = @ActIdPlayIn AND @TmpOrder > 6 ) --在前6个位置出现了自由人上场
				 OR	( @TmpActionID_A = @ActIdLibIn  AND @TmpOrder < 7 ) --在第7个位置及以后出现了非自由人
				 OR ( @TmpOrder > 7 )	--出现了7个以上人
			   )
			BEGIN
				--设置此动作为错误，并且不填入图
				UPDATE @tblAction SET F_ActionIsError_A = 1 
				WHERE F_Order = @TmpOrder
			END	
			ELSE
			BEGIN
				--检测完毕，将此上场动作填入图
				UPDATE @tblPositon SET F_RegID = @TmpRegID_A
				WHERE F_CompPos = 1 AND F_Position = @TmpOrder
			END
			
			--判断TeamB上场动作是否合法,是:填入站位图,否:不填入首发图并设为错误
			IF ( 
					( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B) > 0 --站位图中已有此人，说明重复上场
				 OR ( @TmpActionID_B <> @ActIdPlayIn AND @TmpActionID_B <> @ActIdLibIn ) --不是队员上场，也不是自由人上场
				 OR ( @TmpActionID_B = @ActIdPlayIn AND @TmpOrder > 6 ) --在前6个位置出现了自由人上场
				 OR	( @TmpActionID_B = @ActIdLibIn  AND @TmpOrder < 7 ) --在第7个位置及以后出现了非自由人
				 OR ( @TmpOrder > 7 )	--出现了7个以上人
			   )
			BEGIN
				--设置此动作为错误，并且不填入图
				UPDATE @tblAction SET F_ActionIsError_B = 1 
				WHERE F_Order = @TmpOrder
			END	
			ELSE
			BEGIN
				--检测完毕，将此上场动作填入图
				UPDATE @tblPositon SET F_RegID = @TmpRegID_B
				WHERE F_CompPos = 2 AND F_Position = @TmpOrder
			END
			
			--SET @LastRowInRally = @TmpOrder
			
			FETCH NEXT FROM CSR_Action INTO @TmpOrder, @TmpRallyNum, @TmpIsLastRowInRally
			, @TmpActionID_A, @TmpActionTypeID_A, @TmpRegID_A
			, @TmpActionID_B, @TmpActionTypeID_B, @TmpRegID_B
			SET @FetchStatus = @@FETCH_STATUS
		END
		
		--对首发信息进行整体判断
			--如果发现首发站位有未填入的,就认为首发有错,否则就没错
			IF ( (SELECT COUNT(*) FROM @tblPositon WHERE F_RegID IS NULL) > 0  )	
			BEGIN
				UPDATE @tblAction SET F_RallyEffect = -1 WHERE F_RallyNum = 0 AND F_IsLastRowInRally = 1
			END
			ELSE
			BEGIN
				UPDATE @tblAction SET F_RallyEffect =  0 WHERE F_RallyNum = 0 AND F_IsLastRowInRally = 1
			END
					
	--将首发信息装入站位图,完成
	
	
	--循环每回合, 每个动作，进行查错
		DECLARE @OrderInRally		INT = 1				--这是此Rally中第几个动作
		DECLARE @CurRallyIsError	INT = 0				--此Rally有错误
		DECLARE @TeamAServe			INT = 0				--TeamA发球次数 发一次加1,主要为了识别多次发球
		DECLARE @TeamAResult		INT = 0				--TeamA此Rally结果 赢: 1 输: -1
		DECLARE @TeamBServe			INT = 0
		DECLARE @TeamBResult		INT = 0

		WHILE ( @FetchStatus = 0 )
		BEGIN
				
			--TeamA的发球类动作
			IF ( @TmpActionID_A >= 7 AND @TmpActionID_A <= 9 ) 
			BEGIN
				SET @TeamAServe = @TeamAServe + 1 --累加发球次数
				
				--A方或B方已经发过球了, 发球动作有可能不在第一行,因为有换人动作
				IF ( @TeamAServe > 1 OR @TeamBServe > 1 )--OR @OrderInRally <> 1 ) 
				BEGIN
					UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
				END
			END
			
			--TeamB的发球类动作
			IF ( @TmpActionID_B >= 7 AND @TmpActionID_B <= 9 ) 
			BEGIN
				SET @TeamAServe = @TeamAServe + 1 --累加发球次数
				
				IF ( @TeamAServe > 1 OR @TeamBServe > 1 )--OR @OrderInRally <> 1 ) 
				BEGIN
					UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
				END
			END
			
			--TeamA的得失分
			IF ( @TmpActionTypeID_A = 2 )
			BEGIN
				SET @TeamAResult = 1
			END
			
			IF ( @TmpActionTypeID_A = 3 )
			BEGIN
				SET @TeamAResult = -1
			END 
			
			--TeamB的得失分
			IF ( @TmpActionTypeID_B = 2 )
			BEGIN
				SET @TeamBResult = 1
			END
			
			IF ( @TmpActionTypeID_B = 3 )
			BEGIN
				SET @TeamBResult = -1
			END 
			
			--对于非换人动作,非团体动作, 那么发出人应该在场上
				IF ( ( @TmpActionID_A < @ActIdPlayIn OR @TmpActionID_A > @ActIdTemFlt ) AND 
					( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A ) = 0 )
				BEGIN
					UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
				END
			
				IF ( ( @TmpActionID_B < @ActIdPlayIn OR @TmpActionID_B > @ActIdTemFlt ) AND 
					( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B ) = 0 )
				BEGIN
					UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
				END
			
			
			--每个动作的换人判断
				IF ( @TmpActionID_A = @ActIdPlayOut ) --A队员下场
				BEGIN
					IF ( ( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID = @TmpRegID_A ) > 0 ) --寻找有没有此人
					BEGIN
						UPDATE @tblPositon SET F_RegID = NULL WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID = @TmpRegID_A --有，删去
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder --没有，报错
					END
				END
				
				IF ( @TmpActionID_B = @ActIdPlayOut ) --B队员下场
				BEGIN
					IF ( ( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_Position < 7 AND F_RegID = @TmpRegID_B ) > 0 )
					BEGIN
						UPDATE @tblPositon SET F_RegID = NULL WHERE F_CompPos = 2 AND F_Position < 7 AND F_RegID = @TmpRegID_B
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_A = @ActIdLibOut ) --A自由人下场
				BEGIN
					IF ( ( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position = 7 AND F_RegID = @TmpRegID_A ) > 0 )
					BEGIN
						UPDATE @tblPositon SET F_RegID = NULL WHERE F_CompPos = 1 AND F_Position = 7 AND F_RegID = @TmpRegID_A
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_B = @ActIdLibOut ) --B自由人下场
				BEGIN
					IF ( ( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_Position = 7 AND F_RegID = @TmpRegID_B ) > 0 )
					BEGIN
						UPDATE @tblPositon SET F_RegID = NULL WHERE F_CompPos = 2 AND F_Position = 7 AND F_RegID = @TmpRegID_B
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_A = @ActIdPlayIn ) --A队员上场
				BEGIN
					IF (
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID IS NULL) > 0 --有空地
							AND
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A ) = 0 --将要上场的人未在场上
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_A WHERE F_CompPos = 1 AND 
						F_Position = (SELECT TOP 1 F_Position FROM @tblPositon WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID IS NULL) --寻找第一个空位
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_B = @ActIdPlayIn ) --B队员上场
				BEGIN
					IF (
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_Position < 7 AND F_RegID IS NULL) > 0 --有空地
							AND
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B ) = 0 --将要上场的人未在场上
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_B WHERE F_CompPos = 2 AND 
						F_Position = (SELECT TOP 1 F_Position FROM @tblPositon WHERE F_CompPos = 2 AND F_Position < 7 AND F_RegID IS NULL) --寻找第一个空位
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_A = @ActIdLibIn ) --A自由人上场
				BEGIN
					IF ( 
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position = 7 AND F_RegID IS NULL) > 0 
							AND
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A ) = 0 --将要上场的人未在场上	
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_A WHERE F_CompPos = 1 AND F_Position = 7 AND F_RegID IS NULL
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_B = @ActIdLibIn ) --B自由人上场
				BEGIN
					IF ( 
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_Position = 7 AND F_RegID IS NULL) > 0 
							AND
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B ) = 0 --将要上场的人未在场上	
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_B WHERE F_CompPos = 2 AND F_Position = 7 AND F_RegID IS NULL
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
					END
				END
			--完成每个动作的换人判断
			
			SET @OrderInRally = @OrderInRally + 1
			
			--如果是回合最后一行，要计算回合信息
			IF ( @TmpIsLastRowInRally = 1 )
			BEGIN
	
				--填写此回合输赢等信息
					UPDATE @tblAction SET					
					--发球权信息
						F_RallyServe =  
						CASE WHEN @TeamAServe = 1 AND @TeamBServe = 0 THEN 1
							 WHEN @TeamAServe = 0 AND @TeamBServe = 1 THEN 2
							 ELSE -1 END
					--输赢结果
						, F_RallyEffect = 
						CASE WHEN @TeamAResult =  1 AND @TeamBResult = -1 THEN 1
							 WHEN @TeamAResult = -1 AND @TeamBResult =  1 THEN 2
							 ELSE -1 END
					--推算各个Score
						, F_ScoreA_A = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_A =  1 AND F_Order <= @TmpOrder )
						, F_ScoreB_A = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_A = -1 AND F_Order <= @TmpOrder )
						, F_ScoreA_B = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_B = -1 AND F_Order <= @TmpOrder )
						, F_ScoreB_B = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_B =  1 AND F_Order <= @TmpOrder )
				 WHERE F_RallyNum = @TmpRallyNum AND F_IsLastRowInRally = 1
				
				--计算轮转
					IF ( @LastRallyEffect IS NULL )
					BEGIN
						--在一局的第一个球时,发球法代表了球权
						--这样做,实现了在第一个球时,未发球的一方赢球,即轮转
						SET @LastRallyEffect = @TeamAServe
					END
					
					DECLARE @CurRallyEffect INT = NULL
					SELECT @CurRallyEffect = F_RallyEffect FROM @tblAction WHERE F_Order = @TmpOrder
					
					IF ( @LastRallyEffect = 2 AND @CurRallyEffect = 1 ) --TeamA上回合输了，本回合赢了
					BEGIN
						SET @PosTurnA = @PosTurnA + 1
					END
					
					IF ( @LastRallyEffect = 1 AND @CurRallyEffect = 2 ) --TeamB上回合输了，本回合赢了
					BEGIN
						SET @PosTurnB = @PosTurnB + 1
					END
				
				
				--初始化数值
				SET @OrderInRally = 1
				SET @CurRallyIsError = 0
				SET @TeamAServe = 0
				SET @TeamAResult = 0
				SET @TeamBServe = 0
				SET @TeamBResult = 0 
				SET @LastRallyEffect = @CurRallyEffect
			END
				 
			FETCH NEXT FROM CSR_Action INTO @TmpOrder, @TmpRallyNum, @TmpIsLastRowInRally
			, @TmpActionID_A, @TmpActionTypeID_A, @TmpRegID_A
			, @TmpActionID_B, @TmpActionTypeID_B, @TmpRegID_B 	
			SET @FetchStatus = @@FETCH_STATUS
		END

	CLOSE CSR_Action					
	DEALLOCATE CSR_Action
	
	--把Position表添加到主表中，区别是F_Order为NULL，填入时计算了轮转次数
	
		--把初始Position加上位移量，如果位移量大于6，就模6,即可得到新的Position值
		SET @PosTurnA = @PosTurnA % 6
		SET @PosTurnB = @PosTurnB % 6
		
		SET @PosTurnA = 0
		SET @PosTurnB = 0
		
		--TeamA
		UPDATE @tblPositon SET F_PosTurn = 
			CASE WHEN F_Position - @PosTurnA <= 0 
				THEN F_Position - @PosTurnA + 6 
				ELSE F_Position - @PosTurnA
			END
				WHERE F_CompPos = 1	AND F_Position < 7

		--TeamB
		UPDATE @tblPositon SET F_PosTurn = 
			CASE WHEN F_Position - @PosTurnB <= 0 
				THEN F_Position - @PosTurnB + 6 
				ELSE F_Position - @PosTurnB
			END
				WHERE F_CompPos = 2	AND F_Position < 7
	
		--自由人位不进行轮转，所以两队的自由人位直接拷贝
		UPDATE @tblPositon SET F_PosTurn = F_Position WHERE F_Position = 7
	
		INSERT INTO @tblAction( F_Order, F_CompPos, F_Position, F_RegID )
		SELECT NULL, F_CompPos, F_PosTurn, F_RegID FROM @tblPositon ORDER BY F_CompPos, F_PosTurn
	
	RETURN
End

/*
go
Select * from func_VB_GetMatchStatActionList_Step2_ActionList(1, 1)
*/














GO
/************************func_VB_GetMatchStatActionList_Step2_ActionList OVER*************************/


/************************func_VB_GetMatchStatActionList_Step3_PlayByPlay Start************************/GO


----功  能：获取某场比赛某局的PlayByPlay列表
----使用者：所有外界获取,必须使用此函数, RPT,INFO,CIS,包括程序界面
----作  者：王征 

--2011-03-14	创建
--2011-03-16	返回值增加 F_RallyEffect
CREATE function [dbo].[func_VB_GetMatchStatActionList_Step3_PlayByPlay](
		@MatchID				INT,
		@SetNum					INT
)RETURNS @Result TABLE (
				F_Order				INT,
				F_RallyNum			INT,
				F_IsLastRowInRally	INT,
				F_RallyScoreA		INT,
				F_RallyScoreB		INT,
				F_RallyEffect		INT,	--此回合结果, 1:A胜, 2:B胜, -1:错误   NULL:不是结果行
				
				F_ActionTypeID_A	INT,
				F_RegID_A			INT,
				F_ActionTypeID_B	INT,
				F_RegID_B			INT
						)	
	AS
	BEGIN
	
	--一些常量值
	DECLARE @ActIdSrvSuc	INT=7
	DECLARE @ActIdSrvCnt	INT=8
	DECLARE @ActIdSrvFlt	INT=9
	
	DECLARE @ActIdPlayIn	INT=19
	DECLARE @ActIdPlayOut	INT=20
	DECLARE @ActIdLibIn		INT=21
	DECLARE @ActIdLibOut	INT=22
	DECLARE @ActIdOppErr	INT=23
	DECLARE @ActIdTemFlt	INT=24

	--循环A,B队用的变量,游标
	DECLARE @TmpRallyNum			INT	--第几回合
	DECLARE @TmpIsLastRowInRally	INT --是回合的最后一行
	
	DECLARE @TmpScoreA				INT	--推算的A比分
	DECLARE @TmpScoreB				INT	--推算的B比分
	DECLARE @TmpRallyEffect			INT	--此回合结果
	
	DECLARE @TmpActionTypeID_A		INT	--技术统计类型ID
	DECLARE @TmpRegID_A				INT	--队员ID
	DECLARE @TmpActionTypeID_B		INT	--技术统计类型ID
	DECLARE @TmpRegID_B				INT
	DECLARE @FetchStatus			INT	--游标状态
	
	--只需要符合条件的
	DECLARE CSR_Action CURSOR STATIC FOR 
	SELECT F_RallyNum, F_IsLastRowInRally, F_RallyEffect,
	F_ScoreA_A, F_ScoreB_B,
	F_ActionTypeID_A, F_ActionRegID_A, 
	F_ActionTypeID_B, F_ActionRegID_B 
	FROM dbo.func_VB_GetMatchStatActionList_Step2_ActionList(@MatchID, @SetNum)
	WHERE	dbo.func_VB_IsActionInPlayByPlay(F_ActionTypeID_A) = 1 OR --A有影响比分的东东或为发球，应该显示
			dbo.func_VB_IsActionInPlayByPlay(F_ActionTypeID_B) = 1 OR --B有影响比分的东东或为发球，应该显示
			( F_IsLastRowInRally = 1 AND F_RallyNum <> 0 ) --最后一行 且 不能是首发部分
	OPEN CSR_Action
	FETCH NEXT FROM CSR_Action INTO @TmpRallyNum, @TmpIsLastRowInRally, @TmpRallyEffect,
								@TmpScoreA, @TmpScoreB,
								@TmpActionTypeID_A, @TmpRegID_A, 
								@TmpActionTypeID_B, @TmpRegID_B
	SET @FetchStatus = @@FETCH_STATUS

	DECLARE @TmpOrder	INT=1
	WHILE( @FetchStatus = 0 )
	BEGIN
	
		DECLARE @wActionType_A	INT=NULL
		DECLARE @wRegID_A		INT=NULL
		DECLARE @wActionType_B	INT=NULL
		DECLARE @wRegID_B		INT=NULL
		DECLARE @wScore_A		INT=NULL
		DECLARE @wScore_B		INT=NULL
		
		IF ( @TmpActionTypeID_A IS NOT NULL AND dbo.func_VB_IsActionInPlayByPlay(@TmpActionTypeID_A) = 1 )
		BEGIN
			SET @wActionType_A = @TmpActionTypeID_A
			SET @wRegID_A = @TmpRegID_A
		END
		
		IF ( @TmpActionTypeID_B IS NOT NULL AND dbo.func_VB_IsActionInPlayByPlay(@TmpActionTypeID_B) = 1 )
		BEGIN
			SET @wActionType_B = @TmpActionTypeID_B
			SET @wRegID_B = @TmpRegID_B
		END
				
		IF ( @TmpIsLastRowInRally = 1 ) --如果是最后一行，那么就要插入比分，而且最后一行肯定有影响比分的内容，应该两个都是
		BEGIN
			SET @wScore_A = @TmpScoreA
			SET @wScore_B = @TmpScoreB
		END
	
		INSERT INTO @Result
		SELECT @TmpOrder, @TmpRallyNum, @TmpIsLastRowInRally, @wScore_A, @wScore_B, @TmpRallyEffect, @wActionType_A, @wRegID_A, @wActionType_B, @wRegID_B
	
		FETCH NEXT FROM CSR_Action INTO @TmpRallyNum, @TmpIsLastRowInRally, @TmpRallyEffect,
									@TmpScoreA, @TmpScoreB,
									@TmpActionTypeID_A, @TmpRegID_A, 
									@TmpActionTypeID_B, @TmpRegID_B
		SET @FetchStatus = @@FETCH_STATUS
			
		SET @TmpOrder = @TmpOrder + 1
	END
	
	CLOSE CSR_Action					
	DEALLOCATE CSR_Action
	
	RETURN
END

/*
go
Select * from func_VB_GetMatchStatActionList_Step3_PlayByPlay(1, 1)
*/














GO
/************************func_VB_GetMatchStatActionList_Step3_PlayByPlay OVER*************************/


/************************func_VB_GetMatchTeamInfo Start************************/GO


----功		  能：获取一场一方的Coach,Uniform信息
----作		  者：王征 
----日		  期: 2010-12-17
--此函数为下层函数,供多个PROC调用,或INFO,RPT直接调用

--2011-02-22	修改获取裁判依据，利用FunctionID
--2012-09-05	No Noc any more
CREATE function [dbo].[func_VB_GetMatchTeamInfo]
	(
			@MatchID			INT,
	        @Pos	            INT,
			@LanguageCode		CHAR(3)
	)
Returns @Result TABLE ( 
			F_RegisterID		INT,
			F_RegisterCode		NVARCHAR(100),
			F_UniformID			INT,
			F_UniformColor		NVARCHAR(100), --整套衣服颜色
			F_ShirtColor		NVARCHAR(100), --上衣颜色
			F_Coach1ID			INT,
			F_Coach1Code		NVARCHAR(100),
			F_Coach1Noc			NVARCHAR(100),
			F_Coach1PrtNameS	NVARCHAR(100),
			F_Coach1PrtNameL	NVARCHAR(100),
			F_Coach2ID			INT,
			F_Coach2Code		NVARCHAR(100),
			F_Coach2Noc			NVARCHAR(100),
			F_Coach2PrtNameS	NVARCHAR(100),
			F_Coach2PrtNameL	NVARCHAR(100)
						)
As
BEGIN

    DECLARE @MatchType INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID

    INSERT INTO @Result(F_RegisterID, F_RegisterCode, F_UniformID, F_UniformColor, F_ShirtColor)
	
	--插入ID,球衣颜色
    Select 
		tMatchResult.F_RegisterID as F_RegisterID, 
		tRegister.F_RegisterCode as F_RegisterCode,
		tUnifrom.F_UniformID as F_UniformID, tColorDes.F_ColorLongName as F_UniformColor,
		tShirtColor.F_ColorLongName as F_ShirtColor
    From TS_Match_Result as tMatchResult
		Left join TR_Register as tRegister on tMatchResult.F_RegisterID = tRegister.F_RegisterID
		Left join TR_Uniform as tUnifrom on tUnifrom.F_UniformID = tMatchResult.F_UniformID
		Left join TC_Color_Des as tColorDes on tColorDes.F_ColorID = tUnifrom.F_Shirt and tColorDes.F_LanguageCode = @LanguageCode
		Left join TC_Color_Des as tShirtColor on tShirtColor.F_ColorID = tUnifrom.F_Shirt and tShirtColor.F_LanguageCode = @LanguageCode
    Where tMatchResult.F_CompetitionPosition = @Pos and tMatchResult.F_MatchID = @MatchID
    
    
    DECLARE @TeamRegID INT
    SELECT @TeamRegID = F_RegisterID From @Result
    
    --获取主教练
    UPDATE @Result SET
		 F_Coach1ID = tReg.F_RegisterID
		,F_Coach1Code = tReg.F_RegisterCode
		,F_Coach1Noc = tDelegation.F_DelegationCode
		,F_Coach1PrtNameS = tRegDes.F_PrintShortName
		,F_Coach1PrtNameL = tRegDes.F_PrintLongName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LanguageCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 3
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID
    
    --获取助理教练
    UPDATE @Result SET
		 F_Coach2ID = tReg.F_RegisterID
		,F_Coach2Code = tReg.F_RegisterCode
		,F_Coach2Noc = tDelegation.F_DelegationCode
		,F_Coach2PrtNameS = tRegDes.F_PrintShortName
		,F_Coach2PrtNameL = tRegDes.F_PrintLongName
    FROM TR_Register_Member AS tRegMember 
		LEFT JOIN TR_Register AS tReg ON tReg.F_RegisterID = tRegMember.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS tRegDes ON tReg.F_RegisterID = tRegDes.F_RegisterID AND tRegDes.F_LanguageCode = @LanguageCode
		INNER JOIN TD_Function AS tFunc ON tReg.F_FunctionID = tFunc.F_FunctionID AND tFunc.F_FunctionID = 4
		LEFT JOIN TC_Delegation as tDelegation ON tReg.F_DelegationID = tDelegation.F_DelegationID
    WHERE tRegMember.F_RegisterID = @TeamRegID
    
		
	RETURN


END

/*
go
select * from [func_VB_GetMatchTeamInfo](1, 1, 'ENG')
*/


GO
/************************func_VB_GetMatchTeamInfo OVER*************************/


/************************func_VB_GetPositionSourceInfo Start************************/GO


--一场比赛的队伍来源
--CompetitionSchedule使用

--小组赛，显示组别+签位 #C1，应该不会出现
--淘汰赛第一轮，显示从某组某个排名晋级而来 C1, B2
--淘汰赛第一轮后，显示上一场比赛号+胜负	 32W. 46L

--2011-07-18	Created
--2011-10-15	Add lang
--2012-09-11	Return registerID & PostionDesc
CREATE FUNCTION [dbo].[func_VB_GetPositionSourceInfo]
			(
				@MatchID			INT,
				@CompPos			INT,
				@LangCode			NVARCHAR(100)
			)
RETURNS @Result TABLE 
			( 
				F_RegisterID		INT,
				F_PositionDes		NVARCHAR(100)
			)
AS
BEGIN
	DECLARE @PosDes NVARCHAR(100) = NULL
	DECLARE @RegID	INT = NULL
	
	--错误判断
	IF( @MatchID <=0 OR @CompPos < 1 OR @CompPos > 2)
		RETURN

	--如果已经指派
	DECLARE @TempRegId INT = NULL
	SELECT @TempRegId = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos 
	
	IF @TempRegId >= 1
	BEGIN
		SET @RegID = @TempRegId
	END
	
	
	--小组赛，未分配队员的情况,此种情况应该不会出现
	DECLARE @TempStartPhaseID INT = NULL
	DECLARE @TempStartPhasePos INT = NULL	
	SELECT @TempStartPhaseID = F_StartPhaseID, @TempStartPhasePos = F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	IF @TempStartPhaseID > 0
	BEGIN
		SELECT @PosDes = '#' + F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @TempStartPhaseID
		SELECT @PosDes += CAST(@TempStartPhasePos AS NVARCHAR(100))
	END


	--如果存在Source match
	DECLARE @TempSourceMatchID INT = NULL
	DECLARE @TempSourceMatchRank INT = NULL	
	
	SELECT @TempSourceMatchID = F_SourceMatchID, @TempSourceMatchRank = F_SourceMatchRank FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	IF (@TempSourceMatchID > 0 AND @TempSourceMatchRank >=1 AND @TempSourceMatchRank <=2 )
	BEGIN
		SELECT @PosDes = CASE @LangCode WHEN 'ENG' THEN 'M' ELSE '比赛' END
		SELECT @PosDes += F_RaceNum FROM TS_Match WHERE F_MatchID = @TempSourceMatchID
		SELECT @PosDes += 
			CASE 
				WHEN @LangCode='ENG' AND @TempSourceMatchRank = 1 THEN ' W' 
				WHEN @LangCode='ENG' AND @TempSourceMatchRank = 2 THEN ' L' 
				WHEN @LangCode='CHN' AND @TempSourceMatchRank = 1 THEN ' 胜'
				WHEN @LangCode='CHN' AND @TempSourceMatchRank = 2 THEN ' 负' 
				ELSE '' 
			END
	END
	
	
	--如果存在Source phase
	DECLARE @TempSourcePhaseID INT = NULL
	DECLARE @TempSourcePhaseRank INT = NULL
	
	SELECT @TempSourcePhaseID = F_SourcePhaseID, @TempSourcePhaseRank = F_SourcePhaseRank FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	IF (@TempSourcePhaseID > 0 AND @TempSourcePhaseRank >=1 )
	BEGIN
		SELECT @PosDes = F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @TempSourcePhaseID
		SELECT @PosDes += CAST(@TempSourcePhaseRank AS NVARCHAR(100))
	END
	
	--把结果写入返回表
	INSERT INTO @Result
	SELECT @RegID, @PosDes

	RETURN
END

/*
go
select dbo.[[[func_VB_GetPositionSourceInfo]]]( 1, 1, 'CHN')
*/


GO
/************************func_VB_GetPositionSourceInfo OVER*************************/


/************************func_VB_GetStatEventAthlete Start************************/GO


----功能：队伍累计技术统计排名
----使用: INFO,RPT
----作者：王征 
----日期: 2010-10-14

--2011-01-28	ATK_SUC
--2011-03-17	排序时如果依据的数据都为0，那么Rank为NULL
CREATE function [dbo].[func_VB_GetStatEventAthlete]
		(
			@EventID		INT
		)
Returns @Result TABLE ( 
			F_TeamRegID		INT,		--
			F_RegisterID	INT,		
			F_MatchCount	INT,		--此人经历场次数
			F_SetCount		INT,		--此人伍经历局数	算AVG Per Set 用
			
			F_ATK_SUC		INT,		--扣球得分
			F_ATK_CNT		INT,		--扣球一般
			F_ATK_FLT		INT,		--扣球丢分
			F_ATK_TOT		INT,		--* 总数	= SUC + CNT + FLT
			F_ATK_EFF		FLOAT,		--* 扣球有效率	= SUC / TOT
			F_ATK_SUC_RANK	INT,		--* 扣球排名 Order by SUC
			F_ATK_SUC_DPOS	INT,		
			F_ATK_EFF_RANK	INT,		--* 扣球排名 Order by EFF
			F_ATK_EFF_DPOS	INT,			
			
			F_BLO_SUC		INT,		--拦网得分
			F_BLO_CNT		INT,		--拦网过网
			F_BLO_FLT		INT,		--拦网丢分
			F_BLO_TOT		INT,		--* 扣球总数	= SUC + CNT + FLT
			F_BLO_AVG		FLOAT,		--* 扣球平均值	= SUC / Set count
			F_BLO_SUC_RANK	INT,		--* 扣球排名 Order by SUC
			F_BLO_SUC_DPOS	INT,
			F_BLO_AVG_RANK	INT,		--* 扣球排名 Order by AVG
			F_BLO_AVG_DPOS	INT,
			
			F_SRV_SUC		INT,		--发球得分
			F_SRV_CNT		INT,		--发球过网
			F_SRV_FLT		INT,		--发球丢分
			F_SRV_TOT		INT,		--* 发球总数	= SUC + CNT + FLT
			F_SRV_AVG		FLOAT,		--* 发球平均值	= SUC / Set count
			F_SRV_SUC_RANK	INT,		--* 发球排名 Order by SUC
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
			F_TOT_SUC_RANK	INT,		--* 接发排名 Order by SUCC
			F_TOT_SUC_DPOS	INT,	
			
			F_TOT_ATP		INT,		--* 总出手		= ATK_TOT + BLO_TOT + SRV_TOT
			F_TOT_ATP_RANK	INT,		
			F_TOT_ATP_DPOS	INT		
		)
As
BEGIN

	--填充本Event下所有的队员
	INSERT INTO @Result(F_TeamRegID, F_RegisterID)
	SELECT tInscrpt.F_RegisterID, tRegMember.F_MemberRegisterID FROM TR_Inscription as tInscrpt --从报项表里获取所有队伍
	LEFT JOIN TR_Register_Member AS tRegMember ON tRegMember.F_RegisterID = tInscrpt.F_RegisterID --插入每队里的所有队员
	INNER JOIN TR_Register AS tMemberReg ON tMemberReg.F_RegisterID = tRegMember.F_MemberRegisterID AND tMemberReg.F_RegTypeID = 1 --只需要运动员,教练不要
	WHERE F_EventID = @EventID
		
			
	--获取每个人经历比赛数,经历局数
	UPDATE @Result SET
		  F_MatchCount = 
			(
				SELECT COUNT(*) FROM TS_Match_Result AS tMatchResult
				INNER JOIN TS_Match as tMatch ON
					tMatch.F_MatchID = tMatchResult.F_MatchID AND tMatch.F_MatchStatusID >= 110
				WHERE F_RegisterID = F_TeamRegID
			)
		, F_SetCount = 
			(
				SELECT SUM( CAST(tMatch.F_MatchComment1 AS INT ) ) FROM TS_Match_Result AS tMatchResult
				INNER JOIN TS_Match as tMatch ON
					tMatch.F_MatchID = tMatchResult.F_MatchID AND tMatch.F_MatchStatusID >= 110
				WHERE F_RegisterID = F_TeamRegID
			)
			
	--确保不为NULL
	UPDATE @Result SET 
	  F_MatchCount = ISNULL(F_MatchCount, 0)
	, F_SetCount = ISNULL(F_SetCount, 0)
		
		
	--填充各种基本技术统计项
	UPDATE @Result SET 
	 F_ATK_SUC = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'ATK_SUC')
	,F_ATK_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'ATK_CNT')
	,F_ATK_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'ATK_FLT')		
	
	,F_BLO_SUC = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'BLO_SUC')
	,F_BLO_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'BLO_CNT')
	,F_BLO_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'BLO_FLT')
	
	,F_SRV_SUC = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'SRV_SUC')
	,F_SRV_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'SRV_CNT')
	,F_SRV_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'SRV_FLT')
	
	,F_DIG_EXC = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'DIG_EXC')
	,F_DIG_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'DIG_CNT')
	,F_DIG_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'DIG_FLT')	
		
	,F_SET_EXC = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'SET_EXC')
	,F_SET_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'SET_CNT')
	,F_SET_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'SET_FLT')
	
	,F_RCV_EXC = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'RCV_EXC')
	,F_RCV_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'RCV_CNT')
	,F_RCV_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_RegisterID, NULL, NULL, 'RCV_FLT')
		
	--总数计算
	UPDATE @Result SET
	 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
	,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
	,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
	,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
	,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
	,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
					
	UPDATE @Result SET
	 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC
	,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT 				
					
	--平均值,有效率计算
	UPDATE @Result SET
	 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
	,F_BLO_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_BLO_SUC / CAST(F_SetCount as FLOAT) END
	,F_SRV_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SRV_SUC / CAST(F_SetCount as FLOAT) END
	,F_DIG_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_DIG_EXC / CAST(F_SetCount as FLOAT) END
	,F_SET_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SET_EXC / CAST(F_SetCount as FLOAT) END
	,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
		 
	--排名计算
	UPDATE A SET 
	 A.F_ATK_SUC_RANK = B.ATK_SUC_RANK
	,A.F_ATK_SUC_DPOS = B.ATK_SUC_DPOS
	,A.F_ATK_EFF_RANK = B.ATK_EFF_RANK
	,A.F_ATK_EFF_DPOS = B.ATK_EFF_DPOS

	,A.F_BLO_SUC_RANK = B.BLO_SUC_RANK
	,A.F_BLO_SUC_DPOS = B.BLO_SUC_DPOS
	,A.F_BLO_AVG_RANK = B.BLO_AVG_RANK
	,A.F_BLO_AVG_DPOS = B.BLO_AVG_DPOS

	,A.F_SRV_SUC_RANK = B.SRV_SUC_RANK
	,A.F_SRV_SUC_DPOS = B.SRV_SUC_DPOS
	,A.F_SRV_AVG_RANK = B.SRV_AVG_RANK
	,A.F_SRV_AVG_DPOS = B.SRV_AVG_DPOS

	,A.F_DIG_AVG_RANK = B.DIG_AVG_RANK
	,A.F_DIG_AVG_DPOS = B.DIG_AVG_DPOS

	,A.F_SET_AVG_RANK = B.SET_AVG_RANK
	,A.F_SET_AVG_DPOS = B.SET_AVG_DPOS

	,A.F_RCV_SUCC_RANK = B.RCV_SUCC_RANK
	,A.F_RCV_SUCC_DPOS = b.RCV_SUCC_DPOS
	
	,A.F_TOT_SUC_RANK = B.TOT_SUC_RANK
	,A.F_TOT_SUC_DPOS = b.TOT_SUC_DPOS
	
	,A.F_TOT_ATP_RANK = B.TOT_ATP_RANK
	,A.F_TOT_ATP_DPOS = b.TOT_ATP_DPOS
		
	 FROM @Result AS A 
	 LEFT JOIN (
		SELECT F_RegisterID, 
		
		 RANK()		  OVER(ORDER BY F_ATK_SUC DESC) AS ATK_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_ATK_SUC DESC, F_ATK_CNT DESC, F_ATK_FLT DESC) AS ATK_SUC_DPOS
		,RANK()       OVER(ORDER BY F_ATK_EFF DESC) AS ATK_EFF_RANK
		,ROW_NUMBER() OVER(ORDER BY F_ATK_EFF DESC, F_ATK_TOT DESC, F_ATK_SUC DESC, F_ATK_CNT DESC) AS ATK_EFF_DPOS
		
		,RANK()		  OVER(ORDER BY F_BLO_SUC DESC) AS BLO_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_BLO_SUC DESC, F_BLO_CNT DESC, F_BLO_FLT DESC) AS BLO_SUC_DPOS				
		,RANK()		  OVER(ORDER BY F_BLO_AVG DESC) AS BLO_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_BLO_AVG DESC, F_BLO_TOT DESC, F_BLO_SUC DESC, F_BLO_CNT DESC) AS BLO_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_SRV_SUC DESC) AS SRV_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_SRV_SUC DESC, F_SRV_CNT DESC, F_SRV_FLT DESC) AS SRV_SUC_DPOS
		,RANK()		  OVER(ORDER BY F_SRV_AVG DESC) AS SRV_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_SRV_AVG DESC, F_SRV_TOT DESC, F_SRV_SUC DESC, F_SRV_CNT DESC) AS SRV_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_DIG_AVG DESC) AS DIG_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_DIG_AVG DESC, F_DIG_TOT DESC, F_DIG_EXC DESC, F_DIG_CNT DESC) AS DIG_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_SET_AVG DESC) AS SET_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_SET_AVG DESC, F_SET_TOT DESC, F_SET_EXC DESC, F_SET_CNT DESC) AS SET_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_RCV_SUCC DESC) AS RCV_SUCC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_RCV_SUCC DESC, F_RCV_TOT DESC, F_RCV_EXC DESC, F_RCV_CNT DESC) AS RCV_SUCC_DPOS
		
		,RANK()		  OVER(ORDER BY F_TOT_SUC DESC) AS TOT_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_TOT_SUC DESC, F_TOT_ATP DESC, F_ATK_TOT DESC) AS TOT_SUC_DPOS			
		
		,RANK()		  OVER(ORDER BY F_TOT_ATP DESC) AS TOT_ATP_RANK
		,ROW_NUMBER() OVER(ORDER BY F_TOT_ATP DESC, F_TOT_SUC DESC, F_ATK_TOT DESC) AS TOT_ATP_DPOS	
			
		FROM @Result) AS B 
			ON A.F_RegisterID = B.F_RegisterID
		 		 
		 		 
	--删除数值为0的Rank，例如，一个人ATK三种都为0,那么关于ATK的Rank为NULL,但保留其DispPos
		UPDATE A SET
			  F_ATK_SUC_RANK = CASE WHEN F_ATK_SUC = 0 AND F_ATK_CNT = 0 AND F_ATK_FLT = 0 THEN NULL ELSE F_ATK_SUC_RANK END
			, F_ATK_EFF_RANK = CASE WHEN F_ATK_SUC = 0 AND F_ATK_CNT = 0 AND F_ATK_FLT = 0 THEN NULL ELSE F_ATK_EFF_RANK END
			
			, F_BLO_SUC_RANK = CASE WHEN F_BLO_SUC = 0 AND F_BLO_CNT = 0 AND F_BLO_FLT = 0 THEN NULL ELSE F_BLO_SUC_RANK END
			, F_BLO_AVG_RANK = CASE WHEN F_BLO_SUC = 0 AND F_BLO_CNT = 0 AND F_BLO_FLT = 0 THEN NULL ELSE F_BLO_AVG_RANK END
			
			, F_SRV_SUC_RANK = CASE WHEN F_SRV_SUC = 0 AND F_SRV_CNT = 0 AND F_SRV_FLT = 0 THEN NULL ELSE F_SRV_SUC_RANK END
			, F_SRV_AVG_RANK = CASE WHEN F_SRV_SUC = 0 AND F_SRV_CNT = 0 AND F_SRV_FLT = 0 THEN NULL ELSE F_SRV_AVG_RANK END
			
			, F_DIG_AVG_RANK = CASE WHEN F_DIG_EXC = 0 AND F_DIG_CNT = 0 AND F_DIG_FLT = 0 THEN NULL ELSE F_DIG_AVG_RANK END
			, F_SET_AVG_RANK = CASE WHEN F_SET_EXC = 0 AND F_SET_CNT = 0 AND F_SET_FLT = 0 THEN NULL ELSE F_SET_AVG_RANK END
			, F_RCV_SUCC_RANK = CASE WHEN F_RCV_EXC = 0 AND F_RCV_CNT = 0 AND F_RCV_FLT = 0 THEN NULL ELSE F_RCV_SUCC_RANK END
			
			, F_TOT_SUC_RANK = CASE WHEN F_TOT_SUC = 0 THEN NULL ELSE F_TOT_SUC_RANK END
			, F_TOT_ATP_RANK = CASE WHEN F_TOT_ATP = 0 THEN NULL ELSE F_TOT_ATP_RANK END
			
		FROM @Result AS A
		
	RETURN


END


/*
go
Select * from  dbo.[func_VB_GetStatEventAthlete](31)
*/




GO
/************************func_VB_GetStatEventAthlete OVER*************************/


/************************func_VB_GetStatEventTeam Start************************/GO


----功能：队伍累计技术统计排名
----使用: INFO,RPT等
----作者：王征 
----日期: 2011-01-04

--2011-01-27	BLO写成ATK
--2011-01-28	ATK_SUC

CREATE function [dbo].[func_VB_GetStatEventTeam]
			(
				@EventID		INT
			)
Returns @Result TABLE ( 
				F_TeamRegID		INT,		-- * 自己计算的
				F_MatchCount	INT,		--此队伍经历场次数
				F_SetCount		INT,		--此队伍经历局数	算AVG Per Set 用
				
				F_ATK_SUC		INT,		--扣球得分
				F_ATK_CNT		INT,		--扣球一般
				F_ATK_FLT		INT,		--扣球丢分
				F_ATK_TOT		INT,		--* 总数	= SUC + CNT + FLT
				F_ATK_EFF		FLOAT,		--* 扣球有效率	= SUC / TOT
				F_ATK_SUC_RANK	INT,		--* 扣球排名 Order by SUC
				F_ATK_SUC_DPOS	INT,		
				F_ATK_EFF_RANK	INT,		--* 扣球排名 Order by EFF
				F_ATK_EFF_DPOS	INT,			
				
				F_BLO_SUC		INT,		--拦网得分
				F_BLO_CNT		INT,		--拦网过网
				F_BLO_FLT		INT,		--拦网丢分
				F_BLO_TOT		INT,		--* 扣球总数	= SUC + CNT + FLT
				F_BLO_AVG		FLOAT,		--* 扣球平均值	= SUC / Set count
				F_BLO_SUC_RANK	INT,		--* 扣球排名 Order by SUC
				F_BLO_SUC_DPOS	INT,
				F_BLO_AVG_RANK	INT,		--* 扣球排名 Order by AVG
				F_BLO_AVG_DPOS	INT,
				
				F_SRV_SUC		INT,		--发球得分
				F_SRV_CNT		INT,		--发球过网
				F_SRV_FLT		INT,		--发球丢分
				F_SRV_TOT		INT,		--* 发球总数	= SUC + CNT + FLT
				F_SRV_AVG		FLOAT,		--* 发球平均值	= SUC / Set count
				F_SRV_SUC_RANK	INT,		--* 发球排名 Order by SUC
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
				
				F_OPP_ERR		INT,		--对方失误
				F_TEM_FLT		INT,		--本队失误
				
				F_TOT_SUC		INT,		--总得分 ATK_SUC + BLO_SUC + SRV_SUC + OPP_ERR
				F_TOT_SUC_RANK	INT,		--* 总得分排名 Order by TOT_SUC
				F_TOT_SUC_DPOS	INT,
				
				F_TOT_ATP		INT,		--总出手 ATK_TOT + BLO_TOT + SRV_TOT
				F_TOT_ATP_RANK	INT,		--* 总出手排名 Order by TOT_ATP
				F_TOT_ATP_DPOS	INT
			)
As
BEGIN

	--填充本Event下所有报项的队伍
	INSERT INTO @Result(F_TeamRegID)
		SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID
				
		
	UPDATE @Result SET
		  F_MatchCount = 
			(
				SELECT COUNT(*) FROM TS_Match_Result AS tMatchResult
				INNER JOIN TS_Match as tMatch ON
					tMatch.F_MatchID = tMatchResult.F_MatchID AND tMatch.F_MatchStatusID >= 110
				WHERE F_RegisterID = F_TeamRegID
			)
		, F_SetCount = 
			(
				SELECT SUM( CAST(tMatch.F_MatchComment1 AS INT ) ) FROM TS_Match_Result AS tMatchResult
				INNER JOIN TS_Match as tMatch ON
					tMatch.F_MatchID = tMatchResult.F_MatchID AND tMatch.F_MatchStatusID >= 110
				WHERE F_RegisterID = F_TeamRegID
			)
			
	UPDATE @Result SET 
	  F_MatchCount = ISNULL(F_MatchCount, 0)
	, F_SetCount = ISNULL(F_SetCount, 0)
		
	--填充各种基本技术统计项
	UPDATE @Result SET 
	 F_ATK_SUC = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'ATK_SUC')
	,F_ATK_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'ATK_CNT')
	,F_ATK_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'ATK_FLT')		
	
	,F_BLO_SUC = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'BLO_SUC')
	,F_BLO_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'BLO_CNT')
	,F_BLO_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'BLO_FLT')
	
	,F_SRV_SUC = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'SRV_SUC')
	,F_SRV_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'SRV_CNT')
	,F_SRV_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'SRV_FLT')
	
	,F_DIG_EXC = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'DIG_EXC')
	,F_DIG_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'DIG_CNT')
	,F_DIG_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'DIG_FLT')	
		
	,F_SET_EXC = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'SET_EXC')
	,F_SET_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'SET_CNT')
	,F_SET_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'SET_FLT')
	
	,F_RCV_EXC = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'RCV_EXC')
	,F_RCV_CNT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'RCV_CNT')
	,F_RCV_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'RCV_FLT')
	
	,F_OPP_ERR = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'OPP_ERR')
	,F_TEM_FLT = dbo.func_VB_GetStatValueByStatCode(3, F_TeamRegID, NULL, NULL, 'TEM_FLT')
	
		
	--总数计算
	UPDATE @Result SET
	 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
	,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
	,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
	,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
	,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
	,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
	
	--汇总计算
	UPDATE @Result SET
	 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC + F_OPP_ERR
	,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT
					
	--平均值,有效率计算
	UPDATE @Result SET
	 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
	,F_BLO_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_BLO_SUC / CAST(F_SetCount as FLOAT) END
	,F_SRV_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SRV_SUC / CAST(F_SetCount as FLOAT) END
	,F_DIG_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_DIG_EXC / CAST(F_SetCount as FLOAT) END
	,F_SET_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SET_EXC / CAST(F_SetCount as FLOAT) END
	,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
		 
	--排名计算
	UPDATE A SET 
	 A.F_ATK_SUC_RANK = B.ATK_SUC_RANK
	,A.F_ATK_SUC_DPOS = B.ATK_SUC_DPOS
	,A.F_ATK_EFF_RANK = B.ATK_EFF_RANK
	,A.F_ATK_EFF_DPOS = B.ATK_EFF_DPOS

	,A.F_BLO_SUC_RANK = B.BLO_SUC_RANK
	,A.F_BLO_SUC_DPOS = B.BLO_SUC_DPOS
	,A.F_BLO_AVG_RANK = B.BLO_AVG_RANK
	,A.F_BLO_AVG_DPOS = B.BLO_AVG_DPOS

	,A.F_SRV_SUC_RANK = B.SRV_SUC_RANK
	,A.F_SRV_SUC_DPOS = B.SRV_SUC_DPOS
	,A.F_SRV_AVG_RANK = B.SRV_AVG_RANK
	,A.F_SRV_AVG_DPOS = B.SRV_AVG_DPOS

	,A.F_DIG_AVG_RANK = B.DIG_AVG_RANK
	,A.F_DIG_AVG_DPOS = B.DIG_AVG_DPOS

	,A.F_SET_AVG_RANK = B.SET_AVG_RANK
	,A.F_SET_AVG_DPOS = B.SET_AVG_DPOS

	,A.F_RCV_SUCC_RANK = B.RCV_SUCC_RANK
	,A.F_RCV_SUCC_DPOS = b.RCV_SUCC_DPOS
	
	,A.F_TOT_SUC_RANK = B.TOT_SUC_RANK
	,A.F_TOT_SUC_DPOS = b.TOT_SUC_DPOS

	,A.F_TOT_ATP_RANK = B.TOT_ATP_RANK
	,A.F_TOT_ATP_DPOS = b.TOT_ATP_DPOS
				
	 FROM @Result AS A 
	 LEFT JOIN (
		SELECT F_TeamRegID, 
		
		 RANK()		  OVER(ORDER BY F_ATK_SUC DESC) AS ATK_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_ATK_SUC DESC, F_ATK_CNT DESC, F_ATK_FLT DESC) AS ATK_SUC_DPOS
		,RANK()       OVER(ORDER BY F_ATK_EFF DESC) AS ATK_EFF_RANK
		,ROW_NUMBER() OVER(ORDER BY F_ATK_EFF DESC, F_ATK_TOT DESC, F_ATK_SUC DESC, F_ATK_CNT DESC) AS ATK_EFF_DPOS
		
		,RANK()		  OVER(ORDER BY F_BLO_SUC DESC) AS BLO_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_BLO_SUC DESC, F_BLO_CNT DESC, F_BLO_FLT DESC) AS BLO_SUC_DPOS				
		,RANK()		  OVER(ORDER BY F_BLO_AVG DESC) AS BLO_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_BLO_AVG DESC, F_BLO_TOT DESC, F_BLO_SUC DESC, F_BLO_CNT DESC) AS BLO_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_SRV_SUC DESC) AS SRV_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_SRV_SUC DESC, F_SRV_CNT DESC, F_SRV_FLT DESC) AS SRV_SUC_DPOS
		,RANK()		  OVER(ORDER BY F_SRV_AVG DESC) AS SRV_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_SRV_AVG DESC, F_SRV_TOT DESC, F_SRV_SUC DESC, F_SRV_CNT DESC) AS SRV_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_DIG_AVG DESC) AS DIG_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_DIG_AVG DESC, F_DIG_TOT DESC, F_DIG_EXC DESC, F_DIG_CNT DESC) AS DIG_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_SET_AVG DESC) AS SET_AVG_RANK
		,ROW_NUMBER() OVER(ORDER BY F_SET_AVG DESC, F_SET_TOT DESC, F_SET_EXC DESC, F_SET_CNT DESC) AS SET_AVG_DPOS
		
		,RANK()		  OVER(ORDER BY F_RCV_SUCC DESC) AS RCV_SUCC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_RCV_SUCC DESC, F_RCV_TOT DESC, F_RCV_EXC DESC, F_RCV_CNT DESC) AS RCV_SUCC_DPOS

		,RANK()		  OVER(ORDER BY F_TOT_SUC DESC) AS TOT_SUC_RANK
		,ROW_NUMBER() OVER(ORDER BY F_TOT_SUC DESC, F_TOT_ATP DESC) AS TOT_SUC_DPOS
		
		,RANK()		  OVER(ORDER BY F_TOT_ATP DESC) AS TOT_ATP_RANK
		,ROW_NUMBER() OVER(ORDER BY F_TOT_ATP DESC, F_TOT_SUC DESC) AS TOT_ATP_DPOS
		
		FROM @Result) AS B 
			ON A.F_TeamRegID = B.F_TeamRegID
		 		 
	RETURN


END


/*
go
Select * from  [func_VB_GetStatEventTeam](31)
*/



GO
/************************func_VB_GetStatEventTeam OVER*************************/


/************************func_VB_GetStatMatchAthlete Start************************/GO


----功能：一场比赛双方技术统计列表
----使用：INFO,RPT
----作者：王征 
----日期: 2010-10-14

--2011-01-26	BLO写成了ATK
--2011-01-28	ATK_SUC
--2011-01-30	添加F_Order
--2011-01-30	@CompPos支持NULL,表示同时要两队人
--2011-02-24	添加支持第几局，并添加F_FunctionID
--2011-03-17	排序时如果依据的数据都为0，那么Rank为NULL
CREATE function [dbo].[func_VB_GetStatMatchAthlete]
			(
				@MatchID		INT,
				@CompPos		INT = NULL,	--1,2 NULL:两队都要
				@CurSet			INT = NULL	--N:第N局 NULL:所有比赛
			)
Returns @Result TABLE ( 
				F_TeamRegID		INT,		--
				F_RegisterID    INT,
				F_CompPos		INT,
				F_Bib			NVARCHAR(100),
				F_FunctionID	INT,		-- 1:Caption 2:Libreo Other:NULL
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
As
BEGIN
		
		IF( @CompPos IS NULL ) 
		BEGIN
			--填充两队的出场队员
			INSERT INTO @Result(F_TeamRegID, F_RegisterID, F_CompPos, F_Bib, F_FunctionID, F_Order)
			SELECT B.F_RegisterID, A.F_RegisterID, A.F_CompetitionPosition, A.F_ShirtNumber, A.F_FunctionID,
			ROW_NUMBER() OVER(ORDER BY A.F_CompetitionPosition, F_ShirtNumber) AS F_Order
			FROM TS_Match_Member AS A
			LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID and B.F_CompetitionPosition = A.F_CompetitionPosition
			WHERE A.F_MatchID = @MatchID 
			ORDER BY F_CompetitionPosition, F_ShirtNumber
		END
		ELSE
		BEGIN
			--填充某一队的出场队员
			INSERT INTO @Result(F_TeamRegID, F_RegisterID, F_CompPos, F_Bib, F_FunctionID, F_Order)
			SELECT B.F_RegisterID, A.F_RegisterID, A.F_CompetitionPosition, A.F_ShirtNumber, A.F_FunctionID,
			ROW_NUMBER() OVER(ORDER BY A.F_CompetitionPosition, F_ShirtNumber) AS F_Order
			FROM TS_Match_Member AS A
			LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID and B.F_CompetitionPosition = A.F_CompetitionPosition
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @CompPos
			ORDER BY F_CompetitionPosition, F_ShirtNumber
		END
		
		--填充各种基本技术统计项
		UPDATE @Result SET 
		 F_ATK_SUC = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'ATK_SUC')
		,F_ATK_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'ATK_CNT')
		,F_ATK_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'ATK_FLT')		
		
		,F_BLO_SUC = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'BLO_SUC')
		,F_BLO_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'BLO_CNT')
		,F_BLO_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'BLO_FLT')
		
		,F_SRV_SUC = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'SRV_SUC')
		,F_SRV_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'SRV_CNT')
		,F_SRV_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'SRV_FLT')
		
		,F_DIG_EXC = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'DIG_EXC')
		,F_DIG_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'DIG_CNT')
		,F_DIG_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'DIG_FLT')	
			
		,F_SET_EXC = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'SET_EXC')
		,F_SET_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'SET_CNT')
		,F_SET_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'SET_FLT')
		
		,F_RCV_EXC = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'RCV_EXC')
		,F_RCV_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'RCV_CNT')
		,F_RCV_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_RegisterID, @MatchID, @CurSet, 'RCV_FLT')
		
		--总数计算
		UPDATE @Result SET
		 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
		,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
		,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
		,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
		,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
		,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
		
		--总计
		UPDATE @Result SET
		 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC
		,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT
				
		--当前局即为此场比赛共有几局
		DECLARE @SetCnt FLOAT = 0
		SELECT @SetCnt = CAST(F_MatchComment1 AS FLOAT ) FROM TS_Match WHERE F_MatchID = @MatchID
				
		--平均值,有效率计算
		UPDATE @Result SET
		 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
		,F_BLO_AVG = F_BLO_SUC / @SetCnt
		,F_SRV_AVG = F_SRV_SUC / @SetCnt
		,F_DIG_AVG = F_DIG_EXC / @SetCnt
		,F_SET_AVG = F_SET_EXC / @SetCnt
		,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
		--排名计算
		UPDATE A SET 
		 A.F_ATK_SUC_RANK = B.ATK_SUC_RANK
		,A.F_ATK_SUC_DPOS = B.ATK_SUC_DPOS
		,A.F_ATK_EFF_RANK = B.ATK_EFF_RANK
		,A.F_ATK_EFF_DPOS = B.ATK_EFF_DPOS
		
		,A.F_BLO_SUC_RANK = B.BLO_SUC_RANK
		,A.F_BLO_SUC_DPOS = B.BLO_SUC_DPOS
		,A.F_BLO_AVG_RANK = B.BLO_AVG_RANK
		,A.F_BLO_AVG_DPOS = B.BLO_AVG_DPOS
		
		,A.F_SRV_SUC_RANK = B.SRV_SUC_RANK
		,A.F_SRV_SUC_DPOS = B.SRV_SUC_DPOS
		,A.F_SRV_AVG_RANK = B.SRV_AVG_RANK
		,A.F_SRV_AVG_DPOS = B.SRV_AVG_DPOS
		
		,A.F_DIG_AVG_RANK = B.DIG_AVG_RANK
		,A.F_DIG_AVG_DPOS = B.DIG_AVG_DPOS
		
		,A.F_SET_AVG_RANK = B.SET_AVG_RANK
		,A.F_SET_AVG_DPOS = B.SET_AVG_DPOS
		
		,A.F_RCV_SUCC_RANK = B.RCV_SUCC_RANK
		,A.F_RCV_SUCC_DPOS = b.RCV_SUCC_DPOS
		
		,A.F_TOT_SUC_RANK = B.TOT_SUC_RANK
		,A.F_TOT_SUC_DPOS = b.TOT_SUC_DPOS
		
		,A.F_TOT_ATP_RANK = B.TOT_ATP_RANK
		,A.F_TOT_ATP_DPOS = b.TOT_ATP_DPOS
				
		 FROM @Result AS A 
		 LEFT JOIN (
			SELECT F_RegisterID, 
			
			 RANK()		  OVER(ORDER BY F_ATK_SUC DESC) AS ATK_SUC_RANK
			,ROW_NUMBER() OVER(ORDER BY F_ATK_SUC DESC, F_ATK_CNT DESC, F_ATK_FLT DESC) AS ATK_SUC_DPOS
			,RANK()       OVER(ORDER BY F_ATK_EFF DESC) AS ATK_EFF_RANK
			,ROW_NUMBER() OVER(ORDER BY F_ATK_EFF DESC, F_ATK_TOT DESC, F_ATK_SUC DESC, F_ATK_CNT DESC) AS ATK_EFF_DPOS
			
			,RANK()		  OVER(ORDER BY F_BLO_SUC DESC) AS BLO_SUC_RANK
			,ROW_NUMBER() OVER(ORDER BY F_BLO_SUC DESC, F_BLO_CNT DESC, F_BLO_FLT DESC) AS BLO_SUC_DPOS				
			,RANK()		  OVER(ORDER BY F_BLO_AVG DESC) AS BLO_AVG_RANK
			,ROW_NUMBER() OVER(ORDER BY F_BLO_AVG DESC, F_BLO_TOT DESC, F_BLO_SUC DESC, F_BLO_CNT DESC) AS BLO_AVG_DPOS
			
			,RANK()		  OVER(ORDER BY F_SRV_SUC DESC) AS SRV_SUC_RANK
			,ROW_NUMBER() OVER(ORDER BY F_SRV_SUC DESC, F_SRV_CNT DESC, F_SRV_FLT DESC) AS SRV_SUC_DPOS
			,RANK()		  OVER(ORDER BY F_SRV_AVG DESC) AS SRV_AVG_RANK
			,ROW_NUMBER() OVER(ORDER BY F_SRV_AVG DESC, F_SRV_TOT DESC, F_SRV_SUC DESC, F_SRV_CNT DESC) AS SRV_AVG_DPOS
			
			,RANK()		  OVER(ORDER BY F_DIG_AVG DESC) AS DIG_AVG_RANK
			,ROW_NUMBER() OVER(ORDER BY F_DIG_AVG DESC, F_DIG_TOT DESC, F_DIG_EXC DESC, F_DIG_CNT DESC) AS DIG_AVG_DPOS
			
			,RANK()		  OVER(ORDER BY F_SET_AVG DESC) AS SET_AVG_RANK
			,ROW_NUMBER() OVER(ORDER BY F_SET_AVG DESC, F_SET_TOT DESC, F_SET_EXC DESC, F_SET_CNT DESC) AS SET_AVG_DPOS
			
			,RANK()		  OVER(ORDER BY F_RCV_SUCC DESC) AS RCV_SUCC_RANK
			,ROW_NUMBER() OVER(ORDER BY F_RCV_SUCC DESC, F_RCV_TOT DESC, F_RCV_EXC DESC, F_RCV_CNT DESC) AS RCV_SUCC_DPOS
			
			,RANK()		  OVER(ORDER BY F_TOT_SUC DESC) AS TOT_SUC_RANK
			,ROW_NUMBER() OVER(ORDER BY F_TOT_SUC DESC, F_TOT_ATP DESC, F_ATK_TOT DESC, F_BLO_TOT DESC) AS TOT_SUC_DPOS			

			,RANK()		  OVER(ORDER BY F_TOT_ATP DESC) AS TOT_ATP_RANK
			,ROW_NUMBER() OVER(ORDER BY F_TOT_ATP DESC, F_TOT_SUC DESC, F_ATK_TOT DESC) AS TOT_ATP_DPOS			
			
			FROM @Result) AS B 
				ON A.F_RegisterID = B.F_RegisterID
			
			--删除数值为0的Rank，例如，一个人ATK三种都为0,那么关于ATK的Rank为NULL,但保留其DispPos
			UPDATE A SET
				  F_ATK_SUC_RANK = CASE WHEN F_ATK_SUC = 0 AND F_ATK_CNT = 0 AND F_ATK_FLT = 0 THEN NULL ELSE F_ATK_SUC_RANK END
				, F_ATK_EFF_RANK = CASE WHEN F_ATK_SUC = 0 AND F_ATK_CNT = 0 AND F_ATK_FLT = 0 THEN NULL ELSE F_ATK_EFF_RANK END
				
				, F_BLO_SUC_RANK = CASE WHEN F_BLO_SUC = 0 AND F_BLO_CNT = 0 AND F_BLO_FLT = 0 THEN NULL ELSE F_BLO_SUC_RANK END
				, F_BLO_AVG_RANK = CASE WHEN F_BLO_SUC = 0 AND F_BLO_CNT = 0 AND F_BLO_FLT = 0 THEN NULL ELSE F_BLO_AVG_RANK END
				
				, F_SRV_SUC_RANK = CASE WHEN F_SRV_SUC = 0 AND F_SRV_CNT = 0 AND F_SRV_FLT = 0 THEN NULL ELSE F_SRV_SUC_RANK END
				, F_SRV_AVG_RANK = CASE WHEN F_SRV_SUC = 0 AND F_SRV_CNT = 0 AND F_SRV_FLT = 0 THEN NULL ELSE F_SRV_AVG_RANK END
				
				, F_DIG_AVG_RANK = CASE WHEN F_DIG_EXC = 0 AND F_DIG_CNT = 0 AND F_DIG_FLT = 0 THEN NULL ELSE F_DIG_AVG_RANK END
				, F_SET_AVG_RANK = CASE WHEN F_SET_EXC = 0 AND F_SET_CNT = 0 AND F_SET_FLT = 0 THEN NULL ELSE F_SET_AVG_RANK END
				, F_RCV_SUCC_RANK = CASE WHEN F_RCV_EXC = 0 AND F_RCV_CNT = 0 AND F_RCV_FLT = 0 THEN NULL ELSE F_RCV_SUCC_RANK END
				
				, F_TOT_SUC_RANK = CASE WHEN F_TOT_SUC = 0 THEN NULL ELSE F_TOT_SUC_RANK END
				, F_TOT_ATP_RANK = CASE WHEN F_TOT_ATP = 0 THEN NULL ELSE F_TOT_ATP_RANK END
				
			FROM @Result AS A
			
			
	RETURN


END

/*
go
Select * from  [dbo].[func_VB_GetStatMatchAthlete](1, DEFAULT, DEFAULT)
*/


GO
/************************func_VB_GetStatMatchAthlete OVER*************************/


/************************func_VB_GetStatMatchTeam Start************************/GO


----功		  能：一场比赛双方队伍的技术统计列表
----作		  者：王征 
----日		  期: 2010-10-14

--2011-01-26	BLO写成了ATK
--2011-01-28	ATK_SUC
--				添加获取某局数值支持

CREATE function [dbo].[func_VB_GetStatMatchTeam]
			(
				@MatchID		INT,
				@CompPos		INT,
				@CurSet			INT = 0		--第几局,默认为整场比赛
			)
Returns @Result TABLE ( 
				F_TeamRegID		INT,		-- * 自己计算的
				F_CompPos		INT,
				
				F_ATK_SUC		INT,		--扣球得分
				F_ATK_CNT		INT,		--扣球一般
				F_ATK_FLT		INT,		--扣球丢分
				F_ATK_TOT		INT,		--* 总数	= SUC + CNT + FLT
				F_ATK_EFF		FLOAT,		--* 扣球有效率	= SUC - FLT / TOT
				
				F_BLO_SUC		INT,		--拦网得分
				F_BLO_CNT		INT,		--拦网过网
				F_BLO_FLT		INT,		--拦网丢分
				F_BLO_TOT		INT,		--* 扣球总数	= SUC + CNT + FLT
				F_BLO_AVG		FLOAT,		--* 扣球平均值	= SUC / Set count
				
				F_SRV_SUC		INT,		--发球得分
				F_SRV_CNT		INT,		--发球过网
				F_SRV_FLT		INT,		--发球丢分
				F_SRV_TOT		INT,		--* 发球总数	= SUC + CNT + FLT
				F_SRV_AVG		FLOAT,		--* 发球平均值	= SUC / Set count
				
				F_DIG_EXC		INT,		--防守好
				F_DIG_CNT		INT,		--防守一般
				F_DIG_FLT		INT,		--防守丢分
				F_DIG_TOT		INT,		--* 防守总数	= EXC + CNT + FLT
				F_DIG_AVG		FLOAT,		--* 防守平均值	= EXC / Set count
				
				F_SET_EXC		INT,		--二传好
				F_SET_CNT		INT,		--二传一般
				F_SET_FLT		INT,		--二传丢分
				F_SET_TOT		INT,		--* 二传总数	= EXC + CNT + FLT
				F_SET_AVG		FLOAT,		--* 二传平均值	= EXC / Set count
				
				F_RCV_EXC		INT,		--接发到位
				F_RCV_CNT		INT,		--接发一般
				F_RCV_FLT		INT,		--接发丢分
				F_RCV_TOT		INT,		--* 接发总数	= EXC + CNT + FLT
				F_RCV_SUCC		FLOAT,		--* 接发成功率	= EXC / RCV TOT
				
				F_OPP_ERR		INT,		--对方失误
				F_TEM_FLT		INT,		--本队失误
				
				F_TOT_SUC		INT,		--总得分 ATK_SUC + BLO_SUC + SRV_SUC + OPP_ERR
				F_TOT_ATP		INT			--总出手 ATK_TOT + BLO_TOT + SRV_TOT
			)
As
BEGIN

	--参数错误检测
	IF ( @MatchID < 0 OR @CompPos < 1 OR @CompPos > 2 OR @CurSet < 0 OR @CurSet > 5 )
	BEGIN
		RETURN
	END

	--填充两队的
	INSERT INTO @Result(F_TeamRegID, F_CompPos)

	Select F_RegisterID, F_CompetitionPosition FROM TS_Match_Result
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	ORDER BY F_CompetitionPosition
		
	--填充各种基本技术统计项
	UPDATE @Result SET 
	 F_ATK_SUC = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'ATK_SUC')
	,F_ATK_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'ATK_CNT')
	,F_ATK_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'ATK_FLT')		
	
	,F_BLO_SUC = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'BLO_SUC')
	,F_BLO_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'BLO_CNT')
	,F_BLO_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'BLO_FLT')
	
	,F_SRV_SUC = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'SRV_SUC')
	,F_SRV_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'SRV_CNT')
	,F_SRV_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'SRV_FLT')
	
	,F_DIG_EXC = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'DIG_EXC')
	,F_DIG_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'DIG_CNT')
	,F_DIG_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'DIG_FLT')	
		
	,F_SET_EXC = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'SET_EXC')
	,F_SET_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'SET_CNT')
	,F_SET_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'SET_FLT')
	
	,F_RCV_EXC = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'RCV_EXC')
	,F_RCV_CNT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'RCV_CNT')
	,F_RCV_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'RCV_FLT')
	
	,F_TEM_FLT = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'TEM_FLT')
	,F_OPP_ERR = dbo.func_VB_GetStatValueByStatCode(0, F_TeamRegID, @MatchID, @CurSet, 'OPP_ERR')
	
	--总数计算
	UPDATE @Result SET
	 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
	,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
	,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
	,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
	,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
	,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
			
	--汇总计算
	UPDATE @Result SET
	 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC + F_OPP_ERR
	,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT
			
			
	--当前局即为此场比赛共有几局
	DECLARE @SetCnt FLOAT = 0
	SELECT @SetCnt = CAST(F_MatchComment1 AS FLOAT ) FROM TS_Match WHERE F_MatchID = @MatchID
			
	--平均值,有效率计算
	UPDATE @Result SET
	 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
	,F_BLO_AVG = F_BLO_SUC / @SetCnt 
	,F_SRV_AVG = F_SRV_SUC / @SetCnt
	,F_DIG_AVG = F_DIG_EXC / @SetCnt
	,F_SET_AVG = F_SET_EXC / @SetCnt
	,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
	RETURN

END


/*
go
Select * from  [func_VB_GetStatMatchTeam](2, 1)
*/



GO
/************************func_VB_GetStatMatchTeam OVER*************************/


/************************func_VB_GetTeamMatchHistoryList Start************************/GO


----功  能：获取一支队伍的历史战纪,按比赛时间由近到远排序
----使用者：所有显示历史战绩的，都从此处获取 
----作者：王征 
----日   期: 2011-06-08

--2011-06-08	Created
CREATE function [dbo].[func_VB_GetTeamMatchHistoryList]
			(
				@RegisterID		INT
			)
Returns @Result TABLE ( 
				F_MatchID		INT,
				F_MatchStatusID	INT,
				F_MatchDate		DATETIME,
				F_MatchTime		DATETIME,	
				F_CompPos		INT,
				F_RegID_A		INT,
				F_RegID_B		INT,
				F_RegID_Oppr	INT,
				F_Rank_A		INT,
				F_Rank_B		INT,
				F_Rank			INT	
		)				
As
BEGIN

	INSERT INTO @Result(F_MatchID, F_CompPos, F_MatchStatusID, F_MatchDate, F_MatchTime)
	SELECT A.F_MatchID, B.F_CompetitionPosition, F_MatchStatusID, F_MatchDate, F_StartTime FROM TS_Match AS A
	INNER JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_RegisterID = @RegisterID
	ORDER BY A.F_MatchDate DESC, A.F_StartTime DESC
	
	UPDATE A SET 
		  F_RegID_A = ( SELECT F_RegisterID FROM TS_Match_Result WHERE F_CompetitionPosition = 1 AND F_MatchID = A.F_MatchID )
		, F_RegID_B = ( SELECT F_RegisterID FROM TS_Match_Result WHERE F_CompetitionPosition = 2 AND F_MatchID = A.F_MatchID )
		, F_Rank_A	= ( SELECT F_Rank FROM TS_Match_Result WHERE F_CompetitionPosition = 1 AND F_MatchID = A.F_MatchID )
		, F_Rank_B	= ( SELECT F_Rank FROM TS_Match_Result WHERE F_CompetitionPosition = 2 AND F_MatchID = A.F_MatchID )
	FROM @Result AS A
	
	UPDATE A SET
		    F_RegID_Oppr = ( SELECT CASE WHEN A.F_CompPos = 1 THEN F_RegID_B WHEN A.F_CompPos = 2 THEN F_RegID_A END)
		  , F_Rank = ( SELECT CASE WHEN A.F_CompPos = 1 THEN A.F_Rank_A WHEN A.F_CompPos = 2 THEN A.F_Rank_B END)
	FROM @Result AS A
	
	RETURN
END

/*
go
select * from dbo.[func_VB_GetTeamMatchHistoryList](1)
*/


GO
/************************func_VB_GetTeamMatchHistoryList OVER*************************/


/************************func_VB_GetTeamNameByRegID Start************************/GO



--所有获取TeamName的地方都应该从此处调用
--根据每个赛事需求不同，通过更改此函数，来实现显示不同的标题

--					团队						团队					双人								双人
--					ENG							CHN						ENG									CHN
--NOC:				CHN							CHN						WangZheng/Mayuchao					王征/马玉超
--TeamNameS			China						中国					Wangzheng/Mayuchao(China)			王征/马玉超(中国)
--TeamNameL			People republic of china	中华人名共和国			Wangzheng/Mayuchao(China)			王征/马玉超(中国)

--2011-04-02	Created
--2011-10-17	兼容VB和BV
--2012-09-05	整理为返回多个值
CREATE FUNCTION [dbo].[func_VB_GetTeamNameByRegID]
(
	@RegisterID		INT,
	@LangCode		CHAR(3)
)

RETURNS @Result TABLE (
			F_Noc			NVARCHAR(100),
			F_TeamNameS		NVARCHAR(100),
			F_TeamNameL		NVARCHAR(100)
		)
AS
BEGIN
	
	DECLARE @DiscCode NVARCHAR(100) = ( SELECT TOP 1 F_DisciplineCode FROM TS_Discipline WHERE F_Active = 1)
	DECLARE @RegType INT = (SELECT F_RegTypeID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	
	IF (@RegType = 3) -- For team, VO
		INSERT INTO @Result
		SELECT C.F_DelegationShortName AS F_Noc, C.F_DelegationShortName AS F_TeamNameS, C.F_DelegationLongName AS F_TeamNameL 
		FROM TR_Register AS A  
		LEFT JOIN TC_Delegation AS B ON A.F_DelegationID = B.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS C ON C.F_LanguageCode = @LangCode AND C.F_DelegationID = A.F_DelegationID
		WHERE A.F_RegisterID = @RegisterID
	
	ELSE -- For Pair, BV
		INSERT INTO @Result
			SELECT 
			  C.F_DelegationShortName AS F_Noc
			, D.F_ShortName AS F_teamNameS
			, D.F_ShortName + '(' + C.F_DelegationShortName + ')' AS F_teamNameL
		FROM TR_Register AS A  
		LEFT JOIN TC_Delegation AS B ON A.F_DelegationID = B.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS C ON C.F_LanguageCode = @LangCode AND C.F_DelegationID = A.F_DelegationID
		LEFT JOIN TR_Register_Des AS D ON D.F_RegisterID = A.F_RegisterID AND D.F_LanguageCode = @LangCode
		WHERE A.F_RegisterID = @RegisterID
	
	RETURN
END

/*
go
select * from dbo.func_VB_GetTeamNameByRegID(1, 'CHN')
*/



GO
/************************func_VB_GetTeamNameByRegID OVER*************************/


/************************func_VB_GetTournamentChart Start************************/GO


--2011-10-15	Created	
--2011-11-01	写死PhaseCnt = 1
--2011-11-12	写死PhaseCnt = 3
--2012-09-05	Phase is dynamic
CREATE function [dbo].[func_VB_GetTournamentChart]
			( 
				@EventID		INT
			)
Returns @Result TABLE(
		F_ChartNum			INT,			--可以输出多个晋级图
		F_MatchPos			INT,			--应为1~12
		F_MatchID			INT,
		F_Rank				INT,
		F_RankRegID			INT
)
AS
BEGIN

	--此Event中金字塔的数量，通过判断金字塔顶点Phase(Type=3)来确定,
	--例如有2个，那么MatchNum肯定就有从101-112,201-212
	DECLARE @PhaseCnt INT
	SELECT @PhaseCnt = COUNT(*) FROM TS_Phase where F_PhaseType = 3 AND F_EventID = @EventID 

	--循环每个金字塔
	DECLARE @CycChart INT=1
	WHILE( @CycChart <= @PhaseCnt )
	BEGIN
	
		DECLARE @CycMatchNum INT = 1
		WHILE(@CycMatchNum <= 12)
		BEGIN
			
			--确定此场比赛的MatchNum
			DECLARE @TmpMatchNum NVARCHAR(100) = ''
				SELECT @TmpMatchNum = CAST(@CycChart AS NVARCHAR(100)) + RIGHT(N'00' + CONVERT(NVARCHAR(2), @CycMatchNum), 2)
			
			--确定此场比赛的MathcID
			DECLARE @TmpMatchID INT = NULL
				SELECT @TmpMatchID = F_MatchID FROM TS_Match AS A
				INNER JOIN TS_Phase AS B ON b.F_PhaseID = A.F_PhaseID AND B.F_EventID = @EventID
				WHERE F_MatchNum = @TmpMatchNum 
			
			--插入此场比赛,就算是NULL,也插入
			INSERT INTO @Result(F_ChartNum, F_MatchPos, F_MatchID) SELECT @CycChart, @CycMatchNum, @TmpMatchID
					
			SET @CycMatchNum = @CycMatchNum + 1
		END
		
		SET @CycChart = @CycChart + 1
	END
	
	--从名次列表插入对应的RankTitle和Register
	UPDATE A SET
		  A.F_Rank = B.F_Rank
		, A.F_RankRegID = B.F_RegisterID
	FROM @Result AS A
	LEFT JOIN func_VB_GetEventRankList(@EventID) AS B ON B.F_Rank = (A.F_ChartNum-1)*12 + F_MatchPos
	
	RETURN
END

/*
GO
SELECT * FROM [func_VB_GetTournamentChart](31)
*/


GO
/************************func_VB_GetTournamentChart OVER*************************/

