IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetHeatsResultList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetHeatsResultList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_SL_GetHeatsResultList]
----功		  能：得到当前Match信息
----作		  者：吴定昉
----日		  期: 2010-01-13 
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年7月31日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetHeatsResultList]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @EventCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
	DECLARE @Run1MatchID	INT
	DECLARE @Run2MatchID	INT
	DECLARE @SQL		    NVARCHAR(max)

	SELECT @EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE F_MatchID = @MatchID

    IF @PhaseCode = '9'
    BEGIN 
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '01' 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '02' 
    END
    ELSE
    BEGIN
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '2'
        AND M.F_MatchCode = '01' 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '1'
        AND M.F_MatchCode = '01' 
    END

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
		Run1Time			    NVARCHAR(50),
		Run1Pen			        NVARCHAR(50),
		Run1Result			    NVARCHAR(50),
        Run1Behind              NVARCHAR(50),
        Run1Rank                INT,
        Run1DisplayPosition     INT,
		Run2Time			    NVARCHAR(50),
		Run2Pen			        NVARCHAR(50),
		Run2Result			    NVARCHAR(50),
        Run2Behind              NVARCHAR(50),
        Run2Rank                INT,
        Run2DisplayPosition     INT,
		TotalResult			    NVARCHAR(50),
        TotalBehind             NVARCHAR(50),
        TotalRank               INT,
        TotalDisplayPosition    INT
	)

	-- 在临时表中插入基本信息
	INSERT #ResultList
	(BibNo,[Name],[DefaultName],[DoublePlayerCombName],[DoublePlayerWrapName],
	NOCCode,DelegationName, FederationName, InscriptionResult,
	Run1Time,Run1Pen,Run1Result,Run1Behind,Run1Rank,Run1DisplayPosition, 
	Run2Time,Run2Pen,Run2Result,Run2Behind,Run2Rank,Run2DisplayPosition, 
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
	, MR1.F_PointsCharDes1  
	, MR1.F_Points  
	, (case when MR1.F_IRMID is not null then ID1.F_IRMLongName else MR1.F_PointsCharDes2 end)  
	, MR1.F_PointsCharDes4 
	, MR1.F_Rank 
	, MR1.F_DisplayPosition 
	, MR2.F_PointsCharDes1  
	, MR2.F_Points 
	, (case when MR2.F_IRMID is not null then ID2.F_IRMLongName else MR2.F_PointsCharDes2 end)  
	, MR2.F_PointsCharDes4 
	, MR2.F_Rank 
	, MR2.F_DisplayPosition  
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
	LEFT JOIN TS_Match_Result AS MR1 ON MR.F_RegisterID = MR1.F_RegisterID AND MR1.F_MatchID = @Run1MatchID   
	LEFT JOIN TS_Match_Result AS MR2 ON MR.F_RegisterID = MR2.F_RegisterID AND MR2.F_MatchID = @Run2MatchID   
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TC_IRM_Des AS ID1 ON MR1.F_IRMID = ID1.F_IRMID AND ID1.F_LanguageCode = 'eng' 
	LEFT JOIN TC_IRM_Des AS ID2 ON MR2.F_IRMID = ID2.F_IRMID AND ID2.F_LanguageCode = 'eng' 
	LEFT JOIN TC_IRM_Des AS IDP ON PR.F_IRMID = IDP.F_IRMID AND IDP.F_LanguageCode = 'eng' 
	WHERE MR.F_MatchID = @MatchID 
	)

	SELECT *  FROM #ResultList order by (case when TotalDisplayPosition Is NULL then 99 else TotalDisplayPosition end)

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for test
EXEC [Proc_Report_SL_GetHeatsResultList] 2994,'eng'

*/
