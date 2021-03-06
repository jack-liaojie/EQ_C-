/****** Object:  StoredProcedure [dbo].[proc_AddDiscipline]    Script Date: 05/13/2008 14:42:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddDiscipline]
GO
/****** Object:  StoredProcedure [dbo].[proc_AddDiscipline]    Script Date: 05/13/2008 14:27:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：proc_AddDiscipline
----功		  能：添加一个Discipline，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09 

CREATE PROCEDURE [dbo].[proc_AddDiscipline] 
	@SportID				INT,
	@DisciplineCode			NVARCHAR(10),
	@Order					INT,
	@DisciplineInfo			NVARCHAR(50),
	@languageCode			CHAR(3),
	@DisciplineLongName		NVARCHAR(100),
	@DisciplineShortName	NVARCHAR(50),
	@DisciplineComment		NVARCHAR(100),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Discipline失败，标示没有做任何操作！
					-- @Result>=1; 	添加Discipline成功！此值即为DisciplineID
					-- @Result=-1; 	添加Discipline失败，@SportID无效
					-- @Result=-2;	添加Discipline失败，@DisciplineCode无效,或者@DisciplineCode与已有的冲突
	DECLARE @NewDisciplineID AS INT	

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

	IF EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode AND F_SportID = @SportID)
	BEGIN
		SET @Result = -2
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Discipline WHERE F_SportID = @SportID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Discipline (F_SportID, F_DisciplineCode, F_Order, F_DisciplineInfo, F_Active)
			VALUES (@SportID, @DisciplineCode, @Order, @DisciplineInfo, 0)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewDisciplineID = @@IDENTITY

		insert into TS_Discipline_Des (F_DisciplineID, F_LanguageCode, F_DisciplineLongName, F_DisciplineShortName, F_DisciplineComment)
			VALUES (@NewDisciplineID, @languageCode, @DisciplineLongName, @DisciplineShortName, @DisciplineComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewDisciplineID
	RETURN

SET NOCOUNT OFF
END




