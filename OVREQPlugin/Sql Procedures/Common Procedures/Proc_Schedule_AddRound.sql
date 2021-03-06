IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_AddRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_AddRound]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



----存储过程名称：[Proc_Schedule_AddRound]
----功		  能：添加一个Round，Round主要是为赛事日程安排服务，提供赛事逻辑结构以外的日程结构维护对象
----作		  者：郑金勇 
----日		  期: 2009-05-14 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年11月12日		邓年彩		修改存储过程名称, proc_AddRound->Proc_Schedule_AddRound	
			2009年11月13日		邓年彩		删除参数 @RoundComment , 添加 @RoundCode, @Comment 	
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_AddRound] 
	@EventID			INT,
	@Order				INT,
	@RoundCode			NVARCHAR(20),
	@Comment			NVARCHAR(50),
	@languageCode		CHAR(3),
	@RoundLongName		NVARCHAR(100),
	@RoundShortName		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Round失败，标示没有做任何操作！
					-- @Result>=1; 	添加Round成功！此值即为RoundID
					-- @Result=-1; 	添加Round失败，@EventID无效
	DECLARE @NewRoundID AS INT	

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Round WHERE F_EventID = @EventID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Round (F_EventID, F_Order, F_RoundCode, F_Comment)
			VALUES (@EventID, @Order, @RoundCode, @Comment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewRoundID = @@IDENTITY

		insert into TS_Round_Des (F_RoundID, F_LanguageCode, F_RoundLongName, F_RoundShortName)
			VALUES (@NewRoundID, @languageCode, @RoundLongName, @RoundShortName)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewRoundID
	RETURN

SET NOCOUNT OFF
END





