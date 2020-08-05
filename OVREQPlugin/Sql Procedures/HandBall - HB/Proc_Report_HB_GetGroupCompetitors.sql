

/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetGroupCompetitors]    Script Date: 08/29/2012 16:51:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetGroupCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetGroupCompetitors]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetGroupCompetitors]    Script Date: 08/29/2012 16:51:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_HB_GetGroupCompetitors]
----功		  能：得到一个小项的小组的所有成员信息。
----作		  者：邓年彩
----日		  期: 2011-6-9

CREATE PROCEDURE [dbo].[Proc_Report_HB_GetGroupCompetitors]
                     (
	                   @EventID       INT,
                       @LanguageCode  CHAR(3)
                      )
AS
BEGIN
	
SET NOCOUNT ON

	SELECT PP.F_PhaseID
		, PP.F_RegisterID
		, PP.F_PhasePosition AS Position
		, NOC = CASE 
			WHEN PP.F_RegisterID IS NOT NULL THEN D.F_DelegationCode
			WHEN PP.F_SourcePhaseRank IS NOT NULL THEN CONVERT(NVARCHAR(10), PP.F_SourcePhaseRank) + SP.F_PhaseCode
			WHEN PP.F_SourceMatchRank = 1 THEN N'W' + CONVERT(NVARCHAR(10), SM.F_MatchNum) 
			WHEN PP.F_SourceMatchRank = 2 THEN N'L' + CONVERT(NVARCHAR(10), SM.F_MatchNum) 
			ELSE CONVERT(NVARCHAR(10), PP.F_PhasePosition)
		END
		, NOCDes = CASE 
			WHEN F_PhaseDisplayPosition IS NOT NULL THEN D.F_DelegationCode + N' - ' + DD.F_DelegationShortName 
		END
		
		, (
			SELECT COUNT(M.F_MatchID)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND M.F_MatchStatusID = 110
		) AS Played
		
		, (
			SELECT COUNT(M.F_MatchID)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND MR.F_ResultID = 1
				AND M.F_MatchStatusID = 110
		) AS Won
		
		, (
			SELECT COUNT(M.F_MatchID)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND MR.F_ResultID = 2
				AND M.F_MatchStatusID = 110
		) AS Lost
		
		, (
			SELECT COUNT(M.F_MatchID)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND MR.F_ResultID = 3
				AND M.F_MatchStatusID = 110
		) AS Ties
		
		, (
			SELECT SUM(MR.F_Points)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND M.F_MatchStatusID = 110
		) AS [For]
		
		, (
			SELECT SUM(MRA.F_Points)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			INNER JOIN TS_Match_Result AS MRA
				ON MR.F_MatchID = MRA.F_MatchID AND MR.F_RegisterID <> MRA.F_RegisterID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND M.F_MatchStatusID = 110
		) AS Against
		
		, (
			SELECT SUM(MR.F_Points - MRA.F_Points)
			FROM TS_Match_Result AS MR
			INNER JOIN TS_Match AS M
				ON MR.F_MatchID = M.F_MatchID
			INNER JOIN TS_Match_Result AS MRA
				ON MR.F_MatchID = MRA.F_MatchID AND MR.F_RegisterID <> MRA.F_RegisterID
			WHERE M.F_PhaseID = PP.F_PhaseID
				AND MR.F_RegisterID = PP.F_RegisterID
				AND M.F_MatchStatusID = 110
		) AS Diff
		
		, CASE 
			WHEN PR.F_IRMID IS NOT NULL THEN I.F_IRMCODE
			ELSE CONVERT(NVARCHAR(10), ISNULL(PR.F_PhasePoints, 0))
		END AS Class_Points
		, CONVERT(NVARCHAR(10), PR.F_PhaseRank) AS [Rank]
		, ROW_NUMBER() OVER (PARTITION BY PP.F_PhaseID ORDER BY ISNULL(PR.F_PhaseDisplayPosition, 999), PP.F_PhasePosition) AS [Order]
		,ER.F_EventRank AS [EventRank]
				
	FROM TS_Phase_Position AS PP
	INNER JOIN TS_Phase AS P
		ON PP.F_PhaseID = P.F_PhaseID
	--INNER JOIN TS_Phase AS FP
	--	ON P.F_FatherPhaseID = FP.F_PhaseID
	LEFT JOIN TS_Phase_Result AS PR
		ON PP.F_PhaseID = PR.F_PhaseID AND PP.F_RegisterID = PR.F_RegisterID
	LEFT JOIN TR_Register AS R
		ON PP.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM AS I
		ON PR.F_IRMID = I.F_IRMID
	LEFT JOIN TS_Event_Result AS ER 
		ON ER.F_RegisterID = PP.F_RegisterID	
		
	LEFT JOIN TS_Phase AS SP
		ON PP.F_SourcePhaseID = SP.F_PhaseID	
	LEFT JOIN TS_Match AS SM
		ON PP.F_SourceMatchID = SM.F_MatchID	
		
	WHERE P.F_EventID = @EventID
		AND P.F_PhaseIsPool = 1
		--AND FP.F_PhaseCode = N'9'
	ORDER BY P.F_PhaseCode
		, ISNULL(PR.F_PhaseDisplayPosition, 999)
		, PP.F_PhasePosition

SET NOCOUNT OFF
END


GO


