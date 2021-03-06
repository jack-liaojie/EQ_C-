IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetEventReferee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetEventReferee]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BD_GetEventReferee]
--描    述：得到Match下可选的裁判信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月06日


CREATE PROCEDURE [dbo].[Proc_BD_GetEventReferee](
												@MatchID		    INT,
												@MatchSplitID       INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @MatchType INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
    
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_Delegation      NVARCHAR(20),
                                F_FunctionDes     NVARCHAR(50),
                                F_FunctionID   INT
							)

    DECLARE @EventID INT
    SELECT @EventID = B.F_EventID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

	IF @MatchSplitID = -1
	BEGIN
		SET @MatchType = 1
	END
    IF @MatchType = 3
    BEGIN
        INSERT INTO #Tmp_Table (F_RegisterID, F_Delegation, F_FunctionDes, F_FunctionID)
        SELECT A.F_RegisterID, C.F_DelegationCode, E.F_FunctionShortName, D.F_FunctionID
        FROM TR_Inscription AS A 
        LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID 
        LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
        LEFT JOIN TD_Function AS D ON D.F_FunctionID = B.F_FunctionID
        LEFT JOIN TD_Function_Des AS E ON E.F_FunctionID = D.F_FunctionID AND E.F_LanguageCode = 'ENG'
		WHERE A.F_EventID = @EventID AND B.F_RegTypeID = 4 AND A.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Split_Servant WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_RegisterID IS NOT NULL)
    END
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_RegisterID, F_Delegation, F_FunctionDes, F_FunctionID)
		SELECT A.F_RegisterID, C.F_DelegationCode, E.F_FunctionShortName, D.F_FunctionID
		FROM TR_Inscription AS A 
		LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID 
		LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
		LEFT JOIN TD_Function AS D ON D.F_FunctionID = B.F_FunctionID
        LEFT JOIN TD_Function_Des AS E ON E.F_FunctionID = D.F_FunctionID AND E.F_LanguageCode = 'ENG'
		WHERE A.F_EventID = @EventID AND B.F_RegTypeID = 4 AND A.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL)
    END
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Delegation AS [Delegation], F_RegisterID, F_FunctionDes AS FunctionDes, F_FunctionID FROM #Tmp_Table ORDER BY LongName

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

