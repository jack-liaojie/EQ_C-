IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_GetPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_GetPosition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_BK_GetPosition]
--描    述: 获取指定项目所有的Position类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/




CREATE PROCEDURE [dbo].[Proc_BK_GetPosition]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT B.F_PositionLongName, A.F_PositionID 
	FROM TD_Position AS A
	LEFT JOIN TD_Position_Des AS B
		ON A.F_PositionID = b.F_PositionID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID 

SET NOCOUNT OFF
END
