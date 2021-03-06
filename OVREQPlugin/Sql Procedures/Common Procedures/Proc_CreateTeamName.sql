/****** Object:  StoredProcedure [dbo].[Proc_CreateTeamName]    Script Date: 11/19/2009 13:23:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CreateTeamName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CreateTeamName]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CreateTeamName]    Script Date: 11/19/2009 13:23:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_CreateTeamName]
----功		  能：生成队伍的名字
----作		  者：李燕
----日		  期: 2009-08-17 

CREATE PROCEDURE [dbo].[Proc_CreateTeamName](
                                         @GroupType       int,   ----1:Federation, 2:NOC, 3:Club
                                         @GroupID         NVARCHAR(9),
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

    IF(@GroupType = 1)
    BEGIN
      SELECT F_FederationShortName AS TeamShortName FROM TC_Federation_Des WHERE F_FederationID = CAST(@GroupID AS INT) AND F_LanguageCode = @LanguageCode
    END
    ELSE IF(@GroupType = 2)
    BEGIN
       SELECT F_CountryShortName AS TeamShortName FROM TC_Country_Des WHERE F_NOC = @GroupID AND F_LanguageCode = @LanguageCode
    END
    ELSE IF(@GroupType = 3)
    BEGIN
       SELECT F_ClubShortName AS TeamShortName FROM TC_Club_Des WHERE F_ClubID = CAST(@GroupID AS INT) AND F_LanguageCode = @LanguageCode
    END
    ELSE IF(@GroupType = 4)
    BEGIN
       SELECT F_DelegationShortName AS TeamShortName FROM TC_Delegation_Des WHERE F_DelegationID = CAST(@GroupID AS INT) AND F_LanguageCode = @LanguageCode
    END

Set NOCOUNT OFF
End	

SET QUOTED_IDENTIFIER OFF
