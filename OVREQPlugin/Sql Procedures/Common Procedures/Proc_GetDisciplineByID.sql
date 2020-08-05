IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetDisciplineByID]
--��    ��: ���� DisciplineID ��ȡ Discipline
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��18��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetDisciplineByID]
	@DisciplineID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT * 
	FROM TS_Discipline AS A 
	LEFT JOIN TS_Discipline_Des AS B 
		ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode 
	WHERE A.F_DisciplineID = @DisciplineID
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetDisciplineByID] 45, 'CHN'
--exec [Proc_GetDisciplineByID] 45, 'ENG'