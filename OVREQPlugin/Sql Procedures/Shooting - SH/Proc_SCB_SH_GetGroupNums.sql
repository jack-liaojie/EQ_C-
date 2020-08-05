IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetGroupNums]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetGroupNums]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_SH_GetGroupNums]
--描    述: SCB 获取比赛参数列表.
--创 建 人: 吴定昉
--日    期: 2011-02-24
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetGroupNums]
	@MatchID                    INT
AS
BEGIN
SET NOCOUNT ON
	
	CREATE TABLE #Temp_Table
	(
		GroupNum INT,
	    GroupNumName NVARCHAR(50),	
	)
		
	INSERT INTO #Temp_Table(GroupNum,GroupNumName)
	(
	SELECT distinct MR.F_CompetitionPositionDes2,
	cast(MR.F_CompetitionPositionDes2 as NVARCHAR(50))
	FROM TS_Match AS M
	INNER JOIN TS_Match_Result AS MR
		ON M.F_MatchID = MR.F_MatchID
	WHERE M.F_MatchID = @MatchID
	)
	
	INSERT INTO #Temp_Table(GroupNum,GroupNumName) (SELECT 0,'')

    SELECT * FROM #Temp_Table ORDER BY GroupNum
    
SET NOCOUNT OFF
END

GO

/*
EXEC [Proc_SCB_SH_GetGroupNums] 1
*/