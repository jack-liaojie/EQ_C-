IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTimeTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTimeTable]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_WL_GetTimeTable]
--描    述：得到Discipline下得TimeTable列表
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2010年10月28日


CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTimeTable](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

    SET Language English
    
	CREATE TABLE #Tmp_Table(
	[No]           NVARCHAR(50),
	[Gender]       NVARCHAR(50),
	[Cat]          NVARCHAR(50),
	[Group]        NVARCHAR(50),
    [Date]         NVARCHAR(50),
    [StartTime]    NVARCHAR(50),
    [Event]        NVARCHAR(100),
    [Phase]        NVARCHAR(100),
    [Location]     NVARCHAR(100),
    [MatchID]      INT,
	
    [Lifters]		INT,
    [Tech_Delegate] INT,
    [Jury]			INT,
    [Weigh_In]      INT,
    [Doctors]		INT,
    [Tech_Contrl]   INT,
    [Secr]			INT,
    [Referee]		INT,
    TimeKeeper		INT,
    [ChiefMarshall]	INT
    )
    
	INSERT INTO #Tmp_Table ([No], [Gender], [Cat], [Group], [Date], [StartTime], [Event], [Phase], [Location], [MatchID] ) 
	SELECT 
	(ROW_NUMBER() OVER(ORDER BY convert(varchar,D.F_Date,112),convert(varchar,M.F_StartTime,108))) AS [No],
	SD.F_SexLongName AS [Gender],
	ED.F_EventLongName AS [Cat],
	P.F_PhaseCode AS [Group],
	(UPPER(Substring(dbo.Fun_GetWeekdayName(D.F_Date,'ENG'),1,3)) + ' '
	+ DATENAME(DAY,D.F_Date) + ' ' + UPPER(Substring(DATENAME(MONTH,D.F_Date),1,3)) ) AS [Date],
	Substring(convert(varchar,M.F_StartTime,108),1,5) AS [startime],
    ED.F_EventLongName AS [Event],
	(case when MD.F_MatchShortName is null or MD.F_MatchShortName = '' then (ED.F_EventComment + ' ' + PD.F_PhaseShortName)
          else (ED.F_EventComment + ' ' + PD.F_PhaseShortName + ' - ' + MD.F_MatchShortName) end) AS [Phase],
    VD.F_VenueLongName AS [Location],      
    M.F_MatchID AS [MatchID]
	FROM TS_DisciplineDate AS D
	left join TS_Match AS M on D.F_Date = M.F_Matchdate AND M.F_MatchCode ='01'
	left join TS_Phase AS P on M.F_PhaseID = P.F_PhaseID
	left join TS_Event AS E on P.F_EventID = E.F_EventID
	left join TS_Event_Des AS ED on E.f_EventID = ED.F_EventID and ED.F_Languagecode=@LanguageCode 
	left join TS_Phase_Des AS PD on P.f_PhaseID = PD.F_PhaseID and PD.F_Languagecode=@LanguageCode 
	left join TS_Match_Des AS MD on M.f_MatchID = MD.F_MatchID and MD.F_Languagecode=@LanguageCode 
	left join TC_Venue_Des AS VD on M.F_VenueID = VD.F_VenueID and VD.F_Languagecode=@LanguageCode 	
	left join TC_Court_Des AS CD on M.F_CourtID = CD.F_CourtID and CD.F_Languagecode=@LanguageCode 
	LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	LEFT JOIN TC_Sex_Des AS SD ON S.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = @LanguageCode 
	WHERE D.F_DisciplineID = @DisciplineID and E.F_disciplineid = @DisciplineID
	AND E.F_EventCode IS NOT NULL AND E.F_EventCode <> '000'
	ORDER BY convert(varchar,D.F_Date,112),convert(varchar,M.F_StartTime,108)
	
    UPDATE #Tmp_Table SET [StartTime] = RIGHT([StartTime], 4) WHERE LEFT([StartTime], 1) = '0'
    
	UPDATE #Tmp_Table SET [Lifters]= (SELECT COUNT(MS.F_RegisterID) FROM TS_Match_Result AS MS WHERE MS.F_MatchID = T.MatchID) 
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [Tech_Delegate]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode='IF11')
			--UPPER(FD.F_FunctionLongName)='TECHNICAL DELEGATE' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [Jury]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode='IF16')
			--UPPER(FD.F_FunctionLongName) LIKE '%JURY' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [Weigh_In]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode  IN ('IF17','WO'))
			--UPPER(FD.F_FunctionLongName)='WEIGH-IN OFFICIALS' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [Doctors]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode IN ('DOD','AA10'))
			--UPPER(FD.F_FunctionLongName)='DOCTORS' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [Tech_Contrl]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode='TC')
			--UPPER(FD.F_FunctionLongName)='TECHNICAL CONTROLLERS' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [Secr]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode='CPS')
			--UPPER(FD.F_FunctionLongName)='SECRETARIES' ) 	
			FROM  #Tmp_Table AS T	
					
	UPDATE #Tmp_Table SET [Referee]= (SELECT  top 1 GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID 
			AND F.F_FunctionCode IN ('RRE','R1','R2','R3','RE','RES'))
			--UPPER(FD.F_FunctionLongName)='SECRETARIES' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [TimeKeeper]= (SELECT top 1  GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode='TKP')
			--UPPER(FD.F_FunctionLongName)='SECRETARIES' ) 	
			FROM  #Tmp_Table AS T
			
	UPDATE #Tmp_Table SET [ChiefMarshall]= (SELECT top 1  GD.F_GroupShortName FROM TS_Match_Servant AS MS 
			LEFT JOIN TD_Function_Des AS FD ON FD.F_FunctionID = MS.F_FunctionID AND FD.F_LanguageCode=@LanguageCode
			LEFT JOIN TD_Function AS F ON F.F_FunctionID = MS.F_FunctionID
			LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID = MS.F_RegisterID
			LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID
			WHERE MS.F_MatchID = T.MatchID AND F.F_FunctionCode ='CMS')
			--UPPER(FD.F_FunctionLongName)='SECRETARIES' ) 	
			FROM  #Tmp_Table AS T
			
	/*
    Declare @LastDate NVARCHAR(50)
    Declare @Date NVARCHAR(50)
    Declare @MatchID INT
	Declare RunCur Cursor For Select 
	[Date],[MatchID]
	From #Tmp_Table  

    SET @LastDate = '-1'
	Open RunCur
	Fetch next From RunCur Into @Date,@MatchID
	While @@fetch_status=0     
	Begin
	    IF @Date IS NOT NULL
	    BEGIN
	        IF @Date = @LastDate
	        BEGIN
	            Update #Tmp_Table SET [Date] = NULL WHERE [MatchID] = @MatchID
	        END
	    END
	    SET @LastDate = @Date
	    Fetch next From RunCur Into @Date,@MatchID
	end
	Close RunCur   
	Deallocate RunCur

    ALTER TABLE #Tmp_Table  DROP COLUMN MatchID
*/


	SELECT * FROM #Tmp_Table order by CONVERT(INT,ISNULL([NO],'999'))

Set NOCOUNT OFF
End	

GO


/*
exec Proc_Report_WL_GetTimeTable 1 ,'eng'
*/

