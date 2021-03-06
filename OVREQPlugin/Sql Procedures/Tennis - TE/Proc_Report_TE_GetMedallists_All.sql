IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMedallists_All]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMedallists_All]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_TE_GetMedallists_All]
--描    述: 空手道项目报表获取所有项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年1月18日
--修改记录：
/*			
			时间				修改人		修改内容	
			2010年1月28日		邓年彩		日期取大写.
			2010年2月4日		邓年彩		取日期使用统一的函数 [Func_Report_KR_GetDateTime], 日期不以 0 开头.
			2010年5月28日		邓年彩		添加参数 @LanguageCode, 默认值为 'ENG', 以便出具中文报表;
											日期只取英文的日期.
			2010年7月6日		邓年彩		当 @DisciplineID = -1, 取默认的 DisciplineID.
*/



CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMedallists_All]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID
		FROM TS_Discipline AS D
		WHERE D.F_Active = 1
	END

    CREATE TABLE #tmp_medal(
                            [EventOrder]           INT,
                            [EventName]            NVARCHAR(100),
                            [Date]                 NVARCHAR(100),
                            [Rank]                 INT,
                            [Medal]                NVARCHAR(100),
                            [MemberOrder]          INT,
                            [MemberName]           NVARCHAR(100),
                            [NOC]                  NVARCHAR(100),
                            F_RegisterID           INT,
                            [Pos]                  INT,
                            [LastName]             NVARCHAR(100)
                          )
                          
	-- 双打项目
	INSERT INTO #tmp_medal([EventOrder], [EventName], [Date], [Rank], [Medal], [MemberOrder],[MemberName], [NOC], F_RegisterID, Pos, LastName)
		SELECT F.F_Order AS [EventOrder]
			, G.F_EventLongName AS [EventName]
			, dbo.[Func_Report_TE_GetDateTime](F.F_CloseDate, 7, 'ENG') AS [Date]
			, A.F_EventRank AS [Rank]
			, B.F_MedalLongName AS [Medal]
			, C.F_Order AS [MemberOrder]
			, E.F_PrintLongName AS [MemberName]
			, I.F_DelegationCode  AS [NOC]
			, A.F_RegisterID
			, A.F_EventDisplayPosition AS [Pos]
			, E.F_LastName AS [LastName]
		FROM TS_Event_Result AS A
		LEFT JOIN TC_Medal_Des AS B 
			ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Member AS C
			ON A.F_RegisterID = C.F_RegisterID
		LEFT JOIN TR_Register AS D
			ON C.F_MemberRegisterID = D.F_RegisterID 
		LEFT JOIN TR_Register_Des AS E
			ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Event AS F
			ON A.F_EventID = F.F_EventID
		LEFT JOIN TS_Event_Des AS G
			ON A.F_EventID = G.F_EventID AND G.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS H
			ON A.F_RegisterID = H.F_RegisterID
		LEFT JOIN TC_Delegation AS I
			ON D.F_DelegationID = I.F_DelegationID
		WHERE A.F_MedalID IS NOT NULL
			AND F.F_DisciplineID = @DisciplineID
			AND F.F_EventStatusID = 110							-- 仅显示结束了的项目
			AND F.F_PlayerRegTypeID = 2
			AND D.F_RegTypeID = 1

	--UNION

	-- 单人项目
	INSERT INTO #tmp_medal([EventOrder], [EventName], [Date], [Rank], [Medal], [MemberOrder],[MemberName], [NOC], F_RegisterID, Pos, LastName)
			SELECT E.F_Order AS [EventOrder]
				, F.F_EventLongName AS [EventName]
				, dbo.[Func_Report_TE_GetDateTime](E.F_CloseDate, 7, 'ENG') AS [Date]
				, A.F_EventRank AS [Rank]
				, B.F_MedalLongName AS [Medal]
				, 0 AS [MemberOrder]
				, D.F_PrintLongName AS [MemberName]
				, G.F_DelegationCode AS [NOC]
				, A.F_RegisterID
				, A.F_EventDisplayPosition AS [Pos]
				, D.F_LastName AS [LastName]
			FROM TS_Event_Result AS A
			LEFT JOIN TC_Medal_Des AS B 
				ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C
				ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TR_Register_Des AS D
				ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS E
				ON A.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Des AS F
				ON A.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS G
				ON C.F_DelegationID = G.F_DelegationID
			WHERE A.F_MedalID IS NOT NULL
				AND E.F_DisciplineID = @DisciplineID
				AND E.F_EventStatusID = 110							-- 仅显示结束了的项目
				AND E.F_PlayerRegTypeID = 1
				AND C.F_RegTypeID = 1
		
	--UNION
			
	---- 团体项目
	
	CREATE TABLE #tmp_MedalTeam(     [EventOrder]     INT,
	                                 [EventName]      NVARCHAR(100),
	                                 [Date]           NVARCHAR(100),
	                                 [Rank]           INT,
	                                 [Medal]          NVARCHAR(50), 
	                                 [NOCCode]        NVARCHAR(50), 
	                                 [NOCLongName]    NVARCHAR(100), 
	                                 F_RegisterID     INT,
	                                 F_DelegationID   INT,
	                                 F_DisplayPos     INT,
	                                 F_SexCode     NVARCHAR(10))
	     
	     INSERT INTO #tmp_MedalTeam([EventOrder], [EventName],  [Date], [Rank], [Medal], [NOCCode], [NOCLongName], F_RegisterID, F_DelegationID, F_DisplayPos, F_SexCode)
	       SELECT F.F_Order, ED.F_EventLongName, dbo.[Func_Report_TE_GetDateTime](F.F_CloseDate, 7, 'ENG') AS [Date],
	             A.F_EventRank, B.F_MedalLongName, TD.F_DelegationCode, E.F_DelegationLongName, A.F_RegisterID, C.F_DelegationID, A.F_EventDisplayPosition, F.F_SexCode
	         FROM TS_Event_Result AS A
	            LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
				LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
				LEFT JOIN TR_Register_Des AS D ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Delegation AS TD ON C.F_DelegationID = TD.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS E ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Event AS F ON A.F_EventID = F.F_EventID
				LEFT JOIN TS_Event_Des AS ED ON F.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
				WHERE A.F_MedalID IS NOT NULL AND F.F_EventStatusID = 110  AND F.F_PlayerRegTypeID = 3
		
	 
	  CREATE TABLE #tmp_TeamMember(F_RegisterID         INT,
	                               MemberName           NVARCHAR(100),
	                               LastName             NVARCHAR(100),
	                               F_TeamID             INT)
	   
	   		
	   INSERT INTO #tmp_TeamMember(F_RegisterID, MemberName, LastName, F_TeamID)
			SELECT C.F_RegisterID, D.F_PrintLongName,  D.F_LastName, TT.F_RegisterID
			   FROM #tmp_MedalTeam AS TT 
			    LEFT JOIN TS_Event AS E ON TT.F_SexCode = E.F_SexCode 
			    LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID 
				LEFT JOIN TR_Register AS C ON  I.F_RegisterID = C.F_RegisterID
				LEFT JOIN TR_Register_Des AS D ON C.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
				WHERE E.F_PlayerRegTypeID = 1 AND TT.F_DelegationID = C.F_DelegationID

      
      INSERT INTO #tmp_TeamMember(F_RegisterID, MemberName, LastName, F_TeamID)
		  SELECT RM.F_RegisterID, D.F_PrintLongName, D.F_LastName, TT.F_RegisterID
			FROM #tmp_MedalTeam AS TT 
			LEFT JOIN TS_Event AS E ON TT.F_SexCode = E.F_SexCode 
			LEFT JOIN TR_Inscription AS I ON E.F_EventID = I.F_EventID
			LEFT JOIN TR_Register AS C ON I.F_RegisterID = C.F_RegisterID
			LEFT JOIN TR_Register_Member AS RM ON C.F_RegisterID = RM.F_RegisterID
			LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS D ON R.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
			WHERE R.F_RegisterID NOT IN (SELECT F_RegisterID FROM #tmp_TeamMember) AND E.F_PlayerRegTypeID = 2 AND TT.F_DelegationID = C.F_DelegationID
	
	 
	 INSERT INTO #tmp_medal([EventOrder], [EventName], [Date], [Rank], [Medal], [MemberOrder],[MemberName], [NOC], F_RegisterID, Pos, LastName)
	    SELECT TT.EventOrder, TT.EventName, TT.[Date], TT.[Rank], TT.Medal, 0, TM.MemberName, TT.NOCCode, TT.F_RegisterID, TT.F_DisplayPos, TM.LastName
	       FROM #tmp_MedalTeam AS TT 
	            LEFT JOIN #tmp_TeamMember AS TM ON TT.F_RegisterID = TM.F_TeamID

    SELECT * FROM #tmp_medal
SET NOCOUNT OFF
END


GO