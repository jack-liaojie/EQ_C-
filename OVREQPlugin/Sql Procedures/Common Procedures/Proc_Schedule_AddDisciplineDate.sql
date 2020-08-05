IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_AddDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_AddDisciplineDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_AddDisciplineDate]
--��    ��: ���һ�������� (TS_DisciplineDate)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��11��10��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
			2010��6��23��		�����		�� DateOrder Ϊ NULL ʱ, �Զ���Ϊ���ֵ + 1.
			2010��6��24��		�����		���˴����ϴ��ڴ� Date ʱ, �����.
			2010��7��2��		�����		�����ڴ� Dateʱ, ���ز���Ϊ -1.
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_AddDisciplineDate]
	@DisciplineID					INT,
	@DateOrder						INT,
	@Date							NVARCHAR(50),
	@DateLongDescription			NVARCHAR(100),
	@DateShortDescription			NVARCHAR(50),
	@DateComment					NVARCHAR(100),
	@LanguageCode					CHAR(3),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = -1;	���ڴ� Dateʱ
					  -- @Result = 0; 	���ʧ�ܣ���ʾû�����κβ�����
					  -- @Result >= 1; 	��ӳɹ�����ֵ��Ϊ DisciplineDateID
					  
	-- ������ڴ� Date, �����
	IF EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineID = @DisciplineID AND DATEDIFF(DAY, @Date, F_Date) = 0)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @NewDisciplineDateID AS INT

    IF EXISTS(SELECT F_DisciplineDateID FROM TS_DisciplineDate)
	BEGIN
      SELECT @NewDisciplineDateID = MAX(F_DisciplineDateID) FROM TS_DisciplineDate
      SET @NewDisciplineDateID = @NewDisciplineDateID + 1
	END
	ELSE
	BEGIN
		SET @NewDisciplineDateID = 1
	END
	
	IF @DateOrder = 0 OR @DateOrder IS NULL
	BEGIN
		SELECT @DateOrder = (CASE WHEN MAX(F_DateOrder) IS NULL THEN 0 ELSE MAX(F_DateOrder) END) + 1 FROM TS_DisciplineDate WHERE F_DisciplineID = @DisciplineID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_DisciplineDate 
			(F_DisciplineDateID, F_DisciplineID, F_DateOrder, F_Date) 
		VALUES
			(@NewDisciplineDateID, @DisciplineID, @DateOrder, @Date)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        INSERT INTO TS_DisciplineDate_Des 
			(F_DisciplineDateID, F_LanguageCode, F_DateLongDescription, F_DateShortDescription, F_DateComment) 
			VALUES
			(@NewDisciplineDateID, @LanguageCode, @DateLongDescription, @DateShortDescription, @DateComment)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = @NewDisciplineDateID
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for Test
DECLARE @TestResult INT

-- Add right
exec [Proc_Schedule_AddDisciplineDate]  1, 2, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @TestResult
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @TestResult

-- Delete that added for test
DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @TestResult
DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @TestResult

*/