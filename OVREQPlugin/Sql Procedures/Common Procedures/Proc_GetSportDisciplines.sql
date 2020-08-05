IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetSportDisciplines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetSportDisciplines]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_GetSportDisciplines]
--��    �����õ����е�Sport�����е�Disciplines
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��08��13��

CREATE PROCEDURE [dbo].[Proc_GetSportDisciplines](
				 @SportID		INT,
				 @LanguageCode	CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_Active AS [Active],A.F_Order AS [Order],A.F_DisciplineCode AS [Code],
		B.F_DisciplineLongName AS [Long Name],B.F_DisciplineShortName AS [Short Name],
			A.F_DisciplineID AS [ID] 
				FROM TS_Discipline AS A left join TS_Discipline_Des AS B
					ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode=@LanguageCode
						WHERE F_SportID = @SportID
							ORDER BY [Order]

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_GetSportDisciplines] 1,'CHN'