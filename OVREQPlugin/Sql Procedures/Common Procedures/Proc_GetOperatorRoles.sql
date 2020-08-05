if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetOperatorRoles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetOperatorRoles]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_GetOperatorRoles]
----��		  �ܣ��õ������ߵ����н�ɫ
----��		  �ߣ�֣���� 
----��		  ��: 2009-08-06 

CREATE PROCEDURE [dbo].[Proc_GetOperatorRoles] (	
	@PersonID			AS INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @LanguageCode AS CHAR(3)

	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	SELECT A.F_PersonID, A.F_RoleID, B.F_LanguageCode, B.F_LongRoleName, B.F_ShortRoleName 
		FROM TO_Person_Role AS A LEFT JOIN TO_Role_Des AS B ON A.F_RoleID = B.F_RoleID WHERE A.F_PersonID = @PersonID AND B.F_LanguageCode = @LanguageCode 
			
SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--exec [Proc_GetOperatorRoles] -1, 'CHN'