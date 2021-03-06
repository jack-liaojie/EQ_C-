IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_InsertTeamUniform]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_InsertTeamUniform]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[proc_InsertTeamUniform]
----功		  能：添加一个队伍的Uniform
----作		  者：李燕
----日		  期: 2009-04-24 

CREATE PROCEDURE [dbo].[proc_InsertTeamUniform]
						@RegisterID         INT,
						@ShirtColorID       INT,
						@ShortsColorID      INT,
						@SocksColorID       INT,
						@Order              INT,
						@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Uniform失败，标示没有做任何操作！
                      -- @Result=-1;    添加Uniform失败，@RegisterID无效！
                      -- @Result=-2;    添加Uniform失败，@ColorID无效！
					  -- @Result>=1; 	添加Color成功！此值即为UniformID

	
    IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF ( NOT EXISTS(SELECT F_ColorID FROM TC_Color WHERE F_ColorID = @ShirtColorID) AND (@ShirtColorID IS NOT NULL))
    BEGIN
		SET @Result = -2
		RETURN
	END

    IF ( NOT EXISTS(SELECT F_ColorID FROM TC_Color WHERE F_ColorID = @ShortsColorID) AND (@ShortsColorID IS NOT NULL))
    BEGIN
		SET @Result = -2
		RETURN
	END

    IF ( NOT EXISTS(SELECT F_ColorID FROM TC_Color WHERE F_ColorID = @SocksColorID) AND  (@SocksColorID IS NOT NULL))
    BEGIN
		SET @Result = -2
		RETURN
	END

    IF(@Order IS NULL)
    BEGIN
    SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TR_Uniform WHERE F_RegisterID = @RegisterID
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Uniform(F_RegisterID, F_Shirt,F_Shorts,F_Socks,F_Order) VALUES(@RegisterID, @ShirtColorID, @ShortsColorID, @SocksColorID, @Order)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @@IDENTITY
	RETURN

SET NOCOUNT OFF
END

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
