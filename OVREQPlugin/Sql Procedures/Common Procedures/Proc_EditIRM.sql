/****** Object:  StoredProcedure [dbo].[Proc_EditIRM]    Script Date: 11/13/2009 10:31:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditIRM]
GO
/****** Object:  StoredProcedure [dbo].[Proc_EditIRM]    Script Date: 11/13/2009 10:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_EditIRM]
--描    述: 修改一种 IRM 类型 (IRM)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		添加对 Order 的编辑		
            2009年11月13日      李燕        添加DisciplineID
            2010年1月25日       李燕        IRMCode长度为20					
*/



CREATE PROCEDURE [dbo].[Proc_EditIRM]
	@IRMID						INT,
	@LanguageCode				CHAR(3),
    @DisciplineID				INT,
	@Order						INT,
	@IRMCode					NVARCHAR(20),
	@IRMLongName				NVARCHAR(100),
	@IRMShortName				NVARCHAR(50),
	@IRMComment					NVARCHAR(100),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					  -- @Result = 1; 	更新成功！
					  -- @Result = -1;	更新失败，@IRMID 不存在！

	IF NOT EXISTS (SELECT F_IRMID FROM TC_IRM WHERE F_IRMID = @IRMID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	UPDATE TC_IRM
	SET F_IRMCode = @IRMCode, F_Order = @Order, F_DisciplineID = @DisciplineID
	WHERE F_IRMID = @IRMID
		
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result = 0
		RETURN
	END

	-- Des 表中有该语言的描述就更新, 没有则添加
	IF EXISTS (SELECT F_IRMID FROM TC_IRM_Des 
				WHERE F_IRMID = @IRMID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TC_IRM_Des 
		SET F_IRMLongName = @IRMLongName
			, F_IRMShortName = @IRMShortName
			, F_IRMComment = @IRMComment
		WHERE F_IRMID = @IRMID
			AND F_LanguageCode = @LanguageCode
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
		INSERT INTO TC_IRM_Des 
			(F_IRMID, F_LanguageCode, F_IRMLongName, F_IRMShortName, F_IRMComment) 
			VALUES
			(@IRMID, @LanguageCode, @IRMLongName, @IRMShortName, @IRMComment)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

	COMMIT TRANSACTION --成功提交事务

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 更新成功
	RETURN

SET NOCOUNT OFF
END
