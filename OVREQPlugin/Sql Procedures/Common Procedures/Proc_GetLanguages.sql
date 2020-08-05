IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLanguages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLanguages]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetLanguages]
--��    ��: ��ȡ���е�������Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��25��



CREATE PROCEDURE [dbo].[Proc_GetLanguages]
AS
BEGIN
SET NOCOUNT ON

	SELECT F_Active AS [Active]
		, F_Order AS [Order]
		, F_LanguageCode AS [Code]
		, F_LanguageDescription AS [Description]
	FROM TC_Language
	ORDER by F_Order

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetLanguages]