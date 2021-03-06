IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetPlayerPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetPlayerPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_HO_GetPlayerPosition]
--描    述：得到运动员可选位置列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月21日


CREATE PROCEDURE [dbo].[Proc_HO_GetPlayerPosition](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_PositionID      INT,
                                F_Position        NVARCHAR(100)
							)

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID

	INSERT INTO #Tmp_Table (F_PositionID, F_Position)
    SELECT A.F_PositionID, B.F_PositionLongName FROM TD_Position AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID WHERE A.F_DisciplineID = @DisciplineID
    AND B.F_LanguageCode = @LanguageCode

    INSERT INTO #Tmp_Table (F_PositionID, F_Position)
    VALUES(-1, 'NONE')

	SELECT F_Position AS [Position], F_PositionID FROM #Tmp_Table

Set NOCOUNT OFF
End

GO



