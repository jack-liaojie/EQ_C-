/****** Object:  StoredProcedure [dbo].[Proc_AddIRM]    Script Date: 11/13/2009 10:27:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddIRM]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddIRM]    Script Date: 11/13/2009 10:26:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddIRM]
--描    述: 添加一种IRM类型 (IRM)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		添加时同时添加 Order 信息	
            2009年11月13日      李燕        添加DisciplineID
            2010年1月25日       李燕        IRMCode长度为20		
*/



CREATE PROCEDURE [dbo].[Proc_AddIRM]
	@LanguageCode				CHAR(3),
    @DisciplineID               INT,
	@Order						INT,
	@IRMCode					NVARCHAR(20),
	@IRMLongName				NVARCHAR(100),
	@IRMShortName				NVARCHAR(50),
	@IRMComment					NVARCHAR(100),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 IRMID

	DECLARE @NewIRMID AS INT

    IF EXISTS(SELECT F_IRMID FROM TC_IRM)
	BEGIN
      SELECT @NewIRMID = MAX(F_IRMID) FROM TC_IRM
      SET @NewIRMID = @NewIRMID + 1
	END
	ELSE
	BEGIN
		SET @NewIRMID = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_IRM (F_IRMID, F_DisciplineID, F_Order, F_IRMCode) VALUES(@NewIRMID, @DisciplineID, @Order, @IRMCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_IRM_Des 
			(F_IRMID, F_LanguageCode, F_IRMLongName, F_IRMShortName, F_IRMComment) 
			VALUES
			(@NewIRMID, @LanguageCode, @IRMLongName, @IRMShortName, @IRMComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = @NewIRMID
	RETURN

SET NOCOUNT OFF
END
