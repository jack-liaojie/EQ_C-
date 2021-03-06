IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetMatchTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetMatchTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_BD_GetMatchTime]
--描    述：得到比赛时间
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年07月14日
--2011-1-14王强：由5局改为7局


CREATE PROCEDURE [dbo].[Proc_BD_GetMatchTime](
												@MatchID		          INT,
                                                @FatherMatchSplitID       INT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
	                            Match                 NVARCHAR(10),
                                Game1                 NVARCHAR(10),
                                Game2                 NVARCHAR(10),
                                Game3                 NVARCHAR(10),
                                Game4                 NVARCHAR(10),
                                Game5                 NVARCHAR(10),
                                Game6                 NVARCHAR(10),
                                Game7                 NVARCHAR(10),
                                F_Game1ID             INT,
                                F_Game2ID             INT,
                                F_Game3ID             INT,
                                F_Game4ID             INT,
                                F_Game5ID             INT,
                                F_Game6ID             INT,
                                F_Game7ID             INT,
							)

    DECLARE @MatchType AS INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
    
    IF (@MatchType = 3 AND @FatherMatchSplitID = -1)
    BEGIN        
        SELECT F_Game1ID, F_Game2ID, F_Game3ID, F_Game4ID, F_Game5ID, F_Game6ID, F_Game7ID FROM #Tmp_Table
        RETURN
    END
    ELSE IF @MatchType = 1
    BEGIN
        INSERT INTO #Tmp_Table (Match, Game1, Game2, Game3, Game4, Game5, Game6, Game7, F_Game1ID, F_Game2ID, F_Game3ID, F_Game4ID, F_Game5ID, F_Game6ID, F_Game7ID)
        SELECT
         (SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match WHERE F_MatchID = @MatchID)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 1)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 2)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 3)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 4)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 5)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 6)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 7)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 1)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 2)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 3)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 4)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 5)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 6)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = 7)
    END
    ELSE IF (@MatchType = 3 AND @FatherMatchSplitID <> -1)
    BEGIN
        INSERT INTO #Tmp_Table (Match, Game1, Game2, Game3, Game4, Game5, Game6, Game7, F_Game1ID, F_Game2ID, F_Game3ID, F_Game4ID, F_Game5ID, F_Game6ID, F_Game7ID)
        SELECT
         (SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @FatherMatchSplitID AND F_FatherMatchSplitID = 0)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 1)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 2)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 3)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 4)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 5)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 6)
        ,(SELECT [dbo].[Fun_BD_INTTimeToChar](F_SpendTime) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 7)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 1)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 2)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 3)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 4)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 5)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 6)
        ,(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @FatherMatchSplitID AND F_Order = 7)
    END
       
	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

