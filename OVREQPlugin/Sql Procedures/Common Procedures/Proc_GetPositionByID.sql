IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPositionByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPositionByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetPositionByID]
--��    ��: ���� PositionID ��ȡһ�� Position ���͵���Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetPositionByID]
	@LanguageCode				CHAR(3),
	@PositionID					INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TD_Position a
	LEFT JOIN TD_Position_Des b
		ON a.F_PositionID = b.F_PositionID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_PositionID = @PositionID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetPositionByID] 'CHN', 3001
--exec [Proc_GetPositionByID] 'GRE', 3001