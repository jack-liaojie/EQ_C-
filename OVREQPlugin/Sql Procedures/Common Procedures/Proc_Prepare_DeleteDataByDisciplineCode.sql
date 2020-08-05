IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_DeleteDataByDisciplineCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_DeleteDataByDisciplineCode]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Prepare_DeleteDataByDisciplineCode]
--描    述: 根据 Discipline Code 删除一个 Discipline 的成绩信息.
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年9月14日 星期二
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_DeleteDataByDisciplineCode]
	@DisciplineCode						NVARCHAR(20),
	@IsDeleteTop						INT		-- 是否删除顶层数据: 0 - 不删除; 1 - 删除.
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID				INT
	DECLARE @DType						INT
	
	SET @DType = 1
	
	SELECT @DisciplineID = D.F_DisciplineID
	FROM TS_Discipline AS D
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	EXEC [Proc_Prepare_DeleteDataBySDEPMID] @DisciplineID, @DType, @IsDeleteTop

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'KR', 0
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'CR', 0
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'CR', 1
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'SL', 1
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'KR', 1

*/