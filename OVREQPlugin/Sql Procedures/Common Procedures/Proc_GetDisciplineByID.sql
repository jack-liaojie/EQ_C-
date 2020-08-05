IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetDisciplineByID]
--描    述: 根据 DisciplineID 获取 Discipline
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月18日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/



CREATE PROCEDURE [dbo].[Proc_GetDisciplineByID]
	@DisciplineID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT * 
	FROM TS_Discipline AS A 
	LEFT JOIN TS_Discipline_Des AS B 
		ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode 
	WHERE A.F_DisciplineID = @DisciplineID
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetDisciplineByID] 45, 'CHN'
--exec [Proc_GetDisciplineByID] 45, 'ENG'