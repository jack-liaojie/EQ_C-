
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetMatchOfficials]    Script Date: 10/15/2010 11:35:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetMatchOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetMatchOfficials]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetMatchOfficials]    Script Date: 10/15/2010 11:35:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_Report_BD_GetMatchOfficials]
----功		  能：得到一个Match下的裁判员信息
----作		  者：张翠霞
----日		  期: 2010-07-16
----修 改 记  录：
/*
                   2011-3-17    李燕   增加团体赛中每个小场的比赛
*/ 


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetMatchOfficials]
	                               @MatchID         INT,
                                   @LanguageCode    CHAR(3)                              
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
               
	CREATE TABLE #table_tmp(
	                           F_MatchID                            INT,
	                           F_FatherSplitID                      INT,
                               UM_Long_Print_Name                   NVARCHAR(100),
                               UM_Short_Print_Name                  NVARCHAR(50),
                               UM_NOC                               NVARCHAR(10),
                               SVG_Long_Print_Name                  NVARCHAR(100),
                               SVG_Short_Print_Name                 NVARCHAR(50),
                               SVG_NOC                              NVARCHAR(10),
                               UM_ID                                INT,
                               SVG_ID                               INT,
                           )
	
	IF @MatchType = 3
	BEGIN
     INSERT INTO #table_tmp (F_MatchID, F_FatherSplitID) 
            SELECT F_MatchID, F_MatchSplitID
               FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
     
     UPDATE #table_tmp SET UM_ID = B.F_RegisterID, SVG_Long_Print_Name = D.F_PrintLongName, UM_Short_Print_Name = D.F_PrintLongName,  UM_NOC =  F.F_DelegationCode
         FROM #table_tmp AS A 
             LEFT JOIN TS_Match_Split_Servant AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID 
             LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
             LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
             LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
             LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
         WHERE C.F_FunctionCode = 'UM' 
       

         
     UPDATE #table_tmp SET SVG_ID = B.F_RegisterID, UM_Long_Print_Name = D.F_PrintLongName, SVG_Short_Print_Name = D.F_PrintLongName,  SVG_NOC =  F.F_DelegationCode
         FROM #table_tmp AS A 
             LEFT JOIN TS_Match_Split_Servant AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherSplitID = B.F_MatchSplitID 
             LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
             LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
             LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
             LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
         WHERE C.F_FunctionCode = 'SVJ' 
         
    END
    ELSE
    BEGIN
		
		INSERT INTO #table_tmp (F_MatchID, F_FatherSplitID) VALUES(@MatchID , 0)
		
		UPDATE #table_tmp SET UM_ID = B.F_RegisterID, SVG_Long_Print_Name = D.F_PrintLongName, UM_Short_Print_Name = D.F_PrintLongName,  UM_NOC =  F.F_DelegationCode
         FROM #table_tmp AS A 
             LEFT JOIN TS_Match_Servant AS B ON A.F_MatchID = B.F_MatchID
             LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
             LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
             LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
             LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
         WHERE C.F_FunctionCode = 'UM' 
         
         UPDATE #table_tmp SET SVG_ID = B.F_RegisterID, UM_Long_Print_Name = D.F_PrintLongName, SVG_Short_Print_Name = D.F_PrintLongName,  SVG_NOC =  F.F_DelegationCode
         FROM #table_tmp AS A 
             LEFT JOIN TS_Match_Servant AS B ON A.F_MatchID = B.F_MatchID 
             LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID
             LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
             LEFT JOIN TR_Register AS E ON B.F_RegisterID = E.F_RegisterID
             LEFT JOIN TC_Delegation AS F ON E.F_DelegationID = F.F_DelegationID
         WHERE C.F_FunctionCode = 'SVJ' 
		
    END  
    
    
	SELECT * FROM #table_tmp

SET NOCOUNT OFF
END



GO

