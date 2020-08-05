if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_EditDiscipline]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_EditDiscipline]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[proc_EditDiscipline]
----功		  能：添加一个Discipline，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09 

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

	SET @Result=0;  -- @Result = 0; 	编辑Discipline失败，标示没有做任何操作！
					-- @Result = 1; 	编辑Discipline成功！
					-- @Result = -1; 	编辑Discipline失败，@SportID无效
					-- @Result = -2; 	编辑Discipline失败！@DisciplineCode无效,或者@DisciplineCode与已有的冲突


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
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Discipline SET F_SportID = @SportID, F_DisciplineCode = @DisciplineCode, F_Order = @Order, F_DisciplineInfo = @DisciplineInfo
			WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		IF NOT EXISTS (SELECT F_DisciplineID FROM TS_Discipline_Des WHERE F_DisciplineID = @DisciplineID AND F_LanguageCode = @languageCode)
		BEGIN
			insert into TS_Discipline_Des (F_DisciplineID, F_LanguageCode, F_DisciplineLongName, F_DisciplineShortName, F_DisciplineComment)
				VALUES (@DisciplineID, @languageCode, @DisciplineLongName, @DisciplineShortName, @DisciplineComment)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Discipline_Des SET F_DisciplineLongName = @DisciplineLongName, F_DisciplineShortName = @DisciplineShortName, F_DisciplineComment = @DisciplineComment
				WHERE F_DisciplineID = @DisciplineID AND F_LanguageCode = @languageCode
		
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

