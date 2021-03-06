IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMedalStandings_Event]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMedalStandings_Event]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_TE_GetMedalStandings_Event]
--描    述: 网球项目报表获取奖牌榜(C95) ---按项目展现
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2011年3月8日
--修改记录：
/*			
			时间				修改人		修改内容	
			
*/



CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMedalStandings_Event]
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

	CREATE TABLE #MedalStandings
	(
		[Rank]						INT,
		[NOC]						CHAR(3) collate database_default,
		[NOCLongName]				NVARCHAR(200),
		[NOCShortName]				NVARCHAR(100),
		[MSG]						INT,
		[MSS]						INT,
		[MSB]						INT,
		[MST]						INT,
		[WSG]						INT,
		[WSS]						INT,
		[WSB]						INT,
		[WST]						INT,
		[MDG]						INT,
		[MDS]						INT,
		[MDB]						INT,
		[MDT]						INT,
		[WDG]						INT,
		[WDS]						INT,
		[WDB]						INT,
		[WDT]						INT,
		[XDG]						INT,
		[XDS]						INT,
		[XDB]						INT,
		[XDT]						INT,
		[MTG]						INT,
		[MTS]						INT,
		[MTB]						INT,
		[MTT]						INT,
		[WTG]						INT,
		[WTS]						INT,
		[WTB]						INT,
		[WTT]						INT,
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
		, [MSG], [MSS], [MSB], [MST]
		, [WSG], [WSS], [WSB], [WST]
		, [MDG], [MDS], [MDB], [MDT]
		, [WDG], [WDS], [WDB], [WDT]
		, [MTG], [MTS], [MTB], [MTT]
		, [WTG], [WTS], [WTB], [WTT]
		, [XDG], [XDS], [XDB], [XDT]
		, [TG], [TS], [TB], [TT]
		, [RankByTotal]
	)
	(
		SELECT RANK() OVER(ORDER BY YY.[TG] DESC, YY.[TS] DESC, YY.[TB] DESC) AS [Rank]
			, YY.[NOC]
			, YY.[NOCLongName]
			, YY.[NOCShortName]
			, YY.[MSG], YY.[MSS], YY.[MSB], YY.[MST]
			, YY.[WSG], YY.[WSS], YY.[WSB], YY.[WST]
			, YY.[MDG], YY.[MDS], YY.[MDB], YY.[MDT]
			, YY.[WDG], YY.[WDS], YY.[WDB], YY.[WDT]
			, YY.[MTG], YY.[MTS], YY.[MTB], YY.[MTT]
			, YY.[WTG], YY.[WTS], YY.[WTB], YY.[WTT]
			, YY.[XDG], YY.[XDS], YY.[XDB], YY.[XDT]
			, YY.[TG], YY.[TS], YY.[TB], YY.[TT]
			, RANK() OVER(ORDER BY YY.[TT] DESC) AS [RankByTotal]
		FROM 
		(
			SELECT XX.[NOC]
				, XX.[NOCLongName]
				, XX.[NOCShortName]
				, [MSG], [MSS], [MSB], [MSG] + [MSS] + [MSB] AS [MST]
				, [WSG], [WSS], [WSB], [WSG] + [WSS] + [WSB] AS [WST]
				, [MDG], [MDS], [MDB], [MDG] + [MDS] + [MDB] AS [MDT]
				, [WDG], [WDS], [WDB], [WDG] + [WDS] + [WDB] AS [WDT]
				, [MTG], [MTS], [MTB], [MTG] + [MTS] + [MTB] AS [MTT]
				, [WTG], [WTS], [WTB], [WTG] + [WTS] + [WTB] AS [WTT]
				, [XDG], [XDS], [XDB], [XDG] + [XDS] + [XDB] AS [XDT]
				, [MSG] + [WSG] + [MDG] + [WDG] + [MTG] + [WTG] + [XDG] AS [TG]
				, [MSS] + [WSS] + [MDS] + [WDS] + [MTS] + [WTS] + [XDS] AS [TS]
				, [MSB] + [WSB] + [MDB] + [WDB] + [MTB] + [WTB] + [XDB] AS [TB]
				, [MSG] + [WSG] + [MSS] + [WSS] + [MSB] + [WSB] 
				  + [MDG] + [WDG] + [MDS] + [WDS] + [MDB] + [WDB] 
				  + [MTG] + [WTG] + [MTS] + [WTS] + [MTB] + [WTB]
				  + [XDG] + [XDS] + [XDB] AS [TT]
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
							AND Y.F_EventCode = '001'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MSG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '001'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MSS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '001'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MSB]
					,(
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '002'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MDG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '002'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MDS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '002'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MDB]
					,(
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '003'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MTG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '003'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MTS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '003'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [MTB]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '101'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WSG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '101'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WSS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '101'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WSB]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '102'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WDG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '102'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WDS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '102'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WDB]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '103'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WTG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '103'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WTS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '103'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [WTB]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 1
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '201'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [XDG]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 2
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '201'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [XDS]
					, (
						SELECT COUNT(X.F_EventID)
						FROM TS_Event_Result AS X
						LEFT JOIN TS_Event AS Y
							ON X.F_EventID = Y.F_EventID
						LEFT JOIN TR_Register AS Z
							ON X.F_RegisterID = Z.F_RegisterID
						WHERE X.F_MedalID = 3
							AND Y.F_DisciplineID =@DisciplineID
							AND Y.F_EventCode = '201'
							AND Y.F_EventStatusID = 110
							AND Z.F_DelegationID = A.F_DelegationID
					) AS [XDB]
				FROM TS_ActiveDelegation AS A
				LEFT JOIN TC_Delegation AS B
					ON A.F_DelegationID = B.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS C
					ON A.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode
				WHERE A.F_DisciplineID = @DisciplineID
			) AS XX
			WHERE  [MSG] + [WSG] + [MSS] + [WSS] + [MSB] + [WSB] 
				  + [MDG] + [WDG] + [MDS] + [WDS] + [MDB] + [WDB] 
				  + [MTG] + [WTG] + [MTS] + [WTS] + [MTB] + [WTB]
				  + [XDG] + [XDS] + [XDB]  > 0
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
EXEC [Proc_Report_KR_GetMedalStandings] 62

*/

