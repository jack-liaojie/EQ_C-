IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditMatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_EditMatch]
----功		  能：添加一个Match，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-08 

CREATE PROCEDURE [dbo].[proc_EditMatch] 
	@MatchID			INT,
	@Code				NVARCHAR (20),
	@Order				INT,
	@MatchNum			INT,
	@HasMedal			INT,
	@languageCode		CHAR(3),
	@MatchLongName		NVARCHAR(100),
	@MatchShortName		NVARCHAR(50),
	@MatchComment		NVARCHAR(100),
    @MatchComment2      NVARCHAR(100),
	@StatusID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Match失败，标示没有做任何操作！
					-- @Result=1; 	添加Match成功！
					-- @Result=-1; 	添加Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Match SET F_Order = @Order, F_MatchNum = @MatchNum , F_MatchCode = @Code, F_MatchHasMedal = @HasMedal--, F_MatchStatusID = @StatusID
			WHERE F_MatchID = @MatchID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		IF EXISTS (SELECT F_MatchID FROM TS_Match_DES WHERE F_MatchID = @MatchID AND F_LanguageCode = @LanguageCode)
		BEGIN
			
			UPDATE TS_Match_DES SET F_MatchLongName = @MatchLongName, F_MatchShortName = @MatchShortName, 
                      F_MatchComment = @MatchComment, F_MatchComment2 = @MatchComment2
				WHERE  F_MatchID = @MatchID AND F_LanguageCode = @LanguageCode

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			insert into TS_Match_DES (F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2)
				VALUES (@MatchID, @languageCode, @MatchLongName, @MatchShortName, @MatchComment, @MatchComment2)

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




