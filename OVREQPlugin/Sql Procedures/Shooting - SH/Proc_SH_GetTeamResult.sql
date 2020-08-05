
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_GetTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_GetTeamResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	for SH'S plugin, only call function
--	author: mu xuefeng
----date: 2010-12-22

CREATE PROCEDURE [dbo].[Proc_SH_GetTeamResult] (	
	@MatchID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @EventCode NVARCHAR(10)
	
	SELECT @EventCode = Event_Code FROM DBO.Func_SH_GetEventCommonCodeInfo(@MatchID)
	IF ( @EventCode NOT IN('002', '004', '006', '008', '010', '012', '014', '102', '104', '106', '108', '110') )
	RETURN

	Create table #tt( TeamID INT,
			Display_Rank NVARCHAR(50), 
			DD_RANK INT,
			NOC NVARCHAR(50), 
			NOC_DES NVARCHAR(100), 
			Total NVARCHAR(50),
			IRM_CODE NVARCHAR(50))
	INSERT INTO #tt(TeamID, Display_Rank, DD_RANK, NOC,NOC_DES, Total,IRM_CODE)
	SELECT  TeamID,
			Display_Rank , 
			[RANK],
			NOC, 
			NOC_DES, 
			Total,
			IRM_CODE 
	FROM dbo.[Func_SH_GetTeamResult] (@MatchID) as b
	ORDER BY b.[Rank]

	UPDATE #tt
	SET DD_RANK = Display_Rank
	WHERE DD_RANK IS NULL

	UPDATE #tt
	SET DD_RANK = Display_Rank
	WHERE Display_Rank IS NOT NULL
	
	update TS_Match_Result set F_Rank = b.DD_RANK
	from TS_Match_Result as a
	left join #tt as b on a.F_RegisterID = b.TeamID
	where F_MatchID = @MatchID
	
	
	SELECT TeamID, Display_Rank AS [RANK], NOC,NOC_DES, Total,IRM_CODE
	FROM #tt
	ORDER BY DD_RANK
	
SET NOCOUNT OFF
END

GO

-- SELECT * FROM dbo.[Func_SH_GetTeamResult] (345)
 -- EXEC Proc_SH_GetTeamResult 347
