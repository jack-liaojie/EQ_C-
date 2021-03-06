/****** Object:  StoredProcedure [dbo].[Proc_GetActiveGroupInfo]    Script Date: 11/19/2009 11:05:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetActiveGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetActiveGroupInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetActiveGroupInfo]    Script Date: 11/19/2009 11:04:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetActiveGroupInfo]
----功		  能：得到所有的代表团信息
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetActiveGroupInfo](
                                         @DisciplineID    INT,
                                         @GroupType       INT,   ----1:Federation, 2:NOC, 3:Club
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON


   IF(@GroupType = 1)
   BEGIN
      SELECT A.F_FederationCode AS [Code], B.F_FederationLongName AS [LongName], A.F_FederationID AS [ID]
	     FROM TC_Federation AS A  
            LEFT JOIN TC_Federation_Des AS B ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
	        LEFT JOIN TS_ActiveFederation AS C ON A.F_FederationID = C.F_FederationID 
	      WHERE C.F_DisciplineID = @DisciplineID
   END
   ELSE IF(@GroupType = 2)
   BEGIN 
       SELECT A.F_NOC AS [Code], B.F_CountryLongName AS [LongName],A.F_NOC AS[ID]
          FROM TC_Country AS A  
            LEFT JOIN TC_Country_Des AS B ON A.F_NOC = B.F_NOC AND B.F_LanguageCode = @LanguageCode
            LEFT JOIN TS_ActiveNOC AS C ON A.F_NOC = C.F_NOC
            WHERE C.F_DisciplineID = @DisciplineID
   END
   ELSE IF(@GroupType = 3)
   BEGIN
        SELECT A.F_ClubCode AS [Code], B.F_ClubLongName AS [LongName], A.F_ClubID AS [ID]
          FROM TC_Club AS A  
            LEFT JOIN TC_Club_Des AS B ON A.F_ClubID = B.F_ClubID AND B.F_LanguageCode = @LanguageCode
            LEFT JOIN TS_ActiveClub AS C ON A.F_ClubID = C.F_ClubID 
            WHERE C.F_DisciplineID = @DisciplineID
   END
   ELSE IF(@GroupType = 4)
   BEGIN
        SELECT A.F_DelegationCode AS [Code], B.F_DelegationLongName AS [LongName], A.F_DelegationType AS [Type], A.F_DelegationID AS [ID]
          FROM TC_Delegation AS A  
            LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode = @LanguageCode
            LEFT JOIN TS_ActiveDelegation AS C ON A.F_DelegationID = C.F_DelegationID 
            WHERE C.F_DisciplineID = @DisciplineID
   END
	

Set NOCOUNT OFF
End	


set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


