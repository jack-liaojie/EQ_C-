IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_GetActiveMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_GetActiveMember]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_BK_GetActiveMember]
--��    �����õ������ж���ĳ��϶����Ա
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2010��03��08��

CREATE PROCEDURE [dbo].[Proc_BK_GetActiveMember]
                 @MatchID             INT,   
                 @TeamPos             INT,
                 @LanguageCode        NVARCHAR(3)

AS
BEGIN
   SET NOCOUNT ON

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = E.F_DisciplineID 
       FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                          LEFT JOIN TS_Event AS E On P.F_EventID = E.F_EventID 
           WHERE M.F_MatchID = @MatchID
           
           CREATE TABLE #table_teammember(
                                             F_RegisterID       INT,
                                             F_RegisterName     NVARCHAR(50),
                                             F_ShirtNumber      INT,
                                             F_Comment          NVARCHAR(50),
                                             F_GKPlayerID       INT,
                                             F_PositionID       INT,
                                            )
 
  
      INSERT INTO #table_teammember (F_ShirtNumber, F_RegisterName, F_RegisterID, F_PositionID, F_Comment)
            SELECT A.F_ShirtNumber,  B.F_LongName, A.F_RegisterID, A.F_PositionID, F_Comment
                FROM TS_Match_Member AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID 
                  WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos AND B.F_LanguageCode = @LanguageCode AND A.F_Active = 1

      UPDATE #table_teammember SET F_GKPlayerID = X.F_RegisterID  FROM 
             (SELECT F_RegisterID FROM #table_teammember AS A LEFT JOIN TD_Position AS B ON A.F_PositionID = B.F_PositionID WHERE B.F_PositionCode = 'GK' AND B.F_DisciplineID = @DisciplineID) AS X


    SELECT F_RegisterID, F_ShirtNumber, F_RegisterName, F_Comment, F_GKPlayerID FROM #table_teammember
   
Set NOCOUNT OFF
End
	
set QUOTED_IDENTIFIER OFF
