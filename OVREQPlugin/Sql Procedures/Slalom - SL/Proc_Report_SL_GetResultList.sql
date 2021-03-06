IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetResultList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetResultList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_SL_GetResultList]
----功		  能：得到当前Match信息
----作		  者：吴定昉
----日		  期: 2010-01-13 
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年7月31日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetResultList]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)


	CREATE TABLE #ResultList
	(
		BibNo					INT,
		[Name]					NVARCHAR(100),
		[DefaultName]           NVARCHAR(100),
		[DoublePlayerCombName]  NVARCHAR(100),
		[DoublePlayerWrapName]  NVARCHAR(100), 		
		NOCCode					CHAR(3),
		DelegationName          NVARCHAR(100),		
		FederationName          NVARCHAR(100),		
		InscriptionResult       NVARCHAR(100),
		RunTime			    NVARCHAR(50),
		RunPen			        NVARCHAR(50),
		RunResult			    NVARCHAR(50),
        RunBehind              NVARCHAR(50),
        RunRank                INT,
        RunDisplayPosition     INT,
		TotalResult			    NVARCHAR(50),
        TotalBehind             NVARCHAR(50),
        TotalRank               INT,
        TotalDisplayPosition    INT
	)

	-- 在临时表中插入基本信息
	INSERT #ResultList 
	(BibNo,[Name],[DefaultName],[DoublePlayerCombName],[DoublePlayerWrapName],
	NOCCode,DelegationName,FederationName, InscriptionResult, 
	RunTime,RunPen,RunResult,RunBehind,RunRank,RunDisplayPosition, 
	TotalResult,TotalBehind,TotalRank,TotalDisplayPosition )
	(
	SELECT  
	 (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum else R.F_Bib end) 
	, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [Name] 
	, RD.F_LongName AS [DefaultName]
	, RD.F_LongName AS [DoublePlayerCombName]
	, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [DoublePlayerWrapName]	
	, D.F_DelegationCode 
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
	, I.F_InscriptionResult 
	, MR.F_PointsCharDes1  
	, MR.F_Points  
	, (case when MR.F_IRMID is not null then IDM.F_IRMLongName else MR.F_PointsCharDes2 end) 
	, MR.F_PointsCharDes4 
	, MR.F_Rank  
	, MR.F_DisplayPosition  
	, (case when PR.F_IRMID is not null then IDP.F_IRMLongName else PR.F_PhasePointsCharDes2 end)  
	, PR.F_PhasePointsCharDes4  
	, PR.F_PhaseRank  
	, PR.F_PhaseDisplayPosition  
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TC_IRM_Des AS IDM ON MR.F_IRMID = IDM.F_IRMID AND IDM.F_LanguageCode = 'eng'
	LEFT JOIN TC_IRM_Des AS IDP ON PR.F_IRMID = IDP.F_IRMID AND IDP.F_LanguageCode = 'eng'
	WHERE MR.F_MatchID = @MatchID 
	)

	SELECT *  FROM #ResultList order by (case when RunDisplayPosition Is NULL then 99 else RunDisplayPosition end)


SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for test
EXEC [Proc_Report_SL_GetResultList] 2994,'eng'

*/
