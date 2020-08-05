/****** Object:  StoredProcedure [dbo].[Proc_GetFederationByID]    Script Date: 11/20/2009 15:44:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFederationByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFederationByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetFederationByID]    Script Date: 11/20/2009 15:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetFederationByID]
--��    ��: ���� ID ��ȡһ�� Federation ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: ����
--��    ��: 2009��11��20��



CREATE PROCEDURE [dbo].[Proc_GetFederationByID]
	@FederationID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Federation AS A 
	left join TC_Federation_Des AS B
		ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_FederationID = @FederationID

SET NOCOUNT OFF
END
