IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeListForEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeListForEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_GetRegTypeListForEvent]
--��    �����õ�һ��Event���ܵĲ�����Ա����
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��05��12��

CREATE PROCEDURE [dbo].[Proc_GetRegTypeListForEvent](
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_RegType(
								F_RegTypeID							INT,
								F_RegTypeLongDescription			NVARCHAR(100)
							)

	INSERT INTO #Tmp_RegType ( F_RegTypeLongDescription, F_RegTypeID ) SELECT B.F_RegTypeLongDescription, A.F_RegTypeID
		FROM TC_RegType AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID WHERE A.F_RegTypeID IN (1,2,3) AND B.F_LanguageCode = @LanguageCode
	
	SELECT F_RegTypeLongDescription, F_RegTypeID FROM #Tmp_RegType

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


