

/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchSplitMember]    Script Date: 08/30/2012 08:39:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetMatchSplitMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetMatchSplitMember]
GO


/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchSplitMember]    Script Date: 08/30/2012 08:39:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_HB_GetMatchSplitMember]
--描    述：得到Match下得队的运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_HB_GetMatchSplitMember](
												@MatchID		    INT,
                                                @TeamPos            INT,
                                                @MatchSplitID       INT,  
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
                                F_RegisterID    INT,
							)

   INSERT INTO #Tmp_Table(F_MemberID, F_FunctionID, F_ShirtNumber, F_PositionID, F_Order)
          SELECT B.F_RegisterID, B.F_FunctionID, B.F_ShirtNumber, B.F_PositionID, B.F_Order 
            FROM  TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Member AS B 
                 ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
           WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @MatchSplitID  AND B.F_CompetitionPosition = @TeamPos
  
   UPDATE #Tmp_Table SET F_RegisterID = A.F_RegisterID FROM TS_Match_Result AS A WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos
      
   UPDATE #Tmp_Table SET F_MemberName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
 
   UPDATE #Tmp_Table SET F_FunctionName = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
  
   UPDATE #Tmp_Table SET F_Position = B.F_PositionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode


  SELECT F_ShirtNumber AS [ShirtNumber], F_MemberName AS [LongName], F_FunctionName AS [Function],  F_Position AS [Position], F_Order AS [Order], F_MemberID FROM #Tmp_Table ORDER BY F_Order, F_ShirtNumber
  
  DELETE #Tmp_Table
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


