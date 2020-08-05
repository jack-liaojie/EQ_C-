IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetStartUpStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetStartUpStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_HO_GetStartUpStatus]
--描    述：选择首发运动员
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月21日


CREATE PROCEDURE [dbo].[Proc_HO_GetStartUpStatus]
												(
												@MatchID INT,
												@Pos     INT
												)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_StartUpID        INT,
                                F_StartUp          NVARCHAR(100)
							)

    DECLARE @Count AS INT
    DECLARE @CompetitionPos AS INT
    SELECT @CompetitionPos = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Pos
    SELECT @Count = COUNT(F_StartUp) FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_StartUp = 1 AND F_CompetitionPosition = @CompetitionPos GROUP BY F_StartUp
    
    IF (@Count < 11) OR @Count IS NULL
    BEGIN
		INSERT INTO #Tmp_Table (F_StartUpID, F_StartUp)
		VALUES(1, 'StartUp')
	END

    INSERT INTO #Tmp_Table (F_StartUpID, F_StartUp)
    VALUES(-1, 'NONE')

	SELECT F_StartUp AS [StartUp], F_StartUpID FROM #Tmp_Table

Set NOCOUNT OFF
End


GO


