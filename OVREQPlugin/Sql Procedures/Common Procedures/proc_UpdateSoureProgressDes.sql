/****** Object:  StoredProcedure [dbo].[proc_UpdateSoureProgressDes]    Script Date: 12/18/2009 15:27:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateSoureProgressDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateSoureProgressDes]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_UpdateSoureProgressDes]
----功		  能：更新比赛位置源晋级描述
----作		  者：李燕
----日		  期: 2009-12-18

CREATE PROCEDURE [dbo].[proc_UpdateSoureProgressDes] 
	@MatchID						INT,
	@CompetitionPosition			INT,
	@LanguageCode					CHAR(3),
    @SouceProgressDes               NVARCHAR(100),
	@Result 						AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	更新失败！
					-- @Result=1; 	更新成功！

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS (SELECT F_MatchID FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_LanguageCode = @LanguageCode)
	BEGIN
			
		UPDATE TS_Match_Result_Des SET F_SouceProgressDes = @SouceProgressDes
			WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_LanguageCode = @LanguageCode

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END
	ELSE
	BEGIN
		insert into TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode, F_SouceProgressDes)
			VALUES (@MatchID, @CompetitionPosition, @LanguageCode, @SouceProgressDes)

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