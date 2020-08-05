IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_M3031]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_M3031]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Info_WL_M3031]
----功		  能：
----作		  者：
----日		  期: 2010-11-29 
----修改	记录:

CREATE PROCEDURE [dbo].[Proc_Info_WL_M3031]
		@MatchID            AS INT,
		@LanguageCode		AS CHAR(3),
		@bAuto				INT
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
	DECLARE @MatchStatusID   INT


	SELECT @DisciplineID = D.F_DisciplineID,
	@DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @GenderCode = S.F_GenderCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchStatusID = M.F_MatchStatusID,
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

	CREATE TABLE #Athlete
	(
	    F_RegisterID            INT,
	    Registration            varchar(10), 
		Body_Weight				decimal(9,2),
	)

	INSERT #Athlete 
	(F_RegisterID,Registration, Body_Weight)
	(
	SELECT
	  R.F_RegisterID 
	, R.F_RegisterCode AS [Registration]
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight) AS [Body_Weight]
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
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @PhaseID
	WHERE MR.F_MatchID = @MatchID  
		 AND R.F_RegisterCode IS NOT NULL AND R.F_Weight IS NOT NULL
	)

	CREATE TABLE #Attempt_Weight
	(
	    F_RegisterID            INT,
	    [Order]                 INT, 
	    [Weight]                Nvarchar(10),
		Number				    INT,
	)

	INSERT #Attempt_Weight(F_RegisterID,[Order],[Weight],Number)
	(   SELECT MR.F_RegisterID , 1, 
		 CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes1 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes1,'') END
		, ISNULL(NULL,0)FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID  
		WHERE F_MatchID  =@SnatchMatchID
		UNION ALL 
		SELECT MR.F_RegisterID , 2,  
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes2 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes2,'') END
		, ISNULL(NULL,0)FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID  
		WHERE F_MatchID  =@SnatchMatchID
		UNION ALL 
		SELECT MR.F_RegisterID , 3,  
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes3 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes3,'') END
		, ISNULL(NULL,0)FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID 
		WHERE F_MatchID  =@SnatchMatchID
		UNION ALL 
		SELECT MR.F_RegisterID , 4,  
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes1 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes1,'') END
		, ISNULL(NULL,0)FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID  
		WHERE F_MatchID  =@CleanJerkMatchID
		UNION ALL 
		SELECT MR.F_RegisterID , 5,  
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes2 IS NULL THEN '' 
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2) =3 THEN ''
		      ELSE ISNULL(MR.F_PointsCharDes2,'') END
		, ISNULL(NULL,0)FROM TS_Match_Result  AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID  
		WHERE F_MatchID  =@CleanJerkMatchID 
		UNION ALL 
		SELECT MR.F_RegisterID , 6,  
		CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN ''
		      WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND MR.F_PointsNumDes3 IS NULL THEN ''
		      WHEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3) =3 THEN '' 
		      ELSE ISNULL(MR.F_PointsCharDes3,'') END
		, ISNULL(NULL,0)FROM TS_Match_Result AS MR
		 LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID = MR.F_RegisterID 
		 LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID   
		WHERE F_MatchID  =@CleanJerkMatchID 
		)

	DECLARE @Athlete AS NVARCHAR(MAX)
	SET @Athlete = ( SELECT Athlete.Registration AS [Registration],
	                        Athlete.Body_Weight AS [Body_Weight],
	                        Attempt_Weight.[Order] AS [Order],
	                        Attempt_Weight.[Weight] AS [Weight],
	                        Attempt_Weight.[Number] AS [Number]	                        
	            FROM (SELECT * FROM #Athlete) AS Athlete 
				LEFT JOIN (SELECT F_RegisterID,[Order],[Weight],Number FROM #Attempt_Weight) AS Attempt_Weight
				ON Athlete.F_RegisterID = Attempt_Weight.F_RegisterID
			FOR XML AUTO)

	IF @Athlete IS NULL
	BEGIN
		SET @Athlete = N''
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
							+N' Code = "M3031"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Athlete
					+ N'
						</Message>'

	IF @MatchStatusID > 40 AND @Athlete != '' AND @Athlete IS NOT NULL AND @bAuto=1
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END
	ELSE IF @bAuto=0 AND @Athlete != '' 
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END

	

SET NOCOUNT OFF
END


GO


