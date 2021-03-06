/****** Object:  StoredProcedure [dbo].[Proc_UpdateLanguageActive]    Script Date: 12/21/2009 10:40:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateLanguageActive]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdateLanguageActive]
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateLanguageActive]    Script Date: 12/21/2009 10:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_UpdateLanguageActive]
--描    述: 修改一种语言的激活状态
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_UpdateLanguageActive]
	@LanguageCode				CHAR(3),
	@Active						INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	编辑Language激活状态失败，标示没有做任何操作！
					-- @Result = 1; 	编辑Language激活状态成功！
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		IF (@Active = 1)
		BEGIN
			UPDATE TC_Language SET F_Active = @Active 
				WHERE F_LanguageCode = @LanguageCode
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

			UPDATE TC_Language SET F_Active = 0 WHERE F_LanguageCode != @LanguageCode
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			IF (@Active = 0)
			BEGIN
				IF EXISTS(SELECT F_LanguageCode FROM TC_Language WHERE F_Active = 1 AND F_LanguageCode <> @LanguageCode)
				BEGIN
					UPDATE TC_Language SET F_Active = @Active 
						WHERE F_LanguageCode = @LanguageCode
					IF @@error<>0  --事务失败返回  
					BEGIN 
						ROLLBACK   --事务回滚
						SET @Result=0
						RETURN
					END
				END
			END
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END
