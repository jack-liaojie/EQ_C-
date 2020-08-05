IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetPlayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetPlayerList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_GetPlayerList]
--描    述: 射箭项目,获取所选比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月13日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetPlayerList]
	@MatchID				INT,
	@LanguageCode			CHAR(3)='CHN'
AS
BEGIN
SET NOCOUNT ON

	SELECT
		MR.F_CompetitionPosition  
        , MR.F_RegisterID
		, I.F_InscriptionNum AS Bib
		, RD.F_LongName AS Name
		, DD.F_DelegationShortName AS NOC
        , MR.F_Rank AS [Rank]
        , MR.F_Points AS Total
        , MR.F_RealScore AS Point
        , II.F_IRMCODE AS IRM
        , MR.F_WinPoints AS [10s]
        , MR.F_LosePoints AS [Xs]
        , MR.F_Service AS Remark
		, MR.F_Comment AS [Target]
		--,R.F_Bib AS [Target]
	FROM TS_Match_Result AS MR  
		LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
		LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode =  @LanguageCode  
		LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
		LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
		LEFT JOIN TC_IRM AS II ON MR.F_IRMID = II.F_IRMID AND II.F_DisciplineID = E.F_DisciplineID 
		LEFT JOIN TC_IRM_Des AS ID ON II.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation_Des AS DD ON DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode =  @LanguageCode 
			WHERE MR.F_MatchID = @MatchID


	RETURN

SET NOCOUNT OFF
END

GO


/*
exec Proc_AR_GetPlayerList 1 ,'CHN'
*/