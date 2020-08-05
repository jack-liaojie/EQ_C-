IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_OutPutEventResult_AutoSwitch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_OutPutEventResult_AutoSwitch]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----名   称：[Proc_Info_OutPutEventResult_AutoSwitch]
----功   能：判断是否存在单项自定义的输出存储过程，并对应调用。
----作	 者：郑金勇
----日   期：2010-08-20 

/*
	参数说明：
	序号	参数名称		参数说明
	1		@EventID		指定的比赛项目ID
	2		@LanguageCode	描述的语言类型
*/

/*
	功能描述：判断是否存在单项自定义的输出存储过程，并对应调用。
			  此存储过程遵照内部的MS SQL SERVER编码规范。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_OutPutEventResult_AutoSwitch](
				 @EventID			INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @SQL				AS NVARCHAR(MAX)
	DECLARE @DisciplineProcName AS NVARCHAR(50)
	DECLARE @DisciplineCode		AS NVARCHAR(2)
	 
	SELECT @DisciplineCode = F_DisciplineCode FROM TS_Event AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID
			WHERE A.F_EventID = @EventID

	SET @DisciplineProcName = N'[dbo].[Proc_Info_' + @DisciplineCode + N'_OutPutEventResult]'

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@DisciplineProcName) AND type in (N'P', N'PC'))
	BEGIN
		SET @SQL = N'EXEC ' + @DisciplineProcName + N' ' + CAST(@EventID AS NVARCHAR(MAX)) + N', ' + CAST(@EventID AS NVARCHAR(MAX)) + N', ' + CAST(@LanguageCode AS NVARCHAR(MAX)) 
		EXEC (@SQL)
		RETURN
	END
	ELSE
	BEGIN
		EXEC [dbo].[Proc_Info_OutPutEventResult] @EventID, @LanguageCode
		RETURN
	END
	

	RETURN

Set NOCOUNT OFF
End	
GO
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--EXEC Proc_OutPutEventResult 17,'CHN'
--EXEC Proc_OutPutEventResult 19,'CHN'