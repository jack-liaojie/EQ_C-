IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddMemberRegister_WithOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddMemberRegister_WithOrder]
GO
/****** Object:  StoredProcedure [dbo].[proc_AddMemberRegister_WithOrder]    Script Date: 09/10/2009 14:36:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：proc_AddMemberRegister_WithOrder
----功		  能：添加单个队或双打中的成员,带有Order信息
----作		  者：李燕 
----日		  期: 2009-04-17 
----修 改 记  录：
/*
    修改人      修改日期          修改记录
    李燕        2010-09-27        添加人员中包括，队伍、组合类型。
*/

CREATE PROCEDURE [dbo].[proc_AddMemberRegister_WithOrder] 
    @RegisterID          INT,
    @MemberRegisterID    INT,
    @FunctionID          INT,
    @PositionID          INT,
    @Order               INT,
    @ShirtNum            INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Register失败，标示没有做任何操作！
					-- @Result>=1; 	添加Register成功！
					-- @Result=-1; 	添加Register失败，@RegisterID无效
                    ---@Result= -2; 添加MemberRegister失败，@MemberRegisterID无效
                    ---@Result= -3; 添加MemberRegister失败，已存在Register与MemberRegister之间的从属关系

	IF NOT EXISTS(SELECT @RegisterID FROM TR_Register)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF NOT EXISTS(SELECT @MemberRegisterID FROM TR_Register)
	BEGIN
		SET @Result = -2
		RETURN
	END



--判断是否有死循环

      DECLARE @NodeLevel INT
	  SET @NodeLevel = 0	
	  
    CREATE TABLE #tmp_table(
             F_RegisterID    INT,
             F_MemberID      INT,
             F_MidMemberID   INT,
             F_NodeLevel         INT)
     
     INSERT INTO #tmp_table (F_RegisterID, F_MemberID,F_NodeLevel, F_MidMemberID)
               SELECT @MemberRegisterID, A.F_MemberRegisterID, 0, A.F_MemberRegisterID
                 FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B  ON A.F_MemberRegisterID = B.F_RegisterID
                   WHERE A.F_RegisterID = @MemberRegisterID AND B.F_RegTypeID IN (2,3)
           
     WHILE EXISTS (SELECT F_MidMemberID FROM #tmp_table WHERE F_NodeLevel = 0)
     BEGIN
         SET @NodeLevel = @NodeLevel + 1
	     UPDATE #tmp_table SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
	     
         INSERT INTO #tmp_table (F_RegisterID, F_MemberID, F_NodeLevel, F_MidMemberID)
             SELECT @MemberRegisterID, B.F_MemberRegisterID,  0,  B.F_MemberRegisterID
              FROM #tmp_table AS A LEFT JOIN TR_Register_Member AS B ON A.F_MidMemberID = B.F_RegisterID 
                    LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID 
                WHERE A.F_NodeLevel = @NodeLevel AND C.F_RegTypeID IN (2,3)
     END
    
    IF EXISTS (SELECT F_RegisterID FROM #tmp_table WHERE F_RegisterID = @MemberRegisterID AND F_MemberID = @RegisterID)
    BEGIN
         SET @Result = -3
		 RETURN
    END
    
    
    
    IF (@Order IS NULL OR @Order = 0 OR @Order = NULL)
    BEGIN
         SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) FROM TR_Register_Member WHERE F_RegisterID = @RegisterID
         SET @Order = @Order + 1
    END
	
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_FunctionID, F_PositionID, F_ShirtNumber)
			VALUES (@RegisterID, @MemberRegisterID, @Order, @FunctionID, @PositionID, @ShirtNum)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END


declare @aa as int 
exec [proc_AddMemberRegister_WithOrder] 466,1, null,null,0,0, @aa output
select @aa