IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditColor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditColor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_EditColor]
----功		  能：修改一个Color
----作		  者：李燕
----日		  期: 2009-05-20

CREATE PROCEDURE [dbo].[proc_EditColor]
    @ColorID             INT,
    @LanguageCode		CHAR(3),
	@ColorLongName		NVARCHAR(100),
	@ColorShortName		NVARCHAR(50),
    @ColorComment       NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改Color失败，标示没有做任何操作！
					  -- @Result>=1; 	修改Color成功！
					  -- @Result=-1; 	修改Color失败, @ClubID不存在

	IF NOT EXISTS(SELECT F_ColorID FROM TC_Color WHERE F_ColorID = @ColorID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        IF NOT EXISTS (SELECT F_ColorID FROM TC_Color_Des WHERE F_ColorID = @ColorID AND F_LanguageCode = @LanguageCode)
		BEGIN
			INSERT INTO TC_Color_Des (F_ColorID, F_LanguageCode, F_ColorLongName, F_ColorShortName, F_ColorComment) VALUES(@ColorID, @LanguageCode, @ColorLongName, @ColorShortName, @ColorComment)
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
            UPDATE TC_Color_Des SET F_LanguageCode = @LanguageCode, F_ColorLongName = @ColorLongName, F_ColorShortName = @ColorShortName, F_ColorComment = @ColorComment WHERE F_ColorID = @ColorID AND F_LanguageCode = @LanguageCode
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

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
