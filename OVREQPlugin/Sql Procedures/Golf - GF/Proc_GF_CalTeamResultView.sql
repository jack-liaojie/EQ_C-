IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CalTeamResultView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CalTeamResultView]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_CalTeamResultView]
--描    述: 团体比赛成绩展示
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2011年11月17日


CREATE PROCEDURE [dbo].[Proc_GF_CalTeamResultView](
												@MatchID		    INT,
												@IsDetail           INT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	DECLARE @SexCode AS INT
	DECLARE @IndividualEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    DECLARE @TeamEventID AS INT
    DECLARE @PlayerNum AS INT
    SELECT @EventID = E.F_EventID, @SexCode = E.F_SexCode, @IndividualEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SET @PlayerNum = (CASE WHEN @SexCode = 1 THEN 3 WHEN @SexCode = 2 THEN 2 ELSE 0 END)
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3

    
    DECLARE @TeamMatchID AS INT
    DECLARE @TeamMatchID1 AS INT
    DECLARE @TeamMatchID2 AS INT
    DECLARE @TeamMatchID3 AS INT
    DECLARE @TeamMatchID4 AS INT
    
    SELECT TOP 1 @TeamMatchID = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @TeamEventID AND P.F_Order = @PhaseOrder AND M.F_Order = 1
    SELECT TOP 1 @TeamMatchID1 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @TeamEventID AND P.F_Order = 1 AND M.F_Order = 1
    SELECT TOP 1 @TeamMatchID2 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @TeamEventID AND P.F_Order = 2 AND M.F_Order = 1
    SELECT TOP 1 @TeamMatchID3 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @TeamEventID AND P.F_Order = 3 AND M.F_Order = 1
    SELECT TOP 1 @TeamMatchID4 = F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE P.F_EventID = @TeamEventID AND P.F_Order = 4 AND M.F_Order = 1

	CREATE TABLE #Table_TotalRank(
	                               F_TeamID     INT,
	                               F_TeamCode   NVARCHAR(10),
	                               F_Noc        NVARCHAR(10),
	                               F_Round1     INT,
	                               F_ToPar1     NVARCHAR(10),
                                   F_IRM1       NVARCHAR(10),
	                               F_Round2     INT,
	                               F_ToPar2     NVARCHAR(10),
                                   F_IRM2       NVARCHAR(10),	                               
	                               F_Round3     INT,
	                               F_ToPar3     NVARCHAR(10),
                                   F_IRM3       NVARCHAR(10),	                               	                               
	                               F_Round4     INT,
	                               F_ToPar4     NVARCHAR(10),
                                   F_IRM4       NVARCHAR(10),	                               	                               
	                               F_Total      INT,
	                               F_ToPar      NVARCHAR(10),
	                               F_IRM        NVARCHAR(10),
	                               F_Rank       NVARCHAR(10),
								   F_DisplayPos    INT,							   
	                              )

	INSERT INTO #Table_TotalRank(F_TeamID,F_TeamCode,F_Noc,
	F_Round1,F_ToPar1,F_IRM1,F_Round2,F_ToPar2,F_IRM2,
	F_Round3,F_ToPar3,F_IRM3,F_Round4,F_ToPar4,F_IRM4,
	F_Total,F_ToPar,F_IRM,F_Rank,F_DisplayPos)
	SELECT MRR1.F_RegisterID,R.F_RegisterCode,D.F_DelegationCode,
	MRR1.F_PointsCharDes1,MRR1.F_PointsCharDes2,IRMR1.F_IRMCODE,
	MRR2.F_PointsCharDes1,MRR2.F_PointsCharDes2,IRMR2.F_IRMCODE,
	MRR3.F_PointsCharDes1,MRR3.F_PointsCharDes2,IRMR3.F_IRMCODE,
	MRR4.F_PointsCharDes1,MRR4.F_PointsCharDes2,IRMR4.F_IRMCODE,
	MR.F_PointsCharDes3,MR.F_PointsCharDes4,NULL,MR.F_Rank,MR.F_DisplayPosition
	FROM TS_Match_Result AS MRR1 
    LEFT JOIN TR_Register AS R ON MRR1.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Match_Result AS MRR2 ON MRR1.F_RegisterID = MRR2.F_RegisterID AND MRR2.F_MatchID = @TeamMatchID2
	LEFT JOIN TS_Match_Result AS MRR3 ON MRR1.F_RegisterID = MRR3.F_RegisterID AND MRR3.F_MatchID = @TeamMatchID3
	LEFT JOIN TS_Match_Result AS MRR4 ON MRR1.F_RegisterID = MRR4.F_RegisterID AND MRR4.F_MatchID = @TeamMatchID4
	LEFT JOIN TS_Match_Result AS MR ON MRR1.F_RegisterID = MR.F_RegisterID AND MR.F_MatchID = @TeamMatchID
	LEFT JOIN TC_IRM AS IRMR1 ON MRR1.F_IRMID = IRMR1.F_IRMID
	LEFT JOIN TC_IRM AS IRMR2 ON MRR2.F_IRMID = IRMR2.F_IRMID
	LEFT JOIN TC_IRM AS IRMR3 ON MRR3.F_IRMID = IRMR3.F_IRMID
	LEFT JOIN TC_IRM AS IRMR4 ON MRR4.F_IRMID = IRMR4.F_IRMID
	LEFT JOIN TC_IRM AS IRM ON MR.F_IRMID = IRM.F_IRMID
	WHERE MRR1.F_MatchID = @TeamMatchID1

	IF @PhaseOrder = 1
		UPDATE #Table_TotalRank SET F_Round2 = NULL,F_ToPar2 = NULL,F_IRM2 = NULL,F_Round3 = NULL,F_ToPar3 = NULL,F_IRM3 = NULL,F_Round4 = NULL,F_ToPar4 = NULL,F_IRM4 = NULL
	IF @PhaseOrder = 2
		UPDATE #Table_TotalRank SET F_Round3 = NULL,F_ToPar3 = NULL,F_IRM3 = NULL,F_Round4 = NULL,F_ToPar4 = NULL,F_IRM4 = NULL
	IF @PhaseOrder = 3
		UPDATE #Table_TotalRank SET F_Round4 = NULL,F_ToPar4 = NULL,F_IRM4 = NULL
	
	SELECT F_TeamID AS F_TeamID, F_TeamCode AS F_TeamCode, F_Noc AS F_NOC,
	F_Round1 AS F_Round1, F_ToPar1 AS F_ToPar1, F_IRM1 AS F_IRM1,
	F_Round2 AS F_Round2, F_ToPar2 AS F_ToPar2, F_IRM2 AS F_IRM2,
	F_Round3 AS F_Round3, F_ToPar3 AS F_ToPar3, F_IRM3 AS F_IRM3,
	F_Round4 AS F_Round4, F_ToPar4 AS F_ToPar4, F_IRM4 AS F_IRM4,
	F_Total AS F_Total, F_ToPar AS F_ToPar, F_IRM AS F_IRM, F_Rank AS F_Rank, F_DisplayPos AS F_Order
	FROM #Table_TotalRank ORDER BY F_DisplayPos, F_Noc

Set NOCOUNT OFF
End

GO

/*
exec [Proc_GF_CalTeamResultView] 2,0
exec [Proc_GF_CalTeamResultView] 8,1
*/

