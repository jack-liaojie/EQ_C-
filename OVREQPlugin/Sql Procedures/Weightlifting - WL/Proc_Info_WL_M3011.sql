IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_M3011]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_M3011]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Info_WL_M3011]
----功		  能：
----作		  者：
----日		  期: 2010-11-29 
----修改	记录:
/*			
			日期		   修改人		修改内容
			2010-12-27	    崔凯		添加获取运动员签号（seed），裁判信息,按报名成绩，签号排序
*/
CREATE PROCEDURE [dbo].[Proc_Info_WL_M3011]
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

	CREATE TABLE #Start_List
	(
	    Registration            varchar(10), 
		Bib				        varchar(3),
        Lot_Number              INT,
		Entry_Total				int,
		[Order]					int,
	)

	INSERT #Start_List 
	(Registration,Bib, Lot_Number, Entry_Total,[Order])
	(
	SELECT  
	  R.F_RegisterCode AS [Registration]
	, ISNULL(I.F_InscriptionNum,R.F_Bib)  AS [Bib]
	, I.F_Seed AS [Lot_Number]
	, I.F_InscriptionResult AS [Entry_Total]
	, ROW_NUMBER() OVER (ORDER BY ISNULL(I.F_Seed,999)) AS [Order]
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @PhaseID
	WHERE MR.F_MatchID = @MatchID  
		 AND R.F_RegisterCode IS NOT NULL AND I.F_InscriptionResult IS NOT NULL
		 AND I.F_Seed IS NOT NULL --AND R.F_Weight IS NOT NULL
		 AND (I.F_InscriptionNum IS NOT NULL OR R.F_Bib IS NOT NULL)
	)

	DECLARE @Start_List AS NVARCHAR(MAX)
	SET @Start_List = ( SELECT * FROM #Start_List AS Start_List order by [Order]
			FOR XML AUTO)

	IF @Start_List IS NULL
	BEGIN
		SET @Start_List = N''
	END


	CREATE TABLE #Referee
	(
	    Registration            varchar(10), 
		[Function]				varchar(40),
        [Order]					varchar(1),
	)
	
	INSERT #Referee
	(Registration,[Function],[Order])
	(SELECT 
	 R.F_RegisterCode, 
	 F.F_FunctionCode AS [Function],
	 ISNULL(P.F_PositionShortName,'T')		
		FROM TS_Match_Servant AS TMS 
		LEFT JOIN TR_Register AS R ON R.F_RegisterID = TMS.F_RegisterID
		LEFT JOIN TD_Function AS F ON F.F_FunctionID = TMS.F_FunctionID 
		LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = TMS.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
		LEFT JOIN TD_Position_Des AS P ON P.F_PositionID = TMS.F_PositionID AND P.F_LanguageCode = @LanguageCode
		WHERE TMS.F_MatchID = (SELECT TOP 1 F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchCode ='01')
		AND F.F_FunctionCode IS NOT NULL
		--AND F.F_FunctionCode IN('RRE','R1','R2','R3','RE','RES') 
	)
	
	DECLARE @Referee AS NVARCHAR(MAX)
	SET @Referee = ( SELECT * FROM #Referee AS Referee order by [Order]
			FOR XML AUTO)

	IF @Referee IS NULL
	BEGIN
		SET @Referee = N''
	END

	CREATE TABLE #Weight_Time
	(
	    Weight_Time VARCHAR(6),
	)
	INSERT #Weight_Time
	(Weight_Time)
	(SELECT TOP 1 ISNULL(LEFT(CONVERT(NVARCHAR(100),DATEADD(HOUR,-2,M.F_StartTime), 114), 5),'') FROM TS_Match AS M 
		WHERE M.F_PhaseID = @PhaseID AND M.F_MatchCode='01')
		  --(SELECT P.F_PhaseID FROM TS_Phase AS P LEFT JOIN TS_Match AS MM ON MM.F_PhaseID =P.F_PhaseID WHERE MM.F_MatchID=@MatchID)
		  --AND M.F_MatchCode='01')
	DECLARE @Weight_Time AS NVARCHAR(MAX)
	SET @Weight_Time = ( SELECT * FROM #Weight_Time AS Weight_Time
			FOR XML AUTO)

	IF @Weight_Time IS NULL
	BEGIN
		SET @Weight_Time = N''
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
							+N' Code = "M3011"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Start_List
					+ @Referee
					+ @Weight_Time
					+ N'
						</Message>'

	IF @MatchStatusID =40 AND (@Start_List != '' OR @Referee != '') AND @bAuto=1
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END
	ELSE IF @bAuto=0 AND (@Start_List != '' OR @Referee != '')
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END

SET NOCOUNT OFF
END


/*
exec Proc_Info_WL_M3011 1,'ENG',0
*/



GO


