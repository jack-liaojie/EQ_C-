IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_TE_GetMatchOfficial]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchOfficial](
												@MatchID		    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100)
							)

	INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
    SELECT F_RegisterID, F_FunctionID FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL ORDER BY F_ServantNum
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Function AS [Function], F_RegisterID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

