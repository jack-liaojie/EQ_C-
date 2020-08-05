IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetSingleStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetSingleStartList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_BDTT_GetSingleStartList]
----功		  能：获取SCB需要的个人赛出场名单
----作		  者：王强
----日		  期: 2011-2-21
----修改	记录:

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetSingleStartList]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP_TABLE
	(
		NOC_A NVARCHAR(10),
		NOC_B NVARCHAR(10),
		PlayerA1_ENG NVARCHAR(30),
		PlayerA1_CHN NVARCHAR(30),
		PlayerA2_ENG NVARCHAR(30),
		PlayerA2_CHN NVARCHAR(30),
		PlayerB1_ENG NVARCHAR(30),
		PlayerB1_CHN NVARCHAR(30),
		PlayerB2_ENG NVARCHAR(30),
		PlayerB2_CHN NVARCHAR(30)
	)
	
	CREATE TABLE #TMP_UMPIRE
	(
		Name_ENG NVARCHAR(50),
		Name_CHN NVARCHAR(50),
		NOC NVARCHAR(50),
		F_ORDER INT
	)

    DECLARE @Type INT
    DECLARE @PhaseName_ENG NVARCHAR(30)
    DECLARE @PhaseName_CHN NVARCHAR(30)
    DECLARE @StartTime NVARCHAR(30)
    
    SELECT @Type = C.F_PlayerRegTypeID, @PhaseName_ENG = D.F_PhaseLongName, @PhaseName_CHN = E.F_PhaseLongName,
			@StartTime = LEFT( CONVERT( NVARCHAR(20), A.F_StartTime, 108 ), 5)
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
    LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
    LEFT JOIN TS_Phase_Des AS D ON D.F_PhaseID = B.F_PhaseID AND D.F_LanguageCode = 'ENG'
    LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = B.F_PhaseID AND E.F_LanguageCode = 'CHN'
    WHERE A.F_MatchID = @MatchID
    
    IF @Type = 3
		RETURN
	IF @Type = 1
		BEGIN
			INSERT INTO #TMP_TABLE (NOC_A, NOC_B,PlayerA1_ENG, PlayerA1_CHN, PlayerB1_ENG, PlayerB1_CHN)
			(
				SELECT '[Image]'+ E1.F_DelegationCode, '[Image]'+ E2.F_DelegationCode, C1.F_SBLongName, C2.F_SBLongName, C3.F_SBLongName, C4.F_SBLongName FROM TS_Match AS A
				LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TR_Register AS D1 ON D1.F_RegisterID = B1.F_RegisterID
				LEFT JOIN TC_Delegation AS E1 ON E1.F_DelegationID = D1.F_DelegationID
				LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
				LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_LanguageCode = 'CHN'
				
				LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TR_Register AS D2 ON D2.F_RegisterID = B2.F_RegisterID
				LEFT JOIN TC_Delegation AS E2 ON E2.F_DelegationID = D2.F_DelegationID
				LEFT JOIN TR_Register_Des AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_LanguageCode = 'ENG'
				LEFT JOIN TR_Register_Des AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_LanguageCode = 'CHN'
				WHERE A.F_MatchID = @MatchID
			)	
			
		END
	ELSE IF @Type = 2
		BEGIN
			--INSERT INTO #TMP_TABLE (NOC_A, NOC_B,PlayerA1_ENG, PlayerA1_CHN, PlayerB1_ENG, PlayerB1_CHN)
			--(
			--	SELECT E1.F_DelegationCode, E2.F_DelegationCode, C1.F_SBLongName, C2.F_SBLongName, C3.F_SBLongName, C4.F_SBLongName FROM TS_Match AS A
			--	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
			--	LEFT JOIN TR_Register AS D1 ON D1.F_RegisterID = B1.F_RegisterID
			--	LEFT JOIN TC_Delegation AS E1 ON E1.F_DelegationID = D1.F_DelegationID
			--	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
			--	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_LanguageCode = 'CHN'
				
			--	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
			--	LEFT JOIN TR_Register AS D2 ON D2.F_RegisterID = B2.F_RegisterID
			--	LEFT JOIN TC_Delegation AS E2 ON E2.F_DelegationID = D2.F_DelegationID
			--	LEFT JOIN TR_Register_Des AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_LanguageCode = 'ENG'
			--	LEFT JOIN TR_Register_Des AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_LanguageCode = 'CHN'
			--	WHERE A.F_MatchID = 2
			--)	
			DECLARE @RegA INT
			DECLARE @RegA1 INT
			DECLARE @RegA2 INT
			DECLARE @RegB INT
			DECLARE @RegB1 INT
			DECLARE @RegB2 INT
			SELECT @RegA = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
			SELECT @RegB = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
			
			SELECT @RegA1 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegA AND F_Order = 1
			SELECT @RegA2 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegA AND F_Order = 2
			SELECT @RegB1 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegB AND F_Order = 1
			SELECT @RegB2 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegB AND F_Order = 2
			
			INSERT INTO #TMP_TABLE (NOC_A, NOC_B) VALUES
			(
				(SELECT '[Image]'+ B.F_DelegationCode FROM TR_Register AS A
				LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
				WHERE A.F_RegisterID = @RegA),
				(SELECT '[Image]'+ B.F_DelegationCode FROM TR_Register AS A
				LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
				WHERE A.F_RegisterID = @RegB)
			)
			
			UPDATE #TMP_TABLE SET PlayerA1_ENG = B.F_SBLongName, PlayerA1_CHN = C.F_SBLongName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegA1
			
			UPDATE #TMP_TABLE SET PlayerB1_ENG = B.F_SBLongName, PlayerB1_CHN = C.F_SBLongName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegB1
			
			UPDATE #TMP_TABLE SET PlayerA2_ENG = B.F_SBLongName, PlayerA2_CHN = C.F_SBLongName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegA2
			
			UPDATE #TMP_TABLE SET PlayerB2_ENG = B.F_SBLongName, PlayerB2_CHN = C.F_SBLongName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegB2
		END
	ELSE
		RETURN
	
	DECLARE @Court_ENG NVARCHAR(30)
	DECLARE @Court_CHN NVARCHAR(30)
	DECLARE @MatchName_ENG NVARCHAR(30)
	DECLARE @MatchName_CHN NVARCHAR(30)
	
	SELECT @Court_ENG = B.F_CourtShortName, @Court_CHN = C.F_CourtShortName
			,@MatchName_ENG = D1.F_MatchShortName, @MatchName_CHN = D2.F_MatchShortName
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Court_Des AS C ON C.F_CourtID = A.F_CourtID AND C.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Match_Des AS D1 ON D1.F_MatchID = A.F_MatchID AND D1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Des AS D2 ON D2.F_MatchID = A.F_MatchID AND D2.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = @MatchID
	
	--裁判
	
	INSERT INTO #TMP_UMPIRE (Name_ENG,Name_CHN, NOC, F_ORDER)
	(
		SELECT B1.F_SBLongName, B2.F_SBLongName, '[Image]'+ D1.F_DelegationCode, ROW_NUMBER() OVER(ORDER BY A.F_Order) AS F_Order FROM TS_Match_Servant AS A
		LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register AS C1 ON C1.F_RegisterID = B1.F_RegisterID
		LEFT JOIN TC_Delegation AS D1 ON D1.F_DelegationID = C1.F_DelegationID
		LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
		WHERE A.F_MatchID = @MatchID
	)
	
	DECLARE @UmpireName1_ENG NVARCHAR(50)
	DECLARE @UmpireName1_CHN NVARCHAR(50)
	DECLARE @UmpireName2_ENG NVARCHAR(50)
	DECLARE @UmpireName2_CHN NVARCHAR(50)
	DECLARE @UmpireNOC1 NVARCHAR(10)
	DECLARE @UmpireNOC2 NVARCHAR(20)
	
	SELECT @UmpireName1_ENG = Name_ENG, @UmpireName1_CHN = Name_CHN, @UmpireNOC1 = NOC
	FROM #TMP_UMPIRE WHERE F_ORDER = 1
	
	SELECT @UmpireName2_ENG = Name_ENG, @UmpireName2_CHN = Name_CHN, @UmpireNOC2 = NOC
	FROM #TMP_UMPIRE WHERE F_ORDER = 2
	
	SELECT @Court_ENG AS Court_ENG, @Court_CHN AS Court_CHN, @StartTime AS StartTime, 
			@UmpireName1_ENG AS UmpireName1_ENG, @UmpireName1_CHN AS UmpireName1_CHN,
			@UmpireName2_ENG AS UmpireName2_ENG, @UmpireName2_CHN AS UmpireName2_CHN,
			@UmpireNOC1 AS UmpireNOC1,@UmpireNOC2 AS UmpireNOC2,
			@PhaseName_ENG AS PhaseName_ENG, @PhaseName_CHN AS PhaseName_CHN, 
			@MatchName_ENG AS MatchName_ENG, @MatchName_CHN AS MatchName_CHN,A.*,
			@PhaseName_ENG + '（' + @PhaseName_CHN + '）' AS PhaseName_All,
			@Court_ENG + '（' + @Court_CHN + '）' AS CourtName_All,
			@MatchName_ENG + '（' + @MatchName_CHN + '）' MatchName_All
			FROM #TMP_TABLE AS A	
SET NOCOUNT OFF
END


GO


