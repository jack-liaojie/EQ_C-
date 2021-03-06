 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_GetMatchMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_GetMatchMember]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_BK_GetMatchMember]
--描    述：得到Match下得队的运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_BK_GetMatchMember](
												@MatchID		    INT,
                                                @TeamPos            INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_MemberID      INT,
                                F_FunctionID    INT,
                                F_MemberName    NVARCHAR(100),
                                F_FunctionName  NVARCHAR(50),
                                F_ShirtNumber   INT,
                                F_PositionID    INT,
                                F_Position      NVARCHAR(50),
                                F_Order         INT,
                                F_Comment       NVARCHAR(50),
                                F_Startup        INT,
                                F_StartupNum     INT,
                                F_RegisterID    INT,
							)

   INSERT INTO #Tmp_Table(F_MemberID, F_FunctionID, F_ShirtNumber, F_PositionID, F_Order, F_Startup, F_StartupNum)
          SELECT F_RegisterID, F_FunctionID, F_ShirtNumber, F_PositionID, F_Order, F_Startup, 0 FROM TS_Match_Member
           WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos
  
   UPDATE #Tmp_Table SET F_RegisterID = A.F_RegisterID FROM TS_Match_Result AS A WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos
   
   UPDATE #Tmp_Table SET F_Startup = 0 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos AND F_Startup IS NULL
   
   UPDATE #Tmp_Table SET F_Comment = B.F_Comment FROM #Tmp_Table AS A LEFT JOIN TR_Register_Member AS B ON A.F_MemberID = B.F_MemberRegisterID AND A.F_RegisterID = B.F_RegisterID

  UPDATE #Tmp_Table SET F_MemberName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
 
  UPDATE #Tmp_Table SET F_FunctionName = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
  
  UPDATE #Tmp_Table SET F_Position = B.F_PositionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode

  UPDATe #Tmp_Table SET F_StartupNum = B.F_StartupNum 
          FROM (SELECT COUNT(F_RegisterID) AS F_StartupNum FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos AND F_StartUp = 1 )  AS B
  
  SELECT F_Startup AS [Startup], F_ShirtNumber AS [ShirtNumber], F_MemberName AS [LongName], F_FunctionName AS [Function],  F_Position AS [Position], F_Comment AS [DSQ], F_Order AS [Order], F_MemberID, F_StartupNum FROM #Tmp_Table ORDER BY F_Order, F_ShirtNumber
  
  DELETE #Tmp_Table
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO





