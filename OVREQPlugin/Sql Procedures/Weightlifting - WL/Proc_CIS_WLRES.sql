IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_WLRES]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_WLRES]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_CIS_WLRES]
----功		  能：
----作		  者：wudingfang
----日		  期: 2011-02-15 
----修改	记录:


CREATE PROCEDURE [dbo].[Proc_CIS_WLRES]
		@MatchID            AS INT,
		@IsAll              AS INT,
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

 
 	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        NVARCHAR(1)
    DECLARE @GenderCode     NVARCHAR(1)    
	DECLARE @SnatchMatchID	INT
	DECLARE @CleanJerkMatchID	INT
	DECLARE @EventID    INT
	DECLARE @PhaseID    INT
	DECLARE @GroupCount     INT
	DECLARE @TempPhaseID    INT
	DECLARE @n              INT 
	

	SELECT @DisciplineID = D.F_DisciplineID,
	@EventID = P.F_EventID, 
	@PhaseID = P.F_PhaseID,
	@DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @GenderCode = S.F_GenderCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID
	
    
	CREATE TABLE #GroupList
    (
        [Order] INT,
        PhaseID INT
	)	
	INSERT #GroupList([Order],PhaseID) 
	(
	SELECT ROW_NUMBER() Over(order by P.F_PhaseCode) AS [Order], P.F_PhaseID 
	FROM TS_Phase AS P WHERE P.F_EventID = @EventID
	) 
	SET @GroupCount = 1
	SELECT @GroupCount = MAX([Order]) FROM #GroupList


	CREATE TABLE #Temp_Result
	(
	    [ID]          varchar(10),
	    [Rank]        varchar(10), 
		[Group]		  char,
		[Lift_Order]  varchar(10),
		[Bib]         varchar(10),
		[Name]	      varchar(50),  --运动员姓名	N
		[NOC_Code]	  varchar(3),   --运动员NOC_Code	N
		[Age]	      varchar(10),  --运动员年龄	Y
		[Body_Weight] varchar(10),	--运动员体重	N
		[Entry_Total] varchar(10),	--运动员报名成绩	Y
		[S_Att_1_Wt]  varchar(10),	--第一次抓举重量	Y
		[S_Att_1_Light]	  char,	    --第一次抓举成败	Y
		[S_Att_2_Wt]	  varchar(10), --第二次抓举重量	Y
		[S_Att_2_Light]	  char,        --第二次抓举成败	Y
		[S_Att_3_Wt]	  varchar(10), --第三次抓举重量	Y
		[S_Att_3_Light]	  char,        --第三次抓举成败	Y
		[S_Wt_Result]	  varchar(10), --抓举成绩	Y
		[CJ_Att_1_Wt]	  varchar(10), --第一次挺举重量	Y
		[CJ_Att_1_Light]  char,	       --第一次挺举成败	Y
		[CJ_Att_2_Wt]	  varchar(10), --第二次挺举重量	Y
		[CJ_Att_2_Light]  char,	       --第二次挺举成败	Y
		[CJ_Att_3_Wt]	  varchar(10), --第三次挺举重量	Y
		[CJ_Att_3_Light]  char,	       --第三次挺举成败	Y
		[CJ_Wt_Result]	  varchar(10), --挺举成绩	Y
		[Total_Weight]	  varchar(10), --总成绩，如果没有成绩，则需提供IRM信息	Y
		[S_Remark]	      varchar(50), --备注，抓举如有破纪录情况，则提供纪录信息	Y
		[CJ_Remark]	      varchar(50), --备注，挺举如有破纪录情况，则提供纪录信息	Y
		[Total_Remark]	      varchar(50), --备注，总成绩如有破纪录情况，则提供纪录信息	Y
		[Status]	      int,	--运动员状态	N
		[DisplayPosition] int,	--列表中的显示顺序	N
		[LotNo]			  int,	--列表中的显示顺序	Y
		[IRM_Order]		  int,	--IRM显示顺序DNS,DNF,DSQ
	)

	
    SET @n = 1
	WHILE @n <= @GroupCount
	BEGIN
	    SELECT @TempPhaseID = PhaseID FROM #GroupList WHERE [Order] = @n
	    IF @IsAll = 1 OR @TempPhaseID = @PhaseID 
	    BEGIN
	
			SELECT @SnatchMatchID = M.F_MatchID FROM TS_Match AS M 
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
			WHERE P.F_PhaseID = @TempPhaseID AND M.F_MatchCode = '01'

			SELECT @CleanJerkMatchID = M.F_MatchID FROM TS_Match AS M 
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
			WHERE P.F_PhaseID = @TempPhaseID AND M.F_MatchCode = '02'
	
			INSERT #Temp_Result 
			([ID],[Rank],[Group],[Lift_Order],[Bib],[Name],[NOC_Code],
			[Age],[Body_Weight],[Entry_Total],
			[S_Att_1_Wt],[S_Att_1_Light],[S_Att_2_Wt],[S_Att_2_Light],
			[S_Att_3_Wt],[S_Att_3_Light],[S_Wt_Result],
			[CJ_Att_1_Wt],[CJ_Att_1_Light],[CJ_Att_2_Wt],[CJ_Att_2_Light],
			[CJ_Att_3_Wt],[CJ_Att_3_Light],[CJ_Wt_Result],
			[Total_Weight],[S_Remark],[CJ_Remark],[Total_Remark],
			[Status],[DisplayPosition],[LotNo],[IRM_Order])
			(
			SELECT
			 ISNULL(R.F_RegisterCode,'') AS [ID]
			, CASE WHEN @IsAll=1 THEN RIGHT('000'+ CONVERT(NVARCHAR(10),ISNULL(ER.F_EventRank,'999')),3) 
				   ELSE RIGHT('000'+ CONVERT(NVARCHAR(10),ISNULL(PR.F_PhaseRank,'999')),3) END AS [Rank]
			, P.F_PhaseCode AS [Group]
			, RIGHT('000'+ CONVERT(NVARCHAR(10),ISNULL(MR.F_CompetitionPositionDes2,'999')),3) AS [Lift_Order]
			, RIGHT('000'+ CONVERT(NVARCHAR(10),ISNULL(I.F_InscriptionNum,'999')),3) AS [Bib]
			, RD.F_LongName AS [Name]
			, D.F_DelegationCode 
			, CASE WHEN R.F_Birth_Date IS NOT NULL THEN YEAR(GETDATE())-YEAR(R.F_Birth_Date)
				ELSE '' END AS [Age]				
			, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight) AS [Body_Weight]
			, ISNULL(I.F_InscriptionResult,'')  AS [Entry_Total]
			
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes1 IS NULL THEN '---'
	       WHEN SNMR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1)=3 THEN '---'
	       --WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes1 IS NULL THEN ''
	       ELSE SNMR.F_PointsCharDes1 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
				   WHEN dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) ='1' then 'Y' 
			       WHEN dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) ='0' then 'N'  
				   ELSE '' END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes2 IS NULL THEN '---'
	       WHEN SNMR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2)=3 THEN '---'
	       --WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes2 IS NULL THEN ''
	       ELSE SNMR.F_PointsCharDes2 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
				   WHEN dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) ='1' then 'Y' 
			       WHEN dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) ='0' then 'N'  
				   ELSE '' END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes3 IS NULL THEN '---'
	       WHEN SNMR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3)=3 THEN '---'
	       --WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes3 IS NULL THEN ''
	       ELSE SNMR.F_PointsCharDes3 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
				   WHEN dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) ='1' then 'Y' 
			       WHEN dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) ='0' then 'N'  
				   ELSE '' END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' THEN ISNULL(SNMR.F_PointsCharDes4,'---')
	       WHEN (dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) =0 OR dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) =0 OR dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) =0 OR dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) =3) THEN '---'
	       ELSE SNMR.F_PointsCharDes4 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes1 IS NULL THEN '---'
	       WHEN CJMR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1)=3 THEN '---'
	       --WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes1 IS NULL THEN ''
	       ELSE CJMR.F_PointsCharDes1 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
				   WHEN dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) ='1' then 'Y' 
			       WHEN dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) ='0' then 'N'  
				   ELSE '' END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes2 IS NULL THEN '---'
	       WHEN CJMR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2)=3 THEN '---'
	       --WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes2 IS NULL THEN ''
	       ELSE CJMR.F_PointsCharDes2 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
				   WHEN dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) ='1' then 'Y' 
			       WHEN dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) ='0' then 'N'  
				   ELSE '' END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes3 IS NULL THEN '---'
	       WHEN CJMR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3)=3 THEN '---'
	       --WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes3 IS NULL THEN ''
	       ELSE CJMR.F_PointsCharDes3 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
				   WHEN dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) ='1' then 'Y' 
			       WHEN dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) ='0' then 'N'  
				   ELSE '' END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' THEN ISNULL(CJMR.F_PointsCharDes4,'---')
	       WHEN (dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) =0 OR dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) =0 OR dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) =0 OR dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) =3) THEN '---'
	       ELSE CJMR.F_PointsCharDes4 END
	, CASE WHEN ER.F_IRMID IS NOT NULL THEN IRM.F_IRMCODE ELSE ER.F_EventPointsCharDes4 END AS [Total_Weight]
			
			, CASE WHEN ER.F_IRMID IS NULL THEN dbo.Fun_WL_GetRecordSecString(SNMR.F_MatchID,MR.F_RegisterID, '1') ELSE '' END AS [S_Remark]
			, CASE WHEN ER.F_IRMID IS NULL THEN dbo.Fun_WL_GetRecordSecString(CJMR.F_MatchID,MR.F_RegisterID, '2') ELSE '' END AS [CJ_Remark]
			, CASE WHEN ER.F_IRMID IS NULL THEN dbo.Fun_WL_GetRecordSecString(CJMR.F_MatchID,MR.F_RegisterID, '3') ELSE '' END AS [Total_Remark]
 			
 			, CASE WHEN MR.F_MatchID = @SnatchMatchID THEN 
 					(CASE WHEN MR.F_RealScore=10 THEN 1 WHEN MR.F_RealScore=20 THEN 0 
 					ELSE ISNULL(MR.F_RealScore,3) END)
 			   ELSE (CASE WHEN CJMR.F_RealScore=10 THEN 1 WHEN CJMR.F_RealScore=20 THEN 0 
 					ELSE ISNULL(CJMR.F_RealScore,3) END) END AS [Status]
			
			, ER.F_EventDisplayPosition AS [DisplayPosition]
			, RIGHT('000'+ CONVERT(NVARCHAR(10),ISNULL(I.F_Seed,'999')),3)
			, ISNULL(IRM.F_Order,0) AS [IRM_Order]
			FROM TS_Match_Result AS MR  
			LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
			LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
			LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
			LEFT JOIN TS_Match_Result AS SNMR ON MR.F_RegisterID = SNMR.F_RegisterID AND SNMR.F_MatchID = @SnatchMatchID 
			LEFT JOIN TS_Match_Result AS CJMR ON MR.F_RegisterID = CJMR.F_RegisterID AND CJMR.F_MatchID = @CleanJerkMatchID 
			LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @TempPhaseID
			LEFT JOIN TS_Event_Result AS ER ON MR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = P.F_EventID 
			LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID
			WHERE MR.F_MatchID = (SELECT CASE WHEN @MatchCode ='01' THEN @SnatchMatchID ELSE  @CleanJerkMatchID END))
			
	    END
	    SET @n = @n + 1
	END


	DECLARE @Temp_Result AS NVARCHAR(MAX)
	SET @Temp_Result = ( SELECT Result.[ID] AS [ID],
	                       Result.[Rank] AS [Rank],
	                       Result.[Group] AS [Group],
	                       Result.[Lift_Order] AS [Lift_Order],
	                       Result.[Bib] AS [Bib],
	                       Result.[Name] AS [Name],
	                       Result.[NOC_Code] AS [NOC_Code],
	                       Result.[Age] AS [Age],
	                       Result.[Body_Weight] AS [Body_Weight],
	                       Result.[Entry_Total] AS [Entry_Total],
	                       Result.[S_Att_1_Wt] AS [S_Att_1_Wt],
	                       Result.[S_Att_1_Light] AS [S_Att_1_Light],
	                       Result.[S_Att_2_Wt] AS [S_Att_2_Wt],
	                       Result.[S_Att_2_Light] AS [S_Att_2_Light],
	                       Result.[S_Att_3_Wt] AS [S_Att_3_Wt],
	                       Result.[S_Att_3_Light] AS [S_Att_3_Light],
	                       Result.[S_Wt_Result] AS [S_Wt_Result],
	                       Result.[CJ_Att_1_Wt] AS [CJ_Att_1_Wt],
	                       Result.[CJ_Att_1_Light] AS [CJ_Att_1_Light],
	                       Result.[CJ_Att_2_Wt] AS [CJ_Att_2_Wt],
	                       Result.[CJ_Att_2_Light] AS [CJ_Att_2_Light],
	                       Result.[CJ_Att_3_Wt] AS [CJ_Att_3_Wt],
	                       Result.[CJ_Att_3_Light] AS [CJ_Att_3_Light],
	                       Result.[CJ_Wt_Result] AS [CJ_Wt_Result],
	                       Result.[Total_Weight] AS [Total_Weight],
	                       Result.S_Remark AS [S_Remark],
	                       Result.CJ_Remark AS [CJ_Remark],
	                       Result.Total_Remark AS [Total_Remark],
	                       Result.[Status] AS [Status],
	                       Result.[DisplayPosition] AS [DisplayPosition],
	                       Result.LotNo as [LotNo]                      
	            FROM #Temp_Result AS Result Order By ISNULL(Result.[Bib],999),ISNULL(Result.[IRM_Order],0),Result.LotNo
			FOR XML AUTO)

	IF @Temp_Result IS NULL
	BEGIN
		SET @Temp_Result = N''
	END


	DECLARE @MessageProperty AS NVARCHAR(MAX)
	IF @IsAll = 1 
	SET @MessageProperty = N'Type = "WLRES"'
							+N' ID = "WL' + @GenderCode + @EventCode + N'000"'
							+N' Discipline = "'+ @DisciplineCode + '"'
	ELSE
	SET @MessageProperty = N'Type = "WLRES"'
							+N' ID = "WL' + @GenderCode + @EventCode + @PhaseCode + N'00"'
							+N' Discipline = "'+ @DisciplineCode + '"'
								
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Temp_Result
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END
/*
    EXEC Proc_CIS_WLRES 17,0,'ENG'
*/

GO


