if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_SearchMatchesByDate_XML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_SearchMatchesByDate_XML]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



--创 建 人：	郑金勇
--日    期：	2008年08月13日

Create Procedure Proc_SearchMatchesByDate_XML(
						@CURRENTDATE		NVARCHAR(50)
)
As
Begin
Set Nocount On 

	DECLARE @CurLanguage AS CHAR(3)
	SELECT TOP 1 @CurLanguage =  F_LanguageCode FROM TC_Language where F_ACTIVE= 1
	
	CREATE TABLE #Temp_Table (

					[COURT_DES]					NVARCHAR(50) 		NULL,
					[SESSIONNAME]				NVARCHAR(50)		NULL,
					[OrderInSession]			NVARCHAR(50)		NULL,
					[MATCHID]					INT					NULL,
					[GENDER]					INT					NULL,
					[COMPETITORTYPE]			INT					NULL,
					[EVENT_DES]					NVARCHAR(50)		NULL,
					[PHASE_DES]					NVARCHAR(50)		NULL,
					[START_TIME_DES]			NVARCHAR(50)		NULL,
					[END_TIME_DES]				NVARCHAR(50)		NULL,
					[STATUS]					NVARCHAR(50)		NULL,
					[StatusDes]					NVARCHAR(50)		NULL,

					[H_NOC]						NVARCHAR(50)		NULL,
					[H1_NOC]					NVARCHAR(50)		NULL,
					[H2_NOC]					NVARCHAR(50)		NULL,
					[H_SNAME]					NVARCHAR(50)		NULL,
					[H1_SNAME]					NVARCHAR(50)		NULL,
					[H2_SNAME]					NVARCHAR(50)		NULL,		
					[H_LNAME]					NVARCHAR(50)		NULL,
					[H1_LNAME]					NVARCHAR(50)		NULL,
					[H2_LNAME]					NVARCHAR(50)		NULL,
					[H1_AGE]					INT,
					[H2_AGE]					INT,
					[H1_HEIGHT]					INT,
					[H2_HEIGHT]					INT,
					[H1_WEIGHT]					INT,
					[H2_WEIGHT]					INT,

					[A_NOC]						NVARCHAR(50)		NULL,
					[A1_NOC]					NVARCHAR(50)		NULL,
					[A2_NOC]					NVARCHAR(50)		NULL,
					[A_SNAME]					NVARCHAR(50)		NULL,
					[A1_SNAME]					NVARCHAR(50)		NULL,
					[A2_SNAME]					NVARCHAR(50)		NULL,		
					[A_LNAME]					NVARCHAR(50)		NULL,
					[A1_LNAME]					NVARCHAR(50)		NULL,
					[A2_LNAME]					NVARCHAR(50)		NULL,
					[A1_AGE]					INT,
					[A2_AGE]					INT,
					[A1_HEIGHT]					INT,
					[A2_HEIGHT]					INT,
					[A1_WEIGHT]					INT,
					[A2_WEIGHT]					INT,

					[H_SPLIT_1]					INT,
					[H_SPLIT_2]					INT,
					[H_SPLIT_3]					INT,
					[H_SPLIT_4]					INT,
					[H_SPLIT_5]					INT,

					[A_SPLIT_1]					INT,
					[A_SPLIT_2]					INT,
					[A_SPLIT_3]					INT,
					[A_SPLIT_4]					INT,
					[A_SPLIT_5]					INT,

					[H_WINNING_SETS]			INT,
					[A_WINNING_SETS]			INT,
					[H_RANKING]					INT,
					[A_RANKING]					INT,
					[SPLIT_1_TIME_SET_DES]		INT,
					[SPLIT_2_TIME_SET_DES]		INT,
					[SPLIT_3_TIME_SET_DES]		INT,
					[SPLIT_4_TIME_SET_DES]		INT,
					[SPLIT_5_TIME_SET_DES]		INT,
					[TOTAL_TIME_SET_DES]		INT,

					F_MatchID					INT,
					F_MatchStatusID				INT,
					F_MatchNum					INT,
					F_SessionID					INT,
					F_OrderInSession			NVARCHAR(50),
					F_VenueID					INT,
					F_CourtID					INT,
					F_PhaseID					INT,
					F_EventID					INT,
					H_RegisterID				INT,
					A_RegisterID				INT,
					H1_RegisterID				INT,
					H2_RegisterID				INT,
					A1_RegisterID				INT,
					A2_RegisterID				INT
		)
		

	INSERT INTO #Temp_Table (MATCHID, OrderInSession, F_MatchID, STATUS, F_MatchStatusID, F_MatchNum, F_SessionID, F_OrderInSession, F_VenueID, F_CourtID, F_PhaseID, START_TIME_DES, END_TIME_DES, TOTAL_TIME_SET_DES) 
		SELECT F_MatchID AS MATCHID, F_OrderInSession AS OrderInSession, F_MatchID, F_MatchStatusID AS STATUS, F_MatchStatusID, F_MatchNum, F_SessionID, F_OrderInSession, F_VenueID, F_CourtID, F_PhaseID, 
			RIGHT(CONVERT(NVARCHAR(50), F_StartTime, 120), 8) AS START_TIME_DES, RIGHT(CONVERT(NVARCHAR(50), F_EndTime, 120), 8) AS END_TIME_DES, F_SpendTime AS TOTAL_TIME_SET_DES
				FROM TS_Match WHERE F_MatchDate = @CURRENTDATE

	UPDATE #Temp_Table SET COURT_DES = B.F_CourtLongName FROM #Temp_Table AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @CurLanguage 
	UPDATE #Temp_Table SET F_EventID = B.F_EventID FROM #Temp_Table AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
	UPDATE #Temp_Table SET EVENT_DES = B.F_EventLongName FROM #Temp_Table AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @CurLanguage 
	UPDATE #Temp_Table SET PHASE_DES = B.F_PhaseLongName FROM #Temp_Table AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @CurLanguage 
	UPDATE #Temp_Table SET SESSIONNAME = 'Session' + CAST (B.F_SessionNumber AS NVARCHAR(10)) FROM #Temp_Table AS A LEFT JOIN TS_Session AS B ON A.F_SessionID = B.F_SessionID
	UPDATE #Temp_Table SET StatusDes = B.F_StatusLongName FROM #Temp_Table AS A LEFT JOIN TC_Status_Des AS B ON A.F_MatchStatusID = B.F_StatusID AND B.F_LanguageCode = @CurLanguage 

	UPDATE #Temp_Table SET H_RegisterID = B.F_RegisterID, H_WINNING_SETS = B.F_WinSets, H_RANKING = B.F_Rank FROM #Temp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
	UPDATE #Temp_Table SET A_RegisterID = B.F_RegisterID, A_WINNING_SETS = B.F_WinSets, A_RANKING = B.F_Rank FROM #Temp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2

	UPDATE #Temp_Table SET H_SPLIT_1 = C.F_Points, SPLIT_1_TIME_SET_DES = B.F_SpendTime FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 1 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
	UPDATE #Temp_Table SET H_SPLIT_2 = C.F_Points, SPLIT_2_TIME_SET_DES = B.F_SpendTime FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 2 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
	UPDATE #Temp_Table SET H_SPLIT_3 = C.F_Points, SPLIT_3_TIME_SET_DES = B.F_SpendTime FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 3 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
	UPDATE #Temp_Table SET H_SPLIT_4 = C.F_Points, SPLIT_4_TIME_SET_DES = B.F_SpendTime FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 4 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1
	UPDATE #Temp_Table SET H_SPLIT_5 = C.F_Points, SPLIT_5_TIME_SET_DES = B.F_SpendTime FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 5 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 1

	UPDATE #Temp_Table SET A_SPLIT_1 = C.F_Points FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 1 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
	UPDATE #Temp_Table SET A_SPLIT_2 = C.F_Points FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 2 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
	UPDATE #Temp_Table SET A_SPLIT_3 = C.F_Points FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 3 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
	UPDATE #Temp_Table SET A_SPLIT_4 = C.F_Points FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 4 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
	UPDATE #Temp_Table SET A_SPLIT_5 = C.F_Points FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND B.F_Order = 5 AND B.F_FatherMatchSplitID = 0 LEFT JOIN TS_Match_Split_Result AS C ON B.F_MatchID = C.F_MatchID AND B.F_MatchSplitID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2
----home
	UPDATE #Temp_Table SET GENDER = B.F_SexCode, COMPETITORTYPE = B.F_RegTypeID, H_NOC = D.F_FederationShortName, H_SNAME = C.F_ShortName, H_LNAME = C.F_LongName FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.H_RegisterID = B.F_RegisterID 
		LEFT JOIN TR_Register_Des AS C ON A.H_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @CurLanguage
			LEFT JOIN TC_Federation_Des AS D ON B.F_FederationID = D.F_FederationID AND D.F_LanguageCode = @CurLanguage

	UPDATE #Temp_Table SET H1_RegisterID = DBO.Fun_GetDoubleMember(H_RegisterID, 0)
	UPDATE #Temp_Table SET H2_RegisterID = DBO.Fun_GetDoubleMember(H_RegisterID, H1_RegisterID)

	UPDATE #Temp_Table SET H1_NOC = D.F_FederationShortName, H1_SNAME = C.F_ShortName, H1_LNAME = C.F_LongName, H1_AGE = DATEDIFF(YEAR,B.F_Birth_Date,GETDATE()),H1_HEIGHT = B.F_Height, H1_WEIGHT = B.F_Weight FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.H1_RegisterID = B.F_RegisterID 
		LEFT JOIN TR_Register_Des AS C ON A.H1_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @CurLanguage
			LEFT JOIN TC_Federation_Des AS D ON B.F_FederationID = D.F_FederationID AND D.F_LanguageCode = @CurLanguage

	UPDATE #Temp_Table SET H2_NOC = D.F_FederationShortName, H2_SNAME = C.F_ShortName, H2_LNAME = C.F_LongName, H2_AGE = DATEDIFF(YEAR,B.F_Birth_Date,GETDATE()),H2_HEIGHT = B.F_Height, H2_WEIGHT = B.F_Weight FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.H2_RegisterID = B.F_RegisterID 
		LEFT JOIN TR_Register_Des AS C ON A.H2_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @CurLanguage
			LEFT JOIN TC_Federation_Des AS D ON B.F_FederationID = D.F_FederationID AND D.F_LanguageCode = @CurLanguage

----away
	UPDATE #Temp_Table SET A_NOC = D.F_FederationShortName, A_SNAME = C.F_ShortName, A_LNAME = C.F_LongName FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.A_RegisterID = B.F_RegisterID 
		LEFT JOIN TR_Register_Des AS C ON A.A_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @CurLanguage
			LEFT JOIN TC_Federation_Des AS D ON B.F_FederationID = D.F_FederationID AND D.F_LanguageCode = @CurLanguage
	
	UPDATE #Temp_Table SET A1_RegisterID = DBO.Fun_GetDoubleMember(A_RegisterID, 0)
	UPDATE #Temp_Table SET A2_RegisterID = DBO.Fun_GetDoubleMember(A_RegisterID, A1_RegisterID)

	UPDATE #Temp_Table SET A1_NOC = D.F_FederationShortName, A1_SNAME = C.F_ShortName, A1_LNAME = C.F_LongName, A1_AGE = DATEDIFF(YEAR,B.F_Birth_Date,GETDATE()),A1_HEIGHT = B.F_Height, A1_WEIGHT = B.F_Weight FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.A1_RegisterID = B.F_RegisterID 
		LEFT JOIN TR_Register_Des AS C ON A.A1_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @CurLanguage
			LEFT JOIN TC_Federation_Des AS D ON B.F_FederationID = D.F_FederationID AND D.F_LanguageCode = @CurLanguage

	UPDATE #Temp_Table SET A2_NOC = D.F_FederationShortName, A2_SNAME = C.F_ShortName, A2_LNAME = C.F_LongName, A2_AGE = DATEDIFF(YEAR,B.F_Birth_Date,GETDATE()),A2_HEIGHT = B.F_Height, A2_WEIGHT = B.F_Weight FROM #Temp_Table AS A LEFT JOIN TR_Register AS B ON A.A2_RegisterID = B.F_RegisterID 
		LEFT JOIN TR_Register_Des AS C ON A.A2_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @CurLanguage
			LEFT JOIN TC_Federation_Des AS D ON B.F_FederationID = D.F_FederationID AND D.F_LanguageCode = @CurLanguage


	SELECT * FROM #Temp_Table order by F_CourtID, [START_TIME_DES]
Set Nocount Off
End 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
exec Proc_SearchMatchesByDate_XML '20091016'
exec Proc_SearchMatchesByDate_XML '20091017'
exec Proc_SearchMatchesByDate_XML '20091018'
*/
--select * from TR_Register
