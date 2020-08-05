IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_AddDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_AddDiscipline]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Prepare_AddDiscipline]
--��    ��: ׼����������: ����һ�� Discipline.
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2010��9��14�� ���ڶ�
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_AddDiscipline]
	@SportCode							NVARCHAR(100),
	@DisciplineCode						CHAR(2),
	@Order								INT,
	@EngLongName						NVARCHAR(100),
	@EngShortName						NVARCHAR(100),
	@ChnLongName						NVARCHAR(100),
	@ChnShortName						NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SportID					INT
	DECLARE @DisciplineID				INT

	SELECT @SportID = S.F_SportID
	FROM TS_Sport AS S
	WHERE S.F_SportCode = @SportCode
	
	IF @SportID IS NULL
	BEGIN
		RETURN
	END
	
	SELECT @DisciplineID = D.F_DisciplineID
	FROM TS_Discipline AS D
	WHERE D.F_SportID = @SportID AND D.F_DisciplineCode = @DisciplineCode
	
	-- ���ڴ� DisciplineCode, ���������
	IF @DisciplineID IS NOT NULL
	BEGIN
		UPDATE TS_Discipline
		SET F_Order = @Order
		WHERE F_DisciplineID = @DisciplineID
		
		UPDATE TS_Discipline_Des
		SET F_DisciplineLongName = @EngLongName, F_DisciplineShortName = @EngShortName
		WHERE F_DisciplineID = @DisciplineID AND F_LanguageCode = 'ENG'
		
		UPDATE TS_Discipline_Des
		SET F_DisciplineLongName = @ChnLongName, F_DisciplineShortName = @ChnShortName
		WHERE F_DisciplineID = @DisciplineID AND F_LanguageCode = 'CHN'
	END
	-- �����ڴ� DisciplineCode, �����.
	ELSE
	BEGIN
		INSERT TS_Discipline (F_SportID, F_DisciplineCode, F_Order, F_Active) VALUES (@SportID, @DisciplineCode, @Order, 0)
		SET @DisciplineID = @@IDENTITY
		INSERT TS_Discipline_Des (F_DisciplineID, F_LanguageCode, F_DisciplineLongName, F_DisciplineShortName)
			VALUES (@DisciplineID, 'ENG', @EngLongName, @EngShortName)
		INSERT TS_Discipline_Des (F_DisciplineID, F_LanguageCode, F_DisciplineLongName, F_DisciplineShortName)
			VALUES (@DisciplineID, 'CHN', @ChnLongName, @ChnShortName)
	END
	
	-- ��������� Active = 1 �� Discipline, �򽫴� Discipline �� Active ��Ϊ 1
	IF NOT EXISTS (SELECT F_DisciplineID FROM TS_Discipline WHERE F_Active = 1)
	BEGIN
		UPDATE TS_Discipline SET F_Active = 1 WHERE F_DisciplineID = @DisciplineID
	END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_AddDiscipline] N'AG16', 'KR', 5, N'Karate', N'Karate', N'���ֵ�', N'���ֵ�'

*/