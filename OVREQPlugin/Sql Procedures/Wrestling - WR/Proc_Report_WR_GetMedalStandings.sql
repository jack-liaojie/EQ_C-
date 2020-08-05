IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetMedalStandings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetMedalStandings]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetMedalStandings]
--描    述: 柔道项目报表获取奖牌榜(C95) 
--创 建 人: 邓年彩
--日    期: 2010年10月28日 星期四
--修改记录：
/*			
	时间					修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetMedalStandings]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID
		FROM TS_Discipline AS D
		WHERE D.F_Active = 1
	END

	CREATE TABLE #MedalStandings
	(
		[Rank]						INT,
		[NOC]						CHAR(3) collate database_default,
		[NOCLongName]				NVARCHAR(200),
		[NOCShortName]				NVARCHAR(100),
		[MG]						INT,
		[MS]						INT,
		[MB]						INT,
		[MT]						INT,
		[WG]						INT,
		[WS]						INT,
		[WB]						INT,
		[WT]						INT,
		[TG]						INT,
		[TS]						INT,
		[TB]						INT,
		[TT]						INT,
		[RankByTotal]				INT,
		[RankByTotal_Des]			NVARCHAR(10)
	)

	INSERT #MedalStandings
	(
		[Rank], [NOC], [NOCLongName], [NOCShortName]
		, [MG], [MS], [MB], [MT]
		, [WG], [WS], [WB], [WT]
		, [TG], [TS], [TB], [TT]
		, [RankByTotal]
	)
	(
		SELECT RANK() OVER(ORDER BY YY.[TG] DESC, YY.[TS] DESC, YY.[TB] DESC) AS [Rank]
			, YY.[NOC]
			, YY.[NOCLongName]
			, YY.[NOCShortName]
			, YY.[MG], YY.[MS], YY.[MB], YY.[MT]
			, YY.[WG], YY.[WS], YY.[WB], YY.[WT]
			, YY.[TG], YY.[TS], YY.[TB], YY.[TT]
			, RANK() OVER(ORDER BY YY.[TT] DESC) AS [RankByTotal]
		FROM 
		(
			SELECT XX.[NOC]
				, XX.[NOCLongName]
				, XX.[NOCShortName]
				, [MG], [MS], [MB], [MG] + [MS] + [MB] AS [MT]
				, [WG], [WS], [WB], [WG] + [WS] + [WB] AS [WT]
				, [MG] + [WG] AS [TG]
				, [MS] + [WS] AS [TS]
				, [MB] + [WB] AS [TB]
				, [MG] + [WG] + [MS] + [WS] + [MB] + [WB] AS [TT]
			FROM 
			(
				SELECT B.F_DelegationCode AS [NOC]
					, C.F_DelegationLongName AS [NOCLongName]
					, C.F_DelegationShortName AS [NOCShortName]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_SexCode = 1
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_SexCode = 1
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_SexCode = 1
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MB]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_SexCode = 2
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_SexCode = 2
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_SexCode = 2
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WB]
				FROM TS_ActiveDelegation AS A
				LEFT JOIN TC_Delegation AS B
					ON A.F_DelegationID = B.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS C
					ON A.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode
				WHERE A.F_DisciplineID = @DisciplineID
			) AS XX
			WHERE [MG] + [WG] + [MS] + [WS] + [MB] + [WB] > 0
		) AS YY
	)

	UPDATE #MedalStandings
	SET [RankByTotal_Des] = CONVERT(NVARCHAR(10), [RankByTotal])

	UPDATE #MedalStandings
	SET [RankByTotal_Des] = N'=' + [RankByTotal_Des]
	FROM #MedalStandings AS A
		, (
			SELECT COUNT([NOC]) AS [SameCount], [RankByTotal]
			FROM #MedalStandings
			GROUP BY [RankByTotal]
		) AS B
	WHERE A.[RankByTotal] = B.[RankByTotal]
		AND B.[SameCount] > 1

	SELECT * FROM #MedalStandings

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetMedalStandings] 62, 'ENG'

*/