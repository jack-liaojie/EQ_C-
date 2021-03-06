IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_GetTeamAvailable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_GetTeamAvailable]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_BK_GetTeamAvailable]
--描    述：得到Match下得队的可选运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_BK_GetTeamAvailable](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @TeamPos            INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_MemberID      INT,
                                F_FunctionID    INT,
                                F_PositionID	INT,
                                F_MemberName    NVARCHAR(100),
                                F_FunctionName  NVARCHAR(50),
                                F_PositionName  NVARCHAR(50),
                                F_ShirtNumber   INT,
                                F_Comment       NVARCHAR(50),
                                F_DSQ           INT,    ----0,  无DSQ， 1, DSQ
							)

	INSERT INTO #Tmp_Table (F_MemberID, F_FunctionID,F_PositionID, F_ShirtNumber, F_Comment, F_DSQ)
    SELECT A.F_MemberRegisterID, A.F_FunctionID,A.F_PositionID, A.F_ShirtNumber, A.F_Comment, 0  
       FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID
            WHERE A.F_RegisterID = @RegisterID AND A.F_MemberRegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @TeamPos) AND B.F_RegTypeID = 1

    UPDATE #Tmp_Table SET F_DSQ = 1 FROM #Tmp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_Comment = CAST(B.F_IRMID AS NVARCHAR(50)) WHERE B.F_IRMCODE = 'DSQ' 
    
    UPDATE #Tmp_Table SET F_MemberName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_FunctionName = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
     UPDATE #Tmp_Table SET F_PositionName = B.F_PositionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode
	
    SELECT F_MemberID, F_FunctionID,F_PositionID, F_ShirtNumber AS [ShirtNumber], F_MemberName AS [LongName], F_FunctionName AS [Function],F_PositionName AS Position, F_DSQ AS [DSQ] FROM #Tmp_Table ORDER BY F_DSQ

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

