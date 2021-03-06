/****** Object:  StoredProcedure [dbo].[proc_AciveGroup]    Script Date: 11/19/2009 10:55:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AciveGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AciveGroup]
GO
/****** Object:  StoredProcedure [dbo].[proc_AciveGroup]    Script Date: 11/19/2009 10:54:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_AciveGroup]
----功		  能：激活Federation
----作		  者：郑金勇 
----日		  期: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_AciveGroup]
    @GroupType              INT,
	@GroupID			    NVARCHAR(9),
	@DisciplineID			INT,
	@ActiveType				INT, --1表示激活、0表示关闭
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Federation失败，标示没有做任何操作！
					  -- @Result=1; 	删除Federation成功！
					  -- @Result=-1;	删除Federation失败，@FederationID无效！
					  -- @Result=-2;	删除Federation失败，@FederationID被注册人员引用，不允许关闭

    IF(@GroupType = 1)
    BEGIN
        DECLARE @FederationID INT
        SET @FederationID =  CAST(@GroupID AS INT)
        EXEC proc_ActiveFederation @FederationID, @DisciplineID, @ActiveType, @Result OUTPUT
        RETURN
    END
    ELSE  IF(@GroupType = 2)
    BEGIN
          EXEC proc_ActiveNOC @GroupID, @DisciplineID, @ActiveType, @Result OUTPUT
        RETURN
    END
    ELSE IF(@GroupType = 3)
    BEGIN
        DECLARE @GlubID INT
        SET @GlubID =  CAST(@GroupID AS INT)
        EXEC proc_ActiveClub @GlubID, @DisciplineID, @ActiveType, @Result OUTPUT
        RETURN
    END
    ELSE IF(@GroupType = 4)
    BEGIN
        DECLARE @DelegationID INT
        SET @DelegationID =  CAST(@GroupID AS INT)
        EXEC proc_ActiveDelegation @DelegationID, @DisciplineID, @ActiveType, @Result OUTPUT
        RETURN
    END


SET NOCOUNT OFF
END
