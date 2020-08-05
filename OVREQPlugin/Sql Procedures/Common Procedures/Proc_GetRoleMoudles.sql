if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetRoleMoudles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetRoleMoudles]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_GetRoleMoudles]
----功		  能：得到当前角色所能操作的模块
----作		  者：郑金勇 
----日		  期: 2009-08-06 

CREATE PROCEDURE [dbo].Proc_GetRoleMoudles (	
	@RoleID		AS CHAR(3)

)	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT F_ModuleID FROM TO_Role_Module WHERE F_RoleID = @RoleID

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--exec Proc_GetRoleMoudles 2