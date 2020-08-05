IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_GetTeamMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_GetTeamMembers]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_BK_GetTeamMembers]
--描    述：得到比赛中队伍的队员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月08日

CREATE PROCEDURE [dbo].[Proc_BK_GetTeamMembers]
                 @MatchID             INT,   
                 @TeamPos             INT,
                 @LanguageCode        NVARCHAR(3)

AS
BEGIN
   SET NOCOUNT ON

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = E.F_DisciplineID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                 LEFT JOIN TS_Event AS E On P.F_EventID = E.F_EventID 
            WHERE M.F_MatchID = @MatchID
           
           CREATE TABLE #table_teammember(
                                             F_TeamPos          INT,
                                             F_RegisterID       INT,
                                             F_ShirtNumber      INT,
                                             F_RegisterName     NVARCHAR(50),
                                             F_PositionCode     NVARCHAR(20),
                                             F_PositionID       INT,
                                             F_Active           INT,
                                            )
 
  
      INSERT INTO #table_teammember (F_TeamPos, F_ShirtNumber, F_RegisterID, F_PositionID, F_Active)
            SELECT A.F_CompetitionPosition, A.F_ShirtNumber, A.F_RegisterID, A.F_PositionID, A.F_Active 
                FROM TS_Match_Member AS A 
                  WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos 
                        

      UPDATE #table_teammember SET F_RegisterName = F_ShortName  FROM #table_teammember AS A LEFT JOIN TR_Register_Des AS B
              ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

      UPDATE #table_teammember SET F_PositionCode = B.F_PositionCode FROM #table_teammember AS A LEFT JOIN TD_Position AS B
             ON A.F_PositionID = B.F_PositionID 

     
           
      SELECT F_RegisterID, F_ShirtNumber AS [ShirtNo], F_RegisterName AS [Name], F_PositionCode AS [Position], F_Active FROM #table_teammember ORDER BY F_Active desc, F_ShirtNumber 
   
Set NOCOUNT OFF
End
	
set QUOTED_IDENTIFIER OFF
