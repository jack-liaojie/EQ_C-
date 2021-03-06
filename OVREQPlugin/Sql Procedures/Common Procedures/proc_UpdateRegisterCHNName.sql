IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateRegisterCHNName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateRegisterCHNName]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：proc_UpdateRegisterCHNName
----功		  能：修改一个注册人员的姓名中文信息
----作		  者：李燕
----日		  期: 2010-09-19 


CREATE PROCEDURE [dbo].[proc_UpdateRegisterCHNName] 
	@RegisterID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	编辑Register失败，标示没有做任何操作！
					-- @Result>=1; 	编辑Register成功！
					-- @Result=-1; 	编辑Register失败，@RegisterID无效
					-- @Result=-2;  该Register没有英文名字，没有做任何操作！


	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	IF NOT EXISTS (SELECT F_RegisterID FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG')
	BEGIN
	    SET @Result = -2
	    RETURN
	END

    DECLARE @FirstName			NVARCHAR(50)
	DECLARE @LastName			NVARCHAR(50)
	DECLARE @LongName			NVARCHAR(100)
	DECLARE @ShortName			NVARCHAR(50)
	DECLARE @TvLongName			NVARCHAR(100)
	DECLARE @TvShortName		NVARCHAR(50)
	DECLARE @SBLongName			NVARCHAR(100)
	DECLARE @SBShortName		NVARCHAR(50)
	DECLARE @PrintLongName		NVARCHAR(100)
	DECLARE @PrintShortName		NVARCHAR(50)
    DECLARE @WNPAFirstName      NVARCHAR(50)
    DECLARE @WNPALastName       NVARCHAR(50)
    
    SELECT @FirstName = F_FirstName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @LastName = F_LastName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @LongName = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @ShortName = F_ShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @TvLongName = F_TvLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @TvShortName = F_TvShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @SBLongName = F_SBLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @SBShortName = F_SBShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @PrintLongName = F_PrintLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @PrintShortName = F_PrintShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @WNPAFirstName = F_WNPA_FirstName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    SELECT @WNPALastName = F_WNPA_LastName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'
    
    
    IF(@FirstName IS NULL OR @FirstName = '')
	BEGIN
		SELECT @FirstName = F_FirstName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@LastName IS NULL OR @LastName = '')
	BEGIN
		SELECT @LastName = F_LastName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@LongName IS NULL OR @LongName = '')
	BEGIN
		SELECT @LongName = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@ShortName IS NULL OR @ShortName = '')
	BEGIN
		SELECT @ShortName = F_ShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@TvLongName IS NULL OR @TvLongName = '')
	BEGIN
		SELECT @TvLongName = F_TvLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@TvShortName IS NULL OR @TvShortName = '')
	BEGIN
		SELECT @TvShortName = F_TvShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@SBLongName IS NULL OR @SBLongName = '')
	BEGIN
		SELECT @SBLongName = F_SBLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@SBShortName IS NULL OR @SBShortName = '')
	BEGIN
		SELECT @SBShortName = F_SBShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@PrintLongName IS NULL OR @PrintLongName = '')
	BEGIN
		SELECT @PrintLongName = F_PrintLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@PrintShortName IS NULL OR @PrintShortName = '')
	BEGIN
		SELECT @PrintShortName = F_PrintShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@WNPAFirstName IS NULL OR @WNPAFirstName = '')
	BEGIN
		SELECT @WNPAFirstName = F_WNPA_FirstName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END
	
	IF(@WNPALastName IS NULL OR @WNPALastName = '')
	BEGIN
		SELECT @WNPALastName = F_WNPA_LastName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'ENG'
	END 
		
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        IF NOT EXISTS (SELECT F_RegisterID FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN')
		BEGIN
			INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_FirstName, F_LastName, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName, F_WNPA_FirstName, F_WNPA_LastName)
				VALUES (@RegisterID, 'CHN', @FirstName, @LastName, @LongName, @ShortName, @TvLongName, @TvShortName, @SBLongName, @SBShortName, @PrintLongName, @PrintShortName, @WNPAFirstName, @WNPALastName)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TR_Register_Des SET  F_FirstName = @FirstName, F_LastName = @LastName, F_LongName= @LongName,
										F_ShortName = @ShortName, F_TvLongName = @TvLongName, F_TvShortName = @TvShortName,
										F_SBLongName = @SBLongName, F_SBShortName = @SBShortName, F_PrintLongName = @PrintLongName,
										F_PrintShortName = @PrintShortName, F_WNPA_FirstName = @WNPAFirstName, F_WNPA_LastName = @WNPALastName
					WHERE F_RegisterID = @RegisterID AND F_LanguageCode = 'CHN'

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

