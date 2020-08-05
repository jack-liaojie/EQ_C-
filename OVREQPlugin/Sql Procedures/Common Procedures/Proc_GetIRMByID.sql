IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetIRMByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetIRMByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetIRMByID]
--��    ��: ���� IRMID ��ȡһ�� IRM ���͵���Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������, ���� Order			
*/



CREATE PROCEDURE [dbo].[Proc_GetIRMByID]
	@LanguageCode				CHAR(3),
	@IRMID						INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_IRM a
	LEFT JOIN TC_IRM_Des b
		ON a.F_IRMID = b.F_IRMID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_IRMID = @IRMID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetIRMByID] 'CHN', 1
--exec [Proc_GetIRMByID] 'ENG', 1