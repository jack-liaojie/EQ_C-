IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TT_GetMatchViewResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TT_GetMatchViewResult]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_TT_GetMatchViewResult]
--描    述：获取实时比分
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2010年08月13日


CREATE PROCEDURE [dbo].[Proc_TT_GetMatchViewResult](
												@MatchID		INT,
												@Result   INT OUTPUT
                                                
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @MatchType INT
	
	SET @Result = 1
	SELECT @MatchType = C.F_PlayerRegTypeID FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	IF @MatchType IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END
	IF @MatchType = 3
	BEGIN
		SELECT A.F_Order, ISNULL( CONVERT( NVARCHAR(10), B11.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), B12.F_Points ), '') AS SetScore,
	   ISNULL(D1.F_IRMCODE,'') + ':' + ISNULL(D2.F_IRMCODE,'') AS SetIRM,
	   ISNULL( CONVERT( NVARCHAR(10), C11.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C12.F_Points ), '') AS Game1,
	   ISNULL( CONVERT( NVARCHAR(10), C21.F_Points ), '') +  ' : '  +
	   ISNULL( CONVERT( NVARCHAR(10), C22.F_Points ), '') AS Game2,
	   ISNULL( CONVERT( NVARCHAR(10), C31.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C32.F_Points ), '') AS Game3,
	   ISNULL( CONVERT( NVARCHAR(10), C41.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C42.F_Points ), '') AS Game4,
	   ISNULL( CONVERT( NVARCHAR(10), C51.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C52.F_Points ), '') AS Game5
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B11 ON B11.F_MatchID = A.F_MatchID AND B11.F_MatchSplitID = A.F_MatchSplitID
					AND B11.F_CompetitionPosition = 1
		LEFT JOIN TC_IRM D1 ON D1.F_IRMID = B11.F_IRMID
		LEFT JOIN TS_Match_Split_Result AS B12 ON B12.F_MatchID = A.F_MatchID AND B12.F_MatchSplitID = A.F_MatchSplitID
					AND B12.F_CompetitionPosition = 2	
		LEFT JOIN TC_IRM D2 ON D2.F_IRMID = B12.F_IRMID
		LEFT JOIN TS_Match_Split_Info AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_FatherMatchSplitID = A.F_MatchSplitID AND C1.F_Order = 1
		LEFT JOIN TS_Match_Split_Result AS C11 ON C11.F_MatchID = C1.F_MatchID AND C11.F_MatchSplitID = C1.F_MatchSplitID AND C11.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C12 ON C12.F_MatchID = C1.F_MatchID AND C12.F_MatchSplitID = C1.F_MatchSplitID AND C12.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_FatherMatchSplitID = A.F_MatchSplitID AND C2.F_Order = 2
		LEFT JOIN TS_Match_Split_Result AS C21 ON C21.F_MatchID = C2.F_MatchID AND C21.F_MatchSplitID = C2.F_MatchSplitID AND C21.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C22 ON C22.F_MatchID = C2.F_MatchID AND C22.F_MatchSplitID = C2.F_MatchSplitID AND C22.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C3 ON C3.F_MatchID = A.F_MatchID AND C3.F_FatherMatchSplitID = A.F_MatchSplitID AND C3.F_Order = 3
		LEFT JOIN TS_Match_Split_Result AS C31 ON C31.F_MatchID = C3.F_MatchID AND C31.F_MatchSplitID = C3.F_MatchSplitID AND C31.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C32 ON C32.F_MatchID = C3.F_MatchID AND C32.F_MatchSplitID = C3.F_MatchSplitID AND C32.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C4 ON C4.F_MatchID = A.F_MatchID AND C4.F_FatherMatchSplitID = A.F_MatchSplitID AND C4.F_Order = 4
		LEFT JOIN TS_Match_Split_Result AS C41 ON C41.F_MatchID = C4.F_MatchID AND C41.F_MatchSplitID = C4.F_MatchSplitID AND C41.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C42 ON C42.F_MatchID = C4.F_MatchID AND C42.F_MatchSplitID = C4.F_MatchSplitID AND C42.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C5 ON C5.F_MatchID = A.F_MatchID AND C5.F_FatherMatchSplitID = A.F_MatchSplitID AND C5.F_Order = 5
		LEFT JOIN TS_Match_Split_Result AS C51 ON C51.F_MatchID = C5.F_MatchID AND C51.F_MatchSplitID = C5.F_MatchSplitID AND C51.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C52 ON C52.F_MatchID = C5.F_MatchID AND C52.F_MatchSplitID = C5.F_MatchSplitID AND C52.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C6 ON C6.F_MatchID = A.F_MatchID AND C6.F_FatherMatchSplitID = A.F_MatchSplitID AND C6.F_Order = 6
		LEFT JOIN TS_Match_Split_Result AS C61 ON C61.F_MatchID = C6.F_MatchID AND C61.F_MatchSplitID = C6.F_MatchSplitID AND C61.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C62 ON C62.F_MatchID = C6.F_MatchID AND C62.F_MatchSplitID = C6.F_MatchSplitID AND C62.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C7 ON C7.F_MatchID = A.F_MatchID AND C7.F_FatherMatchSplitID = A.F_MatchSplitID AND C7.F_Order = 7
		LEFT JOIN TS_Match_Split_Result AS C71 ON C71.F_MatchID = C7.F_MatchID AND C71.F_MatchSplitID = C7.F_MatchSplitID AND C71.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C72 ON C72.F_MatchID = C7.F_MatchID AND C72.F_MatchSplitID = C7.F_MatchSplitID AND C72.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM E11 ON E11.F_IRMID = C11.F_IRMID
		LEFT JOIN TC_IRM E12 ON E12.F_IRMID = C12.F_IRMID
		LEFT JOIN TC_IRM E21 ON E21.F_IRMID = C21.F_IRMID
		LEFT JOIN TC_IRM E22 ON E22.F_IRMID = C22.F_IRMID
		LEFT JOIN TC_IRM E31 ON E31.F_IRMID = C31.F_IRMID
		LEFT JOIN TC_IRM E32 ON E32.F_IRMID = C32.F_IRMID
		WHERE A.F_FatherMatchSplitID = 0 AND A.F_MatchID = @MatchID
		ORDER BY A.F_Order	
	END
	ELSE IF @MatchType IN (1,2)
	BEGIN
		SELECT ISNULL( CONVERT( NVARCHAR(10), B11.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), B12.F_Points ), '') AS MatchScore,
	   ISNULL(D1.F_IRMCode,'') + ':' + ISNULL(D2.F_IRMCODE,'') AS MatchIRM,
	   ISNULL( CONVERT( NVARCHAR(10), C11.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C12.F_Points ), '') AS Game1,
	   ISNULL( CONVERT( NVARCHAR(10), C21.F_Points ), '') +  ' : '  +
	   ISNULL( CONVERT( NVARCHAR(10), C22.F_Points ), '') AS Game2,
	   ISNULL( CONVERT( NVARCHAR(10), C31.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C32.F_Points ), '') AS Game3,
	   ISNULL( CONVERT( NVARCHAR(10), C41.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C42.F_Points ), '') AS Game4,
	   ISNULL( CONVERT( NVARCHAR(10), C51.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C52.F_Points ), '') AS Game5,
	   ISNULL( CONVERT( NVARCHAR(10), C61.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C62.F_Points ), '') AS Game6,
	   ISNULL( CONVERT( NVARCHAR(10), C71.F_Points ), '') +  ' : ' +
	   ISNULL( CONVERT( NVARCHAR(10), C72.F_Points ), '') AS Game7
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B11 ON B11.F_MatchID = A.F_MatchID AND B11.F_CompetitionPositionDes1 = 1
		LEFT JOIN TC_IRM D1 ON D1.F_IRMID = B11.F_IRMID
		LEFT JOIN TS_Match_Result AS B12 ON B12.F_MatchID = A.F_MatchID AND B12.F_CompetitionPositionDes1 = 2	
		LEFT JOIN TC_IRM D2 ON D2.F_IRMID = B12.F_IRMID
		LEFT JOIN TS_Match_Split_Info AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_Order = 1
		LEFT JOIN TS_Match_Split_Result AS C11 ON C11.F_MatchID = C1.F_MatchID AND C11.F_MatchSplitID = C1.F_MatchSplitID AND C11.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C12 ON C12.F_MatchID = C1.F_MatchID AND C12.F_MatchSplitID = C1.F_MatchSplitID AND C12.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_Order = 2
		LEFT JOIN TS_Match_Split_Result AS C21 ON C21.F_MatchID = C2.F_MatchID AND C21.F_MatchSplitID = C2.F_MatchSplitID AND C21.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C22 ON C22.F_MatchID = C2.F_MatchID AND C22.F_MatchSplitID = C2.F_MatchSplitID AND C22.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C3 ON C3.F_MatchID = A.F_MatchID AND C3.F_Order = 3
		LEFT JOIN TS_Match_Split_Result AS C31 ON C31.F_MatchID = C3.F_MatchID AND C31.F_MatchSplitID = C3.F_MatchSplitID AND C31.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C32 ON C32.F_MatchID = C3.F_MatchID AND C32.F_MatchSplitID = C3.F_MatchSplitID AND C32.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C4 ON C4.F_MatchID = A.F_MatchID AND C4.F_Order = 4
		LEFT JOIN TS_Match_Split_Result AS C41 ON C41.F_MatchID = C4.F_MatchID AND C41.F_MatchSplitID = C4.F_MatchSplitID AND C41.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C42 ON C42.F_MatchID = C4.F_MatchID AND C42.F_MatchSplitID = C4.F_MatchSplitID AND C42.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C5 ON C5.F_MatchID = A.F_MatchID AND C5.F_Order = 5
		LEFT JOIN TS_Match_Split_Result AS C51 ON C51.F_MatchID = C5.F_MatchID AND C51.F_MatchSplitID = C5.F_MatchSplitID AND C51.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C52 ON C52.F_MatchID = C5.F_MatchID AND C52.F_MatchSplitID = C5.F_MatchSplitID AND C52.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C6 ON C6.F_MatchID = A.F_MatchID AND C6.F_Order = 6
		LEFT JOIN TS_Match_Split_Result AS C61 ON C61.F_MatchID = C6.F_MatchID AND C61.F_MatchSplitID = C6.F_MatchSplitID AND C61.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C62 ON C62.F_MatchID = C6.F_MatchID AND C62.F_MatchSplitID = C6.F_MatchSplitID AND C62.F_CompetitionPosition = 2
		LEFT JOIN TS_Match_Split_Info AS C7 ON C7.F_MatchID = A.F_MatchID AND C7.F_Order = 7
		LEFT JOIN TS_Match_Split_Result AS C71 ON C71.F_MatchID = C7.F_MatchID AND C71.F_MatchSplitID = C7.F_MatchSplitID AND C71.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS C72 ON C72.F_MatchID = C7.F_MatchID AND C72.F_MatchSplitID = C7.F_MatchSplitID AND C72.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM E11 ON E11.F_IRMID = C11.F_IRMID
		LEFT JOIN TC_IRM E12 ON E12.F_IRMID = C12.F_IRMID
		LEFT JOIN TC_IRM E21 ON E21.F_IRMID = C21.F_IRMID
		LEFT JOIN TC_IRM E22 ON E22.F_IRMID = C22.F_IRMID
		LEFT JOIN TC_IRM E31 ON E31.F_IRMID = C31.F_IRMID
		LEFT JOIN TC_IRM E32 ON E32.F_IRMID = C32.F_IRMID
		WHERE A.F_MatchID = @MatchID
	END

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

