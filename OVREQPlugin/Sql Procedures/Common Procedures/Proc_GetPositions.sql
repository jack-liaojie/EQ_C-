IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPositions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPositions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetPositions]
--��    ��: ��ȡָ����Ŀ���е� Position ������Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��25��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetPositions]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT b.F_PositionLongName AS [Long Name]
		, b.F_PositionShortName AS [Short Name]
		, a.F_PositionID AS [ID]
	FROM TD_Position a
	LEFT JOIN TD_Position_Des b
		ON a.F_PositionID = b.F_PositionID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_DisciplineID = @DisciplineID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetPositions] 3, 'CHN'
--exec [Proc_GetPositions] 3, 'GRE'