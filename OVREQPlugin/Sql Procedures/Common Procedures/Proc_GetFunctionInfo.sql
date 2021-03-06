/****** Object:  StoredProcedure [dbo].[Proc_GetFunctionInfo]    Script Date: 01/13/2010 11:21:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFunctionInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFunctionInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetFunctionInfo]    Script Date: 01/13/2010 11:03:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetFunctionInfo]
----功		  能：得到所有的功能信息
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题	
			2011年01月20日      李燕        修改或根据CategroyType过滤		
*/

CREATE PROCEDURE [dbo].[Proc_GetFunctionInfo](
                                         @DisciplineID    INT,
                                         @RegType         INT,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

     CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			INT
							)

	DECLARE @AllDes AS NVARCHAR(100)
	SET @AllDes = ' '

	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (@AllDes, -1)
	
    DECLARE @CategoryType NVARCHAR(10)
    IF(@RegType = 0 OR @RegType IS NULL)
    BEGIN
        SET @CategoryType = ''
    END
    ELSE IF(@RegType = 1 )
     BEGIN
        SET @CategoryType = 'A'
    END
    ELSE IF(@RegType = 4 )
     BEGIN
        SET @CategoryType = 'S'
    END
    ELSE IF(@RegType = 5 )
     BEGIN
        SET @CategoryType = 'T'
    END

    IF (@CategoryType IS NULL OR @CategoryType = '')
    BEGIN
        INSERT INTO #Tmp_Table (F_Name, F_Key) 
			 SELECT B.F_FunctionLongName, A.F_FunctionID 
				FROM TD_Function AS A LEFT JOIN TD_Function_Des AS B 
				  ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode= @LanguageCode
				WHERE A. F_DisciplineID  = @DisciplineID 
    ENd
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_Name, F_Key) 
			 SELECT B.F_FunctionLongName, A.F_FunctionID 
				FROM TD_Function AS A LEFT JOIN TD_Function_Des AS B 
				  ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode= @LanguageCode
				WHERE A. F_DisciplineID  = @DisciplineID  AND ( A.F_FunctionCategoryCode = @CategoryType OR A.F_FunctionCategoryCode IS NULL)
    END
	
    SELECT F_Name, F_Key FROM #Tmp_Table
	

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

