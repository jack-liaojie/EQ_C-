/****** Object:  UserDefinedFunction [dbo].[Fun_GetTeamMemberName]    Script Date: 09/10/2009 14:42:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetTeamMemberName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetTeamMemberName]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetTeamMemberName]    Script Date: 09/10/2009 14:42:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：Fun_GetTeamMemberName
----功		  能：用成员名字组合队伍的名字
----作		  者：李燕 
----日		  期: 2009-09-10 


CREATE FUNCTION [dbo].[Fun_GetTeamMemberName]
								(
									@RegisterID					INT,
									@LanguageCode				CHAR(3)
								)
RETURNS NVARCHAR (100)
AS
BEGIN

	DECLARE @TeamMemberName         AS NVARCHAR(200)
    DECLARE @TempName               AS NVARCHAR(200)
	DECLARE @RegTypeID				AS INT

    DECLARE  @table_temp AS TABLE(
									F_RegisterID         INT,
									F_LongName           NVARCHAR(100),
                                    F_RowNumber          INT   IDENTITY
								    )
	
    SELECT @RegTypeID = F_RegTypeID FROM TR_Register WHERE F_RegisterID = @RegisterID 
	
    IF (@RegTypeID = 2 OR @RegTypeID = 3)
	BEGIN
          INSERT INTO @table_temp(F_RegisterID, F_LongName)
                SELECT A.F_MemberRegisterID, B.F_LongName
                FROM TR_Register_Member AS A LEFT JOIN TR_Register AS C ON A.F_MemberRegisterID = C.F_RegisterID 
                     LEFT JOIN TR_Register_Des AS B ON A.F_MemberRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
                WHERE C.F_RegTypeID = 1 AND A.F_RegisterID = @RegisterID ORDER BY A.F_Order

          DECLARE @RowMaxNumber  AS INT          
          SELECT @RowMaxNumber = (CASE WHEN MAX(F_RowNumber) IS NULL THEN 0 ELSE MAX(F_RowNumber) END) FROM @table_temp
          
          DECLARE @RowNumber  AS INT
          SET @RowNumber = 1
          WHILE(@RowNumber <= @RowMaxNumber)
          BEGIN
             SELECT @TempName =  F_LongName FROM @table_temp WHERE F_RowNumber = @RowNumber
            
             IF(@TempName IS NOT NULL)
             BEGIN
                 IF(@TeamMemberName IS NULL)
                 BEGIN
					SET @TeamMemberName = @TempName 
				 END
				 ELSE
				 BEGIN
					 SET @TeamMemberName = @TeamMemberName + @TempName
				 END
				 
                 IF(@RowNumber <> @RowMaxNumber)
				 BEGIN
					SET @TeamMemberName = @TeamMemberName + '\'
				 END
              END
              SET @RowNumber = @RowNumber +1
          END

	END
	
	RETURN @TeamMemberName
END
