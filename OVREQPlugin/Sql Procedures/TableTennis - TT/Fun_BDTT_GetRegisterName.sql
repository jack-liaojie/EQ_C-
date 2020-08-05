IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetRegisterName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetRegisterName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--王强：获取运动员姓名

CREATE FUNCTION [dbo].[Fun_BDTT_GetRegisterName]
								(
									@RegisterID INT,
									@Type INT,
									-- 11 SCBShortName
									-- 12 SCBLongName
									-- 21 PrintShortName
									-- 22 PrintLongName
									-- 31 TVShortName
									-- 32 TVLongName
									-- 41 LongName
									-- 42 ShortName
									@LanguageCode NVARCHAR(10),
									@LenLimit INT = 0
								)
RETURNS NVARCHAR(200)
AS
BEGIN

	DECLARE @RegName NVARCHAR(200)
	DECLARE @SCBSLen INT
	DECLARE @SCBLLen INT
	DECLARE @PSLEN INT
	DECLARE @PLLEN INT
	DECLARE @Diff1 INT
	DECLARE @Diff2 INT
	DECLARE @Diff3 INT
	DECLARE @Diff4 INT
	DECLARE @MinValue INT
	DECLARE @MaxValue INT
	DECLARE @FinalIndex INT
	DECLARE @MaxIndex INT = -1
	DECLARE @MinIndex INT = -1
	
	IF @Type = 11
		SELECT @RegName = F_SBShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 12
		SELECT @RegName = F_SBLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 21
		SELECT @RegName = F_PrintShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 22
		SELECT @RegName = F_PrintLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 31
		SELECT @RegName = F_TvShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 32
		SELECT @RegName = F_TvLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 41
		SELECT @RegName = F_ShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	ELSE IF @Type = 42
		SELECT @RegName = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode

	IF @LenLimit > 0 AND @Type IN (11,12,21,22)
	BEGIN
		SELECT @SCBSLen = LEN(F_SBShortName), @SCBLLen = LEN(F_SBLongName), @PSLEN = LEN(F_PrintShortName), @PLLEN = LEN(F_PrintLongName)
		FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		
		SET @Diff1 = @SCBSLEN - @LenLimit
		SET @Diff2 = @SCBLLEN - @LenLimit
		SET @Diff3 = @PSLEN - @LenLimit
		SET @Diff4 = @PLLEN - @LenLimit
		
		IF @Diff1 > 0
		BEGIN
			SET @MaxValue = @Diff1
			SET @MaxIndex = 1
		END
		ELSE
		BEGIN
			SET @MinValue = @Diff1
			SET @MinIndex = 1
		END
		
		IF @Diff2 > 0
		BEGIN
			IF @Diff2 < @MaxValue
			BEGIN
				SET @MaxValue = @Diff2
				SET @MaxIndex = 2	
			END
		END
		ELSE 
		BEGIN
			IF @Diff2 > @MinValue
			BEGIN
				SET @MinValue = @Diff2
				SET @MinIndex = 2
			END
		END
		
		IF @Diff3 > 0
		BEGIN
			IF @Diff3 < @MaxValue
			BEGIN
				SET @MaxValue = @Diff3
				SET @MaxIndex = 3
			END
		END
		ELSE 
		BEGIN
			IF @Diff3 > @MinValue
			BEGIN
				SET @MinValue = @Diff3
				SET @MinIndex = 3
			END
		END
		
		IF @Diff4 > 0
		BEGIN
			IF @Diff4 < @MaxValue
			BEGIN
				SET @MaxValue = @Diff4
				SET @MaxIndex = 4
			END
		END
		ELSE 
		BEGIN
			IF @Diff4 > @MinValue
			BEGIN
				SET @MinValue = @Diff4
				SET @MinIndex = 4
			END
		END
		
		IF @MinIndex != -1
			SET @FinalIndex = @MinIndex
		ELSE 
			SET @FinalIndex = @MaxIndex
		
		IF @FinalIndex = 1
			SELECT @RegName = F_SBShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		ELSE IF @FinalIndex = 2
			SELECT @RegName = F_SBLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		ELSE IF @FinalIndex = 3
			SELECT @RegName = F_PrintShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		ELSE IF @FinalIndex = 4
			SELECT @RegName = F_PrintLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	
	END
	ELSE IF @LenLimit > 0 AND @Type IN (31,32,41,42)
	BEGIN
		SELECT @SCBSLen = LEN(F_TvShortName), @SCBLLen = LEN(F_TvLongName), @PSLEN = LEN(F_ShortName), @PLLEN = LEN(F_LongName)
		FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		
		SET @Diff1 = @SCBSLEN - @LenLimit
		SET @Diff2 = @SCBLLEN - @LenLimit
		SET @Diff3 = @PSLEN - @LenLimit
		SET @Diff4 = @PLLEN - @LenLimit
		
		IF @Diff1 > 0
		BEGIN
			SET @MaxValue = @Diff1
			SET @MaxIndex = 1
		END
		ELSE
		BEGIN
			SET @MinValue = @Diff1
			SET @MinIndex = 1
		END
		
		IF @Diff2 > 0
		BEGIN
			IF @Diff2 < @MaxValue
			BEGIN
				SET @MaxValue = @Diff2
				SET @MaxIndex = 2	
			END
		END
		ELSE 
		BEGIN
			IF @Diff2 > @MinValue
			BEGIN
				SET @MinValue = @Diff2
				SET @MinIndex = 2
			END
		END
		
		IF @Diff3 > 0
		BEGIN
			IF @Diff3 < @MaxValue
			BEGIN
				SET @MaxValue = @Diff3
				SET @MaxIndex = 3
			END
		END
		ELSE 
		BEGIN
			IF @Diff3 > @MinValue
			BEGIN
				SET @MinValue = @Diff3
				SET @MinIndex = 3
			END
		END
		
		IF @Diff4 > 0
		BEGIN
			IF @Diff4 < @MaxValue
			BEGIN
				SET @MaxValue = @Diff4
				SET @MaxIndex = 4
			END
		END
		ELSE 
		BEGIN
			IF @Diff4 > @MinValue
			BEGIN
				SET @MinValue = @Diff4
				SET @MinIndex = 4
			END
		END
		
		IF @MinIndex != -1
			SET @FinalIndex = @MinIndex
		ELSE 
			SET @FinalIndex = @MaxIndex
		
		IF @FinalIndex = 1
			SELECT @RegName = F_TvShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		ELSE IF @FinalIndex = 2
			SELECT @RegName = F_TvLongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		ELSE IF @FinalIndex = 3
			SELECT @RegName = F_ShortName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
		ELSE IF @FinalIndex = 4
			SELECT @RegName = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode
	END
	
	RETURN @RegName
END



GO


