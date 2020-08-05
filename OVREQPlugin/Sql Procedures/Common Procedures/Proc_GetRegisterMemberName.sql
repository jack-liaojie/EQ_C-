/****** Object:  StoredProcedure [dbo].[Proc_GetRegisterMemberName]    Script Date: 06/08/2010 11:21:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegisterMemberName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegisterMemberName]
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetRegisterMemberName]    Script Date: 06/08/2010 11:21:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_GetRegisterMemberName]
--描    述: 根据 RegID 获取RegMember信息
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年12月11日



CREATE PROCEDURE [dbo].[Proc_GetRegisterMemberName]
	@LanguageCode				CHAR(3),
	@RegisterID					INT
AS
BEGIN
SET NOCOUNT ON

	DECLARE @RegType  INT
    SELECT @RegType = F_RegTypeID FROM TR_Register WHERE F_RegisterID = @RegisterID

    DECLARE @MemberName  NVARCHAR(MAX)

    IF(@RegType = 2 OR @RegType = 3)
    BEGIN
       DECLARE @TempName NVARCHAR(MAX)
       SET @TempName = ''
       DECLARE @Index  INT
       SET @Index = 0
       
       SELECT @TempName = @TempName + '\' + ISNULL(RD.F_LongName, '') 
		, @Index = @Index + 1
       FROM TR_Register_Member AS RM 
           LEFT JOIN TR_Register_Des AS RD ON RM.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
            WHERE RM.F_RegisterID = @RegisterID
      
       IF( LEN(@TempName) > 2)
       BEGIN
          SET @TempName = RIGHT(@TempName, LEN(@TempName) - 1)  
       END

       SET @MemberName = CAST(@Index AS NVARCHAR(100)) +  (CASE WHEN @Index <> 0 THEN ': ' + @TempName ELSE ''END)
       SELECT @MemberName
    END

SET NOCOUNT OFF
END


GO


