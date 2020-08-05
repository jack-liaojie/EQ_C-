IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_AddDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_AddDisciplineDate]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Prepare_AddDisciplineDate]
--��    ��: ׼�������������һ��������.
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2010��9��14�� ���ڶ�
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_AddDisciplineDate]
	@DisciplineID						INT,
	@Order								INT,
	@Date								DateTime,
	@EngLongDescription					NVARCHAR(200),
	@EngShortDescription				NVARCHAR(100),
	@EngComment							NVARCHAR(200),
	@ChnLongDescription					NVARCHAR(200),
	@ChnShortDescription				NVARCHAR(100),
	@ChnComment							NVARCHAR(200)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineDateID			INT
	
	SELECT @DisciplineDateID = MAX(DD.F_DisciplineDateID) + 1 FROM TS_DisciplineDate AS DD
	IF @DisciplineDateID IS NULL SET @DisciplineDateID = 1 
	
	INSERT INTO TS_DisciplineDate
	(F_DisciplineDateID, F_DisciplineID, F_DateOrder, F_Date)
	VALUES
	(@DisciplineDateID, @DisciplineID, @Order, @Date)
	
	INSERT INTO TS_DisciplineDate_Des
	(F_DisciplineDateID, F_LanguageCode, F_DateLongDescription, F_DateShortDescription, F_DateComment)
	VALUES
	(@DisciplineDateID, 'ENG', @EngLongDescription, @EngShortDescription, @EngComment)
	
	INSERT INTO TS_DisciplineDate_Des
	(F_DisciplineDateID, F_LanguageCode, F_DateLongDescription, F_DateShortDescription, F_DateComment)
	VALUES
	(@DisciplineDateID, 'CHN', @ChnLongDescription, @ChnShortDescription, @ChnComment)

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_AddDisciplineDate] 76, 1, '2011-08-18', N'Day 1', N'Day 1', N'Day 1', N'��1��', N'��1��', N'��1��'

*/