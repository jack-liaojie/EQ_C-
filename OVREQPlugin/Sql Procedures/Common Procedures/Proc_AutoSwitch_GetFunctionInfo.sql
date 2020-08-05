IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoSwitch_GetFunctionInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoSwitch_GetFunctionInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_AutoSwitch_GetFunctionInfo]
--描    述：根据查询条件查询符合的Function列表 --自动查找合适的单项特殊的存储过程进行调用
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年09月25日

CREATE PROCEDURE [dbo].[Proc_AutoSwitch_GetFunctionInfo](
				 @DisciplineID   	INT,
				 @RegType			INT,
				 @LanguageCode      NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

    DECLARE @DisciplineCode      CHAR(2)
    SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE  F_DisciplineID = @DisciplineID
    
	DECLARE @SQL				AS NVARCHAR(MAX)
	DECLARE @DisciplineProcName AS NVARCHAR(50)
	SET @DisciplineProcName = N'[dbo].[Proc_' + @DisciplineCode + '_GetFunctionInfo' +  + N']'
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@DisciplineProcName) AND type in (N'P', N'PC'))
	BEGIN
		SET @SQL = N'EXEC ' + @DisciplineProcName +  CAST(@DisciplineID AS NVARCHAR(MAX)) + N', '+CAST(@RegType AS NVARCHAR(MAX)) + N', '''+ CAST(@LanguageCode AS NVARCHAR(MAX)) + N' '''
		EXEC (@SQL)
		RETURN
	END
	ELSE
	BEGIN
		EXEC [dbo].[Proc_GetFunctionInfo] @DisciplineID, @RegType, @LanguageCode
		RETURN
	END
	
	RETURN
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO