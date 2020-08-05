IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchIRMandHantei]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchIRMandHantei]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetMatchIRMandHantei]
--描    述: 摔跤项目.
--创 建 人: 宁顺泽
--日    期: 2011年10月15日 星期6
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchIRMandHantei]
	@MatchID						INT,
	@Compos							INT
AS
BEGIN
SET NOCOUNT ON
	
	select F_PointsNumDes1 as HanteiID
			,I.F_IRMCODE as IRMCode
	from TS_Match_Result AS MR
	LEFT JOIN TC_IRM AS I
		ON I.F_IRMID=MR.F_IRMID
	where MR.F_MatchID=@MatchID and MR.F_CompetitionPosition=@Compos

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/