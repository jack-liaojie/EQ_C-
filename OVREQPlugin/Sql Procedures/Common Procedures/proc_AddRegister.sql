IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddRegister]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_AddRegister
----功		  能：添加一个注册人员，为基础信息维护服务
----作		  者：郑金勇 
----日		  期: 2009-04-13 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月08日		邓年彩		添加时添加 Bib 号
			2009-05-04			郑金勇		校验RegisterCode是否重复
*/

CREATE PROCEDURE [dbo].[proc_AddRegister] 
	@DisciplineID		INT,
	@RegTypeID			INT,
	@RegisterCode		NVARCHAR(20),
	@NOC				CHAR(3),
	@ClubID				INT,
	@FederationID		INT,
	@SexCode			INT,
	@BirthDate			DATETIME,
	@Height				DECIMAL(9,2),
	@Weight				DECIMAL(9,2),
	@NationID			INT,
	@languageCode		CHAR(3),
	@FirstName			NVARCHAR(50),
	@LastName			NVARCHAR(50),
	@LongName			NVARCHAR(100),
	@ShortName			NVARCHAR(50),
	@TvLongName			NVARCHAR(100),
	@TvShortName		NVARCHAR(50),
	@SBLongName			NVARCHAR(100),
	@SBShortName		NVARCHAR(50),
	@PrintLongName		NVARCHAR(100),
	@PrintShortName		NVARCHAR(50),
	@Bib				NVARCHAR(20),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Register失败，标示没有做任何操作！
					-- @Result>=1; 	添加Register成功！此值即为RegisterID
					-- @Result=-1; 	添加Register失败，@DisciplineID无效
					-- @Result=-2; 	添加Register失败，@RegTypeID无效
					-- @Result=-3; 	添加RegisterCode重复
	DECLARE @NewRegisterID AS INT	

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT EXISTS(SELECT F_RegTypeID FROM TC_RegType WHERE F_RegTypeID = @RegTypeID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterCode = @RegisterCode)
	BEGIN
		SET @Result = -3
		RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Register (F_DisciplineID, F_RegTypeID, F_RegisterCode, F_NOC, F_ClubID, F_FederationID, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_NationID, F_Bib)
			VALUES (@DisciplineID, @RegTypeID, @RegisterCode, @NOC, @ClubID, @FederationID, @SexCode, @BirthDate, (CASE WHEN @Height < 1 THEN NULL ELSE @Height END), (CASE WHEN @Weight < 1 THEN NULL ELSE @Weight END), @NationID, @Bib)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewRegisterID = @@IDENTITY

		insert into TR_Register_Des (F_RegisterID, F_LanguageCode, F_FirstName, F_LastName, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName)
			VALUES (@NewRegisterID, @languageCode, @FirstName, @LastName, @LongName, @ShortName, @TvLongName, @TvShortName, @SBLongName, @SBShortName, @PrintLongName, @PrintShortName)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewRegisterID
	RETURN

SET NOCOUNT OFF
END

