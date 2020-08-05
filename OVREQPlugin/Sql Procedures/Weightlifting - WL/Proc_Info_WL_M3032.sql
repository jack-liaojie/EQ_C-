IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_M3032]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_M3032]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Info_WL_M3032]
----功		  能：
----作		  者：
----日		  期: 2010-11-29 
----修改	记录:

/*
				崔凯	2011-01-27    修改协议，提供6次试举的成绩，只要成绩变更即发送全组运动员的全部6次成绩，
*/

CREATE PROCEDURE [dbo].[Proc_Info_WL_M3032]
		@MatchID            AS INT,
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
	DECLARE @PhaseID   INT


	SELECT @DisciplineID = D.F_DisciplineID,
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

	SELECT @SnatchMatchID = M.F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventCode = @EventCode 
    AND E.F_SexCode = @SexCode
    AND P.F_PhaseCode = @PhaseCode
    AND M.F_MatchCode = '01'
    AND D.F_DisciplineCode = @DisciplineCode 

	SELECT @CleanJerkMatchID = M.F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventCode = @EventCode 
    AND E.F_SexCode = @SexCode
    AND P.F_PhaseCode = @PhaseCode
    AND M.F_MatchCode = '02'
    AND D.F_DisciplineCode = @DisciplineCode 
  
    SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID

CREATE TABLE #Attempt_Weight
	(
	    F_RegisterID            INT,
	    [Order]                 INT, 
	    [Weight]                varchar(10), 
        Indicator_1st           varchar(1),
        Indicator_2nd           varchar(1),
        Indicator_3rd           varchar(1),
        Is_Succeeded            varchar(1),
	)

	INSERT #Attempt_Weight(F_RegisterID,[Order],[Weight],Indicator_1st,Indicator_2nd,Indicator_3rd,Is_Succeeded)
	(   SELECT MR.F_RegisterID , 1, 
		 CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes1 IS NULL THEN ''
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1) =3 THEN '' 
		      ELSE ISNULL(MR.F_PointsCharDes1,'') END
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes1),3)),1,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes1),3)),2,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes1),3)),3,1)
		,CASE WHEN F_PointsNumDes1 IS NULL THEN ''
			  WHEN dbo.Fun_WL_GetIsSuccess(F_PointsNumDes1) = 1 THEN 'Y'
			  ELSE 'N' END 
		FROM TS_Match_Result    AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID   
		WHERE F_MatchID  =@SnatchMatchID AND F_PointsCharDes1 IS NOT NULL
		UNION ALL 
		SELECT MR.F_RegisterID , 2, 
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes2 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes2,'') END
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes2),3)),1,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes2),3)),2,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes2),3)),3,1)
		,CASE WHEN F_PointsNumDes2 IS NULL THEN ''
			  WHEN dbo.Fun_WL_GetIsSuccess(F_PointsNumDes2) = 1  THEN 'Y'
			  ELSE 'N' END 
		 FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID     
		WHERE F_MatchID  =@SnatchMatchID AND F_PointsCharDes2 IS NOT NULL
		UNION ALL 
		SELECT MR.F_RegisterID , 3, 
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes3 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes3,'') END
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes3),3)),1,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes3),3)),2,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes3),3)),3,1)
		,CASE WHEN F_PointsNumDes3 IS NULL THEN ''
			  WHEN dbo.Fun_WL_GetIsSuccess(F_PointsNumDes3) = 1  THEN 'Y'
			  ELSE 'N' END 
		 FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID     
		WHERE F_MatchID  =@SnatchMatchID AND F_PointsCharDes3 IS NOT NULL
		
		UNION ALL 
		SELECT MR.F_RegisterID , 4, 
		 CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes1 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes1,'') END
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes1),3)),1,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes1),3)),2,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes1),3)),3,1)
		,CASE WHEN F_PointsNumDes1 IS NULL THEN ''
			  WHEN dbo.Fun_WL_GetIsSuccess(F_PointsNumDes1) = 1  THEN 'Y'
			  ELSE 'N' END 
		 FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID   
		WHERE F_MatchID  =@CleanJerkMatchID AND F_PointsCharDes1 IS NOT NULL
		UNION ALL 
		SELECT MR.F_RegisterID , 5, 
		 CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes2 IS NULL THEN ''
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2) =3 THEN '' 
		      ELSE ISNULL(MR.F_PointsCharDes2,'') END
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes2),3)),1,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes2),3)),2,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes2),3)),3,1)
		,CASE WHEN F_PointsNumDes2 IS NULL THEN ''
			  WHEN dbo.Fun_WL_GetIsSuccess(F_PointsNumDes2) = 1 THEN 'Y'
			  ELSE 'N' END 
		 FROM TS_Match_Result     AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID
		WHERE F_MatchID  =@CleanJerkMatchID AND F_PointsCharDes2 IS NOT NULL
		UNION ALL 
		SELECT MR.F_RegisterID , 6, 
		 CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes3 IS NULL THEN ''
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3) =3 THEN '' 
		      ELSE ISNULL(MR.F_PointsCharDes3,'') END
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes3),3)),1,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes3),3)),2,1)
		,SUBSTRING(Convert(varchar(10),right('000'+Convert(varchar(3),F_PointsNumDes3),3)),3,1)
		,CASE WHEN F_PointsNumDes3 IS NULL THEN ''
			  WHEN dbo.Fun_WL_GetIsSuccess(F_PointsNumDes3) = 1  THEN 'Y'
			  ELSE 'N' END 
		 FROM TS_Match_Result AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID
		WHERE F_MatchID  =@CleanJerkMatchID AND F_PointsCharDes3 IS NOT NULL
		)
		
	CREATE TABLE #Result
	(
	    Registration            varchar(10), 
		Bib				        varchar(3),
        Lot_Number              INT,
        [Group]                 varchar(1),
        Snatch                  varchar(10), 
        CleanJerk               varchar(10), 
        Total                   varchar(10), 
        [Order]                 INT,
        Weight_On_Bar           varchar(10), 
        Indicator_1st           varchar(1),
        Indicator_2nd           varchar(1),
        Indicator_3rd           varchar(1),
        Is_Succeeded            varchar(1),
	)

	INSERT #Result 
	(Registration, Bib, Lot_Number,[Group]
	 ,Snatch,CleanJerk,Total,[Order],Weight_On_Bar
	 ,Indicator_1st,Indicator_2nd,Indicator_3rd,Is_Succeeded)
	(
	SELECT
	R.F_RegisterCode AS [Registration]
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum else R.F_Bib end) AS [Bib]
	, I.F_Seed AS [Lot_Number]
	, P.F_PhaseCode 
	,ISNULL(SNMR.F_PointsCharDes4,'')
	,ISNULL(CJMR.F_PointsCharDes4,'')	
	,ISNULL(ER.F_EventPointsCharDes4,'')
	,AW.[Order] AS [Order]	
	,AW.[Weight]
	,CASE WHEN AW.Indicator_1st=1 THEN 'Y'
		  WHEN AW.Indicator_1st=0 THEN 'N'
		  ELSE '' END
	,CASE WHEN AW.Indicator_2nd=1 THEN 'Y'
		  WHEN AW.Indicator_2nd=0 THEN 'N'
		  ELSE '' END
	,CASE WHEN AW.Indicator_3rd=1 THEN 'Y'
		  WHEN AW.Indicator_3rd=0 THEN 'N'
		  ELSE '' END
	,AW.Is_Succeeded
	
	FROM #Attempt_Weight AS AW  
	LEFT JOIN TR_Register AS R ON AW.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON AW.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match_Result AS SNMR ON AW.F_RegisterID = SNMR.F_RegisterID AND SNMR.F_MatchID = @SnatchMatchID 
	LEFT JOIN TS_Match_Result AS CJMR ON AW.F_RegisterID = CJMR.F_RegisterID AND CJMR.F_MatchID = @CleanJerkMatchID 
	LEFT JOIN TS_Phase_Result AS PR ON AW.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @PhaseID
	LEFT JOIN TS_Match_Result AS MR ON AW.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TR_Inscription AS I ON AW.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
	LEFT JOIN TS_Event_Result AS ER ON ER.F_EventID = P.F_EventID AND ER.F_RegisterID = AW.F_RegisterID
	WHERE MR.F_MatchID = @MatchID  
		 AND R.F_RegisterCode IS NOT NULL AND P.F_PhaseCode IS NOT NULL 
		 AND I.F_Seed IS NOT NULL AND R.F_Weight IS NOT NULL
		 AND (I.F_InscriptionNum IS NOT NULL OR R.F_Bib IS NOT NULL)
		 AND AW.[Order] IS NOT NULL
	)

	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT * FROM #Result AS Result ORDER BY Registration , [ORDER]
			FOR XML AUTO)

	IF @Result IS NULL
	BEGIN
		SET @Result = N''
	END


	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "VRS"' 
							+N' Origin = "VRS"'
							+N' RSC = "' + @DisciplineCode + @GenderCode + @EventCode + @PhaseCode + '01"'
							+N' Discipline = "'+ @DisciplineCode + '"'
							+N' Gender = "' + @GenderCode + '"'
							+N' Event = "' + @EventCode + '"'
							+N' Phase = "' + @PhaseCode + '"'
							+N' Unit = "01"'
							+N' Venue ="000"'
							+N' Code = "M3032"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Result
					+ N'
						</Message>'

	IF (@Result IS NOT NULL AND @Result !='')
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN 
	END

SET NOCOUNT OFF
END


GO


