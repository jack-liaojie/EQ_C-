IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetKnockOutResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetKnockOutResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_HO_GetKnockOutResult]
--描    述：得到淘汰赛一场Match的信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年09月06日


CREATE PROCEDURE [dbo].[Proc_Report_HO_GetKnockOutResult](
                       @PhaseID         INT,
                       @MatchNum        INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(16),
                                   F_CourtCode     NVARCHAR(10),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(10),
                                   F_HScore        INT,
                                   F_HResult       INT,
                                   F_VScore        INT,
                                   F_VResult       INT,
                                   F_MatchResult   NVARCHAR(20),
                                   F_Winner        NVARCHAR(100)
							)

    DECLARE @MatchID AS INT
    SELECT TOP 1 @MatchID = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_Order = 1

    INSERT INTO #Tmp_Table(F_MatchID, F_StartTime, F_CourtCode, F_MatchNum, F_AName, F_ANOC, F_BName, F_BNOC, F_HScore, F_HResult, F_VScore, F_VResult)
    SELECT A.F_MatchID, LEFT(CONVERT(NVARCHAR(30), A.F_StartTime, 20), 16), C.F_PhaseShortName, A.F_RaceNum
    ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
    ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
    ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
    ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
    ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1)
    ,(SELECT F_ResultID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1)
    ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2)
    ,(SELECT F_ResultID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2)
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
    WHERE A.F_MatchID = @MatchID
    
    UPDATE #Tmp_Table SET F_MatchResult = CAST(F_HScore AS NVARCHAR(3)) + ' - ' + CAST(F_VScore AS NVARCHAR(3))
    UPDATE #Tmp_Table SET F_Winner = F_AName WHERE F_HResult = 1
    UPDATE #Tmp_Table SET F_Winner = F_BName WHERE F_VResult = 1
    
	SELECT F_AName, F_BName, F_StartTime, F_MatchResult, F_Winner FROM #Tmp_Table

Set NOCOUNT OFF
End	


GO

/*EXEC Proc_Report_HO_GetKnockOutResult 5, 1, 'chn'*/

