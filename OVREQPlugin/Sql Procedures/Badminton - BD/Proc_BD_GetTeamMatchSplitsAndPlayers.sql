IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetTeamMatchSplitsAndPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetTeamMatchSplitsAndPlayers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BD_GetTeamPlayersFromMatch]
--描    述：得到团体Match下每场比赛的运动员列表
--参数说明： 
--说    明：
--创 建 人：管仁良
--日    期：2010年10月06日


CREATE PROCEDURE [dbo].[Proc_BD_GetTeamMatchSplitsAndPlayers](
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
                                F_MatchSplitType		INT,
                                F_MatchSplitTypeName	NVARCHAR(100),
                                F_HomeID				INT,
                                F_AwayID				INT,
                                F_HomeName				NVARCHAR(100),
                                F_AwayName				NVARCHAR(100),
                                F_HomePosition			INT,
                                F_AwayPosition			INT
							)

    CREATE TABLE #table_Pos (
                              F_CompetitionPosition         INT
                             )

    DECLARE @ComPosA AS INT
    DECLARE @ComPosB AS INT

    INSERT INTO #table_Pos (F_CompetitionPosition)
    SELECT F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition

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

	INSERT INTO #Tmp_Table (F_MatchSplitID, F_Order, F_MatchSplitType) 
		SELECT F_MatchSplitID, F_Order, F_MatchSplitType FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order
		
	UPDATE #Tmp_Table SET F_MatchSplitTypeName = dbo.Fun_BD_GetMatchSplitTypeName(F_MatchSplitType, @LanguageCode) FROM #Tmp_Table

    UPDATE #Tmp_Table SET F_HomeID = B.F_RegisterID, F_HomePosition = @ComPosA FROM #Tmp_Table AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID
    WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = @ComPosA

    UPDATE #Tmp_Table SET F_AwayID = B.F_RegisterID, F_AwayPosition = @ComPosB FROM #Tmp_Table AS A LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID
    WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = @ComPosB

    UPDATE #Tmp_Table SET F_HomeName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_HomeID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_AwayName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_AwayID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

	SELECT F_Order AS MatchOrder, F_MatchSplitType, F_MatchSplitTypeName AS Type, F_HomeName AS HomeName, F_AwayName AS AwayName, F_MatchSplitID, F_HomeID, F_AwayID, F_HomePosition, F_AwayPosition FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

