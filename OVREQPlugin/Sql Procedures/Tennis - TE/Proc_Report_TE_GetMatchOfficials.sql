IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchOfficials]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_TE_GetMatchOfficials]
----功		  能：得到一个Match下的裁判员信息
----作		  者：张翠霞
----日		  期: 2010-03-17
/*
                 2011-03-05     李燕      更改Official的职责
*/

CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMatchOfficials]
	                               @MatchID         INT,
                                   @LanguageCode    CHAR(3)                              
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
                               Official_Long_TV_Name             NVARCHAR(100),
                               Official_Short_TV_Name            NVARCHAR(50),
                               Official_NOC                      NVARCHAR(10),
                               Official_Position                 NVARCHAR(100)
                           )

    INSERT INTO #table_tmp(Official_Long_TV_Name, Official_Short_TV_Name, Official_NOC, Official_Position)
    SELECT C.F_PrintLongName, C.F_PrintShortName, B.F_NOC, D.F_FunctionLongName
    FROM TS_Match_Servant AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS E ON A.F_FunctionID = E.F_FunctionID
    LEFT JOIN TD_Function_Des AS D ON E.F_FunctionID = D.F_FunctionID AND D.F_LanguageCode = @LanguageCode
    WHERE A.F_MatchID = @MatchID  AND E.F_FunctionCode = 'UR'

	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END


