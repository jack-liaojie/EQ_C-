IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_EditDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_EditDisciplineDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_EditDisciplineDate]
--��    ��: �޸�һ�������� (TS_DisciplineDate)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��11��10��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_EditDisciplineDate]
	@DisciplineDateID					INT,
	@DateOrder							INT,
	@Date								NVARCHAR(50),
	@DateLongDescription				NVARCHAR(100),
	@DateShortDescription				NVARCHAR(50),
	@DateComment						NVARCHAR(100),
	@LanguageCode						CHAR(3),
	@Result								INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	����ʧ�ܣ���ʾû�����κβ�����
					  -- @Result = 1; 	���³ɹ���
					  -- @Result = -1;	����ʧ�ܣ�@DisciplineDateID �����ڣ�

	IF NOT EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

	UPDATE TS_DisciplineDate
	SET F_DateOrder = @DateOrder, F_Date = @Date
	WHERE F_DisciplineDateID = @DisciplineDateID
		
	IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result = 0
		RETURN
	END

	-- Des �����и����Ե������͸���, û�������
	IF EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate_Des 
				WHERE F_DisciplineDateID = @DisciplineDateID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TS_DisciplineDate_Des 
		SET F_DateLongDescription = @DateLongDescription
			, F_DateShortDescription = @DateShortDescription
			, F_DateComment = @DateComment
		WHERE F_DisciplineDateID = @DisciplineDateID
			AND F_LanguageCode = @LanguageCode
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
		INSERT INTO TS_DisciplineDate_Des 
			(F_DisciplineDateID, F_LanguageCode, F_DateLongDescription, F_DateShortDescription, F_DateComment) 
			VALUES
			(@DisciplineDateID, @LanguageCode, @DateLongDescription, @DateShortDescription, @DateComment)
		
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END
	END

	COMMIT TRANSACTION --�ɹ��ύ����

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- ���³ɹ�
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
DECLARE @DisciplineDateID INT
DECLARE @TestResult INT

-- Add one DisciplineDate
exec [Proc_Schedule_AddDisciplineDate]  1, 2, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SET @DisciplineDateID = @TestResult
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID

-- Update One DisciplineDate
exec [Proc_Schedule_EditDisciplineDate] @DisciplineDateID, 2, '2009-09-27', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
exec [Proc_Schedule_EditDisciplineDate] @DisciplineDateID, 2, '2009-09-27', '�ڶ���', '�ڶ���', '�ڶ���', 'CHN', @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
SELECT @TestResult AS [RESULT 1]

-- Update, @DisciplineDateID ������
SET @DisciplineDateID = @DisciplineDateID + 1
exec [Proc_Schedule_EditDisciplineDate] @DisciplineDateID, 3, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
SELECT @TestResult AS [RESULT -1]

-- Delete that added for test
SET @DisciplineDateID = @DisciplineDateID - 1
DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID

*/