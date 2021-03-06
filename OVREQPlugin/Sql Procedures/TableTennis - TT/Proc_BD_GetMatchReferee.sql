IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetMatchReferee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetMatchReferee]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_GetMatchReferee]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月06日
--修改：王强2011-03-17


CREATE PROCEDURE [dbo].[Proc_BD_GetMatchReferee](
												@MatchID		    INT,
												@MatchSplitID       INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100),
                                F_NOC             NVARCHAR(10),
							)
							
	DECLARE @MatchType INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
    
    IF @MatchSplitID = -1
    BEGIN
		SET @MatchType = 1
    END

	IF @MatchType = 3
    BEGIN
        INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
		SELECT F_RegisterID, F_FunctionID FROM TS_Match_Split_Servant WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_RegisterID IS NOT NULL ORDER BY (CASE WHEN F_Order IS NULL THEN 1 ELSE 0 END), F_Order,  F_ServantNum
    END
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
		SELECT F_RegisterID, F_FunctionID FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL ORDER BY (CASE WHEN F_Order IS NULL THEN 1 ELSE 0 END), F_Order,  F_ServantNum
    END
       
    UPDATE #Tmp_Table SET F_RegisterName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_NOC = B.F_NOC FROM #Tmp_Table AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
 
	SELECT F_RegisterName AS LongName, F_NOC AS [NOC], F_Function AS [Function], F_RegisterID FROM #Tmp_Table
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

