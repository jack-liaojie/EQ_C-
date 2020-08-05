IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_GetRegTypeList]
--��    �����õ�ע�������б�
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��05��30��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetRegTypeList](
											@LanguageCode	CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			INT
							)

	DECLARE @AllDes AS NVARCHAR(100)
	SET @AllDes = ' ȫ��'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' ȫ��'
	END
	ELSE
	BEGIN
		IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END
	END

	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (@AllDes, -1)
	INSERT INTO #Tmp_Table (F_Name, F_Key) SELECT B.F_RegTypeLongDescription, A.F_RegTypeID FROM
		TC_RegType AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode

	SELECT F_Name, F_Key FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

--exec [Proc_GetRegTypeList] 'CHN'
--exec [Proc_GetRegTypeList] 'ENG'