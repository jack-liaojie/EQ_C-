if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetOperatorsInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetOperatorsInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_GetOperatorsInfo]
----功		  能：得到操所者的信息
----作		  者：郑金勇 
----日		  期: 2009-08-06 

CREATE PROCEDURE [dbo].[Proc_GetOperatorsInfo]	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_PersonID, A.F_PersonLongName, A.F_PassWord, B.F_RoleID FROM TO_Person AS A LEFT JOIN TO_Person_Role AS B ON A.F_PersonID = B.F_PersonID
			
SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--exec Proc_GetOperatorsInfo