IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TT_CreateCrossDouble]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_TT_CreateCrossDouble]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[proc_TT_CreateCrossDouble]
----功		  能：创建双打组合
----作		  者：王强
----日		  期: 2011-6-9
--修改：王强2011-6-9

CREATE PROCEDURE [dbo].[proc_TT_CreateCrossDouble] 
	@CrossPairCode          NVARCHAR(20),
	@RegisterCodeA			NVARCHAR(20),
	@RegisterCodeB			NVARCHAR(20),
	@LanguageCode			NVARCHAR(3),
	@DoubleLongName			AS NVARCHAR(200) OUTPUT,
	@Result 			    AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	创建Double失败，标示没有做任何操作！
					-- @Result>=1; 	创建Double成功！@Result 即为双打组合的RegisterID
					-- @Result=-1; 	创建Double失败，@RegisterCodeA不存在
                    -- @Result=-2;  创建Double失败，@RegisterCodeB不存在
                    -- @Result=-3;  存在两个CodeA
                    -- @Result=-4;  存在两个CodeB
                    -- @Result=-5;  性别不同
                    -- @Result=-6;  两人不属于同一个Sport
                    -- @Result>=1;  创建Double失败，双打组合已经存在,返回双打组合ID
                    
    IF EXISTS (SELECT F_RegisterID FROM TR_Register WHERE F_RegisterCode = @CrossPairCode)
    BEGIN
		SELECT @Result = F_RegisterID FROM TR_Register WHERE F_RegisterCode = @CrossPairCode
		RETURN
    END
    
	SET @DoubleLongName = NULL
	DECLARE @NewRegID AS INT
	SET @NewRegID = NULL
	DECLARE @RegisterIDA INT
	DECLARE @RegisterIDB INT
	DECLARE @CntA INT
	DECLARE @CntB INT
	SELECT @CntA = COUNT(F_RegisterID) FROM TR_Register WHERE F_RegisterCode = @RegisterCodeA
	IF @CntA >= 2
	BEGIN
		SET @Result = -3
		RETURN
	END
	ELSE IF @CntA = 0
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SELECT @CntB = COUNT(F_RegisterID) FROM TR_Register WHERE F_RegisterCode = @RegisterCodeB
	IF @CntB >= 2
	BEGIN
		SET @Result = -4
		RETURN
	END
	ELSE IF @CntB = 0
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	SELECT @RegisterIDA = F_RegisterID FROM TR_Register WHERE F_RegisterCode = @RegisterCodeA
	SELECT @RegisterIDB = F_RegisterID FROM TR_Register WHERE F_RegisterCode = @RegisterCodeB
	
	DECLARE @GenderIDA INT
	DECLARE @GenderIDB INT
	SELECT @GenderIDA = F_SexCode FROM TR_Register WHERE F_RegisterID = @RegisterIDA
	SELECT @GenderIDB = F_SexCode FROM TR_Register WHERE F_RegisterID = @RegisterIDB
	IF @GenderIDA != @GenderIDB
	BEGIN
		SET @Result = -5
		RETURN
	END

    DECLARE @RegADisciplineID INT
    DECLARE @RegBDisciplineID INT

    SELECT @RegADisciplineID = F_DisciplineID FROM TR_Register WHERE F_RegisterID = @RegisterIDA
    SELECT @RegBDisciplineID = F_DisciplineID FROM TR_Register WHERE F_RegisterID = @RegisterIDB

    IF(@RegADisciplineID != @RegBDisciplineID)
    BEGIN
		SET @Result = -6
		RETURN
	END

    --DECLARE @FederationAID INT
    --DECLARE @FederationBID INT

 --   SELECT @FederationAID = B.F_FederationID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID
 --   WHERE A.F_MemberRegisterID = @RegisterIDA

 --   SELECT @FederationBID = B.F_FederationID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID
 --   WHERE A.F_MemberRegisterID = @RegisterIDB

 --   IF(@FederationAID != @FederationBID)
 --   BEGIN
	--	SET @Result = -3
	--	RETURN
	--END	
 
	SELECT TOP 1 @NewRegID = Part1.F_RegisterID FROM (SELECT A.F_RegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_MemberRegisterID = @RegisterIDA AND B.F_RegTypeID = 2) AS Part1
				INNER JOIN (SELECT C.F_RegisterID FROM TR_Register_Member AS C LEFT JOIN TR_Register AS D ON C.F_RegisterID = D.F_RegisterID WHERE C.F_MemberRegisterID = @RegisterIDB AND D.F_RegTypeID = 2) AS Part2
					ON Part1.F_RegisterID = Part2.F_RegisterID
	IF (@NewRegID IS NOT NULL)
    BEGIN
        SET @Result = @NewRegID
        RETURN
    END

	--DECLARE @FederationID AS INT
	--SELECT @FederationID = F_FederationID FROM TR_Register WHERE F_RegisterID = @RegisterIDA

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	    INSERT INTO TR_Register (F_DisciplineID, F_RegTypeID, F_RegisterCode, F_SexCode) VALUES (@RegADisciplineID, 2, @CrossPairCode,@GenderIDA)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewRegID = @@IDENTITY

		CREATE TABLE #table_RegDouble (
										F_RegisterID         INT,
										F_LanguageCode       NVARCHAR(3)  collate database_default,
										F_LongName           NVARCHAR(100),
										F_ShortName          NVARCHAR(50),
										F_TvLongName         NVARCHAR(100),
										F_TvShortName        NVARCHAR(50),
										F_SBLongName         NVARCHAR(100),
										F_SBShortName        NVARCHAR(50),
										F_PrintLongName      NVARCHAR(100),
										F_PrintShortName     NVARCHAR(50)
									 )

		INSERT INTO #table_RegDouble (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName)
		SELECT @NewRegID AS F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName
		FROM TR_Register_Des WHERE F_RegisterID = @RegisterIDA
	    
		UPDATE #table_RegDouble SET F_LongName = A.F_LongName + '/' + B.F_LongName, F_ShortName = A.F_ShortName + '/' + B.F_ShortName,
		F_TvLongName = A.F_TvLongName + '/' + B.F_TvLongName, F_TvShortName = A.F_TvShortName + '/' + B.F_TvShortName,
		F_SBLongName = A.F_SBLongName + '/' + B.F_SBLongName, F_SBShortName = A.F_SBShortName + '/' + B.F_SBShortName,
		F_PrintLongName = A.F_PrintLongName + '/' + B.F_PrintLongName, F_PrintShortName = A.F_PrintShortName + '/' + B.F_PrintShortName
		FROM #table_RegDouble AS A LEFT JOIN TR_Register_Des AS B ON A.F_LanguageCode = B.F_LanguageCode WHERE B.F_RegisterID = @RegisterIDB

		INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName)
		SELECT F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName
		FROM #table_RegDouble

		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order) VALUES (@NewRegID, @RegisterIDA, 1)

		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order) VALUES (@NewRegID, @RegisterIDB, 2)

		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

	COMMIT TRANSACTION --成功提交事务
	
	SELECT @DoubleLongName = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @NewRegID AND F_LanguageCode = @LanguageCode
	SET @Result = @NewRegID
	RETURN

SET NOCOUNT OFF
END

GO

