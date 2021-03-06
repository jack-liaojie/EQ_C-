IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateDoubleName_Asia]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateDoubleName_Asia]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[proc_CreateDoubleName_Asia]
----功		  能：创建双打组合名称
----作		  者：李燕
----日		  期: 2009-05-09 

CREATE PROCEDURE [dbo].[proc_CreateDoubleName_Asia] 
	@RegisterID  			INT,
	@LanguageCode			NVARCHAR(3)
	
AS
BEGIN
	
SET NOCOUNT ON


    DECLARE @DesciplineID AS INT
    SELECT @DesciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

    DECLARE @RegisterIDA  AS INT
    SELECT TOP 1 @RegisterIDA = F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID 
            WHERE A.F_RegisterID = @RegisterID AND B.F_DisciplineID = @DesciplineID ORDER BY A.F_Order
    
    IF(@RegisterIDA = 0 OR @RegisterIDA IS NULL)
    BEGIN
		RETURN
	END

    DECLARE @RegisterIDB AS INT 
    SELECT TOP 1 @RegisterIDB = F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID 
           WHERE A.F_RegisterID = @RegisterID  AND A.F_MemberRegisterID <> @RegisterIDA  AND B.F_DisciplineID = @DesciplineID ORDER BY A.F_Order
    
    IF(@RegisterIDB = 0 OR @RegisterIDB IS NULL)
    BEGIN
		RETURN
	END
     
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务


		CREATE TABLE #table_RegDouble (
										F_RegisterID         INT,
										F_LanguageCode       NVARCHAR(3),
										F_LongName           NVARCHAR(100),
										F_ShortName          NVARCHAR(50),
										F_TvLongName         NVARCHAR(100),
										F_TvShortName        NVARCHAR(50),
										F_SBLongName         NVARCHAR(100),
										F_SBShortName        NVARCHAR(50),
										F_PrintLongName      NVARCHAR(100),
										F_PrintShortName     NVARCHAR(50)
									 )

		INSERT INTO #table_RegDouble (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName)
		SELECT @RegisterID AS F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName
		FROM TR_Register_Des WHERE F_RegisterID = @RegisterIDA
	    
      
		  UPDATE #table_RegDouble SET F_LongName = A.F_LongName + '/' + B.F_LongName, F_ShortName = A.F_ShortName + '/' + B.F_ShortName,
						 F_TvLongName = A.F_TvLongName + '/' + B.F_TvLongName, F_TvShortName = A.F_TvShortName + '/' + B.F_TvShortName,
						 F_SBLongName = A.F_SBLongName + '/' + B.F_SBLongName, F_SBShortName = A.F_SBShortName + '/' + B.F_SBShortName,
						 F_PrintLongName = A.F_PrintLongName + '/' + B.F_PrintLongName, F_PrintShortName = A.F_PrintShortName + '/' + B.F_PrintShortName
						   FROM #table_RegDouble AS A LEFT JOIN TR_Register_Des AS B ON A.F_LanguageCode = B.F_LanguageCode WHERE B.F_RegisterID = @RegisterIDB


		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				RETURN
			END
      
           
	    COMMIT TRANSACTION --成功提交事务
	
        SELECT * FROM #table_RegDouble

SET NOCOUNT OFF
END

set QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF
GO