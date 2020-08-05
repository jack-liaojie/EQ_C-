IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_DelDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_DelDisciplineDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_DelDisciplineDate]
--��    ��: ɾ��һ�������� (TS_DisciplineDate)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��11��10��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
			2010��6��24��		�����		���˴���� TS_Session �� F_Date ��� Date ��ͬ, ������ɾ��, ���ؽ��Ϊ -2.
*/




CREATE PROCEDURE [dbo].[Proc_Schedule_DelDisciplineDate]
	@DisciplineDateID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ��, ��ʾû�����κβ���!
					  -- @Result = 1; 	ɾ���ɹ�!
					  -- @Result = -1;	ɾ��ʧ��, @DisciplineDateID ������!
					  -- @Result = -2;	ɾ��ʧ��, �� Date ���ѽ� Session.

	IF NOT EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF EXISTS (SELECT S.F_SessionID FROM TS_Session AS S, TS_DisciplineDate AS D 
		WHERE D.F_DisciplineDateID = @DisciplineDateID AND S.F_DisciplineID = D.F_DisciplineID AND DATEDIFF(day, D.F_Date, S.F_SessionDate) = 0 ) 
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- ɾ���ɹ�
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

-- Delete One DisciplineDate
exec [Proc_Schedule_DelDisciplineDate] @DisciplineDateID, @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID

*/