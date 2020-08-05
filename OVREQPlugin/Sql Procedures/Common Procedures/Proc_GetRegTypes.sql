IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetRegTypes]
--��    ��: ��ȡ���е�ע��������Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��25��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetRegTypes]
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT b.F_RegTypeLongDescription AS [Long Description]
		, b.F_RegTypeShortDescription AS [Short Description]
		, a.F_RegTypeID AS [ID]
	FROM TC_RegType a
	LEFT JOIN TC_RegType_Des b
		ON a.F_RegTypeID = b.F_RegTypeID AND b.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetRegTypes] 'CHN'
--exec [Proc_GetRegTypes] 'GRE'