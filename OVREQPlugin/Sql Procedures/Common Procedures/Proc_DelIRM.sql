IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelIRM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_DelIRM]
--描    述: 删除一种IRM类型 (IRM)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_DelIRM]
	@IRMID					INT,
	@Result					AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败, 标示没有做任何操作!
					  -- @Result = 1; 	删除成功!
					  -- @Result = -1;	删除失败, @IRMID 不存在!

	IF NOT EXISTS (SELECT F_IRMID FROM TC_IRM WHERE F_IRMID = @IRMID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_IRM_Des WHERE F_IRMID = @IRMID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_IRM WHERE F_IRMID = @IRMID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 删除成功
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for Test
DECLARE @IRMID INT
DECLARE @TestResult INT

-- Add one IRM
exec [Proc_AddIRM]  'CHN', 100, 'DIE', '死掉', '死掉', '死掉了', @IRMID OUTPUT
SELECT * FROM TC_IRM WHERE F_IRMID = @IRMID
SELECT * FROM TC_IRM_Des WHERE F_IRMID = @IRMID

-- Delete One IRM
exec [Proc_DelIRM] @IRMID, @TestResult OUTPUT
SELECT * FROM TC_IRM WHERE F_IRMID = @IRMID
SELECT * FROM TC_IRM_Des WHERE F_IRMID = @IRMID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TC_IRM_Des WHERE F_IRMID = @IRMID
DELETE FROM TC_IRM WHERE F_IRMID = @IRMID

*/