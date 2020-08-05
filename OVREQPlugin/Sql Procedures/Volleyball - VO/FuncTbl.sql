
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


--��ȡ������Ա��ID
--Ϊ��ɳ��ʹ��

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
	INNER JOIN TR_Register AS B ON B.F_RegisterID = A.F_MemberRegisterID AND B.F_RegTypeID = 1 	--ֻҪ�˶�Ա
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


----��  �ܣ���ȡһ������һ�ֵĻ����б� 
----��	��: 2011-02-18
----ÿһ�����ˣ�����һ��
----����ʵ�����ã����ص��п����ǲ���ȷ��

--2011-04-02	Created
CREATE function [dbo].[func_VB_GetChangeUpList]
	(
		@MatchID		INT,		--������
		@CompPos		INT,		-- 1:A��  2:B��
		@CurSet			INT=NULL	--Ĭ�ϵ�ǰ��
	)
Returns @Result TABLE ( 
				F_Order				INT,
				F_OrderInActionList	INT,	--���³���Ϣ��ActionList���е�Order���Դ�Ϊ��ʶ�������ϳ���Ϣ
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

	--�������
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
	
	--���������л�����Ϣ������ʱ��
	INSERT INTO @TempActionList
	SELECT F_ActionOrder, F_RegisterID, F_ActionTypeID From TS_Match_ActionList 
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurSet AND F_CompetitionPosition = @CompPos
		AND F_ActionTypeID IN ( 19, 20, 21, 22) AND F_ActionOrder > 7 
	ORDER BY F_ActionOrder
	
	--�������³���Ϣ����
	INSERT INTO @Result(F_OutRegisterID, F_OrderInActionList, F_Order)
	SELECT 
		  F_RegisterID 
		, F_Order
		, ROW_NUMBER() OVER(ORDER BY F_Order)
	FROM @TempActionList WHERE F_ActionTypeID IN ( 20, 22 )
	
	--�ڶ����б��У������ң������³��������ϳ���������Ϊ���˵��ϳ���Ϣ
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
--2011-03-20	RscCode��GenderCode�ᵽEventCodeǰ
--2011-03-21	��ȡRscCodeͨ��ͳһ����func_VB_GetRscCode
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


--���ܣ���ȡһ���������Ϣ,�������������н����б��Ӵ˻�ȡ
--ע�⣺ֻ�����н��Ƶ�

--2011-05-20	����д��EventID�Ĵ���
--2011-06-23	ǿ������
--2012-09-05	��Ϊ��������������Ϣ,�����������Ƶ�����
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
        (	--�൱�ڵ�@PoolOrTour=1ʱ,ֻҪIsPool=1��ֵ����@PoolOrTour=2ʱ,ֻҪIsPool<>1��ֵ
			( @PoolOrTour = 1 AND B.F_PhaseIsPool = 1 )
			OR
			( @PoolOrTour = 2 AND B.F_PhaseIsPool = 0 AND F_MatchNum > 100 )
		)
    
		ORDER BY B.F_Order, A.F_MatchDate, A.F_StartTime
		
    /*    ORDER BY B.F_Order, A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), 
		--�����ת����INT,�Ͱ�INT����
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






----��		  �ߣ�����
----��		  ��: 2010-12-20
----ʹ����:			REPORT,INFO			

--2011-03-16	�޸��Լ����Լ��ı������Ϊ''
--2011-04-08	Modify TeamName
--2011-04-12	delete match stats when it have no matches
--				Add shirt colors\
--2011-06-08	Add RegOrder,�˶�����С���е�ǩλ��
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

						F_MemberCount		INT,			--��Ա����
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
    
    --�����ֿ�
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
	
    --����û�н��б�����
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
	
	--��Ա����
	UPDATE A SET 
		F_MemberCount = (SELECT COUNT(*) FROM @Result WHERE F_PhaseID = A.F_PhaseID AND F_RegisterID > 0 )
	FROM @Result AS A
 

	--�������ɼ�
	DECLARE @TmpPhaseID		INT
	DECLARE @FetchStatus	INT
	DECLARE CSR_Action CURSOR STATIC FOR 
	SELECT DISTINCT F_PhaseID FROM @Result
	OPEN CSR_Action
	
	FETCH NEXT FROM CSR_Action INTO @TmpPhaseID
	SET @FetchStatus = @@FETCH_STATUS
	
	WHILE( @FetchStatus = 0 )
	BEGIN
		
		--������6��λ��RegisterID������6λ�ĺ���Ϊ��
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
		
		--DispPos1 ��ǩλ1������ǩλ��ÿ�������ȷ�����
		UPDATE @Result SET 
		  F_Score1 = ''
		, F_Score2 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg2, @LangCode )
		, F_Score3 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg3, @LangCode )
		, F_Score4 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg4, @LangCode )
		, F_Score5 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg5, @LangCode )
		, F_Score6 = dbo.func_VB_GetMatchResultByRegAB(@TmpPhaseID, @DispPosReg1, @DispPosReg6, @LangCode )
		WHERE F_PhaseID = @TmpPhaseID AND F_DisplayPos = 1
		
		--DispPos2 ��ǩλ2������ǩλ��ÿ�������ȷ�����
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


----��  �ܣ���ȡVB��IRM��Ϣ,�����ڵ�һ�в�����NULL,������IRM��Ϣ
----ʹ����: 
----���ߣ����� 
----��   ��: 2011-01-27

--������ʹ��
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
	
	--����ID
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


----��  �ܣ���ȡһ������һ�ֵ��׷�����������Ϊ7�У����һ��Ϊ������
----��	��: 2011-02-18
----��ȷ�Ļ�������7�У�ǰ6��Ϊ6��λ����7��Ϊ������
----����ʵ�����ã����ص��п����ǲ���ȷ��

--2011-03-04	���� @ComPos��CurSet����λ�ã�@CurSet���Ĭ��ֵ
CREATE function [dbo].[func_VB_GetLineUpList]
	(
		@MatchID		INT,		--������
		@CompPos		INT,		-- 1:A��  2:B��
		@CurSet			INT=NULL	--Ĭ�ϵ�ǰ��
	)
Returns @Result TABLE ( 
				F_Order			INT,
				F_ShirtNumber   INT,      
				F_RegisterID    INT,
				F_RegisterCode	NVARCHAR(100),
				F_ActionTypeID	INT,		--ӦΪ19��21
				F_Position		CHAR(1)		--λ�ã� 1-6��L
			)
As
BEGIN

	if ( @CurSet IS NULL )
	BEGIN
		SELECT @CurSet = F_CurSet FROM dbo.func_VB_GetMatchInfo(@MatchID, 'ENG')
	END

	--�������
	IF @MatchID < 1 OR @CurSet < 1 OR @CurSet > 5 OR @CompPos < 1 or @CompPos > 2 
	BEGIN
		RETURN
	END
	
	DECLARE @ActPlyInID AS INT --ѡ���ϳ���ActionID
	SELECT @ActPlyInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Ply_In'
	
	DECLARE @ActLibInID AS INT --�������ϳ���ActionID
	SELECT @ActLibInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Lib_In'
	
	IF @ActPlyInID IS NULL OR @ActLibInID IS NULL
	BEGIN
		RETURN
	END
	
	--������ͳ��ǰ7�в���˱�
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
	
	--���Code,ShirtNumber	
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


----��  �ܣ���ȡһ������������Ϣ
----ʹ����: �κ����ʹ����,��Ӧ���ô˺���
----���ߣ����� 
----��   ��: 2010-12-17

--2011-01-13	��RscCode
--2011-01-27	Add IRM_Code, IRMA->IRMIDA, Delete WinTpe
--2011-02-21	Add PhaseDes
--2011-03-04	Modify Referees
--2011-03-08	Add EventInfo
--2011-03-10	Add Speratator
--				Modify Referee funcID
--2011-03-20	RscCode��ǰ
--2011-03-21	��ȡRscCodeͨ��ͳһ����
--2011-04-14	Add ',' between PhaseDes1 and PhaseDes2
--2011-04-21	������ʾ"Play off"	
--2011-06-13	Add Week info
--2011-07-25	Add F_WinSetsIrmA
--2011-08-12	match num Ϊ RaceNum

--2011-10-15	Delete something

--2011-11-02    Ϊ��ɳ�ţ����ӳ�Ա����
--2011-12-05	��������RSC code λ��
--2012-08-27	NOC��ͬһ������ȡ
--2012-09-06	ֻ����������Ϣ
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
				F_Spectators		NVARCHAR(100),		-- ��������

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

		/*		F_Rank				INT,				-- 0:δ�� 1: Aʤ, 2: Bʤ
				F_WinType			INT,				-- 0:δ�� 1:�ȷ�ʤ 2:��Է�IRM��ʤ��
				F_IRMIDA			INT,				-- ����: NULL �� IRM_ID
				F_IRMIDB			INT,
				F_IRMCodeA			NVARCHAR(100),		-- NULL �� DNS,DNF,DSQ
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
	
	--����ID
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


	--˫��NOC,Name,RscCode
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
	--����VBMatchDes������ʽ��
	--Ԥ����ΪFatherPhaseComment + PhaseNameComment + MatchNum,
	--������ΪPhaseComment + MatchNum
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
			SET @MatchDesCHN = '��' + @MatchNum + '��'
			
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


----��  �ܣ���ȡ���������ճ�, ֻ��ȡ�ѱ��ź�֮��ı���
----��  ;��������Χ��Competition Schedule�Ķ���,��Ӧ�Ӵ˻�ȡ, RPT,INFO,CIS��
----��  �ߣ����� 
----��  �ڣ�2011-01-10

--2011-02-18	���� ��ǰ��getCompetition Sehedule
--				��������ɸѡ����

--2011-02-22	֧�ְ��ƶ��ڼ����ȡ����
--2011-03-21	Rsc��ͳһ������ȡ
--2011-06-17	�޸�����ɸѡ�Ĵ���
--2011-12-05	�޸�RscCode���ͣ������������
--2012-09-05	only output needed field
CREATE function [dbo].[func_VB_GetMatchSchedule]
			(
				@IsCurDate	INT = NULL		--0:��ʾֻҪ��������	NULL:��������	1-N:��N������
			)
Returns @Result TABLE ( 
			F_Order			INT,
			F_MatchID		INT,
			
			F_MatchDay		INT,			--�����ڵڼ���
			F_MatchDate		DATE,
			F_MatchTime		TIME,
			F_MatchStatusID	INT
		)
						
As
BEGIN
	
	--���������б���,�ѱ��źõ�, Order by Date,Time
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
	
	
	--ɾ���ǽ�������,�����������СΪ��һ��,���Ϊ���һ��
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
		--���ָ���˵ڼ�����ߵ�ǰ,��ɾ��������ı���
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
		
		
	--����ڼ������
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


----��		  �ܣ���ȡһ�������ıȷ�
----��		  �ߣ����� 
----��		  ��: 2010-09-20 

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
		F_Serve				INT,			-- 1:TeamA 2:TeamB NULL:��ǰ����Ȩ��Ϣ
		F_CurSet			INT,			-- 1-5��NULL:��ǰ�޾���Ϣ

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
		
		F_SetTime1			INT,			--�˾�����ʱ��,����ڵ�ǰ�ֺ�,ΪNULL
		F_SetTime2			INT,							
		F_SetTime3			INT,
		F_SetTime4			INT,	
		F_SetTime5			INT,
		F_TimeTotal			INT,			--����ʱ,������
	

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
		
		F_RankSet1			INT,			--1:TeamA 2:TeamB 0:δ�� NULL:������
		F_RankSet2			INT,
		F_RankSet3			INT,
		F_RankSet4			INT,
		F_RankSet5			INT,
		F_RankTot			INT,			--�ܳɼ�
		
		F_PointType			INT,			--0:None 1:SetPoint 2:MatchPoint
		F_PointTeam			INT,			--0:None 1:TeamA 2:TeamB
		F_PointCount		INT,			--0:None 1~N
		F_PointCountDes		NVARCHAR(100),	-- '' 1st 2nd 3rd
		
		F_WinType			INT,				-- 0:δ�� 1:�ȷ�ʤ 2:��Է�IRM��ʤ��
		F_IrmIdA			INT,				-- ����: NULL �� IRM_ID
		F_IrmIdB			INT,
		F_IrmCodeA			NVARCHAR(100),		-- NULL �� DNS,DNF,DSQ
		F_IrmCodeB			NVARCHAR(100),
		
		F_PtsASetIrm		NVARCHAR(100),		--0(DNS)
		F_PtsBSetIrm		NVARCHAR(100)
	)
AS
BEGIN
						
		--�Ȳ���һ����
		INSERT INTO @Result(F_Serve) VALUES(NULL)
		
		--�ܷ�
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
		  
		  
		
		--ÿ�����õı���			
		DECLARE @SetWin			INT
		DECLARE @SetTime		INT
		DECLARE @SetPtsA		INT
		DECLARE @SetPtsB		INT
		DECLARE @SetPtsADes		NVARCHAR(100)
		DECLARE @SetPtsBDes		NVARCHAR(100)
		
		
		--��1��
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
		
			
		--��2��	
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
		
		
		--��3��	
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
	
	
		--��4��	
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
		
		
		--��5��	
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
		
		
		--Sets �����һ�ֱȷ�Ϊ�գ���ô�ֺܷ;ַ�ҲΪ��
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
					
				
		--д��˫��IRM,WinType����Ϣ
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
		
		
		--����WinSetsIrm
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


----��  �ܣ���ȡһ��������������,������ͳ��,
----ʹ����: ����������ҪStartList��,��������ô˺���ʵ��, RPT,INFO,CIS��
----��	�ߣ����� 
----��	��: 2010-10-14

--2011-01-13	F_Birth_Date -> F_DateOfBirth
--				Add F_Order, ���򷽷�

--2011-03-22	���ӷֱ�ͳ��
--2011-05-25	����Ƿ���ҪSTAT�Ŀ���
--2012-09-05	Only output most needed information
CREATE function [dbo].[func_VB_GetMatchStartList]
	(
		@MatchID	INT,
		@NeedStat	INT=0	--Ĭ�ϲ���Ҫ����ͳ��
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
				F_SUC_TOT		INT,	--�÷����� F_ATK_SUC+F_BLO_SUC+F_SRV_SUC
				F_PER_TEM		FLOAT	--�÷���ռȫ�Ӱٷֱ� F_SUC_TOT / ȫ��F_SUC_TOT
						)
As
BEGIN
		
	--������Ӷ�ԱID
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
				
	--���Code,FunctionID, SpikeHigh, BlockHigh
	UPDATE A SET	
	  A.F_SpikeHigh = ( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Spike' AND F_RegisterID = A.F_RegisterID )
	, A.F_BlockHigh = ( SELECT TOP 1 F_Comment FROM TR_Register_Comment WHERE F_Title = 'Block' AND F_RegisterID = A.F_RegisterID )
	FROM @Result AS A

	IF(@NeedStat = 1)
	BEGIN
	
		--���STAT,���Ǳ�������ǰ��
		UPDATE @Result SET
		  F_ATK_SUC = dbo.func_VB_GetStatValueByStatCode(1, F_RegisterID, @MatchID, 0, 'ATK_SUC')
		, F_BLO_SUC = dbo.func_VB_GetStatValueByStatCode(1, F_RegisterID, @MatchID, 0, 'BLO_SUC')
		, F_SRV_SUC = dbo.func_VB_GetStatValueByStatCode(1, F_RegisterID, @MatchID, 0, 'SRV_SUC')
		
		--����STAT�ܼ�
		UPDATE @Result SET
		  F_SUC_TOT = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC

		--��������÷�,ͨ���������ٷֱ�
		DECLARE @TeamSucTotA FLOAT
		DECLARE @TeamSucTotB FLOAT
		SELECT @TeamSucTotA = SUM(F_SUC_TOT) FROM @Result WHERE F_CompPos = 1
		SELECT @TeamSucTotB = SUM(F_SUC_TOT) FROM @Result WHERE F_CompPos = 2
		
		--����ÿ���˵÷ֵİٷֱ�
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


----��  �ܣ���ȡ����ͳ����� Step1:��ȡ�б�,���ֳ��غ�. �����м���
----ʹ���ߣ��˺���ֻ�����ȡ�б�,�ֳ��غ�; ����ȷ�,���,������ת��Step2�н���
----��  �ߣ����� 
----��	��: 2010-10-14

--2011-03-23	Ĭ�ϵ�ǰ��
CREATE function [dbo].[func_VB_GetMatchStatActionList_Step1_OriginList]
	(
		@MatchID				INT,
		@SetNum					INT=NULL
	)
Returns @Result TABLE ( 
							F_Order				INT,			--���,������,ǰ7��Ӧ����˫���׷�,RallyֵΪ0
							F_RallyNum			INT,			--�غ���,ֻ��û�غ����һ������,��ʾ,����ΪNULL
							F_IsLastRowInRally	INT,			--����Ϊ��Rally���һ��
							
							F_ActionNumID_A		INT,			--��������Ӧ��ActionNumberID, �޶���ΪNULL
							F_ActionRegID_A		INT,			--�����������˶�ԱID,���Ϊ�������,ΪNULL
							F_ActionTypeID_A	INT,			--�˶������,�޶���ΪNULL
							F_ActionEffect_A	INT,			--�˶����Աȷֵ�Ӱ�� -1,0,1  ���ڻ���:NULL
							F_ActionKindID_A	INT,			--�˶�����ϸ���,��ҪΪ����ʾ��ɫ��, 1:δ��ʧ�� 2:�÷֣�3:ʧ�� 4:��Ա�ϳ� 5:��Ա�³� 6:�������ϳ� 7:�������³� 8:�д����
							
							F_ActionNumID_B		INT,
							F_ActionRegID_B		INT,
							F_ActionTypeID_B	INT,
							F_ActionEffect_B	INT,
							F_ActionKindID_B	INT
						)
As
BEGIN

	--һЩ����ֵ
	DECLARE @ActIdPlayIn	INT=19
	DECLARE @ActIdPlayOut	INT=20
	DECLARE @ActIdLibIn		INT=21
	DECLARE @ActIdLibOut	INT=22
	DECLARE @ActIdSrvSuc	INT=7
	DECLARE @ActIdSrvCnt	INT=8
	DECLARE @ActIdSrvFlt	INT=9
	
	--�α��õ���ʱ����	
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
    
    --����TeamA�α�
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
	
	--����TeamB�α�
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
		
		
	--������
    DECLARE @cntRally		INT = 0		--�غϼ�����
    DECLARE @cntRow			INT = 0		--�м�����
		
	DECLARE @FetchStatusA	INT
	DECLARE @FetchStatusB	INT
		
	OPEN CSR_Action_A
	OPEN CSR_Action_B
	
	FETCH NEXT FROM CSR_Action_A INTO @TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A 
	SET @FetchStatusA = @@FETCH_STATUS
	
	FETCH NEXT FROM CSR_Action_B INTO @TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B 
	SET @FetchStatusB = @@FETCH_STATUS
	
	
	--�����׷�,ֻ��A,Bƽ�е��׷�����ȡ����
		--�ȴ���˫�����еĲ���,һ�����A,B��������,�׷�,�����˶���
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
								
				--�����ƶ�һ��
				FETCH NEXT FROM CSR_Action_A INTO 
					@TmpActionNumberID_A, @TmpActionTypeID_A, @TmpActionEffect_A, @TmpActionKindID_A, @TmpRegisterID_A
				SET @FetchStatusA = @@FETCH_STATUS
				
				FETCH NEXT FROM CSR_Action_B INTO 
					@TmpActionNumberID_B, @TmpActionTypeID_B, @TmpActionEffect_B, @TmpActionKindID_B, @TmpRegisterID_B
				SET @FetchStatusB = @@FETCH_STATUS				
			END
		
		--���A��B�������,��ʵ���Ǵ����,ÿ����ֻ��A������
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
		
		--���B��A�������,��ʵ���Ǵ����,ÿ����ֻ��B������
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
	--�׷�������� 
	
		
	--���洦����ͳ��	
	
		--����Rally����ʼ��
		DECLARE @CurRallyStartRow		INT = 0		
				
		--��ǰAction�Ƿ�Աȷ���Ӱ��,��Ӱ�������һ��Rally�Ľ���
		--ÿ��Rally�������Ӱ��ȷֵ�Action���붼�����һ��
		--���������Ȳ������ӷ�Ӱ��ȷֵ�Action,ֱ������Ӱ��ȷֵ�Action��,��ͬ��һ�����,��ʵ���˴�Ҫ��
		DECLARE @EffectScoreInRallyA	INT = @TmpActionEffect_A
		DECLARE @EffectScoreInRallyB	INT = @TmpActionEffect_B
		
		--ѭ��ÿ��Rally,ֱ�����м�¼����ȡ��
		WHILE( @FetchStatusA = 0 OR @FetchStatusB = 0 )	
		BEGIN
			
			--���õ�ǰRally����ʼ��,������Rally�����֮��,������
			SET @CurRallyStartRow = @cntRow
				
			--�Ȱ�˫��δӰ��÷ֵĶ���,����@Result
			--����STAT�ĵ÷ֱ�־��ȷ���غϵķָ�,����ʱ,��һ��STAT���ǵ�/ʧ�ֵ�,
			--����ÿ�غϵ�һ������ͳ�Ʋ�����/ʧ�ֱ�־���ж�			
			
				--�Ȳ���˫�����еĲ�Ӱ���/ʧ�ֵ�Action
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
				
				--���A�б�B������ķ�Ӱ���/ʧ��Action,��������
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
				
				--���B�б�A������ķ�Ӱ���/ʧ��Action,��������
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
			
			--���������,��ʣ�µ�,Ӧ�þ���˫��Ӱ��ȷֵ�Action,��Ȼ,����A��B��¼����ĩβ���������Ҫ����
			
				--�����һ������˫�����е�/ʧ�ȷֵ�Action,����һ��Rally��������,���ܻ����д���,������˫�����н�β
				--���������һ������,˵��������һ������ĩβ,��û�г��ֵ�ʧ�ֵ�Action,ֻ�ܲ������Action��һ��
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
				IF ( @FetchStatusA = 0 AND @EffectScoreInRallyA <> 0 ) --ֻ��A����Ӱ��ȷֵ�Action
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
				IF ( @FetchStatusB = 0 AND @EffectScoreInRallyB <> 0 ) --ֻ��B����Ӱ��ȷֵ�Action
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
			
			
			--����Rally��Ϣ
			IF ( 
				(	--˫�����е�ʧ����Ϣ
					( SELECT COUNT(F_ActionEffect_A) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_A <> 0 ) > 0  AND
					( SELECT COUNT(F_ActionEffect_B) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_B <> 0 ) > 0      
				) 
				OR
				(	--A���е�ʧ����Ϣ��B��û������
					( SELECT COUNT(F_ActionEffect_A) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_A <> 0 ) > 0  AND
					@FetchStatusB <> 0    
				)
				OR
				(	--B���е�ʧ����Ϣ��A��û������
					( SELECT COUNT(F_ActionEffect_B) FROM @Result WHERE F_Order > @CurRallyStartRow AND F_ActionEffect_B <> 0 ) > 0  AND
					@FetchStatusA <> 0    
				)
			   )
			BEGIN 
				SET @cntRally = @cntRally + 1
				UPDATE @Result SET F_RallyNum = @cntRally WHERE F_RallyNum IS NULL
				UPDATE @Result SET F_IsLastRowInRally = 1 WHERE F_Order = @cntRow
			END
						
		END --ѭ��ÿ��Rally
		
	--ÿ��Rally������	
	
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


----��  �ܣ���ȡĳ������ĳ�ֵļ���ͳ���б�
----ʹ���ߣ���������ȡ,����ʹ�ô˺���, RPT,INFO,CIS,�����������
----��  �ߣ����� 
----��	��: 2010-10-14

--2011-03-03	����һ�׷�TeamB����
--2011-06-02	�����˵�һ����ת
--2011-07-25	ǿ�Ʋ���ת
CREATE function [dbo].[func_VB_GetMatchStatActionList_Step2_ActionList](
		@MatchID				INT,
		@SetNum					INT
)RETURNS 
	@tblAction TABLE (

				F_Order				INT,			--���,������,ǰ7��Ӧ����˫���׷�,RallyֵΪ0
				F_IsLastRowInRally	INT,			--������һ��Rally�����һ�У�Rally��Ϣֻ�ڴ��д���
				F_RallyNum			INT,			--�غ���,ֻ��ÿ�غ����һ������,��ʾ,����ΪNULL
				F_RallyServe		INT,			--1: A���� 2: B����	NULL:�׷���˻غ��д�
				F_RallyEffect		INT,			--�˻غϽ��, 1:Aʤ, 2:Bʤ, -1:����   0:�׷���ȷ
				F_ScoreA_A			INT,			--�˻غϺ�,��A������ͳ�������A�ıȷ�
				F_ScoreB_A			INT,			--�˻غϺ�,��A������ͳ�������B�ıȷ�
				F_ScoreA_B			INT,			--�˻غϺ�,��B������ͳ�������A�ıȷ�
				F_ScoreB_B			INT,			--�˻غϺ�,��B������ͳ�������B�ıȷ�
				
				F_ActionNumID_A		INT,			--��������Ӧ��ActionNumberID,������TS_Match_ActionList������, �޶���ΪNULL
				F_ActionRegID_A		INT,			--�����������˶�ԱID,���Ϊ�������,ΪNULL
				F_ActionTypeID_A	INT,			--�˶������,�޶���ΪNULL
				F_ActionKindID_A	INT,			--�˶�����ϸ���,��ҪΪ����ʾ��ɫ��, 1:δ��ʧ�� 2:�÷֣�3:ʧ�� 4:��Ա�ϳ� 5:��Ա�³� 6:�������ϳ� 7:�������³� 8:�д���� NULL:����λ��
				F_ActionEffect_A	INT,			--�˶����Աȷֵ�Ӱ�� -1,0,1  ���ڻ���:NULL
				F_ActionIsError_A	INT,			--�˶����Ƿ��д��������ļ�飬���ִ˶���������,����1,����ΪNULL
					
				F_ActionNumID_B		INT,
				F_ActionRegID_B		INT,
				F_ActionTypeID_B	INT,
				F_ActionKindID_B	INT,
				F_ActionEffect_B	INT,
				F_ActionIsError_B	INT,
				
				F_CompPos			INT,
				F_Position			INT,
				F_RegID				INT,
				F_IsSetter			INT				--1:Ϊ�����֣�NULL:����
			)
	AS
	BEGIN

	--һЩ����ֵ
	DECLARE @ActIdSrvSuc	INT=7
	DECLARE @ActIdSrvCnt	INT=8
	DECLARE @ActIdSrvFlt	INT=9
	
	DECLARE @ActIdPlayIn	INT=19
	DECLARE @ActIdPlayOut	INT=20
	DECLARE @ActIdLibIn		INT=21
	DECLARE @ActIdLibOut	INT=22
	DECLARE @ActIdOppErr	INT=23
	DECLARE @ActIdTemFlt	INT=24
	
   	--������Ավλͼ
	DECLARE @tblPositon TABLE(
			F_CompPos	INT,
			F_Position	INT,
			F_RegID		INT,
			F_PosTurn	INT		--��ת�����λ��
		)
	
	DECLARE @PosTurnA	INT = 0			--˫����ת����
	DECLARE @PosTurnB	INT	= 0
	DECLARE @LastRallyEffect INT = NULL	--��һ�غ���Ӯ��Ϣ������������ת,��ʼֵ��ΪNULL,��ʾ��һ�غ�֮ǰ,
										--�ڵ�һ�غ�ʱ,�ᱻ��Ϊ�����һ��,��ʵ�ֵ�һ�����ת
    
    --��ʼ��������Ավλͼ
    INSERT INTO @tblPositon VALUES(1, 1, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 2, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 3, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 4, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 5, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 6, NULL, NULL)
    INSERT INTO @tblPositon VALUES(1, 7, NULL, NULL)	--������λ
    INSERT INTO @tblPositon VALUES(2, 1, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 2, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 3, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 4, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 5, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 6, NULL, NULL)
    INSERT INTO @tblPositon VALUES(2, 7, NULL, NULL)

	--��ȡAction�б�
	INSERT INTO @tblAction(F_Order, F_RallyNum, F_IsLastRowInRally
		, F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A
		, F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B )
	SELECT 
	  F_Order, F_RallyNum, F_IsLastRowInRally
	, F_ActionNumID_A, F_ActionTypeID_A, F_ActionEffect_A, F_ActionKindID_A, F_ActionRegID_A
	, F_ActionNumID_B, F_ActionTypeID_B, F_ActionEffect_B, F_ActionKindID_B, F_ActionRegID_B
	 FROM dbo.func_VB_GetMatchStatActionList_Step1_OriginList(@MatchID, @SetNum)
		
	--ѭ��A,B���õı���,�α�
	DECLARE @TmpOrder				INT	--�ڼ���
	DECLARE @TmpRallyNum			INT	--�ڼ��غ�
	DECLARE @TmpIsLastRowInRally	INT --�ǻغϵ����һ��
	
	DECLARE @TmpActionID_A			INT	--����ͳ�ƶ���ID
	DECLARE @TmpActionTypeID_A		INT	--����ͳ������ID
	DECLARE @TmpRegID_A				INT	--��ԱID
	DECLARE @TmpActionID_B			INT
	DECLARE @TmpActionTypeID_B		INT	--����ͳ������ID
	DECLARE @TmpRegID_B				INT
	DECLARE @FetchStatus			INT	--�α�״̬
	
	DECLARE CSR_Action CURSOR STATIC FOR 
	SELECT F_Order, F_RallyNum, F_IsLastRowInRally, 
	F_ActionTypeID_A, F_ActionKindID_A, F_ActionRegID_A, 
	F_ActionTypeID_B, F_ActionKindID_B, F_ActionRegID_B FROM @tblAction

	OPEN CSR_Action
	
	FETCH NEXT FROM CSR_Action INTO @TmpOrder, @TmpRallyNum, @TmpIsLastRowInRally, 
								@TmpActionID_A, @TmpActionTypeID_A, @TmpRegID_A, 
								@TmpActionID_B, @TmpActionTypeID_B, @TmpRegID_B
	SET @FetchStatus = @@FETCH_STATUS
			
	--���׷���Ϣװ��վλͼ	
		--DECLARE @LastRowInRally	INT = 0
	
		--���׷���Ϣ����վλͼ,����ֻ�����׷���������,RallyNum=0	
		WHILE( @FetchStatus = 0 AND @TmpRallyNum = 0 )
		BEGIN
		
			--�ж�TeamA�ϳ������Ƿ�Ϸ�,��:����վλͼ,��:�������׷�ͼ����Ϊ����
			IF ( 
					( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A) > 0 --վλͼ�����д��ˣ�˵���ظ��ϳ�
				 OR ( @TmpActionID_A <> @ActIdPlayIn AND @TmpActionID_A <> @ActIdLibIn ) --���Ƕ�Ա�ϳ���Ҳ�����������ϳ�
				 OR ( @TmpActionID_A = @ActIdPlayIn AND @TmpOrder > 6 ) --��ǰ6��λ�ó������������ϳ�
				 OR	( @TmpActionID_A = @ActIdLibIn  AND @TmpOrder < 7 ) --�ڵ�7��λ�ü��Ժ�����˷�������
				 OR ( @TmpOrder > 7 )	--������7��������
			   )
			BEGIN
				--���ô˶���Ϊ���󣬲��Ҳ�����ͼ
				UPDATE @tblAction SET F_ActionIsError_A = 1 
				WHERE F_Order = @TmpOrder
			END	
			ELSE
			BEGIN
				--�����ϣ������ϳ���������ͼ
				UPDATE @tblPositon SET F_RegID = @TmpRegID_A
				WHERE F_CompPos = 1 AND F_Position = @TmpOrder
			END
			
			--�ж�TeamB�ϳ������Ƿ�Ϸ�,��:����վλͼ,��:�������׷�ͼ����Ϊ����
			IF ( 
					( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B) > 0 --վλͼ�����д��ˣ�˵���ظ��ϳ�
				 OR ( @TmpActionID_B <> @ActIdPlayIn AND @TmpActionID_B <> @ActIdLibIn ) --���Ƕ�Ա�ϳ���Ҳ�����������ϳ�
				 OR ( @TmpActionID_B = @ActIdPlayIn AND @TmpOrder > 6 ) --��ǰ6��λ�ó������������ϳ�
				 OR	( @TmpActionID_B = @ActIdLibIn  AND @TmpOrder < 7 ) --�ڵ�7��λ�ü��Ժ�����˷�������
				 OR ( @TmpOrder > 7 )	--������7��������
			   )
			BEGIN
				--���ô˶���Ϊ���󣬲��Ҳ�����ͼ
				UPDATE @tblAction SET F_ActionIsError_B = 1 
				WHERE F_Order = @TmpOrder
			END	
			ELSE
			BEGIN
				--�����ϣ������ϳ���������ͼ
				UPDATE @tblPositon SET F_RegID = @TmpRegID_B
				WHERE F_CompPos = 2 AND F_Position = @TmpOrder
			END
			
			--SET @LastRowInRally = @TmpOrder
			
			FETCH NEXT FROM CSR_Action INTO @TmpOrder, @TmpRallyNum, @TmpIsLastRowInRally
			, @TmpActionID_A, @TmpActionTypeID_A, @TmpRegID_A
			, @TmpActionID_B, @TmpActionTypeID_B, @TmpRegID_B
			SET @FetchStatus = @@FETCH_STATUS
		END
		
		--���׷���Ϣ���������ж�
			--��������׷�վλ��δ�����,����Ϊ�׷��д�,�����û��
			IF ( (SELECT COUNT(*) FROM @tblPositon WHERE F_RegID IS NULL) > 0  )	
			BEGIN
				UPDATE @tblAction SET F_RallyEffect = -1 WHERE F_RallyNum = 0 AND F_IsLastRowInRally = 1
			END
			ELSE
			BEGIN
				UPDATE @tblAction SET F_RallyEffect =  0 WHERE F_RallyNum = 0 AND F_IsLastRowInRally = 1
			END
					
	--���׷���Ϣװ��վλͼ,���
	
	
	--ѭ��ÿ�غ�, ÿ�����������в��
		DECLARE @OrderInRally		INT = 1				--���Ǵ�Rally�еڼ�������
		DECLARE @CurRallyIsError	INT = 0				--��Rally�д���
		DECLARE @TeamAServe			INT = 0				--TeamA������� ��һ�μ�1,��ҪΪ��ʶ���η���
		DECLARE @TeamAResult		INT = 0				--TeamA��Rally��� Ӯ: 1 ��: -1
		DECLARE @TeamBServe			INT = 0
		DECLARE @TeamBResult		INT = 0

		WHILE ( @FetchStatus = 0 )
		BEGIN
				
			--TeamA�ķ����ද��
			IF ( @TmpActionID_A >= 7 AND @TmpActionID_A <= 9 ) 
			BEGIN
				SET @TeamAServe = @TeamAServe + 1 --�ۼӷ������
				
				--A����B���Ѿ���������, �������п��ܲ��ڵ�һ��,��Ϊ�л��˶���
				IF ( @TeamAServe > 1 OR @TeamBServe > 1 )--OR @OrderInRally <> 1 ) 
				BEGIN
					UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
				END
			END
			
			--TeamB�ķ����ද��
			IF ( @TmpActionID_B >= 7 AND @TmpActionID_B <= 9 ) 
			BEGIN
				SET @TeamAServe = @TeamAServe + 1 --�ۼӷ������
				
				IF ( @TeamAServe > 1 OR @TeamBServe > 1 )--OR @OrderInRally <> 1 ) 
				BEGIN
					UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
				END
			END
			
			--TeamA�ĵ�ʧ��
			IF ( @TmpActionTypeID_A = 2 )
			BEGIN
				SET @TeamAResult = 1
			END
			
			IF ( @TmpActionTypeID_A = 3 )
			BEGIN
				SET @TeamAResult = -1
			END 
			
			--TeamB�ĵ�ʧ��
			IF ( @TmpActionTypeID_B = 2 )
			BEGIN
				SET @TeamBResult = 1
			END
			
			IF ( @TmpActionTypeID_B = 3 )
			BEGIN
				SET @TeamBResult = -1
			END 
			
			--���ڷǻ��˶���,�����嶯��, ��ô������Ӧ���ڳ���
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
			
			
			--ÿ�������Ļ����ж�
				IF ( @TmpActionID_A = @ActIdPlayOut ) --A��Ա�³�
				BEGIN
					IF ( ( SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID = @TmpRegID_A ) > 0 ) --Ѱ����û�д���
					BEGIN
						UPDATE @tblPositon SET F_RegID = NULL WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID = @TmpRegID_A --�У�ɾȥ
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder --û�У�����
					END
				END
				
				IF ( @TmpActionID_B = @ActIdPlayOut ) --B��Ա�³�
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
				
				IF ( @TmpActionID_A = @ActIdLibOut ) --A�������³�
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
				
				IF ( @TmpActionID_B = @ActIdLibOut ) --B�������³�
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
				
				IF ( @TmpActionID_A = @ActIdPlayIn ) --A��Ա�ϳ�
				BEGIN
					IF (
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID IS NULL) > 0 --�пյ�
							AND
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A ) = 0 --��Ҫ�ϳ�����δ�ڳ���
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_A WHERE F_CompPos = 1 AND 
						F_Position = (SELECT TOP 1 F_Position FROM @tblPositon WHERE F_CompPos = 1 AND F_Position < 7 AND F_RegID IS NULL) --Ѱ�ҵ�һ����λ
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_B = @ActIdPlayIn ) --B��Ա�ϳ�
				BEGIN
					IF (
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_Position < 7 AND F_RegID IS NULL) > 0 --�пյ�
							AND
						 (SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B ) = 0 --��Ҫ�ϳ�����δ�ڳ���
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_B WHERE F_CompPos = 2 AND 
						F_Position = (SELECT TOP 1 F_Position FROM @tblPositon WHERE F_CompPos = 2 AND F_Position < 7 AND F_RegID IS NULL) --Ѱ�ҵ�һ����λ
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_A = @ActIdLibIn ) --A�������ϳ�
				BEGIN
					IF ( 
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_Position = 7 AND F_RegID IS NULL) > 0 
							AND
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 1 AND F_RegID = @TmpRegID_A ) = 0 --��Ҫ�ϳ�����δ�ڳ���	
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_A WHERE F_CompPos = 1 AND F_Position = 7 AND F_RegID IS NULL
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_A = 1 WHERE F_Order = @TmpOrder
					END
				END
				
				IF ( @TmpActionID_B = @ActIdLibIn ) --B�������ϳ�
				BEGIN
					IF ( 
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_Position = 7 AND F_RegID IS NULL) > 0 
							AND
						(SELECT COUNT(*) FROM @tblPositon WHERE F_CompPos = 2 AND F_RegID = @TmpRegID_B ) = 0 --��Ҫ�ϳ�����δ�ڳ���	
					   )
					BEGIN
						UPDATE @tblPositon SET F_RegID = @TmpRegID_B WHERE F_CompPos = 2 AND F_Position = 7 AND F_RegID IS NULL
					END
					ELSE
					BEGIN
						UPDATE @tblAction SET F_ActionIsError_B = 1 WHERE F_Order = @TmpOrder
					END
				END
			--���ÿ�������Ļ����ж�
			
			SET @OrderInRally = @OrderInRally + 1
			
			--����ǻغ����һ�У�Ҫ����غ���Ϣ
			IF ( @TmpIsLastRowInRally = 1 )
			BEGIN
	
				--��д�˻غ���Ӯ����Ϣ
					UPDATE @tblAction SET					
					--����Ȩ��Ϣ
						F_RallyServe =  
						CASE WHEN @TeamAServe = 1 AND @TeamBServe = 0 THEN 1
							 WHEN @TeamAServe = 0 AND @TeamBServe = 1 THEN 2
							 ELSE -1 END
					--��Ӯ���
						, F_RallyEffect = 
						CASE WHEN @TeamAResult =  1 AND @TeamBResult = -1 THEN 1
							 WHEN @TeamAResult = -1 AND @TeamBResult =  1 THEN 2
							 ELSE -1 END
					--�������Score
						, F_ScoreA_A = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_A =  1 AND F_Order <= @TmpOrder )
						, F_ScoreB_A = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_A = -1 AND F_Order <= @TmpOrder )
						, F_ScoreA_B = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_B = -1 AND F_Order <= @TmpOrder )
						, F_ScoreB_B = ( SELECT COUNT(*) FROM @tblAction WHERE F_ActionEffect_B =  1 AND F_Order <= @TmpOrder )
				 WHERE F_RallyNum = @TmpRallyNum AND F_IsLastRowInRally = 1
				
				--������ת
					IF ( @LastRallyEffect IS NULL )
					BEGIN
						--��һ�ֵĵ�һ����ʱ,���򷨴�������Ȩ
						--������,ʵ�����ڵ�һ����ʱ,δ�����һ��Ӯ��,����ת
						SET @LastRallyEffect = @TeamAServe
					END
					
					DECLARE @CurRallyEffect INT = NULL
					SELECT @CurRallyEffect = F_RallyEffect FROM @tblAction WHERE F_Order = @TmpOrder
					
					IF ( @LastRallyEffect = 2 AND @CurRallyEffect = 1 ) --TeamA�ϻغ����ˣ����غ�Ӯ��
					BEGIN
						SET @PosTurnA = @PosTurnA + 1
					END
					
					IF ( @LastRallyEffect = 1 AND @CurRallyEffect = 2 ) --TeamB�ϻغ����ˣ����غ�Ӯ��
					BEGIN
						SET @PosTurnB = @PosTurnB + 1
					END
				
				
				--��ʼ����ֵ
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
	
	--��Position����ӵ������У�������F_OrderΪNULL������ʱ��������ת����
	
		--�ѳ�ʼPosition����λ���������λ��������6����ģ6,���ɵõ��µ�Positionֵ
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
	
		--������λ��������ת���������ӵ�������λֱ�ӿ���
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


----��  �ܣ���ȡĳ������ĳ�ֵ�PlayByPlay�б�
----ʹ���ߣ���������ȡ,����ʹ�ô˺���, RPT,INFO,CIS,�����������
----��  �ߣ����� 

--2011-03-14	����
--2011-03-16	����ֵ���� F_RallyEffect
CREATE function [dbo].[func_VB_GetMatchStatActionList_Step3_PlayByPlay](
		@MatchID				INT,
		@SetNum					INT
)RETURNS @Result TABLE (
				F_Order				INT,
				F_RallyNum			INT,
				F_IsLastRowInRally	INT,
				F_RallyScoreA		INT,
				F_RallyScoreB		INT,
				F_RallyEffect		INT,	--�˻غϽ��, 1:Aʤ, 2:Bʤ, -1:����   NULL:���ǽ����
				
				F_ActionTypeID_A	INT,
				F_RegID_A			INT,
				F_ActionTypeID_B	INT,
				F_RegID_B			INT
						)	
	AS
	BEGIN
	
	--һЩ����ֵ
	DECLARE @ActIdSrvSuc	INT=7
	DECLARE @ActIdSrvCnt	INT=8
	DECLARE @ActIdSrvFlt	INT=9
	
	DECLARE @ActIdPlayIn	INT=19
	DECLARE @ActIdPlayOut	INT=20
	DECLARE @ActIdLibIn		INT=21
	DECLARE @ActIdLibOut	INT=22
	DECLARE @ActIdOppErr	INT=23
	DECLARE @ActIdTemFlt	INT=24

	--ѭ��A,B���õı���,�α�
	DECLARE @TmpRallyNum			INT	--�ڼ��غ�
	DECLARE @TmpIsLastRowInRally	INT --�ǻغϵ����һ��
	
	DECLARE @TmpScoreA				INT	--�����A�ȷ�
	DECLARE @TmpScoreB				INT	--�����B�ȷ�
	DECLARE @TmpRallyEffect			INT	--�˻غϽ��
	
	DECLARE @TmpActionTypeID_A		INT	--����ͳ������ID
	DECLARE @TmpRegID_A				INT	--��ԱID
	DECLARE @TmpActionTypeID_B		INT	--����ͳ������ID
	DECLARE @TmpRegID_B				INT
	DECLARE @FetchStatus			INT	--�α�״̬
	
	--ֻ��Ҫ����������
	DECLARE CSR_Action CURSOR STATIC FOR 
	SELECT F_RallyNum, F_IsLastRowInRally, F_RallyEffect,
	F_ScoreA_A, F_ScoreB_B,
	F_ActionTypeID_A, F_ActionRegID_A, 
	F_ActionTypeID_B, F_ActionRegID_B 
	FROM dbo.func_VB_GetMatchStatActionList_Step2_ActionList(@MatchID, @SetNum)
	WHERE	dbo.func_VB_IsActionInPlayByPlay(F_ActionTypeID_A) = 1 OR --A��Ӱ��ȷֵĶ�����Ϊ����Ӧ����ʾ
			dbo.func_VB_IsActionInPlayByPlay(F_ActionTypeID_B) = 1 OR --B��Ӱ��ȷֵĶ�����Ϊ����Ӧ����ʾ
			( F_IsLastRowInRally = 1 AND F_RallyNum <> 0 ) --���һ�� �� �������׷�����
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
				
		IF ( @TmpIsLastRowInRally = 1 ) --��������һ�У���ô��Ҫ����ȷ֣��������һ�п϶���Ӱ��ȷֵ����ݣ�Ӧ����������
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


----��		  �ܣ���ȡһ��һ����Coach,Uniform��Ϣ
----��		  �ߣ����� 
----��		  ��: 2010-12-17
--�˺���Ϊ�²㺯��,�����PROC����,��INFO,RPTֱ�ӵ���

--2011-02-22	�޸Ļ�ȡ�������ݣ�����FunctionID
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
			F_UniformColor		NVARCHAR(100), --�����·���ɫ
			F_ShirtColor		NVARCHAR(100), --������ɫ
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
	
	--����ID,������ɫ
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
    
    --��ȡ������
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
    
    --��ȡ�������
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


--һ�������Ķ�����Դ
--CompetitionScheduleʹ��

--С��������ʾ���+ǩλ #C1��Ӧ�ò������
--��̭����һ�֣���ʾ��ĳ��ĳ�������������� C1, B2
--��̭����һ�ֺ���ʾ��һ��������+ʤ��	 32W. 46L

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
	
	--�����ж�
	IF( @MatchID <=0 OR @CompPos < 1 OR @CompPos > 2)
		RETURN

	--����Ѿ�ָ��
	DECLARE @TempRegId INT = NULL
	SELECT @TempRegId = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos 
	
	IF @TempRegId >= 1
	BEGIN
		SET @RegID = @TempRegId
	END
	
	
	--С������δ�����Ա�����,�������Ӧ�ò������
	DECLARE @TempStartPhaseID INT = NULL
	DECLARE @TempStartPhasePos INT = NULL	
	SELECT @TempStartPhaseID = F_StartPhaseID, @TempStartPhasePos = F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	IF @TempStartPhaseID > 0
	BEGIN
		SELECT @PosDes = '#' + F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @TempStartPhaseID
		SELECT @PosDes += CAST(@TempStartPhasePos AS NVARCHAR(100))
	END


	--�������Source match
	DECLARE @TempSourceMatchID INT = NULL
	DECLARE @TempSourceMatchRank INT = NULL	
	
	SELECT @TempSourceMatchID = F_SourceMatchID, @TempSourceMatchRank = F_SourceMatchRank FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	IF (@TempSourceMatchID > 0 AND @TempSourceMatchRank >=1 AND @TempSourceMatchRank <=2 )
	BEGIN
		SELECT @PosDes = CASE @LangCode WHEN 'ENG' THEN 'M' ELSE '����' END
		SELECT @PosDes += F_RaceNum FROM TS_Match WHERE F_MatchID = @TempSourceMatchID
		SELECT @PosDes += 
			CASE 
				WHEN @LangCode='ENG' AND @TempSourceMatchRank = 1 THEN ' W' 
				WHEN @LangCode='ENG' AND @TempSourceMatchRank = 2 THEN ' L' 
				WHEN @LangCode='CHN' AND @TempSourceMatchRank = 1 THEN ' ʤ'
				WHEN @LangCode='CHN' AND @TempSourceMatchRank = 2 THEN ' ��' 
				ELSE '' 
			END
	END
	
	
	--�������Source phase
	DECLARE @TempSourcePhaseID INT = NULL
	DECLARE @TempSourcePhaseRank INT = NULL
	
	SELECT @TempSourcePhaseID = F_SourcePhaseID, @TempSourcePhaseRank = F_SourcePhaseRank FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	IF (@TempSourcePhaseID > 0 AND @TempSourcePhaseRank >=1 )
	BEGIN
		SELECT @PosDes = F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @TempSourcePhaseID
		SELECT @PosDes += CAST(@TempSourcePhaseRank AS NVARCHAR(100))
	END
	
	--�ѽ��д�뷵�ر�
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


----���ܣ������ۼƼ���ͳ������
----ʹ��: INFO,RPT
----���ߣ����� 
----����: 2010-10-14

--2011-01-28	ATK_SUC
--2011-03-17	����ʱ������ݵ����ݶ�Ϊ0����ôRankΪNULL
CREATE function [dbo].[func_VB_GetStatEventAthlete]
		(
			@EventID		INT
		)
Returns @Result TABLE ( 
			F_TeamRegID		INT,		--
			F_RegisterID	INT,		
			F_MatchCount	INT,		--���˾���������
			F_SetCount		INT,		--�����龭������	��AVG Per Set ��
			
			F_ATK_SUC		INT,		--����÷�
			F_ATK_CNT		INT,		--����һ��
			F_ATK_FLT		INT,		--���򶪷�
			F_ATK_TOT		INT,		--* ����	= SUC + CNT + FLT
			F_ATK_EFF		FLOAT,		--* ������Ч��	= SUC / TOT
			F_ATK_SUC_RANK	INT,		--* �������� Order by SUC
			F_ATK_SUC_DPOS	INT,		
			F_ATK_EFF_RANK	INT,		--* �������� Order by EFF
			F_ATK_EFF_DPOS	INT,			
			
			F_BLO_SUC		INT,		--�����÷�
			F_BLO_CNT		INT,		--��������
			F_BLO_FLT		INT,		--��������
			F_BLO_TOT		INT,		--* ��������	= SUC + CNT + FLT
			F_BLO_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
			F_BLO_SUC_RANK	INT,		--* �������� Order by SUC
			F_BLO_SUC_DPOS	INT,
			F_BLO_AVG_RANK	INT,		--* �������� Order by AVG
			F_BLO_AVG_DPOS	INT,
			
			F_SRV_SUC		INT,		--����÷�
			F_SRV_CNT		INT,		--�������
			F_SRV_FLT		INT,		--���򶪷�
			F_SRV_TOT		INT,		--* ��������	= SUC + CNT + FLT
			F_SRV_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
			F_SRV_SUC_RANK	INT,		--* �������� Order by SUC
			F_SRV_SUC_DPOS	INT,
			F_SRV_AVG_RANK	INT,		--* �������� Order by AVG
			F_SRV_AVG_DPOS	INT,
			
			F_DIG_EXC		INT,		--���غ�
			F_DIG_CNT		INT,		--����һ��
			F_DIG_FLT		INT,		--���ض���
			F_DIG_TOT		INT,		--* ��������	= EXC + CNT + FLT
			F_DIG_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
			F_DIG_AVG_RANK	INT,		--* �������� Order by AVG
			F_DIG_AVG_DPOS	INT,
			
			F_SET_EXC		INT,		--������
			F_SET_CNT		INT,		--����һ��
			F_SET_FLT		INT,		--��������
			F_SET_TOT		INT,		--* ��������	= EXC + CNT + FLT
			F_SET_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
			F_SET_AVG_RANK	INT,		--* �������� Order by AVG
			F_SET_AVG_DPOS	INT,
							
			F_RCV_EXC		INT,		--�ӷ���λ
			F_RCV_CNT		INT,		--�ӷ�һ��
			F_RCV_FLT		INT,		--�ӷ�����
			F_RCV_TOT		INT,		--* �ӷ�����	= EXC + CNT + FLT
			F_RCV_SUCC		FLOAT,		--* �ӷ��ɹ���	= EXC / RCV TOT
			F_RCV_SUCC_RANK	INT,		--* �ӷ����� Order by SUCC
			F_RCV_SUCC_DPOS	INT,		
			
			F_TOT_SUC		INT,		--* �ܵ÷�		= ATK_SUC + BLO_SUC + SRV_SUC
			F_TOT_SUC_RANK	INT,		--* �ӷ����� Order by SUCC
			F_TOT_SUC_DPOS	INT,	
			
			F_TOT_ATP		INT,		--* �ܳ���		= ATK_TOT + BLO_TOT + SRV_TOT
			F_TOT_ATP_RANK	INT,		
			F_TOT_ATP_DPOS	INT		
		)
As
BEGIN

	--��䱾Event�����еĶ�Ա
	INSERT INTO @Result(F_TeamRegID, F_RegisterID)
	SELECT tInscrpt.F_RegisterID, tRegMember.F_MemberRegisterID FROM TR_Inscription as tInscrpt --�ӱ�������ȡ���ж���
	LEFT JOIN TR_Register_Member AS tRegMember ON tRegMember.F_RegisterID = tInscrpt.F_RegisterID --����ÿ��������ж�Ա
	INNER JOIN TR_Register AS tMemberReg ON tMemberReg.F_RegisterID = tRegMember.F_MemberRegisterID AND tMemberReg.F_RegTypeID = 1 --ֻ��Ҫ�˶�Ա,������Ҫ
	WHERE F_EventID = @EventID
		
			
	--��ȡÿ���˾���������,��������
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
			
	--ȷ����ΪNULL
	UPDATE @Result SET 
	  F_MatchCount = ISNULL(F_MatchCount, 0)
	, F_SetCount = ISNULL(F_SetCount, 0)
		
		
	--�����ֻ�������ͳ����
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
		
	--��������
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
					
	--ƽ��ֵ,��Ч�ʼ���
	UPDATE @Result SET
	 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
	,F_BLO_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_BLO_SUC / CAST(F_SetCount as FLOAT) END
	,F_SRV_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SRV_SUC / CAST(F_SetCount as FLOAT) END
	,F_DIG_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_DIG_EXC / CAST(F_SetCount as FLOAT) END
	,F_SET_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SET_EXC / CAST(F_SetCount as FLOAT) END
	,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
		 
	--��������
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
		 		 
		 		 
	--ɾ����ֵΪ0��Rank�����磬һ����ATK���ֶ�Ϊ0,��ô����ATK��RankΪNULL,��������DispPos
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


----���ܣ������ۼƼ���ͳ������
----ʹ��: INFO,RPT��
----���ߣ����� 
----����: 2011-01-04

--2011-01-27	BLOд��ATK
--2011-01-28	ATK_SUC

CREATE function [dbo].[func_VB_GetStatEventTeam]
			(
				@EventID		INT
			)
Returns @Result TABLE ( 
				F_TeamRegID		INT,		-- * �Լ������
				F_MatchCount	INT,		--�˶��龭��������
				F_SetCount		INT,		--�˶��龭������	��AVG Per Set ��
				
				F_ATK_SUC		INT,		--����÷�
				F_ATK_CNT		INT,		--����һ��
				F_ATK_FLT		INT,		--���򶪷�
				F_ATK_TOT		INT,		--* ����	= SUC + CNT + FLT
				F_ATK_EFF		FLOAT,		--* ������Ч��	= SUC / TOT
				F_ATK_SUC_RANK	INT,		--* �������� Order by SUC
				F_ATK_SUC_DPOS	INT,		
				F_ATK_EFF_RANK	INT,		--* �������� Order by EFF
				F_ATK_EFF_DPOS	INT,			
				
				F_BLO_SUC		INT,		--�����÷�
				F_BLO_CNT		INT,		--��������
				F_BLO_FLT		INT,		--��������
				F_BLO_TOT		INT,		--* ��������	= SUC + CNT + FLT
				F_BLO_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
				F_BLO_SUC_RANK	INT,		--* �������� Order by SUC
				F_BLO_SUC_DPOS	INT,
				F_BLO_AVG_RANK	INT,		--* �������� Order by AVG
				F_BLO_AVG_DPOS	INT,
				
				F_SRV_SUC		INT,		--����÷�
				F_SRV_CNT		INT,		--�������
				F_SRV_FLT		INT,		--���򶪷�
				F_SRV_TOT		INT,		--* ��������	= SUC + CNT + FLT
				F_SRV_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
				F_SRV_SUC_RANK	INT,		--* �������� Order by SUC
				F_SRV_SUC_DPOS	INT,
				F_SRV_AVG_RANK	INT,		--* �������� Order by AVG
				F_SRV_AVG_DPOS	INT,
				
				F_DIG_EXC		INT,		--���غ�
				F_DIG_CNT		INT,		--����һ��
				F_DIG_FLT		INT,		--���ض���
				F_DIG_TOT		INT,		--* ��������	= EXC + CNT + FLT
				F_DIG_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
				F_DIG_AVG_RANK	INT,		--* �������� Order by AVG
				F_DIG_AVG_DPOS	INT,
				
				F_SET_EXC		INT,		--������
				F_SET_CNT		INT,		--����һ��
				F_SET_FLT		INT,		--��������
				F_SET_TOT		INT,		--* ��������	= EXC + CNT + FLT
				F_SET_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
				F_SET_AVG_RANK	INT,		--* �������� Order by AVG
				F_SET_AVG_DPOS	INT,
								
				F_RCV_EXC		INT,		--�ӷ���λ
				F_RCV_CNT		INT,		--�ӷ�һ��
				F_RCV_FLT		INT,		--�ӷ�����
				F_RCV_TOT		INT,		--* �ӷ�����	= EXC + CNT + FLT
				F_RCV_SUCC		FLOAT,		--* �ӷ��ɹ���	= EXC / RCV TOT
				F_RCV_SUCC_RANK	INT,		--* �ӷ����� Order by SUCC
				F_RCV_SUCC_DPOS	INT,		
				
				F_OPP_ERR		INT,		--�Է�ʧ��
				F_TEM_FLT		INT,		--����ʧ��
				
				F_TOT_SUC		INT,		--�ܵ÷� ATK_SUC + BLO_SUC + SRV_SUC + OPP_ERR
				F_TOT_SUC_RANK	INT,		--* �ܵ÷����� Order by TOT_SUC
				F_TOT_SUC_DPOS	INT,
				
				F_TOT_ATP		INT,		--�ܳ��� ATK_TOT + BLO_TOT + SRV_TOT
				F_TOT_ATP_RANK	INT,		--* �ܳ������� Order by TOT_ATP
				F_TOT_ATP_DPOS	INT
			)
As
BEGIN

	--��䱾Event�����б���Ķ���
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
		
	--�����ֻ�������ͳ����
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
	
		
	--��������
	UPDATE @Result SET
	 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
	,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
	,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
	,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
	,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
	,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
	
	--���ܼ���
	UPDATE @Result SET
	 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC + F_OPP_ERR
	,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT
					
	--ƽ��ֵ,��Ч�ʼ���
	UPDATE @Result SET
	 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
	,F_BLO_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_BLO_SUC / CAST(F_SetCount as FLOAT) END
	,F_SRV_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SRV_SUC / CAST(F_SetCount as FLOAT) END
	,F_DIG_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_DIG_EXC / CAST(F_SetCount as FLOAT) END
	,F_SET_AVG = CASE WHEN F_SetCount = 0 THEN 0 ELSE F_SET_EXC / CAST(F_SetCount as FLOAT) END
	,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
		 
	--��������
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


----���ܣ�һ������˫������ͳ���б�
----ʹ�ã�INFO,RPT
----���ߣ����� 
----����: 2010-10-14

--2011-01-26	BLOд����ATK
--2011-01-28	ATK_SUC
--2011-01-30	���F_Order
--2011-01-30	@CompPos֧��NULL,��ʾͬʱҪ������
--2011-02-24	���֧�ֵڼ��֣������F_FunctionID
--2011-03-17	����ʱ������ݵ����ݶ�Ϊ0����ôRankΪNULL
CREATE function [dbo].[func_VB_GetStatMatchAthlete]
			(
				@MatchID		INT,
				@CompPos		INT = NULL,	--1,2 NULL:���Ӷ�Ҫ
				@CurSet			INT = NULL	--N:��N�� NULL:���б���
			)
Returns @Result TABLE ( 
				F_TeamRegID		INT,		--
				F_RegisterID    INT,
				F_CompPos		INT,
				F_Bib			NVARCHAR(100),
				F_FunctionID	INT,		-- 1:Caption 2:Libreo Other:NULL
				F_Order			INT,
				
				F_ATK_SUC		INT,		--����÷�
				F_ATK_CNT		INT,		--����һ��
				F_ATK_FLT		INT,		--���򶪷�
				F_ATK_TOT		INT,		--* ����	= SUC + CNT + FLT
				F_ATK_EFF		FLOAT,		--* ������Ч��	= SUC / TOT
				F_ATK_SUC_RANK	INT,		--* ����÷����� Order by SUC
				F_ATK_SUC_DPOS	INT,				
				F_ATK_EFF_RANK	INT,		--* �������� Order by EFF
				F_ATK_EFF_DPOS	INT,
				
				F_BLO_SUC		INT,		--�����÷�
				F_BLO_CNT		INT,		--��������
				F_BLO_FLT		INT,		--��������
				F_BLO_TOT		INT,		--* ��������	= SUC + CNT + FLT
				F_BLO_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
				F_BLO_SUC_RANK	INT,		--* ����÷����� Order by SUC
				F_BLO_SUC_DPOS	INT,
				F_BLO_AVG_RANK	INT,		--* �������� Order by AVG
				F_BLO_AVG_DPOS	INT,
				
				F_SRV_SUC		INT,		--����÷�
				F_SRV_CNT		INT,		--�������
				F_SRV_FLT		INT,		--���򶪷�
				F_SRV_TOT		INT,		--* ��������	= SUC + CNT + FLT
				F_SRV_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
				F_SRV_SUC_RANK	INT,		--* ����÷����� Order by SUC
				F_SRV_SUC_DPOS	INT,
				F_SRV_AVG_RANK	INT,		--* �������� Order by AVG
				F_SRV_AVG_DPOS	INT,
				
				F_DIG_EXC		INT,		--���غ�
				F_DIG_CNT		INT,		--����һ��
				F_DIG_FLT		INT,		--���ض���
				F_DIG_TOT		INT,		--* ��������	= EXC + CNT + FLT
				F_DIG_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
				F_DIG_AVG_RANK	INT,		--* �������� Order by AVG
				F_DIG_AVG_DPOS	INT,
				
				F_SET_EXC		INT,		--������
				F_SET_CNT		INT,		--����һ��
				F_SET_FLT		INT,		--��������
				F_SET_TOT		INT,		--* ��������	= EXC + CNT + FLT
				F_SET_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
				F_SET_AVG_RANK	INT,		--* �������� Order by AVG
				F_SET_AVG_DPOS	INT,
				
				F_RCV_EXC		INT,		--�ӷ���λ
				F_RCV_CNT		INT,		--�ӷ�һ��
				F_RCV_FLT		INT,		--�ӷ�����
				F_RCV_TOT		INT,		--* �ӷ�����	= EXC + CNT + FLT
				F_RCV_SUCC		FLOAT,		--* �ӷ��ɹ���	= EXC / RCV TOT
				F_RCV_SUCC_RANK	INT,		--* �ӷ����� Order by SUCC
				F_RCV_SUCC_DPOS	INT,
				
				F_TOT_SUC		INT,		--* �ܵ÷�		= ATK_SUC + BLO_SUC + SRV_SUC
				F_TOT_SUC_RANK	INT,		
				F_TOT_SUC_DPOS	INT,		
				
				F_TOT_ATP		INT,		--* �ܳ���		= ATK_TOT + BLO_TOT + SRV_TOT
				F_TOT_ATP_RANK	INT,		
				F_TOT_ATP_DPOS	INT		
				)
As
BEGIN
		
		IF( @CompPos IS NULL ) 
		BEGIN
			--������ӵĳ�����Ա
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
			--���ĳһ�ӵĳ�����Ա
			INSERT INTO @Result(F_TeamRegID, F_RegisterID, F_CompPos, F_Bib, F_FunctionID, F_Order)
			SELECT B.F_RegisterID, A.F_RegisterID, A.F_CompetitionPosition, A.F_ShirtNumber, A.F_FunctionID,
			ROW_NUMBER() OVER(ORDER BY A.F_CompetitionPosition, F_ShirtNumber) AS F_Order
			FROM TS_Match_Member AS A
			LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID and B.F_CompetitionPosition = A.F_CompetitionPosition
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @CompPos
			ORDER BY F_CompetitionPosition, F_ShirtNumber
		END
		
		--�����ֻ�������ͳ����
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
		
		--��������
		UPDATE @Result SET
		 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
		,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
		,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
		,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
		,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
		,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
		
		--�ܼ�
		UPDATE @Result SET
		 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC
		,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT
				
		--��ǰ�ּ�Ϊ�˳��������м���
		DECLARE @SetCnt FLOAT = 0
		SELECT @SetCnt = CAST(F_MatchComment1 AS FLOAT ) FROM TS_Match WHERE F_MatchID = @MatchID
				
		--ƽ��ֵ,��Ч�ʼ���
		UPDATE @Result SET
		 F_ATK_EFF = CASE WHEN F_ATK_TOT = 0 OR F_ATK_SUC <= F_ATK_FLT THEN 0 ELSE (F_ATK_SUC - F_ATK_FLT) / CAST(F_ATK_TOT AS FLOAT) END
		,F_BLO_AVG = F_BLO_SUC / @SetCnt
		,F_SRV_AVG = F_SRV_SUC / @SetCnt
		,F_DIG_AVG = F_DIG_EXC / @SetCnt
		,F_SET_AVG = F_SET_EXC / @SetCnt
		,F_RCV_SUCC = CASE WHEN F_RCV_TOT = 0 THEN 0 ELSE F_RCV_EXC / CAST(F_RCV_TOT as FLOAT) END
		
		--��������
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
			
			--ɾ����ֵΪ0��Rank�����磬һ����ATK���ֶ�Ϊ0,��ô����ATK��RankΪNULL,��������DispPos
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


----��		  �ܣ�һ������˫������ļ���ͳ���б�
----��		  �ߣ����� 
----��		  ��: 2010-10-14

--2011-01-26	BLOд����ATK
--2011-01-28	ATK_SUC
--				��ӻ�ȡĳ����ֵ֧��

CREATE function [dbo].[func_VB_GetStatMatchTeam]
			(
				@MatchID		INT,
				@CompPos		INT,
				@CurSet			INT = 0		--�ڼ���,Ĭ��Ϊ��������
			)
Returns @Result TABLE ( 
				F_TeamRegID		INT,		-- * �Լ������
				F_CompPos		INT,
				
				F_ATK_SUC		INT,		--����÷�
				F_ATK_CNT		INT,		--����һ��
				F_ATK_FLT		INT,		--���򶪷�
				F_ATK_TOT		INT,		--* ����	= SUC + CNT + FLT
				F_ATK_EFF		FLOAT,		--* ������Ч��	= SUC - FLT / TOT
				
				F_BLO_SUC		INT,		--�����÷�
				F_BLO_CNT		INT,		--��������
				F_BLO_FLT		INT,		--��������
				F_BLO_TOT		INT,		--* ��������	= SUC + CNT + FLT
				F_BLO_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
				
				F_SRV_SUC		INT,		--����÷�
				F_SRV_CNT		INT,		--�������
				F_SRV_FLT		INT,		--���򶪷�
				F_SRV_TOT		INT,		--* ��������	= SUC + CNT + FLT
				F_SRV_AVG		FLOAT,		--* ����ƽ��ֵ	= SUC / Set count
				
				F_DIG_EXC		INT,		--���غ�
				F_DIG_CNT		INT,		--����һ��
				F_DIG_FLT		INT,		--���ض���
				F_DIG_TOT		INT,		--* ��������	= EXC + CNT + FLT
				F_DIG_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
				
				F_SET_EXC		INT,		--������
				F_SET_CNT		INT,		--����һ��
				F_SET_FLT		INT,		--��������
				F_SET_TOT		INT,		--* ��������	= EXC + CNT + FLT
				F_SET_AVG		FLOAT,		--* ����ƽ��ֵ	= EXC / Set count
				
				F_RCV_EXC		INT,		--�ӷ���λ
				F_RCV_CNT		INT,		--�ӷ�һ��
				F_RCV_FLT		INT,		--�ӷ�����
				F_RCV_TOT		INT,		--* �ӷ�����	= EXC + CNT + FLT
				F_RCV_SUCC		FLOAT,		--* �ӷ��ɹ���	= EXC / RCV TOT
				
				F_OPP_ERR		INT,		--�Է�ʧ��
				F_TEM_FLT		INT,		--����ʧ��
				
				F_TOT_SUC		INT,		--�ܵ÷� ATK_SUC + BLO_SUC + SRV_SUC + OPP_ERR
				F_TOT_ATP		INT			--�ܳ��� ATK_TOT + BLO_TOT + SRV_TOT
			)
As
BEGIN

	--����������
	IF ( @MatchID < 0 OR @CompPos < 1 OR @CompPos > 2 OR @CurSet < 0 OR @CurSet > 5 )
	BEGIN
		RETURN
	END

	--������ӵ�
	INSERT INTO @Result(F_TeamRegID, F_CompPos)

	Select F_RegisterID, F_CompetitionPosition FROM TS_Match_Result
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	ORDER BY F_CompetitionPosition
		
	--�����ֻ�������ͳ����
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
	
	--��������
	UPDATE @Result SET
	 F_ATK_TOT = F_ATK_SUC + F_ATK_CNT + F_ATK_FLT
	,F_BLO_TOT = F_BLO_SUC + F_BLO_CNT + F_BLO_FLT
	,F_SRV_TOT = F_SRV_SUC + F_SRV_CNT + F_SRV_FLT
	,F_DIG_TOT = F_DIG_EXC + F_DIG_CNT + F_DIG_FLT
	,F_SET_TOT = F_SET_EXC + F_SET_CNT + F_SET_FLT
	,F_RCV_TOT = F_RCV_EXC + F_RCV_CNT + F_RCV_FLT
			
	--���ܼ���
	UPDATE @Result SET
	 F_TOT_SUC = F_ATK_SUC + F_BLO_SUC + F_SRV_SUC + F_OPP_ERR
	,F_TOT_ATP = F_ATK_TOT + F_BLO_TOT + F_SRV_TOT
			
			
	--��ǰ�ּ�Ϊ�˳��������м���
	DECLARE @SetCnt FLOAT = 0
	SELECT @SetCnt = CAST(F_MatchComment1 AS FLOAT ) FROM TS_Match WHERE F_MatchID = @MatchID
			
	--ƽ��ֵ,��Ч�ʼ���
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


----��  �ܣ���ȡһ֧�������ʷս��,������ʱ���ɽ���Զ����
----ʹ���ߣ�������ʾ��ʷս���ģ����Ӵ˴���ȡ 
----���ߣ����� 
----��   ��: 2011-06-08

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



--���л�ȡTeamName�ĵط���Ӧ�ôӴ˴�����
--����ÿ����������ͬ��ͨ�����Ĵ˺�������ʵ����ʾ��ͬ�ı���

--					�Ŷ�						�Ŷ�					˫��								˫��
--					ENG							CHN						ENG									CHN
--NOC:				CHN							CHN						WangZheng/Mayuchao					����/����
--TeamNameS			China						�й�					Wangzheng/Mayuchao(China)			����/����(�й�)
--TeamNameL			People republic of china	�л��������͹�			Wangzheng/Mayuchao(China)			����/����(�й�)

--2011-04-02	Created
--2011-10-17	����VB��BV
--2012-09-05	����Ϊ���ض��ֵ
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
--2011-11-01	д��PhaseCnt = 1
--2011-11-12	д��PhaseCnt = 3
--2012-09-05	Phase is dynamic
CREATE function [dbo].[func_VB_GetTournamentChart]
			( 
				@EventID		INT
			)
Returns @Result TABLE(
		F_ChartNum			INT,			--��������������ͼ
		F_MatchPos			INT,			--ӦΪ1~12
		F_MatchID			INT,
		F_Rank				INT,
		F_RankRegID			INT
)
AS
BEGIN

	--��Event�н�������������ͨ���жϽ���������Phase(Type=3)��ȷ��,
	--������2������ôMatchNum�϶����д�101-112,201-212
	DECLARE @PhaseCnt INT
	SELECT @PhaseCnt = COUNT(*) FROM TS_Phase where F_PhaseType = 3 AND F_EventID = @EventID 

	--ѭ��ÿ��������
	DECLARE @CycChart INT=1
	WHILE( @CycChart <= @PhaseCnt )
	BEGIN
	
		DECLARE @CycMatchNum INT = 1
		WHILE(@CycMatchNum <= 12)
		BEGIN
			
			--ȷ���˳�������MatchNum
			DECLARE @TmpMatchNum NVARCHAR(100) = ''
				SELECT @TmpMatchNum = CAST(@CycChart AS NVARCHAR(100)) + RIGHT(N'00' + CONVERT(NVARCHAR(2), @CycMatchNum), 2)
			
			--ȷ���˳�������MathcID
			DECLARE @TmpMatchID INT = NULL
				SELECT @TmpMatchID = F_MatchID FROM TS_Match AS A
				INNER JOIN TS_Phase AS B ON b.F_PhaseID = A.F_PhaseID AND B.F_EventID = @EventID
				WHERE F_MatchNum = @TmpMatchNum 
			
			--����˳�����,������NULL,Ҳ����
			INSERT INTO @Result(F_ChartNum, F_MatchPos, F_MatchID) SELECT @CycChart, @CycMatchNum, @TmpMatchID
					
			SET @CycMatchNum = @CycMatchNum + 1
		END
		
		SET @CycChart = @CycChart + 1
	END
	
	--�������б�����Ӧ��RankTitle��Register
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

