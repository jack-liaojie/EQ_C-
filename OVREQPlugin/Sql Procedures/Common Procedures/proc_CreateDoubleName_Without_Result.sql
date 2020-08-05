/****** Object:  StoredProcedure [dbo].[proc_CreateDoubleName_Without_Result]    Script Date: 02/22/2011 09:26:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateDoubleName_Without_Result]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateDoubleName_Without_Result]
GO

/****** Object:  StoredProcedure [dbo].[proc_CreateDoubleName_Without_Result]    Script Date: 02/22/2011 09:26:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[proc_CreateDoubleName_Without_Result]
----功		  能：创建双打组合名称
----作		  者：李燕
----日		  期: 2009-05-09 

CREATE PROCEDURE [dbo].[proc_CreateDoubleName_Without_Result] 
	@RegisterID  			INT,
	@LanguageCode			NVARCHAR(3)
	
AS
BEGIN
	
SET NOCOUNT ON


    DECLARE @DesciplineID AS INT
    SELECT  @DesciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

    CREATE TABLE #table_RegDouble (
									F_RegisterID         INT,
									F_LanguageCode       NVARCHAR(3) COLLATE DATABASE_DEFAULT,
									F_LongName           NVARCHAR(100),
									F_ShortName          NVARCHAR(50),
									F_TvLongName         NVARCHAR(100),
									F_TvShortName        NVARCHAR(50),
									F_SBLongName         NVARCHAR(100),
									F_SBShortName        NVARCHAR(50),
									F_PrintLongName      NVARCHAR(100),
									F_PrintShortName     NVARCHAR(50)
								 )


    DECLARE @RegisterIDA  AS INT
    SELECT TOP 1 @RegisterIDA = F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID 
            WHERE A.F_RegisterID = @RegisterID AND B.F_DisciplineID = @DesciplineID ORDER BY A.F_Order
 
    IF(@RegisterIDA IS NULL)
    BEGIN	
		INSERT INTO #table_RegDouble (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName)
		   SELECT @RegisterID AS F_RegisterID, F_LanguageCode, B.F_DelegationLongName, B.F_DelegationShortName, B.F_DelegationLongName, B.F_DelegationShortName, B.F_DelegationLongName, B.F_DelegationShortName, B.F_DelegationLongName, B.F_DelegationShortName
		     FROM TR_Register AS A LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID WHERE A.F_RegisterID = @RegisterID AND B.F_LanguageCode = @LanguageCode
	    
	   SELECT * FROM #table_RegDouble
	   RETURN
	END

    DECLARE @RegisterIDB AS INT 
    SELECT TOP 1 @RegisterIDB = F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID 
           WHERE A.F_RegisterID = @RegisterID  AND A.F_MemberRegisterID <> @RegisterIDA  AND B.F_DisciplineID = @DesciplineID ORDER BY A.F_Order
    

	
	INSERT INTO #table_RegDouble (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName)
	SELECT @RegisterID AS F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName
	FROM TR_Register_Des WHERE F_RegisterID = @RegisterIDA AND F_LanguageCode = @LanguageCode
    
    IF(@RegisterIDB IS NOT NULL)
    BEGIN
	      UPDATE #table_RegDouble SET F_LongName = LTRIM ( RTRIM (CAST(A.F_LongName AS NVARCHAR(50)))) + '/' + LTRIM ( RTRIM (CAST(B.F_LongName AS NVARCHAR(49)))), 
	                   F_ShortName = LTRIM ( RTRIM (CAST(A.F_ShortName AS NVARCHAR(25)))) + '/' + LTRIM ( RTRIM (CAST(B.F_ShortName AS NVARCHAR(24)))),
					   F_TvLongName = LTRIM ( RTRIM (CAST(A.F_TvLongName AS NVARCHAR(50)))) + '/' + LTRIM ( RTRIM (CAST(B.F_TvLongName AS NVARCHAR(49)))), 
					   F_TvShortName = LTRIM ( RTRIM (CAST(A.F_TvShortName AS NVARCHAR(25)))) + '/' + LTRIM ( RTRIM (CAST(B.F_TvShortName AS NVARCHAR(24)))),
					   F_SBLongName = LTRIM(RTRIM (CAST(A.F_SBLongName  AS NVARCHAR(7)))) + '/' + LTRIM ( RTRIM (CAST(B.F_SBLongName AS NVARCHAR(6)))), 
					   F_SBShortName = LTRIM( RTRIM(CAST(A.F_SBShortName  AS NVARCHAR(4)))) + '/' + LTRIM(RTRIM(CAST(B.F_SBShortName AS NVARCHAR(3)))),
					   F_PrintLongName = LTRIM ( RTRIM (CAST(A.F_PrintLongName  AS NVARCHAR(50)))) + '/' + LTRIM ( RTRIM ( CAST(B.F_PrintLongName AS NVARCHAR(49)))), 
					   F_PrintShortName = LTRIM ( RTRIM (CAST(A.F_PrintShortName  AS NVARCHAR(24)))) + '/' + LTRIM ( RTRIM (CAST(B.F_PrintShortName AS NVARCHAR(24))))
			   FROM #table_RegDouble AS A, TR_Register_Des AS B
                   WHERE B.F_RegisterID = @RegisterIDB AND B.F_LanguageCode = @LanguageCode
    END


    SELECT * FROM #table_RegDouble

SET NOCOUNT OFF
END

set QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF


GO


--exec proc_CreateDoubleName_Without_Result 1414, 'eng'