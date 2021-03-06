/****** Object:  StoredProcedure [dbo].[Proc_Register_GetGroupAllRegister]    Script Date: 11/19/2009 11:26:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Register_GetGroupAllRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Register_GetGroupAllRegister]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Register_GetGroupAllRegister]    Script Date: 11/19/2009 11:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Register_GetGroupAllRegister]
--描    述: 获取指定代表团的报名信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
			2009年09月08日		邓年彩		添加 Bib 号的显示	
            2009年09月18日      李燕        添加性别的显示	
            2009年09月18日      李燕        多增加一个参数，根据是否为运动员以及具体注册类型来查找	
*/



CREATE PROCEDURE [dbo].[Proc_Register_GetGroupAllRegister]
    @GroupType              INT,
	@GroupID			    NVARCHAR(9),
	@DisciplineID			INT,
    @AthleteID              INT,     --------0:所有人员，1:运动员， 2:非运动员
	@RegTypeID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
 
     IF(@GroupType = 1)
     BEGIN
         DECLARE @FederationID INT
         SET @FederationID = CAST(@GroupID AS INT)
         EXEC Proc_Register_GetFederationAllRegister @FederationID, @DisciplineID, @AthleteID, @RegTypeID, @LanguageCode
     END
     ELSE IF(@GroupType = 2)
     BEGIN
         EXEC Proc_Register_GetNOCAllRegister @GroupID, @DisciplineID, @AthleteID, @RegTypeID, @LanguageCode
     END
     ELSE IF(@GroupType = 3)
     BEGIN
         DECLARE @ClubID INT
         SET @ClubID = CAST(@GroupID AS INT)
         EXEC Proc_Register_GetClubAllRegister @ClubID, @DisciplineID, @AthleteID, @RegTypeID, @LanguageCode
     END
     ELSE IF(@GroupType = 4)
	 BEGIN
		 DECLARE @DelegationID INT
		 SET @DelegationID = CAST(@GroupID AS INT)
		 EXEC Proc_Register_GetDelegationAllRegister @DelegationID, @DisciplineID, @AthleteID, @RegTypeID, @LanguageCode
	 END

SET NOCOUNT OFF
END
