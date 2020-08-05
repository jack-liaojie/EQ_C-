IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers]    Script Date: 12/27/2010 13:43:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











--名    称：[[Proc_JU_GetTeamMatchSplitsAndPlayers]]
--描    述：得到团体Match下每场比赛的运动员列表
--参数说明： 
--说    明：
--创 建 人：宁顺泽
--日    期：2010年12月28日


CREATE PROCEDURE [dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

		

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_MatchSplitID			INT,
                                F_Order					INT,
                                F_BlueID				INT,
                                F_WhiteID				INT,
                                F_BlueName				NVARCHAR(100),
                                F_WhiteName				NVARCHAR(100),
                                F_BluePosition          INT,
                                F_WhitePosition         INT,
                                F_WeighClass			NVARCHAR(20)
							)

    CREATE TABLE #table_Pos (
                              F_CompetitionPosition         INT
                             )

    DECLARE @ComPosA AS INT
    DECLARE @ComPosB AS INT

    INSERT INTO #table_Pos (F_CompetitionPosition)
    SELECT F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition

    DECLARE @Pos AS INT
    DECLARE @Index AS INT
	SET @Index = 1

	DECLARE ONE_CURSOR CURSOR FOR SELECT F_CompetitionPosition FROM #table_Pos
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @Pos
	WHILE @@FETCH_STATUS =0 
	BEGIN
		IF @Index = 1 SET @ComPosA = @Pos
		IF @Index = 2 SET @ComPosB = @Pos
		FETCH NEXT FROM ONE_CURSOR INTO @Pos
		SET @Index = @Index +1
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END

	INSERT INTO #Tmp_Table (F_MatchSplitID, F_Order) 
		SELECT F_MatchSplitID, F_Order FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order
		
	--UPDATE #Tmp_Table SET F_MatchSplitTypeName = dbo.Fun_BD_GetMatchSplitTypeName(F_MatchSplitType, @LanguageCode) FROM #Tmp_Table

    UPDATE #Tmp_Table SET F_BlueID = B.F_RegisterID, F_BluePosition = @ComPosA FROM #Tmp_Table AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID
   WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = @ComPosA

    UPDATE #Tmp_Table SET F_WhiteID = B.F_RegisterID, F_WhitePosition = @ComPosB FROM #Tmp_Table AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID
    WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = @ComPosB

    UPDATE #Tmp_Table SET F_BlueName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_BlueID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_WhiteName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_WhiteID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	
	Update #Tmp_Table SET F_WeighClass=B.F_Memo FroM #Tmp_Table AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchSplitID=B.F_MatchSplitID WHERE B.F_MatchID = @MatchID
	
	SELECT F_Order AS MatchOrder, F_MatchSplitID,F_BlueName AS BlueName, F_WhiteName AS WhiteName, F_BlueID, F_WhiteID, F_BluePosition, F_WhitePosition,F_WeighClass AS WeighClass FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF






GO


