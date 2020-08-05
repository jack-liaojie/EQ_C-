
/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineDateList]    Script Date: 04/25/2011 13:41:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineDateList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineDateList]
GO


/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineDateList]    Script Date: 04/25/2011 13:41:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    �ƣ�[Proc_GetDisciplineDateList]
--��    �����õ�һ��Discipline����ı��������б�
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2011��04��25��
--�޸ļ�¼��


CREATE PROCEDURE [dbo].[Proc_GetDisciplineDateList](
				 @DisciplineCode	CHAR(2)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineID AS INT
	
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	
	CREATE TABLE #Tmp_Dates(
								F_Date			NVARCHAR(100),
								F_Order			INT
							)

	DECLARE @AllDes AS NVARCHAR(50)
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

	INSERT INTO #Tmp_Dates (F_Date) VALUES (@AllDes)
	
	INSERT INTO #Tmp_Dates (F_Date)
	  SELECT DISTINCT LEFT(CONVERT (NVARCHAR(100), F_MatchDate, 120), 10) 
	  FROM TS_Match WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID IN (SELECT F_EventID FROM TS_Event WHERE @DisciplineID = F_DisciplineID))

	DELETE FROM #Tmp_Dates WHERE F_Date IS NULL
	SELECT DISTINCT F_Date FROM #Tmp_Dates ORDER BY  F_Date

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


