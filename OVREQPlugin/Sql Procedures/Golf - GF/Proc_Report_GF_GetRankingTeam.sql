IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetRankingTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetRankingTeam]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_GF_GetRankingTeam]
--描    述：得到当前Event下得各个代表团成绩
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年10月07日


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetRankingTeam](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Table_Team(
	                               F_TeamID     INT,
	                               F_Noc        NVARCHAR(10),
	                               F_NocDes     NVARCHAR(150),
	                               F_Round1     INT,
	                               F_RoundEx1   NVARCHAR(10),
	                               F_ToPar1     NVARCHAR(10),
	                               F_IRM1       NVARCHAR(10),
	                               F_Round2     INT,
	                               F_RoundEx2   NVARCHAR(10),
	                               F_ToPar2     NVARCHAR(10),
	                               F_IRM2       NVARCHAR(10),
	                               F_Round3     INT,
	                               F_RoundEx3   NVARCHAR(10),
	                               F_ToPar3     NVARCHAR(10),
	                               F_IRM3       NVARCHAR(10),
	                               F_Round4     INT,
	                               F_RoundEx4   NVARCHAR(10),
	                               F_ToPar4     NVARCHAR(10),
	                               F_IRM4       NVARCHAR(10),
	                               F_Total      INT,
	                               F_TotalEx    NVARCHAR(100),
	                               F_ToPar      NVARCHAR(10),
	                               F_IRM        NVARCHAR(10),	                               
	                               F_Rank       NVARCHAR(10),
								   F_DisplayPos    INT,		                               
	                              )
	                              
	INSERT INTO #Table_Team(F_TeamID, F_Noc, F_NocDes, 
	F_Round1, F_ToPar1, F_IRM1, F_Round2, F_ToPar2, F_IRM2, F_Round3, F_ToPar3, F_IRM3, F_Round4, F_ToPar4, F_IRM4,
	F_Total, F_ToPar, F_IRM, F_Rank, F_DisplayPos)
	EXEC [dbo].[Proc_GF_CalTeamResult] @MatchID, 1
		
    UPDATE A SET A.F_Noc = D.F_DelegationCode, A.F_NocDes = DD.F_DelegationLongName
    FROM #Table_Team AS A
    LEFT JOIN TR_Register AS R ON A.F_TeamID = R.F_RegisterID LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID
    WHERE DD.F_LanguageCode = @LanguageCode
    
    UPDATE #Table_Team SET F_Round1 = NULL, F_ToPar1 = NULL WHERE F_Round1 = 0
    UPDATE #Table_Team SET F_Round2 = NULL, F_ToPar2 = NULL WHERE F_Round2 = 0
    UPDATE #Table_Team SET F_Round3 = NULL, F_ToPar3 = NULL WHERE F_Round3 = 0
    UPDATE #Table_Team SET F_Round4 = NULL, F_ToPar4 = NULL WHERE F_Round4 = 0
    UPDATE #Table_Team SET F_Total = NULL, F_ToPar = NULL WHERE F_Total = 0
    UPDATE #Table_Team SET F_ToPar1 = 'E' WHERE F_ToPar1 = 0
    UPDATE #Table_Team SET F_ToPar2 = 'E' WHERE F_ToPar2 = 0
    UPDATE #Table_Team SET F_ToPar3 = 'E' WHERE F_ToPar3 = 0
    UPDATE #Table_Team SET F_ToPar4 = 'E' WHERE F_ToPar4 = 0
    UPDATE #Table_Team SET F_ToPar = 'E' WHERE F_ToPar = 0
  
    UPDATE #Table_Team SET F_RoundEx1 = F_Round1 WHERE F_IRM1 IS NULL
    UPDATE #Table_Team SET F_RoundEx1 = F_IRM1 WHERE F_IRM1 IS NOT NULL
    UPDATE #Table_Team SET F_RoundEx2 = F_Round2 WHERE F_IRM2 IS NULL
    UPDATE #Table_Team SET F_RoundEx2 = F_IRM2 WHERE F_IRM2 IS NOT NULL
    UPDATE #Table_Team SET F_RoundEx3 = F_Round3 WHERE F_IRM3 IS NULL
    UPDATE #Table_Team SET F_RoundEx3 = F_IRM3 WHERE F_IRM3 IS NOT NULL
    UPDATE #Table_Team SET F_RoundEx4 = F_Round4 WHERE F_IRM4 IS NULL
    UPDATE #Table_Team SET F_RoundEx4 = F_IRM4 WHERE F_IRM4 IS NOT NULL
   
    UPDATE #Table_Team SET F_TotalEx = F_Total WHERE F_IRM IS NULL
    UPDATE #Table_Team SET F_TotalEx = F_IRM WHERE F_IRM IS NOT NULL
    
    DECLARE @n AS INT
    DECLARE @MaxDisPos AS INT
    DECLARE @count AS INT
    SELECT @MaxDisPos = max(F_DisplayPos) FROM #Table_Team
    SET @n = 1
    SET @count = 0
    while(@n<@MaxDisPos)
    begin
		DECLARE @nNVAR AS NVARCHAR(10)
		SET @nNVAR = cast(@n as NVARCHAR(10))
        SELECT @count = COUNT(*) FROM #Table_Team WHERE F_Rank = @nNVAR
		update #Table_Team set F_Rank = 'T' + F_Rank where @count > 1 and F_Rank = @nNVAR
		set @n = @n + 1
    end
	
	SELECT * FROM #Table_Team ORDER BY case when F_DisplayPos is null then 999 else F_DisplayPos end, F_Noc

Set NOCOUNT OFF
End

GO


