IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InscriptionAllRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_InscriptionAllRegister]
GO
/****** Object:  StoredProcedure [dbo].[Proc_InscriptionAllRegister]    Script Date: 08/31/2009 11:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_InscriptionAllRegister]
--描    述: 所有该Event下的报名运动员都报项
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年8月31日



CREATE PROCEDURE [dbo].[Proc_InscriptionAllRegister]
	@EventID				INT,
	@LanguageCode			CHAR(3),
    @Result 			AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON
   
     CREATE TABLE #table_federation(
								     F_FederationID      INT
                                    )
     
     CREATE TABLE #table_register(
								     F_RegisterID      INT
                                  )
    /* Get Active Info*/
    DECLARE @RegTypeID AS INT
	DECLARE @SexCode AS INT
	DECLARE @DisciplineID AS INT

	SELECT @RegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode, @DisciplineID = F_DisciplineID
	FROM TS_Event 
	WHERE F_EventID = @EventID

    INSERT INTO  #table_federation(F_FederationID)
      SELECT F_FederationID FROM TS_ActiveFederation
			WHERE F_DisciplineID = @DisciplineID

	DECLARE @PlayerRegTypeID AS INT
	DECLARE @DoubleRegTypeID AS INT
	DECLARE @TeamRegTypeID AS INT
	SET @PlayerRegTypeID = 1
	SET @DoubleRegTypeID = 2
	SET @TeamRegTypeID = 3

	DECLARE @MixSexCode AS INT
	SET @MixSexCode = 3

	INSERT INTO #table_register( F_RegisterID)
        SELECT  a.F_RegisterID  FROM TR_Register AS a 
	    WHERE   a.F_RegTypeID = @RegTypeID AND a.F_DisciplineID = @DisciplineID
		      AND (
					a.F_SexCode is NULL 
					OR
					(a.F_RegTypeID = @PlayerRegTypeID AND (a.F_SexCode = @MixSexCode OR a.F_SexCode = @SexCode))
					OR
					((a.F_RegTypeID = @DoubleRegTypeID OR a.F_RegTypeID = @TeamRegTypeID) AND a.F_SexCode = @SexCode)
		          )
			 AND a.F_RegisterID NOT IN (
				  SELECT F_RegisterID
				    FROM TR_Inscription AS e
				    WHERE e.F_EventID = @EventID)
			 AND a.F_FederationID IN (
				 SELECT F_FederationID FROM  #table_federation)

  
   /* Register Inscription*/
   SET @Result=0;  -- @Result=0; 	注册人员报项失败，标示没有做任何操作！
					-- @Result=1; 	注册人员报项成功！
					-- @Result=-1; 	注册人员报项失败，@EventID无效、@RegisterID无效
					-- @Result=-2; 	注册人员报项失败，已经注册过了！

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID IN (SELECT F_RegisterID FROM #table_register))
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID IN (SELECT F_RegisterID FROM #table_register))
	BEGIN
		SET @Result = -2
		RETURN
	END 
   
   SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Inscription (F_RegisterID, F_EventID, F_Seed)
			SELECT F_RegisterID, @EventID, NULL
             FROM #table_register

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

exec Proc_InscriptionAllRegister  28, 'CHN', ''