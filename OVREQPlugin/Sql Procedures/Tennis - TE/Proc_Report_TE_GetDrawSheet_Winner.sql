IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetDrawSheet_Winner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetDrawSheet_Winner]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











--名    称：[Proc_Report_TE_GetDrawSheet_Winner]
--描    述：得到Event下的一个Round下的Match的获胜者信息，为了测试赛用
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2010年10月21日


CREATE PROCEDURE [dbo].[Proc_Report_TE_GetDrawSheet_Winner](
                       @EventID         INT,
                       @PhaseCode       NVARCHAR(10),   ---如果@PhaseCode == '-1'，返回所有Match信息
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                            F_MatchID          INT,
                            F_APlayerID        INT,
                            F_BPlayerID        INT,
                            F_CurPointDes	   NVARCHAR(100),
                            F_WinnerPrintLN         NVARCHAR(100),
                            F_WinnerRegisterCode    NVARCHAR(20),
                            F_WinnerNOC             NVARCHAR(10),
                            F_PhaseCode             NVARCHAR(10),
							)

    DECLARE @EventName NVARCHAR(10)
    SELECT @EventName = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode

    INSERT INTO #Tmp_Table(F_MatchID, F_APlayerID, F_BPlayerID, F_PhaseCode)
    SELECT A.F_MatchID
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
    , B.F_PhaseCode
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    WHERE (@PhaseCode = '-1' OR B.F_PhaseCode = @PhaseCode) AND C.F_EventID = @EventID
    ORDER BY A.F_MatchID

 UPDATE #Tmp_Table SET F_CurPointDes = DBO.[Fun_TE_GetMatchSplitsPointsDes](F_MatchID, 2)

	UPDATE #Tmp_Table SET F_WinnerPrintLN = W.F_PrintLongName, F_WinnerRegisterCode = Y.F_RegisterCode, F_WinnerNOC = Z.F_DelegationCode 
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID AND X.F_Rank = 1
    LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
    LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode

	SELECT  *  FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



