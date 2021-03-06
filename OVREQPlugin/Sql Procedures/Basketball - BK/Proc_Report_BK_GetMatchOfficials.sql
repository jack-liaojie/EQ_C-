IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetMatchOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetMatchOfficials]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_BK_GetMatchOfficials]
----功		  能：得到一个Match下的裁判员信息
----作		  者：李燕
----日		  期: 2010-03-22


CREATE PROCEDURE [dbo].[Proc_Report_BK_GetMatchOfficials]
	                               @MatchID         INT,
                                   @LanguageCode    CHAR(3)                              
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
                            Referee               NVARCHAR(200),
							Umpire1                NVARCHAR(200),
							Umpire2                NVARCHAR(200),
                           )

     CREATE TABLE #temp_RowNumber
                  (
                    F_MatchID          INT,
                    F_PrintShortName    NVARCHAR(100),
                    F_NOC              NVARCHAR(50),
                    F_RowNumber        INT,
                 )
    
    INSERT INTO #temp_RowNumber(F_MatchID, F_PrintShortName, F_NOC, F_RowNumber)
           SELECT A.F_MatchID, D.F_PrintShortName, C.F_NOC, Row_Number() Over( Order By A.F_Order ,D.F_PrintShortName)
           FROM TS_Match_Servant AS A LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID 
                LEFT JOIN TR_Register_Des AS D ON C.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode 
                LEFT JOIN TD_Function AS E ON A.F_FunctionID = E.F_FunctionID 
                  WHERE E.F_FunctionCode = 'RE' AND A.F_MatchID = @MatchID

    INSERT INTO #table_tmp(Referee) 
        SELECT F_PrintShortName  + (CASE WHEN  F_NOC IS NULL THEN '' ELSE ' (' + F_NOC +')' END ) FROM #temp_RowNumber WHERE F_RowNumber = 1
    
    DELETE FROM #temp_RowNumber
   
   INSERT INTO #temp_RowNumber(F_MatchID, F_PrintShortName, F_NOC, F_RowNumber)
           SELECT A.F_MatchID, D.F_PrintShortName, C.F_NOC, Row_Number() Over( Order By A.F_Order,  D.F_PrintShortName)
           FROM TS_Match_Servant AS A LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID 
                LEFT JOIN TR_Register_Des AS D ON C.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode 
                LEFT JOIN TD_Function AS E ON A.F_FunctionID = E.F_FunctionID 
                  WHERE E.F_FunctionCode = 'UM' AND A.F_MatchID = @MatchID
 
    UPDATE #table_tmp SET Umpire1 = F_PrintShortName + (CASE WHEN  F_NOC IS NULL THEN '' ELSE ' (' + F_NOC +')' END ) FROM #temp_RowNumber WHERE F_RowNumber = 1
    UPDATE #table_tmp SET Umpire2 = F_PrintShortName + (CASE WHEN  F_NOC IS NULL THEN '' ELSE ' (' + F_NOC +')' END ) FROM #temp_RowNumber WHERE F_RowNumber = 2
   
	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END

GO

--select * from TS_Match_Servant where F_MatchID = 35