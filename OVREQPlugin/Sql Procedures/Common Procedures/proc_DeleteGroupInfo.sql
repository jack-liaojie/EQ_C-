/****** Object:  StoredProcedure [dbo].[proc_DeleteGroupInfo]    Script Date: 11/19/2009 09:12:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DeleteGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DeleteGroupInfo]
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteGroupInfo]    Script Date: 11/19/2009 09:11:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_DeleteGroupInfo]
----功		  能：删除Federation\Club\NOC\Delegation
----作		  者：李燕 
----日		  期: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_DeleteGroupInfo]
	@GroupID			    NVARCHAR(9),
    @GroupType              INT,    --- 1:Federation, 2:NOC, 3:Club, 4:Delegation
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Federation失败，标示没有做任何操作！
					  -- @Result=1; 	删除Federation成功！
					  -- @Result=-1;	删除Federation失败，@FederationID无效！
					  -- @Result=-2;	删除Federation失败，@FederationID被注册人员引用

  
    IF(@GroupType = 1)
    BEGIN
        DECLARE @FederationID INT
        SET @FederationID = CAST(@GroupID AS INT)
		EXEC proc_DeleteFederation @FederationID, @Result OUTPUT
        RETURN
     END
     ELSE IF(@GroupType = 2)
     BEGIN
        EXEC proc_DelCountry @GroupID, @Result OUTPUT
        RETURN
     END
     ELSE IF(@GroupType = 3)
     BEGIN
        DECLARE @ClubID INT
        SET @ClubID = CAST(@GroupID AS INT)

         EXEC proc_DelClub @ClubID, @Result OUTPUT
         RETURN
     END
     ELSE IF(@GroupType = 4)
     BEGIN
        DECLARE @DelegationID INT
        SET @DelegationID = CAST(@GroupID AS INT)

         EXEC proc_DeleteDelegation @DelegationID, @Result OUTPUT
         RETURN

     END

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END


