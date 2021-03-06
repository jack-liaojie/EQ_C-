IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetRegusList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetRegusList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_GetRegusList]
--描    述：得到Match下子Match
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年08月09日


CREATE PROCEDURE [dbo].[Proc_BD_GetRegusList](
												@MatchID		    INT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_Regu       NVARCHAR(10),
                                F_SplitID    INT
							)

    DECLARE @MatchType INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
    
    IF @MatchType = 3
    BEGIN
        INSERT INTO #Tmp_Table (F_Regu, F_SplitID) VALUES('NONE', -1)

        INSERT INTO #Tmp_Table (F_Regu, F_SplitID)
        SELECT 'Match' + CAST(F_Order AS NVARCHAR(2)), F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
    END

	SELECT F_Regu, F_SplitID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

