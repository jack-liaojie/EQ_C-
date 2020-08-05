IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_EntryByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_EntryByNOC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_Report_AR_EntryByNOC]
--描    述: 
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月18日
--修改记录：
/*	
           2011年10月22日     李燕     增加TeamCoach， FIFA WorldRanking, PlayerNum, TeamNum		
*/



CREATE PROCEDURE [dbo].[Proc_Report_AR_EntryByNOC]
	@DisciplineID				INT,
	@DelegationID				INT,
	@NOCID						CHAR(3),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @GroupType			INT

	-- 确定 @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- 目前只考虑 2 - NOC 和 4 - Delegation 这两种情况, 优先考虑 4 - Delegation.
	IF @DelegationID > 0
	BEGIN
		SET @GroupType = 4
	END
	ELSE IF @NOCID <> '-1 ' AND @NOCID <> '   '
	BEGIN
		SET @GroupType = 2
	END
	-- 当 @DelegationID 与 @NOCID 无效时, 从默认配置中获取 GroupType
	ELSE
	BEGIN
		SELECT @GroupType = SC.F_ConfigValue
		FROM TS_Sport_Config AS SC
		LEFT JOIN TS_Discipline AS D
			ON SC.F_SportID = D.F_SportID
		WHERE D.F_DisciplineID = @DisciplineID
			AND SC.F_ConfigType = 1 AND SC.F_ConfigName = N'GroupType'
			
		IF @GroupType <> 2
			SET @GroupType = 4
	END

	SELECT DISTINCT X.Inscription
		--, X.F_InscriptionRank
		, X.F_InscriptionComment
		, UPPER(SD.F_SexLongName) AS [Gender]
		, [NOC] = CASE @GroupType WHEN 2 THEN R.F_NOC ELSE D.F_DelegationCode END
		, [NOCLongName] = CASE @GroupType WHEN 2 THEN CD.F_CountryLongName ELSE DD.F_DelegationLongName END
		, RD.F_PrintLongName AS [Name]
		, R.F_Bib AS [Bib]
		, S.F_GenderCode AS [GenderCode]
		--, E.F_EventCode AS [EventCode]
		--, ED.F_EventLongName AS [EventName]
		, dbo.[Func_Report_TE_GetDateTime](R.F_Birth_Date, 1, 'ENG') AS [BirthDate]
		, LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + ' / ' 
			+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 3048) + ''''
			+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 254) % 12) + '"' AS [Height]
		, CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + ' / ' 
			+ CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight, 0)) * 22 / 10) AS [Weight]
	    , RCD.F_PrintLongName AS [Coach]
	    --, RCM.F_Comment AS [FITA Ranking]
		, I.F_Seed AS [FITA Ranking]
	    , (SELECT Count(F_RegisterID) FROM TR_Register WHERE F_DisciplineID = @DisciplineID AND F_RegTypeID = 1) AS [PlayerNum]
	    , (SELECT Count(F_RegisterID) FROM TR_Register WHERE F_DisciplineID = @DisciplineID AND F_RegtypeID in(2,3)) AS [TeamNum]
	FROM
	(
		-- 单人项目
		SELECT DISTINCT R.F_RegisterID
			, E.F_EventID
			, 1 AS Inscription
			--, I.F_InscriptionRank
			, I.F_InscriptionComment
		FROM TR_Inscription AS I
		INNER JOIN TR_Register AS R
			ON I.F_RegisterID = R.F_RegisterID
		INNER JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		WHERE E.F_PlayerRegTypeID = 1 
			AND E.F_DisciplineID = @DisciplineID
			AND R.F_DisciplineID = @DisciplineID
			AND R.F_RegTypeID = 1
			AND (
					(@GroupType = 4 AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID))
					OR
					(@GroupType = 2 AND (@NOCID = '-1 ' OR @NOCID = '   ' OR R.F_NOC = @NOCID))
				)
			
		UNION 
		
		-- 多人项目
		SELECT DISTINCT R.F_RegisterID
			, E.F_EventID
			, 1 AS Inscription
			--, I.F_InscriptionRank
			, I.F_InscriptionComment
		FROM TR_Register_Member AS RM
		INNER JOIN TR_Inscription I
			ON RM.F_RegisterID = I.F_RegisterID
		INNER JOIN TS_Event AS E
			ON I.F_EventID = E.F_EventID
		INNER JOIN TR_Register AS R
			ON RM.F_MemberRegisterID = R.F_RegisterID
		WHERE E.F_PlayerRegTypeID IN (2, 3)
			AND E.F_DisciplineID = @DisciplineID
			AND R.F_DisciplineID = @DisciplineID
			AND R.F_RegTypeID = 1
			AND (
					(@GroupType = 4 AND (@DelegationID = -1 OR R.F_DelegationID = @DelegationID))
					OR
					(@GroupType = 2 AND (@NOCID = '-1 ' OR @NOCID = '   ' OR R.F_NOC = @NOCID))
				)
	) AS X
	LEFT JOIN TR_Register AS R
		ON X.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Inscription AS I
		ON X.F_RegisterID = I.F_RegisterID
	LEFT JOIN TS_Event AS E
		ON X.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Country_Des AS CD
		ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex AS S
		ON R.F_SexCode = S.F_SexCode
	LEFT JOIN TC_Sex_Des AS SD
		ON R.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS RC ON R.F_DelegationID = RC.F_DelegationID AND RC.F_FunctionID IN (SELECT F_FunctionID FROM TD_Function_Des WHERE F_FunctionLongName = 'Coach' )
    LEFT JOIN TR_Register_Des AS RCD ON RC.F_RegisterID = RCD.F_RegisterID AND RCD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register_Comment AS RCM ON R.F_RegisterID = RCM.F_RegisterID AND F_Title= 'FITA Ranking' 
    WHERE D.F_DelegationCode IS NOT NULL

SET NOCOUNT OFF
END


GO


