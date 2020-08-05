/****** Object:  StoredProcedure [dbo].[Proc_GetDelegationByID]    Script Date: 11/20/2009 16:07:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDelegationByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDelegationByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDelegationByID]    Script Date: 11/20/2009 16:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetDelegationByID]
--��    ��: ���� ID ��ȡһ�� Delegation ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: ����
--��    ��: 2009��11��20��



CREATE PROCEDURE [dbo].[Proc_GetDelegationByID]
	@DelegationID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Delegation AS A 
	left join TC_Delegation_Des AS B
		ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_DelegationID = @DelegationID

SET NOCOUNT OFF
END
