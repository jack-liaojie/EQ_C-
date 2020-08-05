/****** Object:  StoredProcedure [dbo].[Proc_GetEventListByDisciplineID]    Script Date: 09/18/2009 11:25:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetEventListByDisciplineCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetEventListByDisciplineCode]
GO
/****** Object:  StoredProcedure [dbo].[Proc_JU_GetEventListByDisciplineID]    Script Date: 09/18/2009 11:17:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--��    �ƣ�[Proc_JU_GetEventListByDisciplineCode]
--��    �����õ�Discipline�µ�Event�б�
--����˵���� 
--˵    ����
--�� �� �ˣ���˳��
--��    �ڣ�2011��05��13��
--�޸ļ�¼��
/*					
*/

CREATE PROCEDURE [dbo].[Proc_JU_GetEventListByDisciplineCode](
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	DECLARE @DisciplineID	INT
	SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_DisciplineCode = N'JU'
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
	INSERT INTO #Tmp_Table (F_Name, F_Key) SELECT B.F_EventLongName, A.F_EventID FROM
		TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
			WHERE A.F_DisciplineID = @DisciplineID ORDER BY A.F_Order

	SELECT F_Name, F_Key FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
