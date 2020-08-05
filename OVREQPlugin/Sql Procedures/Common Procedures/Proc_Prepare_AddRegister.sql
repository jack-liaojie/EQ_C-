IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_AddRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_AddRegister]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Prepare_AddRegister]
--描    述: 准备运动员信息.
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年9月14日 星期二
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_AddRegister]
	@DisciplineCode						NVARCHAR(20),
	@RegTypeID							INT,
	@SexCode							INT,
	@RegisterCode						NVARCHAR(40),
	@Bib								NVARCHAR(40),
	@DelegationCode						NVARCHAR(20),
	@NOC								CHAR(3),
	@Birth_Date							DATETIME,
	@FamilyName							NVARCHAR(100),
	@GivenName							NVARCHAR(100),
	@Rank								INT,
	@i									INT OUT
AS
BEGIN
SET NOCOUNT ON

	SET @i = @i + 1

	DECLARE @DisciplineID				INT
	DECLARE @DelegationID				INT
	DECLARE @RegisterNum				NVARCHAR(40)
	DECLARE @RegisterID					INT
	DECLARE @CommentID					INT
	
	SET @DisciplineID = NULL
	SET @DelegationID = NULL
	
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	IF @DisciplineID IS NULL
	BEGIN
		SELECT CONVERT(NVARCHAR(10), @i) + '. DisciplineCode ''' + @DisciplineCode + ''' 不存在.' AS Result
		RETURN
	END

	SELECT @DelegationID = F_DelegationID FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode
	IF @DelegationID IS NULL
	BEGIN
		SELECT CONVERT(NVARCHAR(10), @i) + '. Delegation ''' + @DelegationCode + ''' 不存在.' AS Result
		RETURN
	END
	
	IF NOT EXISTS (SELECT * FROM TC_Country WHERE F_NOC = @NOC)
	BEGIN
		SELECT CONVERT(NVARCHAR(10), @i) + '. Courtry ''' + @NOC + ''' 不存在.' AS Result
		SET @NOC = NULL
	END
	
	-- Active Delegation, NOC
	IF NOT EXISTS (SELECT * FROM TS_ActiveDelegation WHERE F_DisciplineID = @DisciplineID AND F_DelegationID = @DelegationID)
	BEGIN
		INSERT TS_ActiveDelegation (F_DisciplineID, F_DelegationID) VALUES (@DisciplineID, @DelegationID)
	END
	IF @NOC IS NOT NULL AND NOT EXISTS (SELECT * FROM TS_ActiveNOC WHERE F_DisciplineID = @DisciplineID AND F_NOC = @NOC)
	BEGIN
		INSERT TS_ActiveNOC (F_DisciplineID, F_NOC) VALUES (@DisciplineID, @NOC)
	END
	
	SET @RegisterNum = @NOC + CONVERT(NVARCHAR(20), @Birth_Date, 112)
	
	INSERT INTO TR_Register
	(F_DisciplineID, F_RegTypeID, F_SexCode, F_RegisterCode, F_Bib, F_NOC, F_DelegationID, F_RegisterNum, F_Birth_Date)
	VALUES
	(@DisciplineID, @RegTypeID, @SexCode, @RegisterCode, @Bib, @NOC, @DelegationID, @RegisterNum, CAST(@Birth_Date AS DATETIME))
	
	SET @RegisterID = @@IDENTITY
	
	DECLARE @LongName NVARCHAR(200)
	DECLARE @ShortName NVARCHAR(200)
	SET @LongName = @FamilyName + N' ' + @GivenName
	SET @ShortName = @FamilyName
	
	INSERT INTO TR_Register_Des
	(F_RegisterID, F_LanguageCode, F_LastName, F_FirstName, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName, 
	F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName, F_WNPA_LastName, F_WNPA_FirstName)
	VALUES
	(@RegisterID, 'ENG', @FamilyName, @GivenName, @LongName, @ShortName, @LongName, @ShortName, 
	@LongName, @ShortName, @LongName, @ShortName, @FamilyName, @GivenName)
	
	SET @LongName = N'中' + @FamilyName + N' ' + @GivenName
	SET @ShortName = N'中' + @FamilyName
	SET @FamilyName = N'中' + @FamilyName
	SET @GivenName = N'中' + @GivenName
	INSERT INTO TR_Register_Des
	(F_RegisterID, F_LanguageCode, F_LastName, F_FirstName, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName, 
	F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName, F_WNPA_LastName, F_WNPA_FirstName)
	VALUES
	(@RegisterID, 'CHN', @FamilyName, @GivenName, @LongName, @ShortName, @LongName, @ShortName, 
	@LongName, @ShortName, @LongName, @ShortName, @FamilyName, @GivenName)
	
	-- 添加备注信息
	IF @RegTypeID = 1
	BEGIN
		SELECT @CommentID = MAX(RC.F_CommentID) + 1
		FROM TR_Register_Comment AS RC
		IF @CommentID IS NULL
		BEGIN
			SET @CommentID = 1
		END
		
		INSERT INTO TR_Register_Comment
		(F_CommentID, F_RegisterID, F_Comment_Order, F_Title, F_Comment)
		VALUES
		(@CommentID, @RegisterID, 1, N'Rank', @Rank)
	END

SET NOCOUNT OFF
END
/*

-- Just for test
SET LANGUAGE 'English'
DECLARE @i			INT
SET @i = 0
EXEC [Proc_Prepare_AddRegister] N'KR', 1, 2, N'144', N'144', 'BAN', 'DDD', N'2 JAN 1981', N'DIAZ', N'Gabriela', 4, @i OUT

*/