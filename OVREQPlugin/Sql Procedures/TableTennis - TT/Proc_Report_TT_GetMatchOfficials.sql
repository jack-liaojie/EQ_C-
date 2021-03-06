IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_GetMatchOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_GetMatchOfficials]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_TT_GetMatchOfficials]
----功		  能：得到一个Match下的裁判员信息
----作		  者：张翠霞
----日		  期: 2010-07-16


CREATE PROCEDURE [dbo].[Proc_Report_TT_GetMatchOfficials]
	                               @MatchID         INT,
                                   @LanguageCode    CHAR(3)                              
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
                               Official_Long_Print_Name             NVARCHAR(100),
                               Official_Short_Print_Name            NVARCHAR(50),
                               Official_NOC                         NVARCHAR(10),
                               Official_Position                    NVARCHAR(100)
                           )

    INSERT INTO #table_tmp(Official_Long_Print_Name, Official_Short_Print_Name, Official_NOC, Official_Position)
    SELECT C.F_PrintLongName, C.F_PrintShortName, dbo.Fun_BDTT_GetPlayerNOC(B.F_RegisterID), D.F_FunctionLongName
    FROM TS_Match_Servant AS A 
    LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function_Des AS D ON A.F_FunctionID = D.F_FunctionID AND D.F_LanguageCode = @LanguageCode
    WHERE A.F_MatchID = @MatchID ORDER BY A.F_Order
   

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END



GO

