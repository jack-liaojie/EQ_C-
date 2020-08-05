IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetTeamResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GF_GetTeamResult]
--描    述：得到团体比赛成绩，当前Event
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年10月08日


CREATE PROCEDURE [dbo].[Proc_GF_GetTeamResult](
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
	                               F_Point1     INT,
	                               F_ToPar1     INT,
	                               F_IRM1       NVARCHAR(10),
	                               F_Point2     INT,
	                               F_ToPar2     INT,
	                               F_IRM2       NVARCHAR(10),
	                               F_Point3     INT,
	                               F_ToPar3     INT,
	                               F_IRM3       NVARCHAR(10),
	                               F_Point4     INT,
	                               F_ToPar4     INT,
	                               F_IRM4       NVARCHAR(10),
	                               F_Total      INT,
	                               Total        NVARCHAR(100),
	                               F_ToPar      INT,
	                               F_IRM        NVARCHAR(10),	                               
	                               F_Rank       INT,
								   F_DisplayPos    INT,		                               
	                              )
	                              
	INSERT INTO #Table_Team(F_TeamID, F_Noc, F_NocDes, 
	F_Point1, F_ToPar1, F_IRM1, F_Point2, F_ToPar2, F_IRM2, F_Point3, F_ToPar3, F_IRM3, F_Point4, F_ToPar4, F_IRM4,
	F_Total, F_ToPar, F_IRM, F_Rank, F_DisplayPos)
	EXEC [dbo].[Proc_GF_CalTeamResultView] @MatchID, 0

    UPDATE A SET A.F_Noc = D.F_DelegationCode, A.F_NocDes = DD.F_DelegationLongName
    FROM #Table_Team AS A
    LEFT JOIN TR_Register AS R ON A.F_TeamID = R.F_RegisterID LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID
    WHERE DD.F_LanguageCode = @LanguageCode
    
    UPDATE #Table_Team SET Total = (CASE WHEN F_Total = 0 THEN '' WHEN F_Total IS NULL THEN '' ELSE CAST(F_ToPar AS NVARCHAR(10)) END) + '(Rk.' + CAST(F_Rank AS NVARCHAR(10)) + ')'
    UPDATE #Table_Team SET F_Point1 = NULL, F_ToPar1 = NULL WHERE F_Point1 = 0
    UPDATE #Table_Team SET F_Point2 = NULL, F_ToPar2 = NULL WHERE F_Point2 = 0
    UPDATE #Table_Team SET F_Point3 = NULL, F_ToPar3 = NULL WHERE F_Point3 = 0
    UPDATE #Table_Team SET F_Point4 = NULL, F_ToPar4 = NULL WHERE F_Point4 = 0
    UPDATE #Table_Team SET F_Total = NULL, F_ToPar = NULL WHERE F_Total = 0
	
	SELECT F_TeamID, F_Noc AS NOC, F_NocDes AS Name, F_Point1 AS Round1, F_Point2 AS Round2, F_Point3 AS Round3, F_Point4 AS Round4, Total, F_DisplayPos AS Pos FROM #Table_Team 
	ORDER BY F_DisplayPos, F_Noc

Set NOCOUNT OFF
End

GO


