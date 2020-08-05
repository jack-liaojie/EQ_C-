IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetRegTypeByID]
--��    ��: ��ȡ RegTypeID ��ȡһ�� RegType ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetRegTypeByID]
	@LanguageCode				CHAR(3),
	@RegTypeID					INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_RegType a
	LEFT JOIN TC_RegType_Des b
		ON a.F_RegTypeID = b.F_RegTypeID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_RegTypeID = @RegTypeID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetRegtypeByID] 'CHN', 2
--exec [Proc_GetRegtypeByID] 'GRE', 2