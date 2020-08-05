IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchIRMandHantei]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchIRMandHantei]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_UpdateMatchIRMandHantei]
--描    述: 摔跤项目单人项目设定一场比赛的信息.
--创 建 人: 宁顺泽
--日    期: 2011年10月15日 星期6
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchIRMandHantei]
	@MatchID						INT,
	@Compos							INT,
	@HanteiID						INT,
	@IRMCode					NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON



DECLARE @IRMID					INT
	SELECT @IRMID = D.F_IRMID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_IRM AS D
		ON E.F_DisciplineID = D.F_DisciplineID AND D.F_IRMCODE = @IRMCode
	WHERE M.F_MatchID = @MatchID
	
	Update TS_Match_Result set F_IRMID=@IRMID,F_PointsNumDes1=@HanteiID
	where F_MatchID=@MatchID and F_CompetitionPosition=@Compos
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/