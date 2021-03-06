IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_GetForerunRegisterList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_GetForerunRegisterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--名    称: [Proc_SL_GetForerunRegisterList]
--描    述: 激流回旋项目,获取所有预备划比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年07月07日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SL_GetForerunRegisterList]
	@MatchID				INT,
	@CompetitionPosition	INT,	
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

    DECLARE @EventID        INT

	SELECT @EventID = E.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

	CREATE TABLE #Table
	(
		F_CompetitionPosition	INT,
		F_RegisterID            INT,
		[Name]					NVARCHAR(100),
		[Event]                 NVARCHAR(100)
	)

	-- 在临时表中插入基本信息
	INSERT #Table (F_CompetitionPosition, F_RegisterID, [Name], [Event])
	(
	SELECT MR.F_CompetitionPosition , R.F_RegisterID, RD.F_LongName, I.F_InscriptionResult
	FROM TR_Register AS R  
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match_Result AS MR ON R.F_RegisterID = MR.F_RegisterID AND MR.F_MatchID = @MatchID
	LEFT JOIN TR_Inscription AS I ON R.F_RegisterID = I.F_RegisterID AND I.F_EventID = @EventID
	)

    DELETE FROM #Table WHERE F_RegisterID <> -1 
    AND F_RegisterID in (
    SELECT F_RegisterID FROM TS_Match_Result 
    WHERE F_MatchID = @MatchID and F_CompetitionPosition <> @CompetitionPosition
    )

    UPDATE #Table SET Name = 'None' WHERE F_RegisterID = -1 
    
    SELECT * FROM #Table ORDER BY F_RegisterID
    
SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_SL_GetForerunRegisterList] 1,'eng'

*/




