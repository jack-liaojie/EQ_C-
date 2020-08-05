IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLanguageByCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLanguageByCode]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetLanguageByCode]
--��    ��: ���� LanguageCode ��ȡһ�����Ե���Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_GetLanguageByCode]
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Language
	WHERE F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetLanguageByCode] 'ENG'