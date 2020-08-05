if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_EditDiscipline]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_EditDiscipline]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[proc_EditDiscipline]
----��		  �ܣ����һ��Discipline����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-09 

CREATE PROCEDURE [dbo].[proc_EditDiscipline] (
	@DisciplineID				INT,	
	@SportID					INT,
	@DisciplineCode				NVARCHAR(10),
	@Order						INT,
	@DisciplineInfo				NVARCHAR(50),
	@languageCode				CHAR(3),
	@DisciplineLongName			NVARCHAR(100),
	@DisciplineShortName		NVARCHAR(50),
	@DisciplineComment			NVARCHAR(100),
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	�༭Disciplineʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�༭Discipline�ɹ���
					-- @Result = -1; 	�༭Disciplineʧ�ܣ�@SportID��Ч
					-- @Result = -2; 	�༭Disciplineʧ�ܣ�@DisciplineCode��Ч,����@DisciplineCode�����еĳ�ͻ


	IF NOT EXISTS(SELECT F_SportID FROM TS_Sport WHERE F_SportID = @SportID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF ((@DisciplineCode IS NULL) OR (@DisciplineCode = ''))
	BEGIN
			SET @Result = -2
			RETURN
	END

	IF EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode AND F_DisciplineID != @DisciplineID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Discipline SET F_SportID = @SportID, F_DisciplineCode = @DisciplineCode, F_Order = @Order, F_DisciplineInfo = @DisciplineInfo
			WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		IF NOT EXISTS (SELECT F_DisciplineID FROM TS_Discipline_Des WHERE F_DisciplineID = @DisciplineID AND F_LanguageCode = @languageCode)
		BEGIN
			insert into TS_Discipline_Des (F_DisciplineID, F_LanguageCode, F_DisciplineLongName, F_DisciplineShortName, F_DisciplineComment)
				VALUES (@DisciplineID, @languageCode, @DisciplineLongName, @DisciplineShortName, @DisciplineComment)
			
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Discipline_Des SET F_DisciplineLongName = @DisciplineLongName, F_DisciplineShortName = @DisciplineShortName, F_DisciplineComment = @DisciplineComment
				WHERE F_DisciplineID = @DisciplineID AND F_LanguageCode = @languageCode
		
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

