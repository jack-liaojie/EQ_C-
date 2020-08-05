
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetTeamResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetTeamResult] (	
	@MatchID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP(  TeamID INT,
			[RANK] NVARCHAR(50), 
			NOC NVARCHAR(50), 
			NOC_DES NVARCHAR(100), 
			Total NVARCHAR(50),
			IRM_CODE NVARCHAR(50)
			) 


	INSERT INTO #TMP EXEC Proc_SH_GetTeamResult @MatchID 
	
	SELECT TeamID,
			[RANK], 
			'[IMAGE]' + NOC AS NOC, 
			NOC_DES, 
			Total,
			IRM_CODE 
	FROM #TMP
	
SET NOCOUNT OFF
END

GO


 -- EXEC Proc_SCB_SH_GetTeamResult 2190
