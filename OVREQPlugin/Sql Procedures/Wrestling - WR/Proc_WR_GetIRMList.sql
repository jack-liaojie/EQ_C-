IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetIRMList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetIRMList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetIRMList]
--描    述: 摔跤项目获取 Decision 列表.
--创 建 人: 宁顺泽
--日    期: 2011年10月14日 星期5
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetIRMList]
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END

	SELECT 0 AS F_Order
		, N'' AS [IRM]
		, N'' AS [IRMCode]
	UNION
	select IRM.F_Order
		,IRMD.F_IRMLongName AS [IRM]
		,IRM.F_IRMCODE AS [IRMCode]
	from TC_IRM AS IRM
	LEFT JOIN TC_IRM_Des AS IRMD
		ON IRM.F_IRMID=IRMD.F_IRMID aND IRMD.F_LanguageCode=@LanguageCode
	INNER JOIN TS_Discipline aS D
		ON IRM.F_DisciplineID=D.F_DisciplineID AND D.F_Active=1
	Order by F_Order

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDecisionList] 

*/