IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_M3051]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_M3051]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Info_WL_M3051]
----功		  能：INFO获取成绩信息
----作		  者：崔凯
----日		  期: 2010-11-29 
----修改	记录:

CREATE PROCEDURE [dbo].[Proc_Info_WL_M3051]
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
	DECLARE @PhaseID	 INT
	DECLARE @EventID	 INT
	DECLARE @GroupCount	 INT


	SELECT @DisciplineID = D.F_DisciplineID,
	@DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @GenderCode = S.F_GenderCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode,
    @EventID = E.F_EventID  FROM TS_Match AS M 
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
    
    SELECT @GroupCount = F_Order FROM TS_Phase WHERE F_PhaseID = @PhaseID 

	CREATE TABLE #Temp_RegTable
	(
		F_RegisterID            INT,
    )
	INSERT #Temp_RegTable(F_RegisterID)
	(SELECT DISTINCT MR.F_RegisterID
	FROM TS_Match_Result AS MR 
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID
	LEFT JOIN TS_Event_Result AS ER ON PR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = @EventID
	WHERE MR.F_MatchID IN (
		SELECT F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE M.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_Order >=@GroupCount AND F_EventID = @EventID)
			AND E.F_EventID = @EventID)
	AND MR.F_RegisterID IS NOT NULL 
	--AND --(ER.F_EventPointsCharDes2 IS NOT NULL AND  ER.F_EventPointsCharDes3 IS NOT NULL AND ER.F_EventPointsCharDes4 IS NOT NULL)
		--ER.F_EventPointsCharDes4 IS NOT NULL OR (ER.F_IRMID IS NOT NULL) 
	)

	CREATE TABLE #Result
	(
	    Registration            varchar(10), 
        [Group]                 varchar(1),
		Bib				        varchar(3),
        Lot_Number              INT,
		Body_Weight				decimal(9,2),        
        Snatch                  varchar(10), 
        CleanJerk               varchar(10), 
        Total                   varchar(10), 
        [Status]                varchar(10),
        [Rank]                  varchar(10),
        [Order]					INT,
	)

	INSERT #Result 
	(Registration, [Group], Bib, Lot_Number, Body_Weight, Snatch, CleanJerk, Total, [Status], [Rank], [Order])
	(
	SELECT
	R.F_RegisterCode AS [Registration]
	, P.F_PhaseCode
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' 
		then I.F_InscriptionNum else R.F_Bib end) AS [Bib]
	, I.F_Seed AS [Lot_Number]
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight)
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMLongName ='DNS' OR IRM.F_IRMLongName ='DSQ') THEN ''
		   ELSE  ISNULL(ER.F_EventPointsCharDes2,'') END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMLongName ='DNS' OR IRM.F_IRMLongName ='DSQ') THEN ''
		   ELSE  ISNULL(ER.F_EventPointsCharDes3,'') END
	, CASE WHEN ER.F_IRMID IS NOT NULL THEN ''  ELSE ISNULL(ER.F_EventPointsCharDes4,'') END
	, ISNULL(IRM.F_IRMLongName,'')
	, ISNULL(Convert(varchar(5),F_EventRank),'')
	, ROW_NUMBER() OVER (ORDER BY ISNULL(ER.F_EventDisplayPosition,999))  AS [Order]
	FROM #Temp_RegTable AS T
	LEFT JOIN TR_Register AS R ON T.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON T.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Phase_Result AS PR ON T.F_RegisterID = PR.F_RegisterID
	LEFT JOIN TS_Event_Result AS ER ON PR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = @EventID
	LEFT JOIN TS_Phase AS P ON P.F_PhaseID = PR.F_PhaseID AND P.F_EventID = @EventID
	LEFT JOIN TR_Inscription AS I ON T.F_RegisterID = I.F_RegisterID AND I.F_EventID = @EventID
	LEFT JOIN TC_IRM_Des AS IRM ON ER.F_IRMID = IRM.F_IRMID AND IRM.F_LanguageCode= @LanguageCode
	WHERE R.F_RegisterCode IS NOT NULL AND
		 P.F_PhaseCode IS NOT NULL AND I.F_Seed IS NOT NULL AND R.F_Weight IS NOT NULL
		 AND (I.F_InscriptionNum IS NOT NULL OR R.F_Bib IS NOT NULL)
	--LEFT JOIN TS_Match_Result AS MR ON T.F_RegisterID = MR.F_RegisterID AND MR.F_MatchID =
	--	(SELECT TOP 1 MR.F_MatchID FROM TS_Match_Result AS MR WHERE MR.F_RegisterID = T.F_RegisterID AND MR.F_MatchID IN
	--		(SELECT MM.F_MatchID  FROM TS_Match AS MM LEFT JOIN TS_Phase AS PP ON PP.F_PhaseID =MM.F_PhaseID
	--					LEFT JOIN TS_Event AS EE ON EE.F_EventID = @EventID WHERE MM.F_MatchCode ='01'))	 
	--LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID	
	--LEFT JOIN TS_Match_Result AS SNMR ON MR.F_RegisterID = SNMR.F_RegisterID AND SNMR.F_MatchID IN 
	--				(SELECT MM.F_MatchID  FROM TS_Match AS MM LEFT JOIN TS_Phase AS PP ON PP.F_PhaseID =MM.F_PhaseID
	--					LEFT JOIN TS_Event AS EE ON EE.F_EventID = @EventID WHERE MM.F_MatchCode ='01')
	--LEFT JOIN TS_Match_Result AS CJMR ON MR.F_RegisterID = CJMR.F_RegisterID AND CJMR.F_MatchID IN
	--				(SELECT MM.F_MatchID  FROM TS_Match AS MM LEFT JOIN TS_Phase AS PP ON PP.F_PhaseID =MM.F_PhaseID
	--					LEFT JOIN TS_Event AS EE ON EE.F_EventID = @EventID WHERE MM.F_MatchCode ='02')		
	--WHERE --(ER.F_EventPointsCharDes2 IS NOT NULL AND  ER.F_EventPointsCharDes3 IS NOT NULL AND ER.F_EventPointsCharDes4 IS NOT NULL)
	--	ER.F_EventPointsCharDes4 IS NOT NULL OR (ER.F_IRMID IS NOT NULL) 
	)
	
	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT * FROM #Result AS Result ORDER BY [Order]
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
							+N' Code = "M3051"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'
	IF(@Result = N'')
		BEGIN
		SET @OutputXML = N''
		END
	ELSE
		BEGIN
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						   <Message ' + @MessageProperty +'>'
						+ @Result
						+ N'
							</Message>'
		END

	IF (@Result IS NOT NULL AND @Result !='')
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END

SET NOCOUNT OFF
END

/*
exec Proc_Info_WL_M3051 17,'ENG'
*/

