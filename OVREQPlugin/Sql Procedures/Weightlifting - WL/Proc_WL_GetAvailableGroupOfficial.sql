IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetAvailableGroupOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetAvailableGroupOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_WL_GetAvailableGroupOfficial]
--描    述：得到Match下可选的裁判信息
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年05月31日


CREATE PROCEDURE [dbo].[Proc_WL_GetAvailableGroupOfficial](
												@OfficialGroupID    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 


	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100),                               
                                F_PositionID      INT,
                                F_Position        NVARCHAR(100),                          
                                F_OfficialGroupID      INT,
                                F_OfficialGroup        NVARCHAR(100)
							)


    INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID)
           SELECT B.F_RegisterID, B.F_FunctionID FROM TR_Register AS B 
		   LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID= B.F_RegisterID
           WHERE (B.F_RegTypeID = 4 OR B.F_RegTypeID = 5) 
              AND GG.F_OfficialGroupID IS NULL
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A 
		LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Function AS [Function], F_RegisterID, F_FunctionID FROM #Tmp_Table
	ORDER BY F_FunctionID
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

/*
exec Proc_WL_GetAvailableGroupOfficial -1,'eng'
*/

