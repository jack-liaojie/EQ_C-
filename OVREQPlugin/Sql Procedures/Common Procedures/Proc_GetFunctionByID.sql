IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFunctionByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFunctionByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetFunctionByID]
--��    ��: ���� FunctionID ��ȡһ�� Function ���͵���Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetFunctionByID]
	@LanguageCode				CHAR(3),
	@FunctionID					INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TD_Function a
	LEFT JOIN TD_Function_Des b
		ON a.F_FunctionID = b.F_FunctionID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_FunctionID = @FunctionID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetFunctionByID] 'CHN', 3101
--exec [Proc_GetFunctionByID] 'GRE', 3101